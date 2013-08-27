unit utils;

interface

uses
  Windows, SysUtils, XmlConf;

var
  Configuration: TXMLConfigurationFile;

// function GetAppVersion: string;
procedure InitConfigurationFile;

implementation

uses
  Forms, SysTools, UITools;

const
  CONFIG_FILENAME = 'config.xml';

//------------------------------------------------------------------------------

(*function GetAppVersion: string;
begin
  Result := GetApplicationVersion(LANG_FRENCH, SUBLANG_FRENCH);
end;*)

//------------------------------------------------------------------------------

procedure InitConfigurationFile;
var
  ConfigFile: TFileName;
  ConfigID: string;
  
begin
  // Create the Configuration object
  ConfigFile := GetApplicationDirectory + CONFIG_FILENAME;
  ConfigID := GetApplicationCodeName;
  Configuration := TXMLConfigurationFile.Create(ConfigFile, ConfigID);
end;

//------------------------------------------------------------------------------

initialization

finalization
  Configuration.Free;

//------------------------------------------------------------------------------

end.
