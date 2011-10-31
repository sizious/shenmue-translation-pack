unit LibPC1;

interface

uses
  Windows, SysUtils, Classes;

type
  TPC1Mode = (pmNormal, pmAdvanced);
  
procedure PC1Encrypt(Mode: TPC1Mode; Key: string; InBuf, OutBuf: TStream);
procedure PC1Decrypt(Mode: TPC1Mode; Key: string; InBuf, OutBuf: TStream);

implementation

{$LINK libpc1.obj}

function pc1_init(mode, decrypt: Integer; inbufsize: LongWord): LongWord; cdecl; external;
function pc1_cipher(mode, decrypt: Integer; key, inbuf, outbuf: PAnsiChar;
  inbufsize: LongWord): LongWord; cdecl; external;

procedure PC1(Mode: TPC1Mode; Decrypt: Boolean; Key: string; InBuf, OutBuf: TStream);
var
  _inbuf, _outbuf: PAnsiChar;
  _inbufsize, _outbufsize: LongWord;

begin
  _inbufsize := InBuf.Size;
  _outbufsize := pc1_init(Integer(Mode), Integer(Decrypt), _inbufsize);

  GetMem(_inbuf, _inbufsize);
  GetMem(_outbuf, _outbufsize);
  try
    InBuf.Read(_inbuf^, _inbufsize);
    pc1_cipher(Integer(Mode), Integer(Decrypt), PAnsiChar(Key), _inbuf, _outbuf, _inbufsize);
    OutBuf.Write(_outbuf^, _outbufsize);
  finally
    FreeMem(_inbuf, _inbufsize);
    FreeMem(_outbuf, _outbufsize);
  end;
end;

procedure PC1Encrypt(Mode: TPC1Mode; Key: string; InBuf, OutBuf: TStream);
begin
  PC1(Mode, False, Key, InBuf, OutBuf);
end;

procedure PC1Decrypt(Mode: TPC1Mode; Key: string; InBuf, OutBuf: TStream);
begin
  PC1(Mode, True, Key, InBuf, OutBuf);
end;

end.
