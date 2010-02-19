unit utils;

interface

uses
  Windows, SysUtils;

function GetAppVersion: string;
function GetWorkingTempDirectory: TFileName;

implementation

uses
  SysTools;

const
  WORKING_TEMP_DIR = 'IPACTemp';
    
var
  sWorkingTempDirectory: TFileName;

//------------------------------------------------------------------------------

function GetAppVersion: string;
begin
  Result := GetApplicationVersion(LANG_FRENCH, SUBLANG_FRENCH);
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

initialization
  sWorkingTempDirectory := ''; // see GetWorkingTempDirectory

//------------------------------------------------------------------------------

finalization
  DeleteWorkingTempDirectory;

//------------------------------------------------------------------------------

end.
