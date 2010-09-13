// {$DEFINE INTERACTIVE}

program srfdebug;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  srfedit in '..\..\..\AiO Cinematics Subtitles Editor\src\engine\srfedit.pas',
  hashidx in '..\..\..\Common\hashidx.pas',
  chrcodec in '..\..\..\Common\SubsUtil\chrcodec.pas',
  systools in '..\..\..\Common\systools.pas',
  MD5Api in '..\..\..\Common\MD5\MD5Api.pas',
  MD5Core in '..\..\..\Common\MD5\MD5Core.pas';

var
  SRFEditor: TSRFEditor;
  OldFile, NewFile, XmlFile: TFileName;
  HashFile: TStringList;
  
procedure Interactive;
begin
{$IFDEF INTERACTIVE}
  WriteLn('<Enter> to quit');
  ReadLn;
{$ELSE}

{$ENDIF}
end;

procedure StrongTest;
var
  i, j: Integer;

begin
  SRFEditor.LoadFromFile(OldFile);
  HashFile.Add(ExtractFileName(ChangeFileExt(OldFile, '')) + ': ' + SRFEditor.HashKey);

  if not SRFEditor.Subtitles.JapaneseCharset then begin
    SRFEditor.SaveToFile(NewFile);
    SRFEditor.LoadFromFile(NewFile);
    SRFEditor.Subtitles.ExportToFile(XmlFile);

    for i := 0 to 4 do begin
      for j := 0 to SRFEditor.Subtitles.Count - 1 do
        SRFEditor.Subtitles[j].Text := GetRandomString(90);
      SRFEditor.Save;
    end;

    SRFEditor.Subtitles.ImportFromFile(XmlFile);
    SRFEditor.Save;
  end; // not supported
end;

procedure SaveBugTest;
begin
  SRFEditor.LoadFromFile(OldFile);
  SRFEditor.Subtitles[0].Text := 'BLOH______________________________';
  SRFEditor.Save;
  SRFEditor.Subtitles[0].Text := 'BUSTA !!!_________________________';
  SRFEditor.Save;
end;

begin
  OldFile := ExpandFileName(ParamStr(1));
  NewFile := ChangeFileExt(OldFile, '.NEW');
  XmlFile := ChangeFileExt(OldFile, '.XML');

  HashFile := TStringList.Create;
  SRFEditor := TSRFEditor.Create;
  try
    try
      if FileExists('HASH.TXT') then HashFile.LoadFromFile('HASH.TXT');
//      SaveBugTest;
      StrongTest;
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;
  finally
    HashFile.SaveToFile('HASH.TXT');
    SRFEditor.Free;
    HashFile.Free;
    Interactive;
  end;
end.
