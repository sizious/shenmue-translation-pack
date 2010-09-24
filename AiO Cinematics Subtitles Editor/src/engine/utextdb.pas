unit UTextDB;

interface

uses
  Windows, SysUtils, TextDB, SRFEdit;

var
  TextDatabaseCorrector: TTextDatabaseCorrector;

function TextCorrectorDatabaseUpdate: Boolean;

implementation

uses
  Main, SysTools, LZMADec, WorkDir;

const
  TEXTDB_ROOT_DIR = 'textdb';

function GameVersionToDatabaseName(GameVersion: TSRFGameVersion): TFileName;
begin
  case GameVersion of
    sgvUndef: Result := '';
    sgvShenmue: Result := 'sm1dc';
    sgvShenmue2: Result := 'sm2dc';
  end;
end;

// Extract every textdb/*.db files to working temp directory
function DBInitialize(GameVersion: TSRFGameVersion): TFileName;
var
  InputDir, OutputDir, DBFile, DBName: TFileName;

begin
  DBName := GameVersionToDatabaseName(GameVersion);
  OutputDir := GetWorkingTempDirectory + TEXTDB_ROOT_DIR + '\' + DBName + '\';
  if not DirectoryExists(OutputDir) then begin
    InputDir := GetApplicationDataDirectory + TEXTDB_ROOT_DIR + '\';
    DBFile := InputDir + DBName + '.db';
    if FileExists(DBFile) then
      SevenZipExtract(DBFile, OutputDir);
  end;
  Result := OutputDir + DBName + '.dbi'; // return the DBI index file  
end;

function TextCorrectorDatabaseUpdate: Boolean;
var
  DBIFileName: TFileName;

begin
  // Initialize the TextCorrectorDatabase if needed
  DBIFileName := DBInitialize(SRFEditor.GameVersion);
  if FileExists(DBIFileName) then
    TextDatabaseCorrector.OpenDatabase(DBIFileName); // Load the DBI (index) file

  // Load the next subtitle
  Result := TextDatabaseCorrector.LoadTable(SRFEditor.HashKey);
end;

initialization
  SevenZipInitEngine(GetWorkingTempDirectory);
  TextDatabaseCorrector := TTextDatabaseCorrector.Create;

finalization
  TextDatabaseCorrector.Free;

end.
