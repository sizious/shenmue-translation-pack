program systalk;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  systools in '..\..\..\Common\systools.pas',
  sncfedit in '..\..\..\System Talk Subtitles Editor\src\engine\sncfedit.pas';

var
  SCNF: TSCNFEditor;
  i, j: integer;

begin
  ReportMemoryLeaksOnShutdown := True;

  try
    SCNF := TSCNFEditor.Create;

    SCNF.LoadFromFile('cold_f.bin');

    scnf.Sections[5].Subtitles.ExportToFile('test.xml');

    for j := 0 to 20 do begin
      Writeln('Pass #', j, '/20');
      for i := 0 to scnf.sections[5].Subtitles.count - 1 do
        scnf.sections[5].Subtitles[i].Text := GetRandomString(90);
    end;
    scnf.sections[5].subtitles.ExportToFile('dummy.xml');

    scnf.Sections[5].Subtitles.ImportFromFile('test.xml');

    SCNF.SaveToFile('COLD.HAK');

    readln;
  
    SCNF.Free;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
