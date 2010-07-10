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
      WriteLn(Codec.Encode('S�l�cti...�onn�z votre je�.....o''l' + #13#10 + 'dirty bast��rd..'));
      WriteLn(Codec.Decode('c''m�n� � b�b�=@ it''s tim�..' + #$81#$95 + 't� g�t m�n�y.'));
      ReadLn;
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;
  finally
    Codec.Free;
  end;
end.
