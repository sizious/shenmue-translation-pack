unit utils;

interface

uses
  Windows, SysUtils, XmlConf;

function GetAppVersion: string;
function GetApplicationDirectory: TFileName;
function GetConfigurationObject: TXMLConfigurationFile;
function GetWorkingTempDirectory: TFileName;
procedure LoadConfigMain;
procedure LoadConfigProperties;
procedure SaveConfigMain;
procedure SaveConfigProperties;

implementation

uses
  Forms, SysTools, UITools, Main, FileProp;

const
  WORKING_TEMP_DIR = 'IPACTemp';
  CONFIG_ID        = 'ipacbrowser';

var
  sWorkingTempDirectory: TFileName;
  Configuration: TXMLConfigurationFile;

//------------------------------------------------------------------------------

function GetConfigurationObject: TXMLConfigurationFile;
begin
  Result := Configuration;
end;

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

procedure LoadConfigMain;
begin
  with Configuration do begin
    if FirstConfiguration then
      frmMain.Position := poScreenCenter
    else begin
      frmMain.Position := poDesigned;
      ReadFormAttributes(frmMain);
      frmMain.lvIpacContent.ColumnsOrder :=
        ReadString('main', 'columnsorder', frmMain.lvIpacContent.ColumnsOrder);
    end;
    frmMain.AutoSave := ReadBool('options', 'autosave', False);
    frmMain.MakeBackup := ReadBool('options', 'makebackup', True);
  end;
end;

//------------------------------------------------------------------------------

procedure LoadConfigProperties;
begin
  with Configuration do begin
    ReadFormAttributes(frmProperties);

    with frmProperties do begin
      pcProp.TabIndex := ReadInteger('properties', 'tabindex', 0);
      lvGeneral.ColumnsOrder :=
        ReadString('properties', 'generalview', lvGeneral.ColumnsOrder);
      lvSections.ColumnsOrder :=
        ReadString('properties', 'sectionsorder', lvSections.ColumnsOrder);
      lvContent.ColumnsOrder :=
        ReadString('properties', 'contentorder', lvContent.ColumnsOrder);
    end;

    frmMain.FilePropertiesVisible := ReadBool('properties', 'visible', False);
  end;
end;

//------------------------------------------------------------------------------

procedure SaveConfigMain;
begin
  with Configuration do begin
    WriteFormAttributes(frmMain);
    WriteString('main', 'columnsorder', frmMain.lvIpacContent.ColumnsOrder);
    WriteBool('options', 'autosave', frmMain.AutoSave);
    WriteBool('options', 'makebackup', frmMain.MakeBackup);
  end;
end;

//------------------------------------------------------------------------------

procedure SaveConfigProperties;
begin
  with Configuration do begin
    WriteFormAttributes(frmProperties);

    with frmProperties do begin
      WriteInteger('properties', 'tabindex', pcProp.TabIndex);
      WriteString('properties', 'generalview', lvGeneral.ColumnsOrder);
      WriteString('properties', 'sectionsorder', lvSections.ColumnsOrder);
      WriteString('properties', 'contentorder', lvContent.ColumnsOrder);
    end;

    WriteBool('properties', 'visible', frmMain.FilePropertiesVisible);
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
  if (GetApplicationInstancesCount = 1) and DirectoryExists(sWorkingTempDirectory) then
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

function InitConfigurationFile: TXMLConfigurationFile;
begin
  Result := TXMLConfigurationFile.Create(GetConfigFile, CONFIG_ID);
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
