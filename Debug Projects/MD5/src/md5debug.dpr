program md5debug;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  MD5Api in '..\..\..\Common\MD5\MD5Api.pas',
  MD5Core in '..\..\..\Common\MD5\MD5Core.pas',
  srfedit in '..\..\..\AiO Cinematics Subtitles Editor\src\engine\srfedit.pas',
  systools in '..\..\..\Common\systools.pas',
  chrcodec in '..\..\..\Common\SubsUtil\chrcodec.pas',
  hashidx in '..\..\..\Common\hashidx.pas';

var
  SRFEditor: TSRFEditor;

function MD5HashFromSRF(Subs: TSRFSubtitlesList): string;
var
  i: Integer;
  sBuf: string;

begin
  sBuf := '';
  for i := 0 to Subs.Count - 1 do
    sBuf := sBuf + Subs[i].ExtraDataString;

  WriteLn(
'******************************************************************************'
, sLineBreak,
sBuf, sLineBreak,
'******************************************************************************'
);

  Result := MD5(sBuf);
end;


procedure _PH(FileName: TFileName);
begin
  SRFEditor.LoadFromFile(FileName);
  WriteLn('HASH=', SRFEditor.HashKey);
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  try

    SRFEditor := TSRFEditor.Create;
    try
      _PH('F1015.SRF');
    finally
      SRFEditor.Free;
    end;

    { TODO -oUtilisateur -cCode du point d'entrée : Placez le code ici }
    ReadLn;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
