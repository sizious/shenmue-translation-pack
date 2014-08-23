unit Settings;

interface

uses
  Windows, SysUtils, Messages, Forms, Variants, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, JvExStdCtrls, JvCombobox, JvDriveCtrls,
  DTECore;

type
  TfrmSettings = class(TForm)
    pclSettings: TPageControl;
    TabSheet2: TTabSheet;
    gbxVDFileName: TGroupBox;
    edtVDFileName: TEdit;
    btnVDFileNameBrowse: TButton;
    rdVDNone: TRadioButton;
    rdVDAlcohol: TRadioButton;
    rdVDDaemon: TRadioButton;
    gbxVD: TGroupBox;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    edtEmulatorFileName: TEdit;
    Button1: TButton;
    gbxVDLetter: TGroupBox;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    cbxVDLetter: TJvDriveCombo;
    btnCancel: TButton;
    Bevel1: TBevel;
    btnOK: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rdVDNoneClick(Sender: TObject);
    procedure cbxVDLetterDriveChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    fSettings: TDreamcastImageSettings;
    procedure LoadCurrentSettings;
  public
    { Déclarations publiques }
    property Settings: TDreamcastImageSettings read fSettings;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

uses
  Main;

procedure TfrmSettings.cbxVDLetterDriveChange(Sender: TObject);
begin
  Settings.VirtualDrive.Drive := cbxVDLetter.Drive;
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
end;

procedure TfrmSettings.rdVDNoneClick(Sender: TObject);
var
  Index: Integer;

begin
  Index := (Sender as TRadioButton).Tag;
  Settings.VirtualDrive.Kind := TvirtualDriveKind(Index);
end;

end.
