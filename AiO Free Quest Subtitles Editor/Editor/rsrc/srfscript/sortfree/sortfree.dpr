program SortFree;

{$APPTYPE CONSOLE}

uses
  Windows, SysUtils, Classes;

const
  MAX_FILES_PER_DIRECTORY = 500;
  
var
  SR: TSearchRec;
  Directory, MoveDirectory, FoundFile: TFileName;
  Filter: string;
  NumDirectory, NumFiles: Integer;
  
begin
  Directory := '.\';
  Filter := '*.STR';

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
            + 'DIR' + IntToStr(NumDirectory) + '\';
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
