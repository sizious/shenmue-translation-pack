unit Config;

interface

uses
  Windows, SysUtils, XMLConf;

type
  EConfigurationNotInitialized = class(Exception);
  
function Configuration: TXMLConfigurationFile;
procedure InitConfiguration;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  SysTools, UITools;

const
  CONFIG_FILENAME = 'config.xml';

var
  _Configuration: TXMLConfigurationFile;

//------------------------------------------------------------------------------

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

//------------------------------------------------------------------------------

function Configuration: TXMLConfigurationFile;
begin
  if not Assigned(_Configuration) then
    raise EConfigurationNotInitialized.Create('Sorry, the Configuration ' +
      'object wasn''t initialized! Call InitConfigurationFile() first.');

  Result := _Configuration;
end;

//------------------------------------------------------------------------------

initialization
// (nothing)

finalization
  Configuration.Free;
  
//------------------------------------------------------------------------------

end.
