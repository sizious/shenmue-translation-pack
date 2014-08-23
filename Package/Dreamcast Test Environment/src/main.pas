unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, DTECore;

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
  private
    { Déclarations privées }  
    fSelectedPresetIndex: Integer;
    fButtonMakeCaption: string;
    fCloseOnProcessRequest: Boolean;
    procedure ChangeControlsState(State: Boolean);
    procedure ChangeQuitControlsState(State: Boolean);
    procedure DreamcastImageMaker_OnAbort(Sender: TObject);
    procedure DreamcastImageMaker_OnProgress(Sender: TObject; Value: Integer);
    procedure DreamcastImageMaker_OnStatus(Sender: TObject; Status: TMakeImageStatus);
    procedure MakeImageProcessCancel;
    procedure MakeImageProcessExecute;
    procedure InitializeEngineComponents;
    procedure ModulesInitialize;
    procedure ModulesFinalize;
    procedure LoadPresets;
    procedure OnEngineComponentsInitializationTerminate(Sender: TObject);
    function GetProgressText: string;
    procedure SetProgressText(const Value: string);
    procedure SetSelectedPresetIndex(const Value: Integer);
  public
    { Déclarations publiques }
    function MsgBox(Text, Title: string; Flags: Integer): Integer;
    property ProgressText: string read GetProgressText write SetProgressText;
    property SelectedPresetIndex: Integer
      read fSelectedPresetIndex write SetSelectedPresetIndex;
  end;

var
  frmMain: TfrmMain;
  DreamcastImageMaker: TDreamcastImageMaker;

implementation

{$R *.dfm}

uses
  SysTools, UITools, WorkDir, LZMADec, Config, Presets, Settings;

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
    DreamcastImageMaker.Settings.Assign(frmSettings.Settings);
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
end;

procedure TfrmMain.ChangeControlsState(State: Boolean);
begin
  btnSettings.Enabled := State;
  btnPresets.Enabled := State;
  cbxVirtualDriveEnabled.Enabled := State;
  cbxEmulatorEnabled.Enabled := State;
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
      ChangeControlsState(True);
    end;
  end;
end;

procedure TfrmMain.MakeImageProcessCancel;
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
    ChangeControlsState(False);
    fCloseOnProcessRequest := False;
    pbrTotal.Position := 0;
    DreamcastImageMaker.Presets[SelectedPresetIndex].Select;
    DreamcastImageMaker.Execute;
  end
  else
    MsgBox('Please select a valid preset.', 'Warning', MB_ICONWARNING);
end;

procedure TfrmMain.btnMakeClick(Sender: TObject);
begin
  if btnMake.Tag = 0 then
    MakeImageProcessExecute
  else
    MakeImageProcessCancel;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if DreamcastImageMaker.Busy then
  begin
    CanClose := False;
    fCloseOnProcessRequest := True;
    MakeImageProcessCancel;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  ChangeQuitControlsState(False);
  pbrTotal.Max := Integer(High(TMakeImageStatus)) + 1;
  fButtonMakeCaption := btnMake.Caption;
  ModulesInitialize;
  LoadPresets;
  LoadConfig;
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

procedure TfrmMain.InitializeEngineComponents;
begin
  // Init of the LZMA module
  SevenZipInitEngine(GetWorkingTempDirectory);

  // Extract the binaries
  with TDreamcastImageInitializerThread.Create(False) do
  begin
    OnTerminate := OnEngineComponentsInitializationTerminate;
  end;
end;

procedure TfrmMain.lbxPresetsClick(Sender: TObject);
begin
  SelectedPresetIndex := lbxPresets.ItemIndex;
end;

procedure TfrmMain.LoadPresets;
var
  i: Integer;

begin
  lbxPresets.Clear;
  for i := 0 to DreamcastImageMaker.Presets.Count - 1 do
  begin
    lbxPresets.Items.Add(DreamcastImageMaker.Presets[i].Name);
  end;
  SelectedPresetIndex := -1;
end;

procedure TfrmMain.ModulesFinalize;
begin
  DreamcastImageMaker.Free;
end;

procedure TfrmMain.ModulesInitialize;
begin
  // Initialize the engine itself
  ProgressText := 'Initializing engine components...';

  // Initialize the components of the engine
  InitializeEngineComponents;

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
    lbxPresets.ItemIndex := fSelectedPresetIndex;
  end
  else
    fSelectedPresetIndex := -1;
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
