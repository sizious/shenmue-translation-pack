unit Settings;

interface

uses
  Windows, SysUtils, Messages, Forms, Variants, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, JvExStdCtrls, JvCombobox, JvDriveCtrls,
  DTECore, JvDialogs;

type
  TfrmSettings = class(TForm)
    pclSettings: TPageControl;
    tbsVirtualDrive: TTabSheet;
    gbxVDFileName: TGroupBox;
    edtVDFileName: TEdit;
    btnVDFileNameBrowse: TButton;
    rdVDNone: TRadioButton;
    rdVDAlcohol: TRadioButton;
    rdVDDaemon: TRadioButton;
    gbxVD: TGroupBox;
    tbsEmulator: TTabSheet;
    gbxEmulator: TGroupBox;
    edtEmulatorFileName: TEdit;
    btnEmulatorFileName: TButton;
    gbxVDLetter: TGroupBox;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Image2: TImage;
    Label4: TLabel;
    cbxVDLetter: TJvDriveCombo;
    btnCancel: TButton;
    Bevel1: TBevel;
    btnOK: TButton;
    opdVDAlcohol: TJvOpenDialog;
    opdVDDaemon: TJvOpenDialog;
    opdEmulator: TJvOpenDialog;
    gbxEmulatorPatches: TGroupBox;
    cbxEmulatorAutoStart: TCheckBox;
    cbxEmulatorShowConsole: TCheckBox;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rdVDNoneClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbxVDLetterChange(Sender: TObject);
    procedure btnVDFileNameBrowseClick(Sender: TObject);
    procedure edtVDFileNameChange(Sender: TObject);
    procedure edtEmulatorFileNameChange(Sender: TObject);
    procedure btnEmulatorFileNameClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Déclarations privées }
    fSettings: TDreamcastImageSettings;
    procedure ChangeEmulatorControlsState(State: Boolean);
    procedure ChangeVirtualDriveControlsState(State: Boolean);
    procedure EmulatorLoadConfig;
    procedure EmulatorSaveConfig;
    procedure LoadCurrentSettings;
    procedure SetEmulatorConfigFile;
    procedure UpdateVirtualDriveControlsState;
  public
    { Déclarations publiques }
    property Settings: TDreamcastImageSettings read fSettings;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

uses
  IniFiles, Main;

const
  SFILE_EMULATOR_CONFIG_FILE = 'nullDC.cfg';

var
  EmulatorConfigFileName: TFileName;
    
procedure TfrmSettings.btnOKClick(Sender: TObject);
begin
  EmulatorSaveConfig;
end;

procedure TfrmSettings.btnVDFileNameBrowseClick(Sender: TObject);
var
  DialogCtrl: TJvOpenDialog;

begin
  DialogCtrl := nil;
  case Settings.VirtualDrive.Kind of
    vdkAlcohol:
      DialogCtrl := opdVDAlcohol;
    vdkDaemonTools:
      DialogCtrl := opdVDDaemon;
  end;
  
  if Assigned(DialogCtrl) then
    with DialogCtrl do
      if Execute then
        edtVDFileName.Text := FileName;
end;

procedure TfrmSettings.btnEmulatorFileNameClick(Sender: TObject);
begin
  with opdEmulator do
    if Execute then
    begin
      edtEmulatorFileName.Text := FileName;
      edtEmulatorFileNameChange(Self);
    end;
end;

procedure TfrmSettings.cbxVDLetterChange(Sender: TObject);
begin
  Settings.VirtualDrive.Drive := cbxVDLetter.Drive;
end;

procedure TfrmSettings.ChangeEmulatorControlsState(State: Boolean);
begin
  cbxEmulatorAutoStart.Enabled := State;
  cbxEmulatorShowConsole.Enabled := State;
end;

procedure TfrmSettings.ChangeVirtualDriveControlsState(State: Boolean);
begin
  btnVDFileNameBrowse.Enabled := State;
  edtVDFileName.Enabled := State;
  cbxVDLetter.Enabled := State;
end;

procedure TfrmSettings.edtEmulatorFileNameChange(Sender: TObject);
begin
  Settings.Emulator.FileName := edtEmulatorFileName.Text;
  SetEmulatorConfigFile;
end;

procedure TfrmSettings.edtVDFileNameChange(Sender: TObject);
begin
  Settings.VirtualDrive.FileName := edtVDFileName.Text;
end;

procedure TfrmSettings.EmulatorLoadConfig;
var
  IniFile: TIniFile;

begin
  SetEmulatorConfigFile;
  if FileExists(EmulatorConfigFileName) then
  begin
    IniFile := TIniFile.Create(EmulatorConfigFileName);
    try
      // Auto Start
      cbxEmulatorAutoStart.Checked :=
        IniFile.ReadInteger('nullDC', 'Emulator.AutoStart', 1) = 1;

      // Show Console
      cbxEmulatorShowConsole.Checked :=
        IniFile.ReadInteger('nullDC', 'Emulator.NoConsole', 0) = 0;

      // Initialize the controls
      ChangeEmulatorControlsState(True);
    finally
      IniFile.Free;
    end;
  end;
end;

procedure TfrmSettings.EmulatorSaveConfig;
var
  IniFile: TIniFile;
  Value: Integer;

begin
  if FileExists(EmulatorConfigFileName) then
  begin
    IniFile := TIniFile.Create(EmulatorConfigFileName);
    try
      // Auto Start
      Value := 1;
      if not cbxEmulatorAutoStart.Checked then Value := 0;
      IniFile.WriteInteger('nullDC', 'Emulator.AutoStart', Value);

      // Show Console
      Value := 1;
      if cbxEmulatorShowConsole.Checked then Value := 0;
      IniFile.WriteInteger('nullDC', 'Emulator.NoConsole', Value);

      // Patch the Image Root in every case
      IniFile.WriteString('ImageReader', 'LastImage', Settings.VirtualDrive.Drive + ':\');
    finally
      IniFile.Free;
    end;
  end;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  fSettings := TDreamcastImageSettings.Create;
  pclSettings.ActivePageIndex := 0;
end;

procedure TfrmSettings.FormDestroy(Sender: TObject);
begin
  fSettings.Free;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  LoadCurrentSettings;
  pclSettings.ActivePageIndex := 0;
  UpdateVirtualDriveControlsState;
end;

procedure TfrmSettings.LoadCurrentSettings;
begin
  Settings.Assign(DreamcastImageMaker.Settings);

  // Virtual Drive
  edtVDFileName.Text := Settings.VirtualDrive.FileName;
  cbxVDLetter.Drive := Settings.VirtualDrive.Drive;
  case Settings.VirtualDrive.Kind of
    vdkNone:
      rdVDNone.Checked := True;
    vdkAlcohol:
      rdVDAlcohol.Checked := True;
    vdkDaemonTools:
      rdVDDaemon.Checked := True;
  end;

  // Emulator
  edtEmulatorFileName.Text := Settings.Emulator.FileName;
  EmulatorLoadConfig;
end;

procedure TfrmSettings.rdVDNoneClick(Sender: TObject);
var
  Index: Integer;

begin
  Index := (Sender as TRadioButton).Tag;
  Settings.VirtualDrive.Kind := TvirtualDriveKind(Index);
  UpdateVirtualDriveControlsState;
end;

procedure TfrmSettings.SetEmulatorConfigFile;
begin
  EmulatorConfigFileName := IncludeTrailingPathDelimiter(
    ExtractFilePath(Settings.Emulator.FileName)) + SFILE_EMULATOR_CONFIG_FILE;
  ChangeEmulatorControlsState(FileExists(EmulatorConfigFileName));
end;

procedure TfrmSettings.UpdateVirtualDriveControlsState;
begin
  ChangeVirtualDriveControlsState(Settings.VirtualDrive.Kind <> vdkNone);
end;

end.
