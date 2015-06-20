unit common;

interface

uses
  Windows, SysUtils;

function GetWorkingDirectory: TFileName;
  
//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  SysTools;
  
const
  WORKING_DIRECTORY = 'MTEditor';

var
  WorkingDirectory: TFileName;

//------------------------------------------------------------------------------

function InitWorkingDirectory: Boolean;
begin
  WorkingDirectory := GetTempDir + WORKING_DIRECTORY + '\';
  Result := ForceDirectories(WorkingDirectory);
end;

//------------------------------------------------------------------------------

function GetWorkingDirectory: TFileName;
begin
  if not DirectoryExists(WorkingDirectory) then
    InitWorkingDirectory;
  Result := WorkingDirectory;
end;

//------------------------------------------------------------------------------

initialization
{$IFDEF DEBUG}
  if not InitWorkingDirectory then
    WriteLn('WORKING DIRECTORY WAS NOT CREATED!');
{$ELSE}
  InitWorkingDirectory;
{$ENDIF}

//------------------------------------------------------------------------------

finalization
  DeleteDirectory(WorkingDirectory);

//------------------------------------------------------------------------------

end.
