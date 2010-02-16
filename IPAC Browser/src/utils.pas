unit utils;

interface

uses
  Windows, SysUtils;

function GetWorkingTempDirectory: TFileName;

implementation

uses
  SysTools;

const
  WORKING_TEMP_DIR = 'IPACTemp';
    
var
  sWorkingTempDirectory: TFileName;

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
