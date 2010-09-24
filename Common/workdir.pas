unit WorkDir;

interface

uses
  Windows, SysUtils, SysTools;

function GetWorkingTempDirectory: TFileName;

implementation

var
  sWorkingTempDirectory: TFileName;
  
//------------------------------------------------------------------------------

procedure InitWorkingDirectory;
begin
  sWorkingTempDirectory := GetTempDir + GetApplicationRadicalName + '\';
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

end.
