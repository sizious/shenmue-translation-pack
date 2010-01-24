unit lzmadec;

interface

uses
  SysUtils, ScnfUtil;

function InitTextDatabase(GameVersion: TGameVersion): TFileName;

implementation

uses
  Common, SysTools, Utils;

const
  TEXT_DATABASE_ROOT_DIR = 'orgtext';
    
var
  SevenZipDecExec: TFileName;

function InitTextDatabase(GameVersion: TGameVersion): TFileName;
var
  SavedCurrentDir,
  BaseFileName: TFileName;

begin
  BaseFileName := LowerCase(GameVersionToCodeStr(GameVersion));
  Result := GetDatasDirectory + TEXT_DATABASE_ROOT_DIR + '\'
    + BaseFileName + '.db';

  SavedCurrentDir := GetCurrentDir;
  SetCurrentDir(GetWorkingTempDirectory);

  if RunAndWait(SevenZipDecExec + ' e "' + Result + '"') then
    Result := GetWorkingTempDirectory + BaseFileName + '.dbi';

  if not FileExists(Result) then
    Result := '';
    
  SetCurrentDir(SavedCurrentDir);
end;

initialization
  SevenZipDecExec := GetWorkingTempDirectory + '7zDec.exe';
  ExtractFile('LZMA', SevenZipDecExec);

end.
