unit lzmadec;

interface

uses
  SysUtils, ScnfUtil;

function GetTextDatabaseIndexFile(GameVersion: TGameVersion): TFileName;

implementation

uses
  Common, SysTools, Utils;

const
  TEXT_DATABASE_ROOT_DIR = 'textdb';
    
var
  SevenZipDecExec: TFileName;

function GetTextDatabaseIndexFile(GameVersion: TGameVersion): TFileName;
var
  BaseFileName, DatabaseSourceFileName, DatabaseDestDirectory: TFileName;

begin
  BaseFileName := LowerCase(GameVersionToCodeStr(GameVersion));
  DatabaseDestDirectory := GetWorkingTempDirectory + BaseFileName;
  DatabaseSourceFileName := GetDatasDirectory + TEXT_DATABASE_ROOT_DIR + '\'
    + BaseFileName + '.db';

  if not DirectoryExists(DatabaseDestDirectory) then
    ForceDirectories(DatabaseDestDirectory);
  
  if RunAndWait(SevenZipDecExec
    + ' x "' + DatabaseSourceFileName + '" "' + DatabaseDestDirectory + '"') then
    Result := DatabaseDestDirectory + '\' + BaseFileName + '.dbi';

  if not FileExists(Result) then
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
