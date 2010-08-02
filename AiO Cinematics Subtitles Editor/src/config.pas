unit Config;

interface

uses
  Windows, SysUtils, XMLConf;

type
  EConfigurationNotInitialized = class(Exception);
  
function Configuration: TXMLConfigurationFile;
procedure InitConfiguration;
procedure LoadConfig;
procedure SaveConfig;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  Forms, SysTools, UITools, Main;

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

procedure LoadConfig;
var
  S: string;

begin
  with Configuration do begin
    with frmMain do begin
      if not FirstConfiguration then begin
        Position := poDesigned;
        ReadFormAttributes(frmMain);
      end;
      lvSubs.ColumnsOrder := ReadString('main', 'columns', lvSubs.ColumnsOrder);
      DecodeSubtitles := ReadBool('main', 'decodesubs', DecodeSubtitles);
      PreviewerVisible := ReadBool('main', 'preview', PreviewerVisible);
      S := ReadString('main', 'batchexportdir', BatchExportPreviousSelectedDirectory);
      if DirectoryExists(S) then
        BatchExportPreviousSelectedDirectory := S;        
    end; // frmMain
  end; // Configuration
end;

//------------------------------------------------------------------------------

procedure SaveConfig;
begin
  with Configuration do begin
    WriteFormAttributes(frmMain);
    with frmMain do begin
      WriteString('main', 'columns', lvSubs.ColumnsOrder);
      WriteBool('main', 'decodesubs', DecodeSubtitles);
      WriteBool('main', 'preview', PreviewerVisible);
      WriteString('main', 'batchexportdir', BatchExportPreviousSelectedDirectory);
    end;
  end;
end;

//------------------------------------------------------------------------------

initialization
// (nothing)

finalization
  Configuration.Free;
  
//------------------------------------------------------------------------------

end.
