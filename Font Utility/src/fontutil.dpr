program fontutil;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  fontmgr in 'fontmgr.pas';

begin
  try
  { TODO -oUtilisateur -cCode du point d'entrée : Placez le code ici }
    DecodeFontFile('DC_KANJI.BIN', 'DC_KANJI.BMP');
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
