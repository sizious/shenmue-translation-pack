program dbgseqdb;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  seqdb in '..\..\..\Special Scenes Subtitles Editor\src\engine\seqdb.pas',
  fsparser in '..\..\..\Common\fsparser.pas',
  systools in '..\..\..\Common\systools.pas',
  binhack in '..\..\..\Common\binhack.pas',
  filespec in '..\..\..\Common\filespec.pas',
  chrcodec in '..\..\..\Common\SubsUtil\chrcodec.pas',
  hashidx in '..\..\..\Common\hashidx.pas';

var
  SeqLib: TSequenceDatabase;
  i: Integer;

begin
  ReportMemoryLeaksOnShutdown := True;
  SeqLib := TSequenceDatabase.Create;
  try
    try
      SeqLib.LoadDatabase('seqinfo.xml');
      for i := 0 to SeqLib.Count - 1 do
        WriteLn(i, ': ', SeqLib.Items[i].SequenceID);
      WriteLn('INDEX=', SeqLib.IdentifyFile('NBIK_P_4.SCN'));
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;
  finally
    SeqLib.Free;
  end;
  WriteLn('>>> END');
  ReadLn;
end.
