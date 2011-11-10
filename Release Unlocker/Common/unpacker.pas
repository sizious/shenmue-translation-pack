unit Unpacker;

interface

uses
  Windows, SysUtils, Classes, OpThBase, D7zipAPI, Common;

type
  EPackageExtractorThread = class(Exception);
  
  TPackageExtractorThread = class(TOperationThread)
  private
    fPasswords: TPackagePasswords;
    fOutputDirectory: TFileName;
    fInputPackageFileName: TFileName;
    fSuccess: Boolean;
    fErrorMessage: string;
    procedure DecompressSourcePackage;
    procedure SetOutputDirectory(const Value: TFileName);
  protected
    procedure Execute; override;
    function ReadPackage: Boolean;
    property InputPackageFileName: TFileName read fInputPackageFileName;
  public
    constructor Create; overload;
    destructor Destroy; override;
    property ErrorMessage: string read fErrorMessage;
    property OutputDirectory: TFileName read fOutputDirectory
      write SetOutputDirectory;
    property Passwords: TPackagePasswords read fPasswords;
    property Success: Boolean read fSuccess;
  end;

function DecompileRuntimePackage: Boolean;
function GetUnlockKeys(MediaHashKey: string;
  ResultPasswords: TPackagePasswords; var UnpackedSize: Int64): Boolean;

implementation

uses
  SysTools, WorkDir, LibCamellia, LibPC1, Base64, IniFiles;

var
  MediaHashKeyFiles: TStringList;
  WorkingThread: TPackageExtractorThread;
  szLzmaLib: TFileName;
  PackageBinaryOffset: Int64;

// CompileRuntimePackage is located in the PackMan.pas unit (multi-threaded)
// Decompile is here because it must be run only 1 time at the Runtime initialization
// because we have UI messages to translate too in this package.

function DecompileRuntimePackage: Boolean;
var
  SourceStream: TFileStream;
  MemoryStream: TMemoryStream;
  Offset, Size,
  ResCount, i: LongWord;
  FileName: TFileName;
  ResType: Byte;

begin
{$IFDEF DEBUG}
  WriteLn('DecompileRuntimePackage');
{$ENDIF}
  SourceStream := TFileStream.Create(ParamStr(0), fmOpenRead or fmShareDenyWrite);
  MemoryStream := TMemoryStream.Create;
  try
    // Seek at the end of the file
    SourceStream.Seek(-(UINT32_SIZE * 2), soFromEnd);
    SourceStream.Read(Offset, UINT32_SIZE);
    Offset := SourceStream.Size - Offset - 8; // 8 for 2 * 4 bytes Int (1 for Offset, 2 for ResCount)
    SourceStream.Read(ResCount, UINT32_SIZE);

    // Positionning at the offset
    SourceStream.Seek(Offset, soFromBeginning);

{$IFDEF DEBUG}
    WriteLn(
      '  Extra Datas Offset: ', Offset, sLineBreak,
      '  Resources Count: ', ResCount
    );
{$ENDIF}

    i := 0;
    while i < ResCount do
    begin
      // Read the resource type
      SourceStream.Read(ResType, SizeOf(ResType));
      
      // Read the size...
      SourceStream.Read(Size, UINT32_SIZE);

{$IFDEF DEBUG}
      Write('  #', i, ': ResType= ', ResType);
{$ENDIF}

      if ResType <> RESTYPE_PACKAGE then
      begin
        // Copy the stream
        MemoryStream.CopyFrom(SourceStream, Size);

        // Save it to a file
        FileName := GetWorkingTempFileName;
        MemoryStream.SaveToFile(FileName);
        MemoryStream.Clear;

{$IFDEF DEBUG}
        WriteLn(sLineBreak, '    FileName= "', FileName, '"');
{$ENDIF}
      end else begin
        SourceStream.Seek(Size, soFromCurrent);
{$IFDEF DEBUG}
        WriteLn('');
{$ENDIF}
      end;

      case ResType of
        // The result package...
        RESTYPE_PACKAGE:
          begin
            PackageBinaryOffset := SourceStream.Position - Size;
{$IFDEF DEBUG}
            WriteLn('    PackageBinaryOffset= ', PackageBinaryOffset);
{$ENDIF}
          end;

        // DiscAuth files...
        RESTYPE_DISCAUTH:
          MediaHashKeyFiles.Add(FileName);

        // AppConfigs...
        RESTYPE_APPCONFIG:
          begin
            with CreateInArchive(CLSID_CFormat7z) do
            begin
              SetPassword(RUNTIME_EXTRA_RESOURCE_PASSWORD);
              OpenFile(FileName);
              ExtractTo(GetWorkingTempDirectory);
              Close;
            end;
            DeleteFile(FileName);
          end;
      end;

      Inc(i);
    end;

    Result := ResCount > 0;
  finally
    SourceStream.Free;
    MemoryStream.Free;
  end;
end;

// Function made to test the media hash key.
// True if the media key is valid. If yes, package unlocking keys are in the
// result 'ResultPasswords' object.
function GetUnlockKeys(MediaHashKey: string; ResultPasswords: TPackagePasswords;
  var UnpackedSize: Int64): Boolean;
const
  DISCAUTH_INVALID_INTEGER = 0;
  DISCAUTH_INVALID_STRING = 'DEADBEEF#DEADBEEF#DEADBEEF#DEADBEEF';

var
  i: Integer;
  DiscAuthFileName: TFileName;
  DiscAuthStream: TFileStream;
  Buffer: TMemoryStream;
  Passwords: TPackagePasswords;
  DiscAuthFile: TIniFile;

begin
  Result := False;
  i := 0;

  while (not Result) and (i < MediaHashKeyFiles.Count) do
  begin
    // Try to decrypt the discauth key...
    DiscAuthStream := TFileStream.Create(MediaHashKeyFiles[i], fmOpenRead);
    Buffer := TMemoryStream.Create;
    Passwords := TPackagePasswords.Create;
    try
      DiscAuthFileName := GetWorkingTempFileName;

      // Decrypt the DiscAuth.inf file...
      with Passwords do
      begin
        AES := MediaHashKey;
        PC1 := MediaHashKey;
        Camellia := MediaHashKey;
      end;
      DecryptStream(Passwords, DiscAuthStream, Buffer);
      Buffer.SaveToFile(DiscAuthFileName);

      // Try to read the discauth.inf file..
      if FileExists(DiscAuthFileName) then
      begin
        DiscAuthFile := TIniFile.Create(DiscAuthFileName);
        try
          with DiscAuthFile do
          begin
            UnpackedSize := StrToInt64Def(ReadString('DISCAUTH', 'DirSize', DISCAUTH_INVALID_STRING), 0);
            Passwords.PC1 := ReadString('DISCAUTH', 'PC1', DISCAUTH_INVALID_STRING);
            Passwords.Camellia := ReadString('DISCAUTH', 'Camellia', DISCAUTH_INVALID_STRING);
            Passwords.AES := ReadString('DISCAUTH', 'AES', DISCAUTH_INVALID_STRING);
          end;
        finally
          DiscAuthFile.Free;
          DeleteFile(DiscAuthFileName);
        end;

        // Important: If the INI is valid, valid parameters were retrived!
        Result :=
              (UnpackedSize <> DISCAUTH_INVALID_INTEGER)
          and (Passwords.PC1 <> DISCAUTH_INVALID_STRING)
          and (Passwords.Camellia <> DISCAUTH_INVALID_STRING)
          and (Passwords.AES <> DISCAUTH_INVALID_STRING);
        if Result then ResultPasswords.Assign(Passwords);
      end;

    finally
      DiscAuthStream.Free;
      Buffer.Free;
      Passwords.Free;
    end;

    // must continue here!
    Inc(i);
  end;
end;

// -----------------------------------------------------------------------------
// TPackageExtractorThread
// -----------------------------------------------------------------------------

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

constructor TPackageExtractorThread.Create;
begin
  inherited;
  fInputPackageFileName := ParamStr(0);
  
  (*fInputPackageFileName := szInputPackageFileName; //ExtractFilePath(ParamStr(0)) + 'PACKAGE.BIN';
  if not FileExists(szInputPackageFileName) then
    raise EPackageExtractorThread.Create('Package file doesn''t exists! FileName: "' + InputPackageFileName + '"');*)

  fPasswords := TPackagePasswords.Create;
end;

procedure TPackageExtractorThread.DecompressSourcePackage;
begin
  with CreateInArchive(CLSID_CFormat7z) do
  begin
    SetProgressCallback(nil, ProgressCallback);
    SetPassword(Passwords.AES);
//    OpenFile(InputPackageFileName);
    OpenFileSFX(InputPackageFileName, PackageBinaryOffset);
    ExtractTo(OutputDirectory);
    Close;
  end;
end;

destructor TPackageExtractorThread.Destroy;
begin
  fPasswords.Free;
  inherited;
end;

procedure TPackageExtractorThread.Execute;
begin
  fTerminated := False;
  WorkingThread := Self;
  try
    fSuccess := ReadPackage;
  finally
    CallSyncFinishEvent;
  end;
end;

function TPackageExtractorThread.ReadPackage: Boolean;
begin
  Result := True;
  try
    DecompressSourcePackage;
  except
    on E:Exception do
    begin
      Result := False;
      fErrorMessage := 'TPackageExtractorThread.ReadPackage: ' + E.ClassName + ' - ' + E.Message;
    end;
  end;
end;

procedure TPackageExtractorThread.SetOutputDirectory(const Value: TFileName);
begin
  fOutputDirectory := IncludeTrailingPathDelimiter(Value);
end;

initialization
  MediaHashKeyFiles := TStringList.Create;
  // Extracting 7z library to the temp directory.
  szLzmaLib := GetWorkingTempDirectory + '7z.dll';
  ExtractFile('LZMALIB', szLzmaLib);
  SevenZipSetLibraryFilePath(szLzmaLib);

finalization
  MediaHashKeyFiles.Free;
  
end.
