{
  Engine of the Release Maker thing, for making packages
}
unit Packer;

interface

uses
  Windows, SysUtils, Classes, OpThBase, D7zipAPI, Common;
  
type
  TPackageMakerThreadStatusEvent = procedure(
    Sender: TObject; StatusText: string) of object;

  TPackageMakerThread = class(TOperationThread)
  private
    { Déclarations privées }
    fPackageReleaseInfo: TPackageReleaseInfo;
    fPasswords: TPackagePasswords;
    fOutputDirectory: TFileName;
    fInputDirectory: TFileName;
    fDirectorySize: Int64;
    fMediaHashKeys: TStringList;
    fSkinImages: TSkinImages;
    fAppConfig: TFileName;
    fEula: TFileName;
    fOnStatus: TPackageMakerThreadStatusEvent;

    fLoggingMessage: string;
    fOutputFileName: TFileName;
    fAppIcon: TFileName;
    procedure DoLog;

    procedure CompressSourcePackage;
    procedure CompileExtraFiles;
    procedure CompileRuntimePackage;
    procedure SetInputDirectory(const Value: TFileName);
    procedure SetOutputDirectory(const Value: TFileName);
    function WriteDiscAuthentification: TFileName;
    procedure SetAppConfig(const Value: TFileName);
    procedure SetEula(const Value: TFileName);
    procedure SetAppIcon(const Value: TFileName);
  protected
    procedure Execute; override;
    function WritePackage: Boolean;
    procedure Log(Text: string);
  public
    constructor Create; overload;
    destructor Destroy; override;

    property AppConfig: TFileName read fAppConfig write SetAppConfig;
    property AppIcon: TFileName read fAppIcon write SetAppIcon;
    property Eula: TFileName read fEula write SetEula;

    property InputDirectory: TFileName read fInputDirectory
      write SetInputDirectory;
    property MediaHashKeys: TStringList read fMediaHashKeys
      write fMediaHashKeys;
    property OutputDirectory: TFileName read fOutputDirectory
      write SetOutputDirectory;
    property OutputFileName: TFileName read fOutputFileName;
    property Passwords: TPackagePasswords read fPasswords;

    property ReleaseInfo: TPackageReleaseInfo read fPackageReleaseInfo;

    property SkinImages: TSkinImages read fSkinImages;

    property OnStatus: TPackageMakerThreadStatusEvent read
      fOnStatus write fOnStatus;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  IniFiles, SysTools, WorkDir, UpxLib, IconChng;

const
  COMPRESSION_LEVEL_MAX = 9;

  RUNTIME_PACKAGE_RELEASE_FILENAME            = 'package.tmp';

  RUNTIME_PACKAGE_RESOURCE_NAME               = 'RUNTIME';
  RUNTIME_PACKAGE_FINAL_OUTPUT                = 'unpacker.exe';

  RUNTIME_PRIMARY_EXTRA_RESOURCE_FILENAME     = 'master.dat';
  RUNTIME_SECONDARY_EXTRA_RESOURCE_FILENAME   = 'slave.dat';

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
      Result := E_ABORT;
  end;
end;

{ TReleasePackageMaker }

procedure TPackageMakerThread.Execute;
begin
  Log('Starting process.');
  fTerminated := False;
  WorkingThread := Self;
  try
    WritePackage;
  finally
    CallSyncFinishEvent;
  end;
end;

procedure TPackageMakerThread.Log(Text: string);
begin
  fLoggingMessage := Text;
  Synchronize(DoLog);
end;

(*procedure TPackageMakerThread.ProgressCryptoEvent;
begin
  if Assigned(OnProgressCrypto) then
    OnProgressCrypto(Self, fCurrent, fTotal);
end;*)

procedure TPackageMakerThread.SetAppConfig(const Value: TFileName);
begin
  fAppConfig := ExpandFileName(Value);
end;

procedure TPackageMakerThread.SetAppIcon(const Value: TFileName);
begin
  fAppIcon := ExpandFileName(Value);
end;

procedure TPackageMakerThread.SetEula(const Value: TFileName);
begin
  fEula := ExpandFileName(Value);
end;

procedure TPackageMakerThread.SetInputDirectory;
begin
  fInputDirectory := IncludeTrailingPathDelimiter(ExpandFileName(Value));
end;

procedure TPackageMakerThread.SetOutputDirectory;
begin
  fOutputDirectory := IncludeTrailingPathDelimiter(ExpandFileName(Value));
end;

(*procedure TPackageMakerThread.StartCryptoEvent;
begin
  if Assigned(OnStartCrypto) then
    OnStartCrypto(Self, fTotal);
end;*)

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
    SevenZipSetSolidSettings(OutArchive, False);

    // Volume info !
    SevenZipVolumeMode(OutArchive, False);

    // Set a password
    SetPassword(Passwords.AES);
    SevenZipEncryptHeaders(OutArchive, True);

    // Execute : Save to file
    OutputPackage := OutputDirectory + RUNTIME_PACKAGE_RELEASE_FILENAME;
    if FileExists(OutputPackage) then
      DeleteFile(OutputPackage);
    SaveToFile(OutputPackage);
  end;

  // When done, wait a bit...
  if not Aborted then
    Sleep(500);
end;

constructor TPackageMakerThread.Create;
begin
  inherited Create;
  fPasswords := TPackagePasswords.Create;
  fPackageReleaseInfo := TPackageReleaseInfo.Create;
  fMediaHashKeys := TStringList.Create;
  fSkinImages := TSkinImages.Create;
  fOutputFileName := '';
end;

destructor TPackageMakerThread.Destroy;
begin
  fPasswords.Free;
  fMediaHashKeys.Free;
  fSkinImages.Free;
  fPackageReleaseInfo.Free;
  inherited;
end;

procedure TPackageMakerThread.DoLog;
begin
  if Assigned(fOnStatus) then
    fOnStatus(Self, fLoggingMessage);
{$IFDEF DEBUG}
  WriteLn('UserLog: ', fLoggingMessage);
{$ENDIF}
end;

(*
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
*)

procedure TPackageMakerThread.CompileExtraFiles;
var
  ExtraTempDir: TFileName;
  i: Integer;

  procedure _Compress(OutputFileName: TFileName);
  var
    OutArchive: I7zOutArchive;

  begin
    OutputFileName := GetWorkingTempDirectory + OutputFileName;
    OutArchive := CreateOutArchive(CLSID_CFormat7z);
    with OutArchive do
    begin
      AddFiles(ExtraTempDir, '', '*.*', True);
      SetCompressionLevel(OutArchive, COMPRESSION_LEVEL_MAX);
      SetProgressCallback(nil, ProgressCallback);
      SevenZipSetSolidSettings(OutArchive, True);
      SevenZipVolumeMode(OutArchive, False);
      SetPassword(RUNTIME_EXTRA_RESOURCE_PASSWORD);
      SevenZipEncryptHeaders(OutArchive, True);
      if FileExists(OutputFileName) then
        DeleteFile(OutputFileName);
      SaveToFile(OutputFileName);
    end;
    
    // When done, wait a bit...
    if not Aborted then
      Sleep(500);
  end;

  function _CP(InF, OutF: TFileName): TFileName;
  begin
    CopyFile(InF, ExtraTempDir + OutF, False);
  end;

  procedure _Init();
  begin
    ExtraTempDir := GetWorkingTempDirectory + 'extra\';
    if DirectoryExists(ExtraTempDir) then
      DeleteDirectory(ExtraTempDir);
    ForceDirectories(ExtraTempDir);
  end;

  procedure _GenerateReleaseInfoFile;
  begin
    ReleaseInfo.SaveToFile(ExtraTempDir + APPCONFIG_RELEASEINFO);
  end;

begin
  // Compress the primary resource file...
  _Init();
  _CP(AppConfig, APPCONFIG_UI_MESSAGES);
  _CP(SkinImages.Top, SKIN_IMAGE_TOP);
  _CP(SkinImages.Bottom, SKIN_IMAGE_BOTTOM);
  _CP(SkinImages.Left[0].FileName, SKIN_IMAGES_LEFT_ORDER[0]); // Home image
  _GenerateReleaseInfoFile();
  _Compress(RUNTIME_PRIMARY_EXTRA_RESOURCE_FILENAME);

  // Compress the secondary resource file...
  _Init();
  _CP(Eula, APPCONFIG_EULA);
  for i := 1 to SkinImages.Left.Count - 1 do
    _CP(SkinImages.Left[i].FileName, SKIN_IMAGES_LEFT_ORDER[i]);
  _Compress(RUNTIME_SECONDARY_EXTRA_RESOURCE_FILENAME);

  // Cleaning directory...
  DeleteDirectory(ExtraTempDir);
end;

procedure TPackageMakerThread.CompileRuntimePackage;
var
  i: Integer;
  RuntimeFileName, DiscAuthFileName, ExtraOutputPackage,
  ReleasePackage: TFileName;
  DiscAuthInStream, OutStream: TFileStream;
  CryptedStream: TMemoryStream;
  Offset, ResCount: LongWord;
  DiscAuthPasswords: TPackagePasswords;

  function _FP(FileName: TFileName): TFileName;
  begin
    Result := GetWorkingTempDirectory + FileName;
  end;

  procedure BindResource(SourceStream: TStream; ResType: TResourceType); overload;
  var
    Size: LongWord;
    R: Byte;

  begin
    // Write Stream Type
    R := Integer(ResType);
    OutStream.Write(R, 1);

    // Write Stream Size
    Size := SourceStream.Size;   
    OutStream.Write(Size, UINT32_SIZE);

    // Write datas to the final runtime file
    OutStream.CopyFrom(SourceStream, Size);
    SourceStream.Seek(0, soFromBeginning);

    // Add a new resource
    Inc(ResCount, 1);
  end;

  procedure BindResource(FileName: TFileName; ResType: TResourceType); overload;
  var
    SourceStream: TFileStream;

  begin
    SourceStream := TFileStream.Create(FileName, fmOpenRead);
    try
      BindResource(SourceStream, ResType);
    finally
      SourceStream.Free;
      DeleteFile(FileName);
    end;
  end;

  procedure WriteFakePackage;
  const
    FAKEPACK_RESNAME = 'FAKEPACK';
  var
    FakeFileName: TFileName;
    SourceStream: TFileStream;

  begin
    FakeFileName := GetWorkingTempFileName;
    ExtractFile(FAKEPACK_RESNAME, FakeFileName);
    SourceStream := TFileStream.Create(FakeFileName, fmOpenRead);
    try
      OutStream.CopyFrom(SourceStream, 0);
    finally
      SourceStream.Free;
      DeleteFile(FakeFileName);
    end;
  end;

begin
{$IFDEF DEBUG}
  WriteLn('CompileRuntimePackage');
{$ENDIF}

  ResCount := 0;

  // Generate disc auth files / extra resource files
  DiscAuthFileName := WriteDiscAuthentification;

  // Encrypt the DiscAuth.Inf file with each Media Key.
  if FileExists(DiscAuthFileName) then
  begin
    // Extracting the Runtime Setup Application ('Shenmue Release Unlocker')
    Log('Extracting runtime...');
    RuntimeFileName := _FP(RUNTIME_PACKAGE_RESOURCE_NAME + '.BIN');
    ExtractFile(RUNTIME_PACKAGE_RESOURCE_NAME, RuntimeFileName);

    // Modifiying application ressources...
    if FileExists(AppIcon) then
    begin
      Log('Updating runtime icon...');
      try
        UpdateAppIcon(RuntimeFileName, AppIcon);
      except
        on E:Exception do
          Log('  Unable to update runtime icon, error: ' + E.Message);
      end;
    end;

    // Compress binary by UPX
    Log('Compressing runtime with UPX (Thanks flying to the UPX Team!)...');
    CompressBinary(RuntimeFileName);

    // Opening Runtime to write the extra files inside it.
    OutStream := TFileStream.Create(RuntimeFileName, fmOpenWrite);
    try
      // Move to the end in the Runtime binary...
      OutStream.Seek(0, soFromEnd);

      // Adding the Fake Package to the end of the file (for the 7z Shell Extension)
      WriteFakePackage;

      // Extra Resource Section entry-point
      Offset := OutStream.Position;

      //------------------------------------------------------------------------
      // WRITING PACKAGE.BIN TO RUNTIME
      //------------------------------------------------------------------------

      Log('Writing package to runtime...');
      ReleasePackage := OutputDirectory + RUNTIME_PACKAGE_RELEASE_FILENAME;
      BindResource(ReleasePackage, rtPackage);

      //------------------------------------------------------------------------
      // WRITING RESOURCE FILES
      //------------------------------------------------------------------------

      // Write the primary extra file...
      Log('Writing primary extra resource file...');
      ExtraOutputPackage := _FP(RUNTIME_PRIMARY_EXTRA_RESOURCE_FILENAME);
      BindResource(ExtraOutputPackage, rtResPrimary);

      // Write the secondary extra file...
      Log('Writing secondary extra resource file...');
      ExtraOutputPackage := _FP(RUNTIME_SECONDARY_EXTRA_RESOURCE_FILENAME);
      BindResource(ExtraOutputPackage, rtResSecondary);

      //------------------------------------------------------------------------
      // WRITING DISCAUTH.INF FILES
      //------------------------------------------------------------------------

      Log('Creating disc authentification memory streams...');

{$IFDEF DEBUG}
      WriteLn(sLineBreak, 'Creating DiscAuth.xxx files...', sLineBreak);
{$ENDIF}

      DiscAuthInStream := TFileStream.Create(DiscAuthFileName, fmOpenRead);
      DiscAuthPasswords := TPackagePasswords.Create;
      try
        // For each media key, create a DISCAUTH.xxx file, then write to final Runtime app.
        i := 0;
        while (i < MediaHashKeys.Count) and (not Aborted) do
        begin
          Log(Format('  Processing Key #%d: %s', [i, MediaHashKeys[i]]));

          CryptedStream := TMemoryStream.Create;
          try
            // Encrypt Stream...
            with DiscAuthPasswords do
            begin
              AES := MediaHashKeys[i];
              PC1 := MediaHashKeys[i];
              Camellia := MediaHashKeys[i];
            end;
            EncryptStream(DiscAuthPasswords, DiscAuthInStream, CryptedStream);

            // Write the crypted stream to the binary...
            BindResource(CryptedStream, rtDiscAuth);
          finally
            CryptedStream.Free;
          end;

          Inc(i);
        end; // for
      finally
        DiscAuthPasswords.Free;
        DiscAuthInStream.Free;
{$IFDEF RELEASE}
        DeleteFile(DiscAuthFileName);
{$ENDIF}
      end; // try

      //------------------------------------------------------------------------
      // FINALIZE RUNTIME
      //------------------------------------------------------------------------

      // Write the offset extra header at the end of the file.
      Offset := OutStream.Size - Offset;
      OutStream.Write(Offset, UINT32_SIZE);

      // Write the number of entry at the end of the file too.
      OutStream.Write(ResCount, UINT32_SIZE);

      Log('Finalizing runtime...');
    finally
      OutStream.Free;

      // Move the final runtime binary to the output directory...
      fOutputFileName := OutputDirectory + RUNTIME_PACKAGE_FINAL_OUTPUT;
      if FileExists(OutputFileName) then
        DeleteFile(OutputFileName);
      MoveFile(RuntimeFileName, OutputFileName);
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
    Log('Making release package... please wait.');
    CompressSourcePackage;

    // Encrypt the result compressed package source file with Camellia.
//    EncryptPackage;

    // Compile extra resource (gui, images, etc...)
    Log('Compiling extra resources...');
    CompileExtraFiles;

    // Compile the final package.
    Log('Building final package...');
    CompileRuntimePackage;
  except
    on e:Exception do
    begin
      Log('Error when making package: ' + e.Message);
      Result := False;
    end;
  end;
end;

initialization
  // Extracting 7z library to the temp directory.
  szLzmaLib := GetWorkingTempDirectory + '7z.dll';
  ExtractFile('LZMALIB', szLzmaLib);
  SevenZipSetLibraryFilePath(szLzmaLib);

end.
