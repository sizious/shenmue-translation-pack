unit utils;

interface

uses
  Windows, SysUtils;

function GetAppVersion: string;
function GetApplicationDirectory: TFileName;
function GetWorkingTempDirectory: TFileName;
procedure LoadConfigDebug;
procedure LoadConfigMain;
procedure SaveConfigDebug;
procedure SaveConfigMain;

implementation

uses
  Forms, SysTools, XmlConf, Main, DebugLog;

const
  WORKING_TEMP_DIR = 'IPACTemp';
  CONFIG_ID        = 'ipacbrowser';

var
  sWorkingTempDirectory: TFileName;
  Configuration: TXmlConfigurationFile;
  
//------------------------------------------------------------------------------

function GetApplicationDirectory: TFileName;
begin
  GetApplicationDirectory :=
    IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
end;

//------------------------------------------------------------------------------

function GetAppVersion: string;
begin
  Result := GetApplicationVersion(LANG_FRENCH, SUBLANG_FRENCH);
end;

//------------------------------------------------------------------------------

procedure LoadConfigDebug;
begin
  with Configuration do begin
    frmDebugLog.OnTop := ReadBool('debug', 'ontop', False);
    frmDebugLog.Left := ReadInteger('debug', 'left', 100);
    frmDebugLog.Top := ReadInteger('debug', 'top', 100);
    frmDebugLog.Width := ReadInteger('debug', 'width', frmDebugLog.Width);
    frmDebugLog.Height := ReadInteger('debug', 'height', frmDebugLog.Height);
    frmDebugLog.WindowState := TWindowState(ReadInteger('debug', 'state',
      Integer(frmDebugLog.WindowState)));
    frmMain.DebugLogVisible := ReadBool('debug', 'visible', False);    
  end;
end;

//------------------------------------------------------------------------------

procedure LoadConfigMain;
begin
  with Configuration do begin
    frmMain.AutoSave := ReadBool('options', 'autosave', False);
    frmMain.MakeBackup := ReadBool('options', 'makebackup', True);
  end;
end;

//------------------------------------------------------------------------------

procedure SaveConfigDebug;
begin
  with Configuration do begin
    WriteBool('debug', 'ontop', frmDebugLog.OnTop);
    WriteInteger('debug', 'left', frmDebugLog.Left);
    WriteInteger('debug', 'top', frmDebugLog.Top);
    WriteInteger('debug', 'width', frmDebugLog.Width);
    WriteInteger('debug', 'height', frmDebugLog.Height);
    WriteInteger('debug', 'state', Integer(frmDebugLog.WindowState));   
    WriteBool('debug', 'visible', frmMain.DebugLogVisible);
  end;
end;

//------------------------------------------------------------------------------

procedure SaveConfigMain;
begin
  with Configuration do begin
    WriteBool('options', 'autosave', frmMain.AutoSave);
    WriteBool('options', 'makebackup', frmMain.MakeBackup);
  end;
end;

//------------------------------------------------------------------------------

procedure InitWorkingDirectory;
begin
  sWorkingTempDirectory := GetTempDir + WORKING_TEMP_DIR + '\';
  if not DirectoryExists(sWorkingTempDirectory) then
    ForceDirectories(sWorkingTempDirectory);
end;

//------------------------------------------------------------------------------

procedure DeleteWorkingTempDirectory;
begin
  if DirectoryExists(sWorkingTempDirectory) then
    DeleteDirectory(sWorkingTempDirectory);
end;

//------------------------------------------------------------------------------

function GetWorkingTempDirectory: TFileName;
begin
  if sWorkingTempDirectory = '' then
    InitWorkingDirectory;
  Result := sWorkingTempDirectory; 
end;

//------------------------------------------------------------------------------

function GetConfigFile: TFileName;
begin
  Result := GetApplicationDirectory + 'config.xml';
end;

//------------------------------------------------------------------------------

function InitConfigurationFile: TXmlConfigurationFile;
begin
  Result := TXmlConfigurationFile.Create(GetConfigFile, CONFIG_ID);
end;

//------------------------------------------------------------------------------

initialization
  sWorkingTempDirectory := '';              // see GetWorkingTempDirectory
  Configuration := InitConfigurationFile;   // Create the Configuration object

//------------------------------------------------------------------------------

finalization
  DeleteWorkingTempDirectory;
  Configuration.Free;

//------------------------------------------------------------------------------

end.
