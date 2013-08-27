program dbghash;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  hashidx in '..\..\..\Common\hashidx.pas';

var
  Hash: THashIndexOptimizer;

procedure PrintBloh;
begin
  WriteLn('BLOH = ', Hash.IndexOf('BLOH'));
end;

begin
  ReportMemoryLeaksOnShutdown := True;

  Hash := THashIndexOptimizer.Create;

  try
    Hash.Add('BLAH', 0);
    Hash.Add('BLOH', 1);
    Hash.Add('BLIH', 2);

    PrintBloh;

    Hash.Delete('BLOH');

    PrintBloh;

    Hash.Add('BLOH', 999);

    PrintBloh;

    Hash.Delete('BLOH');

    PrintBloh;

    ReadLn;    

  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;

  Hash.Free;
end.
