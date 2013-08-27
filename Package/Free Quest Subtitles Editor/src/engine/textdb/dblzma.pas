unit dblzma;

interface

uses
  SysUtils, ScnfUtil;

function GetTextDatabaseIndexFile(GameVersion: TGameVersion): TFileName;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  Common, SysTools, LzmaDec, Utils;

function GetTextDatabaseIndexFile(GameVersion: TGameVersion): TFileName;
var
  BaseFileName, DatabaseSourceFileName, DatabaseDestDirectory: TFileName;

begin
  BaseFileName := LowerCase(GameVersionToCodeStr(GameVersion));
  DatabaseDestDirectory := GetWorkingTempDirectory + BaseFileName;
  DatabaseSourceFileName := GetTextCorrectorDatabasesDirectory
    + BaseFileName + '.db';
  Result := DatabaseDestDirectory + '\' + BaseFileName + '.dbi';
  
  SevenZipExtract(DatabaseSourceFileName, DatabaseDestDirectory);

  if not FileExists(Result) then // if not exist the DBI (index file)
    Result := '';
end;

//------------------------------------------------------------------------------

initialization
  SevenZipInitEngine(GetWorkingTempDirectory);

//------------------------------------------------------------------------------

end.
