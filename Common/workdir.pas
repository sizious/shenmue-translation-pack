unit WorkDir;

interface

uses
  Windows, SysUtils, SysTools;

// Get the Temp directory for the application
function GetWorkingTempDirectory: TFileName;

// Get a temp filename in the temp directory above.
function GetWorkingTempFileName: TFileName;

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
  if (GetApplicationInstancesCount < 2)
    and DirectoryExists(sWorkingTempDirectory) then
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

function GetWorkingTempFileName: TFileName;
begin
  repeat
    Result := GetWorkingTempDirectory + IntToHex(Random($FFFFFFF), 8) + '.SiZ';
  until not FileExists(Result);
end;

//------------------------------------------------------------------------------

initialization
  sWorkingTempDirectory := ''; // see GetWorkingTempDirectory

//------------------------------------------------------------------------------

finalization
  DeleteWorkingTempDirectory;

end.
