unit Config;

interface

uses
  Windows, SysUtils, XMLConf;

type
  EConfigurationNotInitialized = class(Exception);
  
function Configuration: TXMLConfigurationFile;
procedure InitConfiguration; // called from dpr
function IsMigrationWarningUnderstood: Boolean;
procedure LoadConfig;
procedure SaveConfig;
procedure SetWarningUnderstood(const Agree: Boolean);

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
      BatchPreviousSelectedDirectory :=
        ReadDirectoryPath('main', 'batchexportdir', GetApplicationDirectory);
      AutoSave := ReadBool('main', 'autosave', AutoSave);
      MakeBackup := ReadBool('main', 'makebackup', MakeBackup);
      SelectedDirectory := ReadDirectoryPath('main', 'sourcedir',
        GetApplicationDirectory);
      OriginalColumnList := ReadBool('main', 'originalcolumnlist',
        OriginalColumnList);
      OriginalTextField := ReadBool('main', 'originaltextfield',
        OriginalTextField);
      OriginalSubtitlesColumnObjectWidth :=
        ReadInteger('main', 'originalcolumnlistwidth',
          OriginalSubtitlesColumnObjectWidth);
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
      WriteDirectoryPath('main', 'batchexportdir', BatchPreviousSelectedDirectory);
      WriteBool('main', 'autosave', AutoSave);
      WriteBool('main', 'makebackup', MakeBackup);
      WriteDirectoryPath('main', 'sourcedir', SelectedDirectory);
      WriteBool('main', 'originalcolumnlist', OriginalColumnList);
      WriteBool('main', 'originaltextfield', OriginalTextField);
      WriteInteger('main', 'originalcolumnlistwidth',
        OriginalSubtitlesColumnObjectWidth);
    end;
  end;
end;

//------------------------------------------------------------------------------

function IsMigrationWarningUnderstood: Boolean;
begin
  with Configuration do
    Result := ReadBool('main', 'warningdisplayed', False);
end;

//------------------------------------------------------------------------------

procedure SetWarningUnderstood(const Agree: Boolean);
begin
  with Configuration do
    WriteBool('main', 'warningdisplayed', Agree);
end;

//------------------------------------------------------------------------------

initialization
// (nothing)

finalization
  Configuration.Free;
  
//------------------------------------------------------------------------------

end.
