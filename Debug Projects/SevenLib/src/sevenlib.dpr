program sevenlib;

{$APPTYPE CONSOLE}

uses
  SysUtils, JclCompression;

var
  FArchive: TJclCompressionArchive;

procedure CloseArchive;
begin
  FreeAndNil(FArchive);
end;

procedure CreateArchive;
const
  SPLIT_VOLUME_SIZE = 0;
  ARCHIVE_PASSWORD = 'test';

var
  ArchiveFileName: TFileName;
  AFormat: TJclCompressArchiveClass;

begin
  CloseArchive;

  ArchiveFileName := 'test.7z';
  AFormat := GetArchiveFormats.FindCompressFormat(ArchiveFileName);

  if AFormat <> nil then
  begin
    if SPLIT_VOLUME_SIZE <> 0 then
      ArchiveFileName := ArchiveFileName + '.%.3d';

    FArchive := AFormat.Create(ArchiveFileName, SPLIT_VOLUME_SIZE,
      SPLIT_VOLUME_SIZE <> 0);

    FArchive.Password := ARCHIVE_PASSWORD;
//    FArchive.OnProgress := ArchiveProgress;
  end
  else
    WriteLn('not a supported format');
end;

procedure AddDirectoryExecute(const Directory: TFileName);
begin
  (FArchive as TJclCompressArchive).AddDirectory(ExtractFileName(Directory),
    Directory, True, True);
end;

procedure SaveExecute;
begin
  (FArchive as TJclCompressArchive).Compress;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
  { TODO -oUtilisateur -cCode du point d'entrée : Placez le code ici }
    CreateArchive;
    AddDirectoryExecute('test_dir');
    SaveExecute;
    CloseArchive;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
