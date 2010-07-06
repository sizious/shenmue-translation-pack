program srfdebug;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  systools in '..\..\..\Common\systools.pas',
  chrcodec in '..\..\..\Common\SubsUtil\chrcodec.pas',
  srfedit in '..\..\src\engine\srfedit.pas';

var
  SRFEditor: TSRFEditor;
  i, j: Integer;
  NewFile, XmlFile: TFileName;

begin
  SRFEditor := TSRFEditor.Create;
  try
    try
      NewFile := ChangeFileExt(ParamStr(1), '.NEW');
      XmlFile := ChangeFileExt(ParamStr(1), '.XML');

      SRFEditor.LoadFromFile(ParamStr(1));
      SRFEditor.SaveToFile(NewFile);
      SRFEditor.LoadFromFile(NewFile);
      SRFEditor.Subtitles.ExportToFile(XmlFile);

      for i := 0 to 4 do begin
        for j := 0 to SRFEditor.Subtitles.Count - 1 do
          SRFEditor.Subtitles[i].Text := GetRandomString(90);
        SRFEditor.Save;
      end;

      SRFEditor.Subtitles.ImportFromFile(XmlFile);
      SRFEditor.Save;
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;
  finally
    SRFEditor.Free;
(*    WriteLn('<Enter> to quit');
    ReadLn;*)
  end;
end.
