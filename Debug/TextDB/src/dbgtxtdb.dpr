program dbgtxtdb;

{$APPTYPE CONSOLE}

{$R 'lzmabin.res' 'lzmabin.rc'}

uses
  SysUtils,
  textdb in '..\..\..\Common\TextDB\textdb.pas',
  dbindex in '..\..\..\Common\TextDB\dbindex.pas',
  dbinlay in '..\..\..\Common\TextDB\dbinlay.pas',
  lzmadec in '..\..\..\Common\lzmadec.pas',
  systools in '..\..\..\Common\systools.pas',
  hashidx in '..\..\..\Common\hashidx.pas';

var
  DB: TTextCorrectorDatabase;

(*
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
*)

procedure PrintSubs;
var
  i: Integer;
  
begin
  for i := 0 to DB.Subtitles.Count - 1 do
    WriteLn(DB.Subtitles[i].Code + ': ' + DB.Subtitles[i].Text);
end;

begin
  try
//    SevenZipInitEngine(GetTempDir);

//    SevenZipExtract('dc_pal_shenmue2.db', 'unpack');

    DB := TTextCorrectorDatabase.Create;
    try
      DB.OpenDatabase('unpack\dc_pal_shenmue2.dbi');
      DB.LoadTable('FEX10_00A_');

      PrintSubs;

      WriteLn(DB.LoadTable('ABCDEF'));

      PrintSubs;

      DB.LoadTable('FEX10_00A_');
        
      ReadLn;
    finally
      DB.Free;
    end;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
