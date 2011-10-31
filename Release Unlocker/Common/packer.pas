{
  Engine of the Release Maker thing, for making packages
}
unit Packer;

interface

uses
  Windows, SysUtils, Classes, OpThBase, D7zipAPI, Common;

type
  TPackageMakerThread = class(TOperationThread)
  private
    { Déclarations privées }
    fPasswords: TPackagePasswords;
    fOnStartCrypto: TOperationStartEvent;
    fOnProgressCrypto: TOperationProgressEvent;
    fOutputDirectory: TFileName;
    fInputDirectory: TFileName;
    fDirectorySize: Int64;
    fMediaHashKeys: TStringList;
    fSkinImages: TSkinImages;
    fAppConfig: TFileName;
    fEula: TFileName;

    procedure StartCryptoEvent;
    procedure ProgressCryptoEvent;

    procedure CompressSourcePackage;
    procedure EncryptPackage;
    procedure CompileRuntimePackage;
    procedure CompileExtraFiles;
    function WriteDiscAuthentification: TFileName;

    procedure SetInputDirectory(const Value: TFileName);
    procedure SetOutputDirectory(const Value: TFileName);
  protected
    procedure Execute; override;
    function WritePackage: Boolean;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property AppConfig: TFileName read fAppConfig write fAppConfig;
    property Eula: TFileName read fEula write fEula;

    property InputDirectory: TFileName read fInputDirectory
      write SetInputDirectory;
    property MediaHashKeys: TStringList read fMediaHashKeys
      write fMediaHashKeys;
    property OutputDirectory: TFileName read fOutputDirectory
      write SetOutputDirectory;
    property Passwords: TPackagePasswords read fPasswords;

    property SkinImages: TSkinImages read fSkinImages;

    property OnStartCrypto: TOperationStartEvent read fOnStartCrypto
      write fOnStartCrypto;
    property OnProgressCrypto: TOperationProgressEvent read fOnProgressCrypto
      write fOnProgressCrypto;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  IniFiles, SysTools, WorkDir;

const
  COMPRESSION_LEVEL_MAX = 9;

  RUNTIME_PACKAGE_RELEASE_FILENAME  = 'package.bin';

  RUNTIME_PACKAGE_RESOURCE_NAME     = 'RUNTIME';
  RUNTIME_PACKAGE_FINAL_OUTPUT      = 'unpacker.exe'; //'rlzulock.exe';

  RUNTIME_EXTRA_RESOURCE_FILENAME   = 'extra.bin';

var
  WorkingThread: TPackageMakerThread;
  szLzmaLib: TFileName;
  
function ProgressCallback(Sender: Pointer; Total: Boolean;
  Value: Int64): HRESULT; stdcall;
begin
  Result := S_OK;
  with WorkingThread do
  begin
    if Total then
    begin
      fTotal := Value;
      CallSyncStartEvent;
    end else begin
      fCurrent := Value;
      CallSyncProgressEvent;
    end;
    // Trick to cancel the process...
    // This will crash the 7zAPI ("Incorrect Function"), but will stop the process!
    if Aborted then
      Result := S_FALSE;
  end;
end;

{ TReleasePackageMaker }

procedure TPackageMakerThread.Execute;
begin
  fTerminated := False;
  WorkingThread := Self;
  try
    WritePackage;
  finally
    CallSyncFinishEvent;
  end;
end;

procedure TPackageMakerThread.ProgressCryptoEvent;
begin
  if Assigned(OnProgressCrypto) then
    OnProgressCrypto(Self, fCurrent, fTotal);
end;

procedure TPackageMakerThread.SetInputDirectory;
begin
  fInputDirectory := IncludeTrailingPathDelimiter(Value);
end;

procedure TPackageMakerThread.SetOutputDirectory;
begin
  fOutputDirectory := IncludeTrailingPathDelimiter(Value);
end;

procedure TPackageMakerThread.StartCryptoEvent;
begin
  if Assigned(OnStartCrypto) then
    OnStartCrypto(Self, fTotal);
end;

procedure TPackageMakerThread.CompressSourcePackage;
var
  OutArchive: I7zOutArchive;
  OutputPackage: TFileName;

begin
  // Create the 7z archive !
  OutArchive := CreateOutArchive(CLSID_CFormat7z);
  with OutArchive do
  begin
    // Add files using willcards and recursive search
    AddFiles(InputDirectory, '', '*.*', True);

    // Compression level
    SetCompressionLevel(OutArchive, COMPRESSION_LEVEL_MAX);

    // Handle a progress bar ...
    SetProgressCallback(nil, ProgressCallback);

    // Solid Archive
    SevenZipSetSolidSettings(OutArchive, True);

    // Volume info !
    SevenZipVolumeMode(OutArchive, True);

    // Set a password
    SetPassword(Passwords.AES);
    SevenZipEncryptHeaders(OutArchive, True);

    // Execute : Save to file
    OutputPackage := OutputDirectory + RUNTIME_PACKAGE_RELEASE_FILENAME;
    if FileExists(OutputPackage) then
      DeleteFile(OutputPackage);
    SaveToFile(OutputPackage);

    // When done, wait a bit...
    if not Aborted then
      Sleep(500);
  end;
end;

constructor TPackageMakerThread.Create;
begin
  inherited Create;
  fPasswords := TPackagePasswords.Create;
  fMediaHashKeys := TStringList.Create;
  fSkinImages := TSkinImages.Create;
end;

destructor TPackageMakerThread.Destroy;
begin
  fPasswords.Free;
  fMediaHashKeys.Free;
  fSkinImages.Free;
  inherited;
end;

procedure TPackageMakerThread.EncryptPackage;
const
  CODEC_BLOCK_SIZE = 16777216; // 16 MB
  
var
  FileStream: TFileStream;
  Memory1, Memory2: TMemoryStream;
  BlockSize: Int64;

begin
  FileStream := TFileStream.Create(OutputDirectory
    + RUNTIME_PACKAGE_RELEASE_FILENAME, fmOpenReadWrite);
  Memory1 := TMemoryStream.Create;
  Memory2 := TMemoryStream.Create;
  try
    // Fire the start encryption event
    fCurrent :=  0;
    fTotal := FileStream.Size;
    Synchronize(StartCryptoEvent);

    // Encrypting the file
    while (not EOS(FileStream)) and (not Aborted) do
    begin
      // Input is 7z encrypted with AES-256
      BlockSize := GetStreamBlockReadSize(FileStream, CODEC_BLOCK_SIZE);
      Memory1.CopyFrom(FileStream, BlockSize);
      FileStream.Seek(-BlockSize, soFromCurrent); // rewind

      // Encrypt with Camellia 256
      Memory2.Clear;
//      CamelliaEncrypt(Passwords.Camellia, Memory1, Memory2);
      Memory2.CopyFrom(Memory1, 0);
      Memory1.Clear;

      // Writing result to the input file.
      Memory2.Seek(0, soFromBeginning);
      FileStream.Write(Memory2.Memory^, Memory2.Size);

      // Fire the progress event
      Inc(fCurrent, BlockSize);
      Synchronize(ProgressCryptoEvent);
    end;
  finally
    if not Aborted then
      Sleep(500);
    FileStream.Free;
    Memory1.Free;
    Memory2.Free;
  end;
end;

procedure TPackageMakerThread.CompileExtraFiles;
var
  ExtraTempDir: TFileName;
  i: Integer;
  OutArchive: I7zOutArchive;
  ExtraOutputPackage: TFileName;

begin
  // Create temp directory
  ExtraTempDir := GetWorkingTempDirectory + 'extra\';
  ForceDirectories(ExtraTempDir);

  // Copy files to this directory...
  CopyFile(AppConfig, ExtraTempDir + APPCONFIG_UI_MESSAGES, False);
  CopyFile(Eula, ExtraTempDir + APPCONFIG_EULA, False);
  CopyFile(SkinImages.Top, ExtraTempDir + SKIN_IMAGE_TOP, False);
  CopyFile(SkinImages.Bottom, ExtraTempDir + SKIN_IMAGE_BOTTOM, False);
  for i := 0 to SkinImages.Left.Count - 1 do
    CopyFile(SkinImages.Left[i].FileName, ExtraTempDir
      + SKIN_IMAGES_LEFT_ORDER[i], False);

  // Compress the extra file...
  OutArchive := CreateOutArchive(CLSID_CFormat7z);
  with OutArchive do
  begin
    // Add files using willcards and recursive search
    AddFiles(ExtraTempDir, '', '*.*', True);

    // Compression level
    SetCompressionLevel(OutArchive, COMPRESSION_LEVEL_MAX);

    // Handle a progress bar ...
    SetProgressCallback(nil, ProgressCallback);

    // Solid Archive
    SevenZipSetSolidSettings(OutArchive, True);

    // Volume info !
    SevenZipVolumeMode(OutArchive, False);

    // Set a password
    SetPassword(RUNTIME_EXTRA_RESOURCE_PASSWORD);
    SevenZipEncryptHeaders(OutArchive, True);

    // Execute : Save to file
    ExtraOutputPackage := GetWorkingTempDirectory
      + RUNTIME_EXTRA_RESOURCE_FILENAME;
    if FileExists(ExtraOutputPackage) then
      DeleteFile(ExtraOutputPackage);
    SaveToFile(ExtraOutputPackage);

    // When done, wait a bit...
    if not Aborted then
      Sleep(500);
  end;
end;

procedure TPackageMakerThread.CompileRuntimePackage;
var
  i: Integer;
  WorkFileName, RuntimeFileName, DiscAuthFileName, ExtraOutputPackage: TFileName;
  DiscAuthInStream, ExtraResInStream, OutStream: TFileStream;
  CryptedStream: TMemoryStream;
  Offset, ResCount: LongWord;
  Passwords: TPackagePasswords;

  procedure BindResource(SourceStream: TStream; ResourceType: Byte);
  var
    Size: LongWord;
    
  begin
    // Write Stream Type
    OutStream.Write(ResourceType, SizeOf(ResourceType));

    // Write Stream Size
    Size := SourceStream.Size;   
    OutStream.Write(Size, UINT32_SIZE);

    // Write datas to the final runtime file
    OutStream.CopyFrom(SourceStream, Size);
    SourceStream.Seek(0, soFromBeginning);
  end;

begin
{$IFDEF DEBUG}
  WriteLn('CompileRuntimePackage');
{$ENDIF}

  // At least for the resource...
  ResCount := 1;

  // Extracting the Runtime Setup Application.
  RuntimeFileName := GetWorkingTempDirectory + RUNTIME_PACKAGE_RESOURCE_NAME + '.BIN';
  ExtractFile(RUNTIME_PACKAGE_RESOURCE_NAME, RuntimeFileName);

  // Generate disc auth files / extra resource files
  DiscAuthFileName := WriteDiscAuthentification;
  ExtraOutputPackage := GetWorkingTempDirectory + RUNTIME_EXTRA_RESOURCE_FILENAME;

  // Encrypt the DiscAuth.Inf file with each Media Key.
  if FileExists(DiscAuthFileName) then
  begin
    Passwords := TPackagePasswords.Create;

    ExtraResInStream := TFileStream.Create(ExtraOutputPackage, fmOpenRead);
    DiscAuthInStream := TFileStream.Create(DiscAuthFileName, fmOpenRead);
    OutStream := TFileStream.Create(RuntimeFileName, fmOpenWrite);
    try
      // Move to the end in the Runtime binary...
      OutStream.Seek(0, soFromEnd);
      Offset := OutStream.Position;

      //------------------------------------------------------------------------
      // WRITING RESOURCE FILES
      //------------------------------------------------------------------------

      // Write the extra files...
      BindResource(ExtraResInStream, RESTYPE_APPCONFIG);

      //------------------------------------------------------------------------
      // WRITING DISCAUTH.INF FILES
      //------------------------------------------------------------------------

{$IFDEF DEBUG}
      WriteLn(sLineBreak, 'Creating DiscAuth.xxx files...', sLineBreak);
{$ENDIF}

      // For each media key, create a DISCAUTH.xxx file, then write to final Runtime app.
      i := 0;
      while (i < MediaHashKeys.Count) and (not Aborted) do
      begin
{$IFDEF DEBUG}
        WriteLn('  Processing Key #', i, ': ', MediaHashKeys[i]);
{$ENDIF}

        CryptedStream := TMemoryStream.Create;
        try
          // Encrypt Stream...
          with Passwords do
          begin
            AES := MediaHashKeys[i];
            PC1 := MediaHashKeys[i];
            Camellia := MediaHashKeys[i];
          end;
          EncryptStream(Passwords, DiscAuthInStream, CryptedStream);

          // Write the crypted stream to the binary...
          BindResource(CryptedStream, RESTYPE_DISCAUTH);
        finally
          CryptedStream.Free;
        end;

        Inc(i);
      end; // for
      Inc(ResCount, i);

      //------------------------------------------------------------------------
      // FINALIZE RUNTIME
      //------------------------------------------------------------------------

      // Write the offset extra header at the end of the file.
      Offset := OutStream.Size - Offset;
      OutStream.Write(Offset, UINT32_SIZE);

      // Write the number of entry at the end of the file too.
      OutStream.Write(ResCount, UINT32_SIZE);
    finally
      Passwords.Free;
      ExtraResInStream.Free;
      DiscAuthInStream.Free;
      OutStream.Free;
      DeleteFile(DiscAuthFileName);

      // Move the final runtime binary to the output directory...
      WorkFileName := OutputDirectory + RUNTIME_PACKAGE_FINAL_OUTPUT;
      if FileExists(WorkFileName) then
        DeleteFile(WorkFileName);
      MoveFile(RuntimeFileName, WorkFileName);
    end; // try
    
  end; // FileExists 
end;

function TPackageMakerThread.WriteDiscAuthentification;
var
  DiscAuthInf: TIniFile;

begin
  // Compute the total size of the directory
  fDirectorySize := GetDirectorySize(InputDirectory);
{$IFDEF DEBUG}
  WriteLn('Directory Size: ', fDirectorySize);
{$ENDIF}

  // Write the DiscAuth.Inf plain text file.
  Result := GetWorkingTempDirectory + 'DISCAUTH.INF';
  DiscAuthInf := TIniFile.Create(Result);
  try
    with DiscAuthInf do
    begin
      WriteInteger('DISCAUTH', 'DirSize', fDirectorySize);
      WriteString('DISCAUTH', 'PC1', Passwords.PC1);
      WriteString('DISCAUTH', 'Camellia', Passwords.Camellia);
      WriteString('DISCAUTH', 'AES', Passwords.AES);
    end;
  finally
    DiscAuthInf.Free;
  end;
end;

function TPackageMakerThread.WritePackage;
begin
  Result := True;
  try
    // First, make the 7z package. Encrypt with AES.
    CompressSourcePackage;

    // Encrypt the result compressed package source file with Camellia.
    EncryptPackage;

    // Compile extra resource (gui, images, etc...)
    CompileExtraFiles;

    // Compile the final package.
    CompileRuntimePackage;
  except
    Result := False;
  end;
end;

initialization
  // Extracting 7z library to the temp directory.
  szLzmaLib := GetWorkingTempDirectory + '7z.dll';
  ExtractFile('LZMALIB', szLzmaLib);
  SevenZipSetLibraryFilePath(szLzmaLib);

end.
