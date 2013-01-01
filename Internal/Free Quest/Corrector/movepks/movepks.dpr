program movepks;

{$APPTYPE CONSOLE}

uses
  Windows, SysUtils, Classes;

// cette application permet de d�placer tous les PKS depuis le dossier "FULL_AFS_FILE_DUMP" g�n�r� par AFS Explorer
// et les r�partit dans X dossiers. Les fichiers sont r�partit par paquet de MAX_FILES_PER_DIRECTORY
// Ceci pour g�n�rer des XML l�ger contenant les sous titres originaux des jeux.
// A utiliser donc conjointement avec le projet "datasgen"
const
  MAX_FILES_PER_DIRECTORY = 30;
  
var
  SR: TSearchRec;
  Directory, MoveDirectory, FoundFile: TFileName;
  Filter: string;
  NumDirectory, NumFiles: Integer;
  
begin
  Directory := '.\';
  Filter := '*.PKS';

  try

    NumFiles := 0;
    NumDirectory := 0;

    if FindFirst(Directory + Filter, faAnyFile, SR) = 0 then begin

      repeat
        FoundFile := Directory + SR.Name;

        if NumFiles = 0 then begin
          Inc(NumDirectory);
          NumFiles := 0;
          MoveDirectory := IncludeTrailingPathDelimiter(Directory)
            + 'FULL_AFS_FILE_DUMP_' + IntToStr(NumDirectory) + '\';
          if not DirectoryExists(MoveDirectory) then
            ForceDirectories(MoveDirectory);
        end;

        MoveFile(PChar(FoundFile), PChar(MoveDirectory + SR.Name));
        Inc(NumFiles);

        if NumFiles = MAX_FILES_PER_DIRECTORY then
          NumFiles := 0;
          
      until (FindNext(SR) <> 0);

      FindClose(SR);
    end;

  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
