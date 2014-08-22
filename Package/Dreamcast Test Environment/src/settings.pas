unit Config;

interface

uses
  Windows, SysUtils, Messages, Forms, Variants, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, XMLConf;

type
  TfrmConfig = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    GroupBox3: TGroupBox;
    Edit2: TEdit;
    Button2: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    GroupBox2: TGroupBox;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Button1: TButton;
    GroupBox4: TGroupBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmConfig: TfrmConfig;

function Configuration: TXMLConfigurationFile;
procedure InitConfiguration;
procedure LoadConfig;
procedure SaveConfig;

implementation

{$R *.dfm}

uses
  SysTools, UITools, Main;

type
  EConfigurationNotInitialized = class(Exception);

const
  CONFIG_FILENAME = 'config.xml';
  
var
  _Configuration: TXMLConfigurationFile;

procedure InitConfiguration;
var
  ConfigFile: TFileName;
  ConfigID: string;

begin
  // Create the Configuration object
  ConfigFile := GetApplicationDirectory + CONFIG_FILENAME;
  ConfigID := GetApplicationCodeName;
  _Configuration := TXMLConfigurationFile.Create(ConfigFile, ConfigID);
end;

function Configuration: TXMLConfigurationFile;
begin
  if not Assigned(_Configuration) then
    raise EConfigurationNotInitialized.Create('Sorry, the Configuration ' +
      'object wasn''t initialized! Call InitConfigurationFile() first.');
  Result := _Configuration;
end;

procedure LoadConfig;
begin
  with Configuration do begin
    if not FirstConfiguration then begin
      frmMain.Position := poDesigned;
      ReadFormAttributes(frmMain);
    end;
  end;
end;

procedure SaveConfig;
begin
  with Configuration do begin
    WriteFormAttributes(frmMain);
  end;
end;

initialization
// (nothing)

finalization
//  Configuration.Free;

end.
