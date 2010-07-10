program dbgcodec;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  hashidx in '..\..\..\Common\hashidx.pas',
  chrcodec in '..\..\..\Common\SubsUtil\chrcodec.pas',
  systools in '..\..\..\Common\systools.pas';

var
  Codec: TShenmueCharsetCodec;

begin
  Codec := TShenmueCharsetCodec.Create;
  try
    try
      Codec.LoadFromFile('chrlist1.csv');
      WriteLn(Codec.Encode('Sélécti...éonnéz votre jeù.....o''l' + #13#10 + 'dirty bastààrd..'));
      WriteLn(Codec.Decode('c''m©nÆ Æ bÄbÎ=@ it''s timÆ..' + #$81#$95 + 'tÌ gÆt mÌnÆy.'));
      ReadLn;
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;
  finally
    Codec.Free;
  end;
end.
