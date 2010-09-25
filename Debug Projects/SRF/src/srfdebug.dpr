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

const
  sTab = Chr(9);
  
var
  SRFEditor: TSRFEditor;
  OldFile, NewFile, XmlFile: TFileName;
  HashFile: TStringList;
  S: string;


procedure Interactive;
begin
{$IFDEF INTERACTIVE}
  WriteLn('<Enter> to quit');
  ReadLn;
{$ELSE}

{$ENDIF}
end;

procedure AddToLog(S: string);
begin
  HashFile.Add(StringReplace(S, ';', sTab, [rfReplaceAll, rfIgnoreCase]));
end;

procedure StrongTest;
var
  i, j: Integer;

begin
  try
    S :=
      ExtractFileName(ChangeFileExt(OldFile, '')) + ';';
    S := S + ExtremeRight('\', Copy(ExtractFilePath(OldFile), 1, Length(ExtractFilePath(OldFile))-1)) + ';';

    if SRFEditor.LoadFromFile(OldFile) then begin


      if not SRFEditor.Subtitles.JapaneseCharset then begin
        S := S + IntToStr(SRFEditor.Subtitles.Count) + ';'
          +       SRFEditor.HashKey + ';' +
          MD5FromFile(SRFEditor.SourceFileName);

        SRFEditor.SaveToFile(NewFile);
        SRFEditor.LoadFromFile(NewFile);

        SRFEditor.Subtitles.ExportToFile(XmlFile);

        for i := 0 to 9 do begin
          for j := 0 to SRFEditor.Subtitles.Count - 1 do
            SRFEditor.Subtitles[j].Text := GetRandomString(90);
          SRFEditor.Save;
        end;

        S :=
            S + ';' +
            SRFEditor.HashKey + ';' +
            MD5FromFile(SRFEditor.SourceFileName);

        SRFEditor.Subtitles.ImportFromFile(XmlFile);
        SRFEditor.Save;

        S :=
            S + ';' +
            SRFEditor.HashKey + ';' +
            MD5FromFile(SRFEditor.SourceFileName);

        AddToLog(S);
      end else
        AddToLog(S + 'JAPANESE FILES NOT SUPPORTED'); // not supported

    end else
      AddToLog(S + ' FAILED WHEN OPENING FILE');
  except
    AddToLog(S + ' EXCEPTION RAISED');
  end;
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

      if FileExists('HASH.TXT') then
        HashFile.LoadFromFile('HASH.TXT')
      else
        AddToLog('File;Disc;SubtitlesCount;HashKey;FileMD5;HakHashKey;HakFileMD5;NewHashKey;NewFileMD5');
        
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
