unit DTECore;

interface

uses
  Windows, SysUtils, Classes, Forms;
  
type
  // Exceptions
  EMakeDisc = class(Exception);
  EBinHackFileNotFound = class(EMakeDisc);
  EBinHackFailed = class(EMakeDisc);
  EMakeDiscUnableToRunFile = class(EMakeDisc);

  // Virtual Drive Software Type
  TVirtualDriveKind = (vdkNone, vdkAlcohol120, vdkDaemonTools);

  // Progression event
  TProgressEvent = procedure(Sender: TObject; Value: Integer) of object;

  TCoreProcessThread = class;
  
  // Thread for reading the memory of mkisofs
  TMakeImageWatcherThread = class(TThread)
  private
    fOwner: TCoreProcessThread;
  protected
    procedure Execute; override;
  public
    constructor Create; overload;    
  end;

  // Thread for running the process
  TCoreProcessThread = class(TThread)
  private
    fBatchFileName: TFileName;
    fErrOutputFileName: TFileName;
    fStdOutputFileName: TFileName;
    fData1FileName: TFileName;
    fMakeImageWatcherThread: TMakeImageWatcherThread;
    function CatchCommandOutput: string;
    function ExecuteBinHack: Boolean;
    procedure GenerateBatchFile(const Command: string);
    procedure MakeImage;
    procedure MakeImageWatcherThread_Terminate(Sender: TObject);
    function RunCommand(const Command: string): string;
  protected
    procedure Execute; override;
  public
    constructor Create; overload;
  end;

  // Virtual Drive Settings
  TVirtualDriveSettings = class(TObject)
  private
    fDrive: Char;
    fKind: TVirtualDriveKind;
    fDirectory: TFileName;
  public
    property Drive: Char read fDrive write fDrive;
    property Kind: TVirtualDriveKind read fKind write fKind;
    property Directory: TFileName read fDirectory write fDirectory;
  end;

  // Settings Root
  TDreamcastImageSettings = class(TObject)
  private
    fVirtualDrive: TVirtualDriveSettings;
    fEmulator: TFileName;
  public
    constructor Create;
    destructor Destroy; override;
    property Emulator: TFileName read fEmulator write fEmulator;
    property VirtualDrive: TVirtualDriveSettings read fVirtualDrive;
  end;

  // Main Class
  TDreamcastImageMaker = class(TObject)
  private
    fCoreProcessThread: TCoreProcessThread;
    fSettings: TDreamcastImageSettings;
    fProgress: TProgressEvent;
    procedure CoreProcessThread_Terminate(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
    property Settings: TDreamcastImageSettings read fSettings;
    property OnProgress: TProgressEvent read fProgress write fProgress;
  end;

implementation

uses
  JvJCLUtils, SysTools, UITools, WorkDir, ProcUtil;

const
  SFILE_MKISOFS                   = 'mkisofs.exe';
  SFILE_DATA1                     = 'data1.iso';
  SFILE_DATA2                     = 'data2.iso';
  SFILE_BOOTSTRAP_HACKED          = 'IP.HAK';
  SFILE_BOOTSTRAP                 = 'IP.BIN';
  SFILE_BOOT_BINARY               = '1ST_READ.BIN';
  OUTPUT_ERROR_TAG                = '*** ERROR OUTPUT ***';

  MKISOFS_PROGRESS_ADDRESS_XP_32  = $0022B2D4;
  MKISOFS_PROGRESS_ADDRESS_W7_32  = $0022B2AC;
  MKISOFS_PROGRESS_ADDRESS_W7_64  = $0028B2AC;

{ TDreamcastImageMaker }

procedure TDreamcastImageMaker.CoreProcessThread_Terminate(Sender: TObject);
begin
  fCoreProcessThread := nil;
end;

constructor TDreamcastImageMaker.Create;
begin
  fSettings := TDreamcastImageSettings.Create;
end;

destructor TDreamcastImageMaker.Destroy;
begin
  fSettings.Free;
  inherited;
end;

procedure TDreamcastImageMaker.Execute;
begin
  fCoreProcessThread := TCoreProcessThread.Create;
  with fCoreProcessThread do
  begin
    OnTerminate := CoreProcessThread_Terminate;
    Resume;
  end;
end;

{ TDreamcastImageSettings }

constructor TDreamcastImageSettings.Create;
begin
  fVirtualDrive := TVirtualDriveSettings.Create;
end;

destructor TDreamcastImageSettings.Destroy;
begin
  fVirtualDrive.Free;
  inherited;
end;

{ TMakeImageWatcherThread }

constructor TMakeImageWatcherThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
end;

procedure TMakeImageWatcherThread.Execute;
const
  SE_DEBUG_NAME = 'SeDebugPrivilege';

var
  ProcessHwnd,
  Crap,
  ProcessId,
  TokenHwnd: THandle;
  MkisofsProgressValue: Double;
  PreviousState, NewState: TOKEN_PRIVILEGES;
  ReturnLength: Cardinal;
  Address: Cardinal;
  
begin
  // Setting the real address to lookup...
  Address := MKISOFS_PROGRESS_ADDRESS_XP_32;
  if IsWindowsVista then
  begin
    Address := MKISOFS_PROGRESS_ADDRESS_W7_32;
    if Is64BitOS then
      Address := MKISOFS_PROGRESS_ADDRESS_W7_64;
  end;

  // Getting the value !
  if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, TokenHwnd) then
  begin

    try

      // Initializing...
      if not LookupPrivilegeValue(nil, SE_DEBUG_NAME, NewState.Privileges[0].Luid) then
        RaiseLastOSError
      else
      begin
        PreviousState := NewState;
        NewState.PrivilegeCount := 1;
        NewState.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        ReturnLength := 0;
        if not AdjustTokenPrivileges(TokenHwnd, False, NewState, SizeOf(PreviousState), PreviousState, ReturnLength) then
          RaiseLastOSError;
      end;

      // Getting the mkisofs Process Id
      ProcessId := INVALID_HANDLE_VALUE;
      while ProcessId = INVALID_HANDLE_VALUE do
      begin
        ProcessId := GetProcessIdByName('mkisofs.exe');
      end;

      // Reading the mkisofs progress percentage
      ProcessHwnd := OpenProcess(PROCESS_VM_READ or PROCESS_VM_OPERATION, False, ProcessId);
      while ProcessHwnd <> 0 do
      begin
        try
          ReadProcessMemory(ProcessHwnd, Ptr(Address),
            @MkisofsProgressValue, SizeOf(MkisofsProgressValue), Crap);
          WriteLn(Format('%2.2f', [MkisofsProgressValue]));
        finally
          CloseHandle(ProcessHwnd);
        end;
        ProcessHwnd := OpenProcess(PROCESS_VM_READ, False, ProcessId);
      end;

    finally
      CloseHandle(TokenHwnd);
    end;
    
  end;

  WriteLn('END');
end;

{ TCoreProcessThread }

function TCoreProcessThread.CatchCommandOutput: string;
var
  StdBuffer,
  ErrBuffer: TStringList;

begin
  // Appeding the std and err outputs
  StdBuffer := TStringList.Create;
  ErrBuffer := TStringList.Create;
  try
    // Loading the std and err outputs
    if FileExists(fStdOutputFileName) then
      StdBuffer.LoadFromFile(fStdOutputFileName);
    if FileExists(fErrOutputFileName) then
      ErrBuffer.LoadFromFile(fErrOutputFileName);
    StdBuffer.Add(OUTPUT_ERROR_TAG);
    StdBuffer.Append(ErrBuffer.Text);

    // Returning the buffer !
    Result := StdBuffer.Text;
  finally
    StdBuffer.Free;
    ErrBuffer.Free;
  end;
  KillFile(fStdOutputFileName);
  KillFile(fErrOutputFileName);
end;

constructor TCoreProcessThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  fData1FileName := GetWorkingTempDirectory + SFILE_DATA1;
end;

procedure TCoreProcessThread.Execute;
begin
  ExecuteBinHack;
  MakeImage;
end;

function TCoreProcessThread.ExecuteBinHack: Boolean;
var
  SourceDirectory,
  HackedBootstrapFile,
  MainBinaryFile,
  BootstrapFile,
  TempMainBinaryFile,
  TempBootstrapFile: TFileName;
  Command: string;
  
begin
  SourceDirectory := '.\';

  MainBinaryFile := SourceDirectory + SFILE_BOOT_BINARY;
  BootstrapFile := SourceDirectory + SFILE_BOOTSTRAP;

  // Check if the 1ST_READ.BIN file exists
  if not FileExists(MainBinaryFile) then
    raise EBinHackFileNotFound.CreateFmt('Unable to find the Main Binary File: "%s".', [MainBinaryFile]);

  // Check if the IP.BIN file exists
  if not FileExists(BootstrapFile) then
    raise EBinHackFileNotFound.CreateFmt('Unable to find the Boostrap File: "%s".', [BootstrapFile]);

  // Copy the 1ST_READ.BIN to the proper hacking location
  TempMainBinaryFile := GetWorkingTempDirectory + SFILE_BOOT_BINARY;
  CopyFile(MainBinaryFile, TempMainBinaryFile);

  // Copy the IP.BIN to the proper hacking location
  TempBootstrapFile := GetWorkingTempDirectory + SFILE_BOOTSTRAP;
  CopyFile(BootstrapFile, TempBootstrapFile);

  // Execute the command
  Command := Format('(echo %s & echo %s & echo 45000) | binhack', [
    SFILE_BOOT_BINARY,
    SFILE_BOOTSTRAP_HACKED
  ]);
  RunCommand(Command);

  // Check the results
  HackedBootstrapFile := GetWorkingTempDirectory + SFILE_BOOTSTRAP_HACKED;
  Result := FileExists(HackedBootstrapFile);
  if Result then  
  begin
    DeleteFile(TempMainBinaryFile);
    DeleteFile(TempBootstrapFile);
    MoveFile(HackedBootstrapFile, SourceDirectory + SFILE_BOOTSTRAP_HACKED);
  end else
    raise EBinHackFailed.Create('Sorry, the Binary Hacking process failed. Cannot continue.');
end;

procedure TCoreProcessThread.GenerateBatchFile(const Command: string);
var
  BatchBuffer: TStringList;
  S: string;
  
begin
  // Preparing the batch for running the command.
  BatchBuffer := TStringList.Create;
  try
    fBatchFileName := ChangeFileExt(GetWorkingTempFileName, '.BAT');
    BatchBuffer.Add('@echo off');
    BatchBuffer.Add('REM This file was generated by ' + Application.Title + '.');
    BatchBuffer.Add(ExtractFileDrive(GetWorkingTempDirectory));
    BatchBuffer.Add('cd "' + GetWorkingTempDirectory + '"');

    // Catching the output ! (std and err)
    fStdOutputFileName := GetWorkingTempFileName;
    fErrOutputFileName := GetWorkingTempFileName;
    S := Command + Format(' > "%s" 2> "%s"', [fStdOutputFileName, fErrOutputFileName]);
    BatchBuffer.Add(S);

    BatchBuffer.Text := StrToOem(BatchBuffer.Text);
    BatchBuffer.SaveToFile(fBatchFileName);
  finally
    BatchBuffer.Free;
  end;
end;

procedure TCoreProcessThread.MakeImage;
var
  Command: string;

begin
  Command := Format('mkisofs -C 0,45000 -V %s -G "%s" -M "%s" -duplicates-once -l -o data2.iso "%s"', [
    'SHENTEST',
    SFILE_BOOTSTRAP_HACKED,
    fData1FileName,
    GetApplicationDirectory + 'data'
  ]);

  fMakeImageWatcherThread := TMakeImageWatcherThread.Create;
  with fMakeImageWatcherThread do
  begin
    OnTerminate := MakeImageWatcherThread_Terminate;
    Resume;
  end;

  RunCommand(Command);
end;

procedure TCoreProcessThread.MakeImageWatcherThread_Terminate(Sender: TObject);
begin
  fMakeImageWatcherThread := nil;
end;

function TCoreProcessThread.RunCommand(const Command: string): string;
var
  OriginalCurrentDir: TFileName;

begin
  Result := '';
  OriginalCurrentDir := GetCurrentDir;

  GenerateBatchFile(Command);
  if not RunAndWait(fBatchFileName) then
  begin
    raise EMakeDiscUnableToRunFile.CreateFmt('Unable to run the file: "%s".',
      [fBatchFileName]);
  end
  else
  begin
    Result := CatchCommandOutput;
{$IFDEF RELEASE}
    KillFile(fBatchFileName);
{$ENDIF}
  end;

  SetCurrentDir(OriginalCurrentDir);
end;

end.
