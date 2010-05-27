unit Config;

interface

uses
  Windows, SysUtils, XMLConf;

type
  EConfigurationNotInitialized = class(Exception);
  
function Configuration: TXMLConfigurationFile;
procedure InitConfiguration;
procedure LoadConfig;
procedure LoadConfigFileSelection;
procedure SaveConfig;
procedure SaveConfigFileSelection;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  Forms, SysTools, UITools, Main, FileSel;

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
    if not FirstConfiguration then begin
      frmMain.Position := poDesigned;
      ReadFormAttributes(frmMain);
    end;
    frmMain.AutoSave := ReadBool('main', 'autosave', False);
    frmMain.MakeBackup := ReadBool('main', 'makebackup', True);
(*    frmMain.lvSubs.ColumnsOrder := ReadString('main', 'columns', frmMain.lvSubs.ColumnsOrder);
    frmMain.DecodeSubtitles := ReadBool('main', 'decodesubs', frmMain.DecodeSubtitles);
    frmMain.PreviewerVisible := ReadBool('main', 'preview', frmMain.PreviewerVisible);
    frmMain.OriginalSubtitleField := ReadBool('main', 'originalsubsfield', frmMain.OriginalSubtitleField);
    frmMain.OriginalSubtitlesColumn := ReadBool('main', 'originalsubscolumn', frmMain.OriginalSubtitlesColumn);*)
  end;
end;

//------------------------------------------------------------------------------

procedure LoadConfigFileSelection;
begin
  with frmFileSelection do begin
    edtDataFileName.Text :=
      Configuration.ReadString('fileselection', 'datafilename', 'MEMODATA.BIN');
    edtFlagFileName.Text :=
      Configuration.ReadString('fileselection', 'flagfilename', 'MEMOFLG.BIN');
  end;
end;

//------------------------------------------------------------------------------

procedure SaveConfig;
begin
  with Configuration do begin
    WriteFormAttributes(frmMain);
    WriteBool('main', 'autosave', frmMain.AutoSave);
    WriteBool('main', 'makebackup', frmMain.MakeBackup);
(*    WriteString('main', 'columns', frmMain.lvSubs.ColumnsOrder);
    WriteBool('main', 'decodesubs', frmMain.DecodeSubtitles);
    WriteBool('main', 'preview', frmMain.PreviewerVisible);
    WriteBool('main', 'originalsubsfield', frmMain.OriginalSubtitleField);
    WriteBool('main', 'originalsubscolumn', frmMain.OriginalSubtitlesColumn);*)
  end;
end;

//------------------------------------------------------------------------------

procedure SaveConfigFileSelection;
begin
  with frmFileSelection do begin
    Configuration.WriteString('fileselection', 'datafilename', edtDataFileName.Text);
    Configuration.WriteString('fileselection', 'flagfilename', edtFlagFileName.Text);
  end;
end;

//------------------------------------------------------------------------------

initialization
// (nothing)

finalization
  Configuration.Free;
  
//------------------------------------------------------------------------------

end.

