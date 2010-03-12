program fontutil;

{$APPTYPE CONSOLE}

{$R 'fontutil.res' 'fontutil.rc'}

uses
  SysUtils,
  fontmgr in 'fontmgr.pas';

begin
  try
    // DC_KANA: 2, 32. 256 Characters.
    // DC_KANJI: 3, 6. 7806 Characters.
    // RYOU: 2, 32. 256 Characters.
    // WAZA: 3, 6. 7806 Characters.
//    DecodeFontFile('TEST.FON', 'TEST.BMP', 2, 4);


    DecodeFontFile('DC_KANJI.FON', 'DC_KANJI.BMP', 3, 6);
    EncodeFontFile('DC_KANJI.BMP', 'DC_KANJI.NEW', 3, 6);

//    EncodeFontFile('TEST2.BMP', 'OUTPUT.BIN', 2, 4);
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
