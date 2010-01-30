unit lzmadec;

interface

uses
  SysUtils, ScnfUtil;

function GetTextDatabaseIndexFile(GameVersion: TGameVersion): TFileName;

implementation

uses
  Common, SysTools, Utils;

var
  SevenZipDecExec: TFileName;

function GetTextDatabaseIndexFile(GameVersion: TGameVersion): TFileName;
var
  BaseFileName, DatabaseSourceFileName, DatabaseDestDirectory: TFileName;
{$IFDEF DEBUG}
  ExecResult: Boolean;
{$ENDIF}

begin
  BaseFileName := LowerCase(GameVersionToCodeStr(GameVersion));
  DatabaseDestDirectory := GetWorkingTempDirectory + BaseFileName;
  DatabaseSourceFileName := GetTextCorrectorDatabasesDirectory
    + BaseFileName + '.db';
  Result := DatabaseDestDirectory + '\' + BaseFileName + '.dbi';
  
  if not DirectoryExists(DatabaseDestDirectory) then begin
    ForceDirectories(DatabaseDestDirectory);
{$IFDEF DEBUG}
    ExecResult :=
{$ENDIF}
    RunAndWait(SevenZipDecExec + ' x "' + DatabaseSourceFileName
      + '" "' + DatabaseDestDirectory + '"');
{$IFDEF DEBUG}
    WriteLn('RunAndWait Result on 7zDec: ', ExecResult);
{$ENDIF}
  end;

  if not FileExists(Result) then // if not exist the DBI (index file)
    Result := '';
end;

initialization
  SevenZipDecExec := GetWorkingTempDirectory + '7zDec.exe';
  ExtractFile('LZMA', SevenZipDecExec);

(*  finalization section:
    not needed: everything is cleaned up in the DeleteWorkingTempDirectory
    function of the utils.pas file
*)

end.
