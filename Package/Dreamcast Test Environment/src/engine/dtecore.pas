unit DTECore;

interface

uses
  Windows, SysUtils, Classes, Forms, ComCtrls, Messages;

type
  // Classes partial declarations
  TDreamcastImageMaker = class;
  TCoreProcessThread = class;
  TDreamcastImagePresetItem = class;
  TDreamcastImagePresetsList = class;
  TDreamcastImageSettings = class;

  // Exceptions
  EMakeDisc = class(Exception);
  EBinHackFileNotFound = class(EMakeDisc);
  EBinHackFailed = class(EMakeDisc);
  EMakeDiscUnableToRunFile = class(EMakeDisc);
  ENrgHeaderFailed = class(EMakeDisc);
  EMakeImageFailed = class(EMakeDisc);
  EDaemonToolsDriveInvalid = class(EMakeDisc);
  EOutputFileCantBeWritten = class(EMakeDisc);
  
  // Virtual Drive Software Type
  TVirtualDriveKind = (vdkNone, vdkAlcohol, vdkDaemonTools);

  // Status Type
  TMakeImageStatus = (misInitialize, misBinHacking, misPrepareImage, misBuildDataTrack,
    misMakeImage, misFinalize, misDone);

  // Current progress bar event (not "total progress bar")
  TProgressEvent = procedure(Sender: TObject; Value: Integer) of object;

  // Status event
  TStatusEvent = procedure(Sender: TObject; Status: TMakeImageStatus) of object;

  // Thread for reading the memory of mkisofs
  TMakeImageWatcherThread = class(TThread)
  private
    fProgressStarted: Boolean;
    fOwner: TCoreProcessThread;
    fProgressBegin: TNotifyEvent;
    procedure InitializeProgressBar;
    procedure FinalizeProgressBar;
    procedure UpdateProgressBar(const Value: Double);
    function GetDreamcastImageMakerOwner: TDreamcastImageMaker;
    property Parent: TDreamcastImageMaker read GetDreamcastImageMakerOwner;
  protected
    procedure Execute; override;
  public
    constructor Create; overload;
    property OnProgressBegin: TNotifyEvent read fProgressBegin write fProgressBegin;
    property Owner: TCoreProcessThread read fOwner write fOwner;
  end;

  // Thread for running the process
  TCoreProcessThread = class(TThread)
  private
    fSettings: TDreamcastImageSettings;
    fVirtualDriveID: string;
    fBatchFileName: TFileName;
    fErrOutputFileName: TFileName;
    fStdOutputFileName: TFileName;
    fData1FileName: TFileName;
    fData2FileName: TFileName;
    fMakeImageWatcherThread: TMakeImageWatcherThread;
    fOwner: TDreamcastImageMaker;
    fException: Exception;
    fPreset: TDreamcastImagePresetItem;
    function CatchCommandOutput: string;
    procedure CheckWritePermissions;
    procedure DoHandleException;
    procedure ExecuteBinHack;
    procedure ExecuteEmulator;
    procedure ExecuteNrgHeader;
    procedure FastCopyFileCallback(const FileName: TFileName;
      const CurrentSize, TotalSize: LongWord; var CanContinue: Boolean);
    procedure InitializeSettings;
    procedure GenerateBatchFile(const Command: string);
    function GetVirtualDriveLetter: string;
    procedure HandleException;
    procedure MakeDataTrack;
    procedure MakeImageWatcherThread_ProgressBegin(Sender: TObject);
    procedure MakeImageWatcherThread_Terminate(Sender: TObject);
    procedure MergeTracks;    
    procedure MountImage;
    procedure NotifyStatus(Status: TMakeImageStatus);
    function RunCommand(const Command: string): string;
    procedure UnmountImage;
    property Settings: TDreamcastImageSettings read fSettings;
    property VirtualDriveID: string read fVirtualDriveID;
  protected
    procedure Execute; override;
  public
    constructor Create; overload;
    destructor Destroy; override;
    property Owner: TDreamcastImageMaker read fOwner write fOwner;
    property Preset: TDreamcastImagePresetItem read fPreset;
  end;

  // Image Preset Item
  TDreamcastImagePresetItem = class(TObject)
  private
    fOwner: TDreamcastImagePresetsList;
    fParent: TDreamcastImageMaker;
    fName: string;
    fSourceDirectory: TFileName;
    fOutputFileName: TFileName;
    fVolumeName: string;
    procedure SetSourceDirectory(const Value: TFileName);
  public
    procedure Assign(Source: TDreamcastImagePresetItem);
    procedure Select;
    property Name: string read fName write fName;
    property SourceDirectory: TFileName
      read fSourceDirectory write SetSourceDirectory;
    property OutputFileName: TFileName
      read fOutputFileName write fOutputFileName;
    property VolumeName: string read fVolumeName write fVolumeName;
  end;

  // Presets List Manager
  TDreamcastImagePresetsList = class(TObject)
  private
    fCacheFileName: TFileName;
    fOwner: TDreamcastImageMaker;
    fList: TList;
    function GetItem(Index: Integer): TDreamcastImagePresetItem;
    function GetCount: Integer;
  protected
    function LoadFromFile(const FileName: TFileName): Boolean;
    procedure SaveToFile(const FileName: TFileName);
  public
    constructor Create(AOwner: TDreamcastImageMaker);
    destructor Destroy; override;
    function Add: TDreamcastImagePresetItem;
    procedure Clear;
    procedure Delete(const Index: Integer);
    procedure Select(const Index: Integer);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TDreamcastImagePresetItem
      read GetItem; default;
  end;

  // Emulator Settings
  TDreamcastEmulatorSettings = class(TObject)
  private
    fFileName: TFileName;
    fEnabled: Boolean;
  public
    property Enabled: Boolean read fEnabled write fEnabled;
    property FileName: TFileName read fFileName write fFileName;
  end;

  // Virtual Drive Settings
  TVirtualDriveSettings = class(TObject)
  private
    fDrive: Char;
    fKind: TVirtualDriveKind;
    fFileName: TFileName;
    fEnabled: Boolean;
  public
    property Drive: Char read fDrive write fDrive;
    property Enabled: Boolean read fEnabled write fEnabled;
    property Kind: TVirtualDriveKind read fKind write fKind;
    property FileName: TFileName read fFileName write fFileName;
  end;

  // Settings Root
  TDreamcastImageSettings = class(TObject)
  private
    fVirtualDrive: TVirtualDriveSettings;
    fEmulator: TDreamcastEmulatorSettings;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TDreamcastImageSettings);
    property Emulator: TDreamcastEmulatorSettings read fEmulator;
    property VirtualDrive: TVirtualDriveSettings read fVirtualDrive;
  end;

  // Main Class
  TDreamcastImageMaker = class(TObject)
  private
    fAbortedFlag: Boolean;
    fCoreProcessThread: TCoreProcessThread;
    fSettings: TDreamcastImageSettings;
    fProgress: TProgressEvent;
    fStatus: TStatusEvent;
    fPresets: TDreamcastImagePresetsList;
    fSelectedPreset: TDreamcastImagePresetItem;
    fAbort: TNotifyEvent;
    fBusy: Boolean;
    procedure CoreProcessThread_Terminate(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Abort;
    procedure Execute;
    procedure Resume;
    procedure Suspend;
    property Busy: Boolean read fBusy;
    property Presets: TDreamcastImagePresetsList read fPresets;
    property Settings: TDreamcastImageSettings read fSettings;
    property OnAbort: TNotifyEvent read fAbort write fAbort;
    property OnProgress: TProgressEvent read fProgress write fProgress;
    property OnStatus: TStatusEvent read fStatus write fStatus;
  end;

implementation

uses
  IniFiles, Math, JvJCLUtils,
  SysTools, UITools, WorkDir, ProcUtil, FastCopy;

const
  SFILE_NRGHEADER                 = 'nrghdr.exe';
  SFILE_BINHACK                   = 'binhack.exe';
  SFILE_MKISOFS                   = 'mkisofs.exe';
  SFILE_DATA0_LEADIN              = 'leadin.bin';
  SFILE_DATA0_NRGHEADER           = 'nrghdr.bin';
  SFILE_DATA1                     = 'data1.iso';
  SFILE_DATA2                     = 'data2.iso';
  SFILE_BOOTSTRAP_HACKED          = 'IP.HAK';
  SFILE_BOOTSTRAP                 = 'IP.BIN';
  SFILE_BOOT_BINARY               = '1ST_READ.BIN';
  OUTPUT_ERROR_TAG                = '*** ERROR OUTPUT ***';

  MKISOFS_PROGRESS_ADDRESS_XP     = $0022B2D4; // XP x86 and x64
  MKISOFS_PROGRESS_ADDRESS_W7_32  = $0022B2AC; // Vista, 7, 8 and 8.1 x86
  MKISOFS_PROGRESS_ADDRESS_W7_64  = $0028B2AC; // Vista, 7, 8 and 8.1 x64

  MKISOFS_PROGRESS_VALUE_MIN      = 0;
  MKISOFS_PROGRESS_VALUE_MAX      = 100;

{ TDreamcastImageMaker }

procedure TDreamcastImageMaker.Abort;
begin
  fAbortedFlag := True;
  if Assigned(fCoreProcessThread) then
  begin
    fCoreProcessThread.Terminate;
    KillProcess(SFILE_MKISOFS);
  end;
  Resume;
end;

procedure TDreamcastImageMaker.CoreProcessThread_Terminate(Sender: TObject);
begin
  fBusy := False;
  fCoreProcessThread := nil;
  if fAbortedFlag and Assigned(OnAbort) then
    OnAbort(Self);
end;

constructor TDreamcastImageMaker.Create;
begin
  fSettings := TDreamcastImageSettings.Create;
  fPresets := TDreamcastImagePresetsList.Create(Self);
  fSelectedPreset := TDreamcastImagePresetItem.Create;
end;

destructor TDreamcastImageMaker.Destroy;
begin
  fSettings.Free;
  fPresets.Free;
  fSelectedPreset.Free;
  inherited;
end;

procedure TDreamcastImageMaker.Execute;
begin
  fAbortedFlag := False;
  fBusy := True;
  fCoreProcessThread := TCoreProcessThread.Create;
  with fCoreProcessThread do
  begin
    Owner := Self;
    OnTerminate := CoreProcessThread_Terminate;
    Preset.Assign(Self.fSelectedPreset);
    Resume;
  end;
end;

procedure TDreamcastImageMaker.Resume;
begin
  if Assigned(fCoreProcessThread) and fCoreProcessThread.Suspended then
    fCoreProcessThread.Resume;
end;

procedure TDreamcastImageMaker.Suspend;
begin
  if Assigned(fCoreProcessThread) and not fCoreProcessThread.Suspended then
    fCoreProcessThread.Suspend;
end;

{ TDreamcastImageSettings }

procedure TDreamcastImageSettings.Assign(Source: TDreamcastImageSettings);
begin
  Self.Emulator.Enabled := Source.Emulator.Enabled;
  Self.Emulator.FileName := Source.Emulator.FileName;
  Self.VirtualDrive.Drive := Source.VirtualDrive.Drive;
  Self.VirtualDrive.Enabled := Source.VirtualDrive.Enabled;
  Self.VirtualDrive.Kind := Source.VirtualDrive.Kind;
  Self.VirtualDrive.FileName := Source.VirtualDrive.FileName;
end;

constructor TDreamcastImageSettings.Create;
begin
  fVirtualDrive := TVirtualDriveSettings.Create;
  fEmulator := TDreamcastEmulatorSettings.Create;
end;

destructor TDreamcastImageSettings.Destroy;
begin
  fVirtualDrive.Free;
  fEmulator.Free;
  inherited;
end;

{ TMakeImageWatcherThread }

constructor TMakeImageWatcherThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  fProgressStarted := False;
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
  PreviousState,
  NewState: TTokenPrivileges;
  ReturnLength,
  Address: Cardinal;
  
begin
  // Initializing ProgressBar...
  InitializeProgressBar;

  // Setting the real address to lookup...
  Address := MKISOFS_PROGRESS_ADDRESS_XP;
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
        ProcessId := GetProcessIdByName(SFILE_MKISOFS);
      end;

      // Reading the mkisofs progress percentage
      ProcessHwnd := OpenProcess(PROCESS_VM_READ or PROCESS_VM_OPERATION, False, ProcessId);
      while (ProcessHwnd <> 0) and (ProcessId <> INVALID_HANDLE_VALUE) do
      begin
        try
          ReadProcessMemory(ProcessHwnd, Ptr(Address),
            @MkisofsProgressValue, SizeOf(MkisofsProgressValue), Crap);
{$IFDEF DEBUG}
          WriteLn(Format('%2.2f', [MkisofsProgressValue]));
{$ENDIF}
          // Updating on-screen ProgressBar
          UpdateProgressBar(MkisofsProgressValue);
        finally
          CloseHandle(ProcessHwnd);
        end;
        ProcessId := GetProcessIdByName(SFILE_MKISOFS);
        ProcessHwnd := OpenProcess(PROCESS_VM_READ, False, ProcessId);
      end;

    finally
      CloseHandle(TokenHwnd);
    end;

  end;

  // Finalizing ProgressBar...
  FinalizeProgressBar;

{$IFDEF DEBUG}
  WriteLn('MKISOFS Progress Done!');
{$ENDIF}
end;

procedure TMakeImageWatcherThread.FinalizeProgressBar;
begin
  UpdateProgressBar(MKISOFS_PROGRESS_VALUE_MAX);
end;

function TMakeImageWatcherThread.GetDreamcastImageMakerOwner: TDreamcastImageMaker;
begin
  Result := Self.Owner.Owner;
end;

procedure TMakeImageWatcherThread.InitializeProgressBar;
begin
  UpdateProgressBar(MKISOFS_PROGRESS_VALUE_MIN);
end;

procedure TMakeImageWatcherThread.UpdateProgressBar(const Value: Double);
var
  ProgressValue: Integer;

begin
  ProgressValue := Ceil(Value);
  if (ProgressValue > 1) then
  begin
    // For the ProgressBegin event
    if not fProgressStarted then
    begin
      fProgressStarted := True;
      if Assigned(OnProgressBegin) then
        OnProgressBegin(Self);
    end;

    // For the current progress bar value
    if Assigned(Parent.OnProgress) then
      Parent.OnProgress(Parent, ProgressValue);
  end;
end;

{ TCoreProcessThread }

procedure TCoreProcessThread.MountImage;
var
  Command: string;

begin
  if (not Terminated)
    and (VirtualDriveID <> '') and (Settings.VirtualDrive.Enabled) then
  begin
    Command := '';
    case Settings.VirtualDrive.Kind of
      vdkAlcohol:
        Command := Format('"%s" %s: /M:"%s"', [Settings.VirtualDrive.FileName,
          VirtualDriveID, Preset.OutputFileName]);
      vdkDaemonTools:
        Command := Format('"%s" -mount %s,"%s"', [Settings.VirtualDrive.FileName,
          VirtualDriveID, Preset.OutputFileName]);
    end;
    if Command <> '' then
      RunCommand(Command);
  end;
end;

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

procedure TCoreProcessThread.CheckWritePermissions;
begin
  if not KillFile(Preset.OutputFileName) then
    raise EOutputFileCantBeWritten.CreateFmt('Sorry, but the specified ' +
      'output file location isn''t writable. Check if the specified location ' +
      'exists, is writable (e.g. not a DVD-ROM drive) and you have the proper ' +
      'rights (e.g. beware of UAC). File: "%s".', [Preset.OutputFileName]); 
end;

constructor TCoreProcessThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  fPreset := TDreamcastImagePresetItem.Create;
  fSettings := TDreamcastImageSettings.Create;
  fData1FileName := GetWorkingTempDirectory + SFILE_DATA1;
  fData2FileName := GetWorkingTempDirectory + SFILE_DATA2;
end;

destructor TCoreProcessThread.Destroy;
begin
  fPreset.Free;
  fSettings.Free;
  inherited Destroy;
end;

procedure TCoreProcessThread.DoHandleException;
begin
  // Cancel the mouse capture
  if GetCapture <> 0 then
    SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    
  // Now actually show the exception
  if fException is Exception then
    Application.ShowException(fException)
  else
    SysUtils.ShowException(fException, nil);

  // Notifying the parent of the process is aborted.
  if Assigned(Owner.OnAbort) then
    Owner.OnAbort(Owner);
end;

procedure TCoreProcessThread.Execute;
const
  WATCHER_THREAD_MAX_TRIES = 10;
  
var
  i: Integer;
  
begin
  fException := nil;
  try
    // Prepare the environment
    NotifyStatus(misInitialize);
    InitializeSettings;
    UnmountImage;
    CheckWritePermissions;
    
    // Build the selected preset
    ExecuteBinHack;
    MakeDataTrack;
    MergeTracks;
    ExecuteNrgHeader;
    NotifyStatus(misDone);

    // Mount the image (if needed)
    MountImage;

    // Run the Emulator (if needed)
    ExecuteEmulator;

    // Clean the incomplete file if needed
    if Terminated then
    begin
      KillFile(Preset.OutputFileName);
      // Waiting the Watcher Thread for its ends.
      i := 0;
      while Assigned(fMakeImageWatcherThread) and (i < WATCHER_THREAD_MAX_TRIES) do
      begin
        Sleep(1000);
        Inc(i);
      end;
    end;
  except
    HandleException;
  end;
end;

procedure TCoreProcessThread.ExecuteBinHack;
var
  HackedBootstrapFile,
  MainBinaryFile,
  BootstrapFile,
  TempMainBinaryFile,
  TempBootstrapFile: TFileName;
  Command: string;
  
begin
  if not Terminated then
  begin
    // Notify Bin Hacking Start...
    NotifyStatus(misBinHacking);

    MainBinaryFile := Preset.SourceDirectory + SFILE_BOOT_BINARY;
    BootstrapFile := Preset.SourceDirectory + SFILE_BOOTSTRAP;

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
    Command := Format('(echo %s & echo %s & echo 45000) | %s', [
      SFILE_BOOT_BINARY,
      SFILE_BOOTSTRAP_HACKED,
      SFILE_BINHACK
    ]);
    RunCommand(Command);

    // Check the results
    HackedBootstrapFile := GetWorkingTempDirectory + SFILE_BOOTSTRAP_HACKED;
    if FileExists(HackedBootstrapFile) then
    begin
      DeleteFile(TempMainBinaryFile);
      DeleteFile(TempBootstrapFile);
      MoveFile(HackedBootstrapFile, Preset.SourceDirectory + SFILE_BOOTSTRAP_HACKED);
    end else
      raise EBinHackFailed.Create('Sorry, the Binary Hacking process failed. Cannot continue.');
  end;
end;

procedure TCoreProcessThread.ExecuteEmulator;
begin
  if (not Terminated)
    and (Settings.VirtualDrive.Enabled) and (Settings.Emulator.Enabled) then
  begin
    RunNoWait(Settings.Emulator.FileName);
  end;
end;

procedure TCoreProcessThread.ExecuteNrgHeader;
const
  NRGHEADER_SUCCESS = 'Done!';

var
  NrgHeader,
  OutputDirectory: TFileName;
  OutputBuffer,
  Command: string;

begin
  if not Terminated then
  begin
    // Running nrghdr
    // The nrghdr program made by Indiket can only works with relative paths
    NotifyStatus(misFinalize);

    OutputDirectory := ExtractFilePath(Preset.OutputFileName);
    NrgHeader := OutputDirectory + SFILE_NRGHEADER;
    FastCopyFile(GetWorkingTempDirectory + SFILE_NRGHEADER, NrgHeader);

    Command := Format('%s' + sLineBreak + 'cd "%s"' + sLineBreak + 'echo %s | %s', [
      ExtractFileDrive(OutputDirectory),
      OutputDirectory,
      ExtractFileName(Preset.OutputFileName),
      SFILE_NRGHEADER
    ]);
    OutputBuffer := RunCommand(Command);
    KillFile(NrgHeader);

    if not IsInString(NRGHEADER_SUCCESS, OutputBuffer) then
      raise ENrgHeaderFailed.Create('Sorry, the Nero Header Hacking process failed. Cannot continue.');
  end;
end;

procedure TCoreProcessThread.FastCopyFileCallback(const FileName: TFileName;
  const CurrentSize, TotalSize: LongWord; var CanContinue: Boolean);
var
  ProgressValue: Integer;

begin
  CanContinue := not Terminated;
  ProgressValue := Round((CurrentSize / TotalSize) * 100);
  if Assigned(Owner.OnProgress) then
    Owner.OnProgress(Owner, ProgressValue);
end;

procedure TCoreProcessThread.MergeTracks;
var
  Data0LeadIn,
  Data0NrgHeader: TFileName;
  
begin
  if not Terminated then
  begin
    // Copying files block in the following order:
    // leadin + data1.iso + data2.iso + nrgheader
    NotifyStatus(misMakeImage);
    Data0LeadIn := GetWorkingTempDirectory + SFILE_DATA0_LEADIN;
    Data0NrgHeader := GetWorkingTempDirectory + SFILE_DATA0_NRGHEADER;
    FastCopyFile(Data0LeadIn, Preset.OutputFileName);
    FastCopyFile(fData1FileName, Preset.OutputFileName, fcfmAppend);
    FastCopyFile(fData2FileName, Preset.OutputFileName, fcfmAppend, FastCopyFileCallback);
    FastCopyFile(Data0NrgHeader, Preset.OutputFileName, fcfmAppend);
  end;

  // Deleting the temporary data image because it's now useless
  KillFile(fData2FileName);
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

function TCoreProcessThread.GetVirtualDriveLetter: string;
var
  Command,
  OutputBuffer: string;
  i,
  VirtualDrivesCount,
  VirtualDriveIndex,
  BaseLetterIndex: Integer;
  Found: Boolean;
  VirtualDriveLetter: Char;

begin
  Result := '';
  case Settings.VirtualDrive.Kind of
    // Alcohol
    vdkAlcohol:
      // Very simple for Alcohol
      Result := Settings.VirtualDrive.Drive;

    // Daemon Tools
    vdkDaemonTools:
    begin
      // For Deamon Tools, we need to translate the drive letter to the internal ID

      // Base Letter
      BaseLetterIndex := Ord('A');

      // Get Virtual Drives Count
      Command := Format('"%s" -get_count' + sLineBreak
        + 'echo %%errorlevel%%', [Settings.VirtualDrive.FileName]);
      OutputBuffer := Copy(RunCommand(Command), 1, 1);
      VirtualDrivesCount := StrToIntDef(OutputBuffer, 0);

      // Search the corresponding Virtual Drive
      Found := False;
      i := 0;
      while (not Found) and (i < VirtualDrivesCount) do
      begin
        Command := Format('"%s" -get_letter %d' + sLineBreak
          + 'echo %%errorlevel%%', [Settings.VirtualDrive.FileName, i]);
        OutputBuffer := Trim(Left(sLineBreak, RunCommand(Command)));
        VirtualDriveIndex := StrToIntDef(OutputBuffer, -1); // drive letter as number
        if VirtualDriveIndex > -1 then
        begin
          Inc(VirtualDriveIndex, BaseLetterIndex); // to translate to uppercase letter
          VirtualDriveLetter := Chr(VirtualDriveIndex);
          Found := (Settings.VirtualDrive.Drive = VirtualDriveLetter);
          if Found then Result := IntToStr(i); // If found, return the drive index
        end;
        Inc(i);
      end;

      // Return an exception if the specified drive isn't created by Daemon Tools
      if Result = '' then
        raise EDaemonToolsDriveInvalid.CreateFmt('Sorry, but the drive %s: ' +
          'seems to be invalid for using with Deamon Tools.', [Settings.VirtualDrive.Drive]);
    end;
  end;
end;

procedure TCoreProcessThread.HandleException;
begin
  fException := Exception(ExceptObject);
  try
    // Don't show EAbort messages
    if not (fException is EAbort) then
      Synchronize(DoHandleException);
  finally
    fException := nil;
  end;
end;

procedure TCoreProcessThread.InitializeSettings;
begin
  Settings.Assign(Owner.Settings);
  fVirtualDriveID := GetVirtualDriveLetter;
end;

procedure TCoreProcessThread.MakeDataTrack;
const
  MKISOFS_INVALID_SOURCE  = 'No such file or directory. Invalid node';
  MKISOFS_INVALID_VOLID   = 'Volume ID string too long';

var
  Command,
  OutputBuffer: string;

begin
  if not Terminated then
  begin
    // Notify Prepare Image...
    NotifyStatus(misPrepareImage);

    Command := Format('%s -C 0,45000 -V %s -G "%s" -M "%s" -duplicates-once ' +
      '-l -o "%s" "%s"', [
      SFILE_MKISOFS,
      Preset.VolumeName,
      SFILE_BOOTSTRAP_HACKED,
      fData1FileName,
      fData2FileName,
      ExcludeTrailingPathDelimiter(Preset.SourceDirectory)
    ]);

    fMakeImageWatcherThread := TMakeImageWatcherThread.Create;
    with fMakeImageWatcherThread do
    begin
      Owner := Self;
      OnProgressBegin := MakeImageWatcherThread_ProgressBegin;
      OnTerminate := MakeImageWatcherThread_Terminate;
      Resume;
    end;

    OutputBuffer := RunCommand(Command);

    // Check for errors
    if IsInString(MKISOFS_INVALID_SOURCE, OutputBuffer) then
      raise EMakeImageFailed.CreateFmt('Unable to find source directory for ' +
        'making the image: "%s".', [Preset.SourceDirectory]);

    if IsInString(MKISOFS_INVALID_VOLID, OutputBuffer) then
      raise EMakeImageFailed.CreateFmt('The Volume ID "%s" is too long.', [
        Preset.VolumeName]);
  end;
end;

procedure TCoreProcessThread.MakeImageWatcherThread_ProgressBegin(Sender: TObject);
begin
  NotifyStatus(misBuildDataTrack);
end;

procedure TCoreProcessThread.MakeImageWatcherThread_Terminate(Sender: TObject);
begin
  fMakeImageWatcherThread := nil;
end;

procedure TCoreProcessThread.NotifyStatus(Status: TMakeImageStatus);
begin
  if not Terminated and Assigned(Owner.OnStatus) then
    Owner.OnStatus(Owner, Status);
end;

function TCoreProcessThread.RunCommand(const Command: string): string;
var
  OriginalCurrentDir: TFileName;

begin
  Result := '';
  if not Terminated then
  begin
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

{$IFDEF DEBUG}
    WriteLn(
      sLineBreak,
      '### OUTPUT START ###', sLineBreak,
      Command, sLineBreak,
      Result, sLineBreak,
      '### OUTPUT END ###',
      sLineBreak
    );
{$ENDIF}

    SetCurrentDir(OriginalCurrentDir);
  end;
end;

procedure TCoreProcessThread.UnmountImage;
var
  Command: string;

begin
  if VirtualDriveID <> '' then
  begin
    Command := '';
    case Settings.VirtualDrive.Kind of
      vdkAlcohol:
        Command := Format('"%s" %s: /U', [Settings.VirtualDrive.FileName,
          VirtualDriveID]);
      vdkDaemonTools:
        Command := Format('"%s" -unmount %s', [Settings.VirtualDrive.FileName,
          VirtualDriveID]);
    end;
    if Command <> '' then
      RunCommand(Command);
  end;
end;

{ TDreamcastImagePresetsList }

function TDreamcastImagePresetsList.Add: TDreamcastImagePresetItem;
begin
  Result := TDreamcastImagePresetItem.Create;
  Result.fOwner := Self;
  Result.fParent := Self.fOwner;
  fList.Add(Result);
end;

procedure TDreamcastImagePresetsList.Clear;
var
  i: Integer;

begin
  for i := 0 to fList.Count - 1 do
    TDreamcastImagePresetItem(fList[i]).Free;
  fList.Clear;
end;

constructor TDreamcastImagePresetsList.Create(AOwner: TDreamcastImageMaker);
begin
  fCacheFileName := GetApplicationDirectory + 'presets.ini';
  fList := TList.Create;
  fOwner := AOwner;
  LoadFromFile(fCacheFileName);
end;

destructor TDreamcastImagePresetsList.Destroy;
begin
  SaveToFile(fCacheFileName);
  Clear;
  fList.Free;
  inherited;
end;

function TDreamcastImagePresetsList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TDreamcastImagePresetsList.GetItem(
  Index: Integer): TDreamcastImagePresetItem;
begin
  Result := TDreamcastImagePresetItem(fList[Index]);
end;

function TDreamcastImagePresetsList.LoadFromFile(
  const FileName: TFileName): Boolean;
var
  IniFile: TIniFile;
  i: Integer;
  
begin
  Result := FileExists(FileName);
  if Result then
  begin
    IniFile := TIniFile.Create(FileName);
    try
      for i := 0 to IniFile.ReadInteger('General', 'Count', 0) - 1 do
        with Add do
        begin
          Name := IniFile.ReadString(IntToStr(i), 'Name', '');
          SourceDirectory := IniFile.ReadString(IntToStr(i), 'SourceDirectory', '');
          OutputFileName := IniFile.ReadString(IntToStr(i), 'OutputFileName', '');
          VolumeName := IniFile.ReadString(IntToStr(i), 'VolumeName', '');
        end;
    finally
      IniFile.Free;
    end;
  end;
end;

procedure TDreamcastImagePresetsList.SaveToFile(const FileName: TFileName);
var
  IniFile: TIniFile;
  i: Integer;
  Item: TDreamcastImagePresetItem;

begin
  KillFile(FileName);
  IniFile := TIniFile.Create(FileName);
  try
    IniFile.WriteInteger('General', 'Count', Count);
    for i := 0 to Count - 1 do
    with IniFile do
    begin
      Item := Items[i];
      WriteString(IntToStr(i), 'Name', Item.Name);
      WriteString(IntToStr(i), 'SourceDirectory', Item.SourceDirectory);
      WriteString(IntToStr(i), 'OutputFileName', Item.OutputFileName);
      WriteString(IntToStr(i), 'VolumeName', Item.VolumeName);
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TDreamcastImagePresetsList.Select(const Index: Integer);
begin
  Items[Index].Select;
end;

procedure TDreamcastImagePresetsList.Delete(const Index: Integer);
begin
  TDreamcastImagePresetItem(fList[Index]).Free;
  fList.Delete(Index);
end;

{ TDreamcastImagePresetEntry }

procedure TDreamcastImagePresetItem.Assign(Source: TDreamcastImagePresetItem);
begin
  Self.fName := Source.fName;
  Self.fSourceDirectory := Source.fSourceDirectory;
  Self.fOutputFileName := Source.fOutputFileName;
  Self.fVolumeName := Source.fVolumeName;
end;

procedure TDreamcastImagePresetItem.Select;
begin
  fParent.fSelectedPreset.Assign(Self);
end;

procedure TDreamcastImagePresetItem.SetSourceDirectory(const Value: TFileName);
begin
  fSourceDirectory := IncludeTrailingPathDelimiter(Value);
end;

end.
