unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, BugsMgr, DTECore, AppEvnts,
  JvComponentBase, Menus, JvTrayIcon;

type
  TfrmMain = class(TForm)
    Bevel1: TBevel;
    btnMake: TButton;
    btnQuit: TButton;
    gbxOptions: TGroupBox;
    cbxVirtualDriveEnabled: TCheckBox;
    cbxEmulatorEnabled: TCheckBox;
    gbxPresets: TGroupBox;
    lbxPresets: TListBox;
    gbxConfig: TGroupBox;
    btnPresets: TButton;
    btnSettings: TButton;
    gbxProgress: TGroupBox;
    pbrCurrent: TProgressBar;
    lblProgress: TLabel;
    lblPresets: TLabel;
    pbrTotal: TProgressBar;
    btnAbout: TButton;
    aeMain: TApplicationEvents;
    pmTrayIcon: TPopupMenu;
    miOpen: TMenuItem;
    N1: TMenuItem;
    miQuit: TMenuItem;
    tiTrayIcon: TJvTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnPresetsClick(Sender: TObject);
    procedure btnMakeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure cbxVirtualDriveEnabledClick(Sender: TObject);
    procedure cbxEmulatorEnabledClick(Sender: TObject);
    procedure lbxPresetsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnAboutClick(Sender: TObject);
    procedure aeMainException(Sender: TObject; E: Exception);
    procedure miOpenClick(Sender: TObject);
    procedure tiTrayIconDblClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miQuitClick(Sender: TObject);
  private
    { Déclarations privées }  
    fSelectedPresetIndex: Integer;
    fButtonMakeCaption: string;
    fCloseOnProcessRequest: Boolean;
    procedure BugsHandlerQuitRequest(Sender: TObject);
    procedure ChangeControlsState(State: Boolean);
    procedure ChangeQuitControlsState(State: Boolean);
    function CheckParameters: Boolean;
    procedure DreamcastImageMaker_OnAbort(Sender: TObject);
    procedure DreamcastImageMaker_OnProgress(Sender: TObject; Value: Integer);
    procedure DreamcastImageMaker_OnStatus(Sender: TObject; Status: TMakeImageStatus);
    procedure MakeImageProcessAbort;
    procedure MakeImageProcessExecute;
    procedure InitBugsHandler;
    procedure InitializeEngineComponents;
    procedure InitializeUserInterface;
    procedure ModulesInitialize;
    procedure ModulesFinalize;
    procedure LoadPresets;
    procedure OnEngineComponentsInitializationTerminate(Sender: TObject);
    function GetProgressText: string;
    procedure SetProgressText(const Value: string);
    procedure SetSelectedPresetIndex(const Value: Integer);
    procedure UpdateEmulatorControlState;
  public
    { Déclarations publiques }
    function MsgBox(Text, Title: string; Flags: Integer): Integer;
    procedure UpdateOptionsControls;
    property ProgressText: string read GetProgressText write SetProgressText;
    property SelectedPresetIndex: Integer
      read fSelectedPresetIndex write SetSelectedPresetIndex;
  end;

var
  frmMain: TfrmMain;
  BugsHandler: TBugsHandlerInterface;  
  DreamcastImageMaker: TDreamcastImageMaker;

implementation

{$R *.dfm}

uses
  SysTools, UITools, WorkDir, LZMADec, AppVer, About,
  Config, Presets, Settings;

type
  TDreamcastImageInitializerThread = class(TThread)
  protected
    procedure Execute; override;
  end;

procedure TfrmMain.btnQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
begin
  if frmSettings.ShowModal = mrOK then
  begin
    DreamcastImageMaker.Settings.Assign(frmSettings.Settings);
    UpdateOptionsControls;
  end;
end;

procedure TfrmMain.BugsHandlerQuitRequest(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  RunAboutBox;
end;

procedure TfrmMain.btnPresetsClick(Sender: TObject);
begin
  frmPresets.ShowModal;
  LoadPresets;
end;

procedure TfrmMain.cbxEmulatorEnabledClick(Sender: TObject);
begin
  DreamcastImageMaker.Settings.Emulator.Enabled := cbxEmulatorEnabled.Checked;
end;

procedure TfrmMain.cbxVirtualDriveEnabledClick(Sender: TObject);
begin
  DreamcastImageMaker.Settings.VirtualDrive.Enabled := cbxVirtualDriveEnabled.Checked;
  UpdateEmulatorControlState;
end;

procedure TfrmMain.ChangeControlsState(State: Boolean);
begin
  btnSettings.Enabled := State;
  btnPresets.Enabled := State;
  if not State then
  begin
    cbxVirtualDriveEnabled.Enabled := False;
    cbxEmulatorEnabled.Enabled := False;
  end
  else
    UpdateOptionsControls;
  if State then
  begin
    btnMake.Tag := 0;
    btnMake.Caption := fButtonMakeCaption;
  end
  else
  begin
    btnMake.Tag := 1;
    btnMake.Caption := '&Abort';
  end;
end;

procedure TfrmMain.ChangeQuitControlsState(State: Boolean);
begin
  SetCloseWindowButtonState(Self, State);
  btnQuit.Enabled := State;
  btnMake.Enabled := State;
end;

function TfrmMain.CheckParameters: Boolean;
var
  Preset: TDreamcastImagePresetItem;
  MessagesText: TStringList;

begin
  try
    Preset := DreamcastImageMaker.Presets[SelectedPresetIndex];
    MessagesText := TStringList.Create;
    try
      // Check Source Directory existence
      Result := DirectoryExists(Preset.SourceDirectory);
      if not Result then
        MessagesText.Add('- The source directory of the selected preset doesn''t exists.');

      // Check if the 1ST_READ.BIN is in Source Directory
      Result := FileExists(Preset.SourceDirectory + SFILE_BOOT_BINARY);
      if not Result then
        MessagesText.Add(Format('- The required Dreamcast file, "%s", wasn''t found.', [
        SFILE_BOOT_BINARY]));

      // Check if the IP.BIN is in Source Directory
      Result := FileExists(Preset.SourceDirectory + SFILE_BOOTSTRAP);
      if not Result then
        MessagesText.Add(Format('- The required Dreamcast file, "%s", wasn''t found.', [
        SFILE_BOOTSTRAP]));

      // Check the destination directory, in order to know if we can write on it
      Result := DirectoryExists(ExtractFilePath(Preset.OutputFileName));
      if not Result then
        MessagesText.Add('- The destination directory of the selected preset doesn''t exist.');

      // Final result
      Result := MessagesText.Count = 0;
      if not Result then
        MsgBox(Format('%d error(s) was(were) found:%s%s',
          [MessagesText.Count, sLineBreak, MessagesText.Text]),
          'Warning',
          MB_ICONWARNING);
    finally
      MessagesText.Free;
    end;
  except
    Result := False;
  end;
end;

procedure TfrmMain.DreamcastImageMaker_OnAbort(Sender: TObject);
begin
  pbrCurrent.Position := 0;
  pbrTotal.Position := 0;
  ProgressText := 'Image generation was aborted.';
  ChangeControlsState(True);
  if fCloseOnProcessRequest then
    Close;
end;

procedure TfrmMain.DreamcastImageMaker_OnProgress(Sender: TObject;
  Value: Integer);
begin
  pbrCurrent.Position := Value;
end;

procedure TfrmMain.DreamcastImageMaker_OnStatus(Sender: TObject;
  Status: TMakeImageStatus);
begin
  pbrTotal.Position := pbrTotal.Position + 1;
  pbrCurrent.Position := 0;
  case Status of
    misInitialize:
      ProgressText := 'Initialization...';
    misBinHacking:
      ProgressText := 'Modifying the files...';
    misPrepareImage:
      ProgressText := 'Preparing the building of the image...';
    misBuildDataTrack:
      ProgressText := 'Building the data track...';
    misMakeImage:
      ProgressText := 'Assembling the image...';
    misFinalize:
      ProgressText := 'Finalization...';
    misDone:
    begin
      ProgressText := 'Done!';
      pbrCurrent.Position := pbrCurrent.Max;
      pbrTotal.Position := pbrTotal.Max;
      ChangeControlsState(True);
    end;
  end;
end;

procedure TfrmMain.MakeImageProcessAbort;
begin
  DreamcastImageMaker.Suspend;
  if MsgBox('Are you sure to abort the current process ?',
    'Abort Process',
    MB_ICONWARNING + MB_YESNO + MB_DEFBUTTON2) = IDYES then
  begin
    DreamcastImageMaker.Abort;
    if fCloseOnProcessRequest then
      ChangeQuitControlsState(False);
  end
  else
  begin
    fCloseOnProcessRequest := False;
    DreamcastImageMaker.Resume;
  end;
end;

procedure TfrmMain.MakeImageProcessExecute;
begin
  if SelectedPresetIndex <> -1 then
  begin
    // Execute the process (if possible)
    if CheckParameters then
    begin
      ChangeControlsState(False);
      fCloseOnProcessRequest := False;
      pbrTotal.Position := 0;
      DreamcastImageMaker.Presets[SelectedPresetIndex].Select;
      DreamcastImageMaker.Execute;
    end;
  end
  else
    MsgBox('Please select a valid preset.', 'Warning', MB_ICONWARNING);
end;

procedure TfrmMain.aeMainException(Sender: TObject; E: Exception);
begin
  BugsHandler.Execute(Sender, E);
  aeMain.CancelDispatch;
end;

procedure TfrmMain.btnMakeClick(Sender: TObject);
begin
  if btnMake.Tag = 0 then
    MakeImageProcessExecute
  else
    MakeImageProcessAbort;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if DreamcastImageMaker.Busy then
  begin
    CanClose := False;
    fCloseOnProcessRequest := True;
    MakeImageProcessAbort;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title + ' v' + GetApplicationVersion;
{$IFDEF DEBUG}
  Caption := Caption + ' *DEBUG*';
{$ENDIF}
  ModulesInitialize;
  LoadPresets;
  LoadConfig;
  InitializeUserInterface;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  SaveConfig;
  ModulesFinalize;
end;

function TfrmMain.GetProgressText: string;
begin
  Result := lblProgress.Caption;
end;

procedure TfrmMain.InitBugsHandler;
begin
  BugsHandler := TBugsHandlerInterface.Create;
  try
    BugsHandler.OnQuitRequest := BugsHandlerQuitRequest;
    BugsHandler.LogSaveFeature := False;
  except
    on E: Exception do
      MsgBox('Unable to initialize the Bugs Manager: ' + E.Message,
      'Error',
      MB_ICONERROR);
  end;
end;

procedure TfrmMain.InitializeEngineComponents;
begin
  // Initialize the engine itself
  ProgressText := 'Initializing engine components...';

  // Init of the LZMA module
  SevenZipInitEngine(GetWorkingTempDirectory);

  // Extract the binaries
  with TDreamcastImageInitializerThread.Create(False) do
  begin
    OnTerminate := OnEngineComponentsInitializationTerminate;
  end;
end;

procedure TfrmMain.InitializeUserInterface;
begin
  DoubleBuffered := True;
  InitAboutBox(Application.Title, GetApplicationVersion, 'DC Test Environment');
  pbrTotal.Max := Integer(High(TMakeImageStatus)) + 1;
  fButtonMakeCaption := btnMake.Caption;
  ChangeQuitControlsState(False);
  tiTrayIcon.Hint := Caption;
end;

procedure TfrmMain.lbxPresetsClick(Sender: TObject);
begin
  SelectedPresetIndex := Integer(lbxPresets.Items.Objects[lbxPresets.ItemIndex]);
end;

procedure TfrmMain.LoadPresets;
var
  i: Integer; //, SortedItemIndex

begin
  lbxPresets.Items.BeginUpdate;
  lbxPresets.Clear;
  for i := 0 to DreamcastImageMaker.Presets.Count - 1 do
  begin
    lbxPresets.Items.AddObject(DreamcastImageMaker.Presets[i].Name, TObject(i))
  end;
  lbxPresets.Items.EndUpdate;
  if DreamcastImageMaker.Presets.Count > 0 then
    SelectedPresetIndex := 0
  else
    SelectedPresetIndex := -1;
end;

procedure TfrmMain.ModulesFinalize;
begin
  DreamcastImageMaker.Free;
  BugsHandler.Free;
end;

procedure TfrmMain.ModulesInitialize;
begin
  // Initialize the Bugs Handler
  InitBugsHandler;

  // Initialize the components of the engine
  InitializeEngineComponents;

  // Initialize the engine itself
  DreamcastImageMaker := TDreamcastImageMaker.Create;
  with DreamcastImageMaker do
  begin
    OnAbort := DreamcastImageMaker_OnAbort;
    OnStatus := DreamcastImageMaker_OnStatus;
    OnProgress := DreamcastImageMaker_OnProgress;
  end;
end;

function TfrmMain.MsgBox(Text, Title: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Title), Flags);
end;

procedure TfrmMain.OnEngineComponentsInitializationTerminate(Sender: TObject);
begin
  ChangeQuitControlsState(True);
  ProgressText := '';
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  tiTrayIcon.ShowApplication;
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.SetProgressText(const Value: string);
var
  S: string;

begin
  if Value = '' then S := 'Idle...' else S := Value;
  lblProgress.Caption := S;
end;

procedure TfrmMain.SetSelectedPresetIndex(const Value: Integer);
var
  State: Boolean;

begin
  State := (Value > -1) and (Value < DreamcastImageMaker.Presets.Count);
  if State then
  begin
    fSelectedPresetIndex := Value;
  end
  else
    fSelectedPresetIndex := -1;
{$IFDEF DEBUG}
  if fSelectedPresetIndex <> -1 then
    WriteLn('Selected: ', DreamcastImageMaker.Presets[fSelectedPresetIndex].Name);
{$ENDIF}
end;

procedure TfrmMain.tiTrayIconDblClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  tiTrayIcon.ShowApplication;
end;

procedure TfrmMain.UpdateEmulatorControlState;
begin
  cbxEmulatorEnabled.Enabled := (cbxEmulatorEnabled.Tag = 0)
    and cbxVirtualDriveEnabled.Checked
end;

procedure TfrmMain.UpdateOptionsControls;
begin
  cbxVirtualDriveEnabled.Enabled :=
    (DreamcastImageMaker.Settings.VirtualDrive.Kind <> vdkNone);

  cbxEmulatorEnabled.Tag := 1;
  if cbxVirtualDriveEnabled.Enabled
    and (DreamcastImageMaker.Settings.Emulator.FileName <> '') then
      cbxEmulatorEnabled.Tag := 0;
  UpdateEmulatorControlState;
end;

{ TDreamcastImageInitializer }

procedure TDreamcastImageInitializerThread.Execute;
var
  BinariesFileName: TFileName;

begin
  FreeOnTerminate := True;
  BinariesFileName := GetWorkingTempFileName;
  ExtractFile('ENGINE', BinariesFileName);
  if FileExists(BinariesFileName) then
  begin
    SevenZipExtract(BinariesFileName, GetWorkingTempDirectory);
    DeleteFile(BinariesFileName);
  end;
end;

end.
