program dbgcodec;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  hashidx in '..\..\..\Common\hashidx.pas',
  chrcodec in '..\..\..\Common\SubsUtil\chrcodec.pas',
  systools in '..\..\..\Common\systools.pas';

begin
  try
  { TODO -oUtilisateur -cCode du point d'entrée : Placez le code ici }
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
