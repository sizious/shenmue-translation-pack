unit Config;

interface

uses
  Windows, SysUtils, Forms;

procedure LoadConfig;  
procedure SaveConfig;

implementation

uses
  Graphics, SysTools, UITools, XMLConf, Main, DTECore;

var
  ConfigFile: TXMLConfigurationFile;
  sAppConfigFile: TFileName;
  sAppConfigID: string;

// GetDefaultFileName
function GetDefaultFileName(const FileName: TFileName): TFileName;
begin
  Result := FileName;
  if not FileExists(Result) then Result := '';
end;

// Load Config
procedure LoadConfig;
var
  DriveLetter: string;

begin
  with ConfigFile do
  begin
    if FirstConfiguration then
      frmMain.Position := poScreenCenter
    else
    begin
      frmMain.Position := poDesigned;
      ReadFormAttributes(frmMain);
    end;
  end;

  with DreamcastImageMaker.Settings do
  begin
    // Emulator
    Emulator.Enabled := ConfigFile.ReadBool('emulator', 'enabled', False);
    frmMain.cbxEmulatorEnabled.Checked := Emulator.Enabled;
    Emulator.FileName := ConfigFile.ReadString('emulator', 'filename', '');

    // Virtual Drive
    DriveLetter := ConfigFile.ReadString('virtualdrive', 'drive', '');
    if DriveLetter <> '' then
      VirtualDrive.Drive := DriveLetter[1];
    VirtualDrive.Enabled := ConfigFile.ReadBool('virtualdrive', 'enabled', False);
    frmMain.cbxVirtualDriveEnabled.Checked := VirtualDrive.Enabled;
    VirtualDrive.Kind := TVirtualDriveKind(ConfigFile.ReadInteger('virtualdrive', 'kind', 0));
    VirtualDrive.FileName := ConfigFile.ReadString('virtualdrive', 'filename', '');
  end;
end;

// Save Config
procedure SaveConfig;
begin
  ConfigFile.WriteFormAttributes(frmMain);
  with DreamcastImageMaker.Settings do
  begin
    // Emulator
    ConfigFile.WriteBool('emulator', 'enabled', Emulator.Enabled);
    ConfigFile.WriteString('emulator', 'filename', Emulator.FileName);

    // Virtual Drive
    ConfigFile.WriteString('virtualdrive', 'drive', VirtualDrive.Drive);
    ConfigFile.WriteBool('virtualdrive', 'enabled', VirtualDrive.Enabled);
    ConfigFile.WriteInteger('virtualdrive', 'kind', Integer(VirtualDrive.Kind));
    ConfigFile.WriteString('virtualdrive', 'filename', VirtualDrive.FileName);
  end;
end;

initialization
  sAppConfigFile := GetApplicationDirectory + 'config.xml';
  sAppConfigID := GetApplicationCodeName;
  ConfigFile := TXMLConfigurationFile.Create(sAppConfigFile, sAppConfigID);

finalization
  ConfigFile.Free;

end.

