unit LibCamellia;

interface

uses
  Windows, SysUtils, Classes;

procedure CamelliaEncrypt(Key: string; InBuf, OutBuf: TStream);
procedure CamelliaDecrypt(Key: string; InBuf, OutBuf: TStream);

implementation

uses
{$IFDEF WINCRT}
  WinCrt,
{$ENDIF}
  CAM_base,
  StrUtils;

type
  TCAMKey256 = array[0..31] of Byte;

procedure Key2Array(Key: string; var SubKey: TCAMKey256);
const
  Key0: TCAMKey256 = (
    $53, $69, $5A, $21, $FF, $DE, $AD, $BE, $EF, $04, $DF, $59, $3A, $F4, $56, $8D,
    $E4, $50, $4D, $1B, $5F, $A2, $7D, $F3, $45, $6D, $BE, $53, $21, $C2, $1F, $3E
  );
  
var
  _k: string;
  i: Integer;

begin
  _k := Copy(Key, 1, 32);
  CopyMemory(@SubKey, @Key0, SizeOf(Key0));
  for i := High(SubKey) downto Length(_k) do
    SubKey[i] := Ord(_k[i]);
end;

function Camellia(Decrypt: Boolean; Key: string; InBuf, OutBuf: TStream): Integer;
var
  _key0: TCAMKey256;
  ctx: TCAMContext;
  incb, outcb: TCAMBlock;
  _inmem, _outmem: TMemoryStream;
  
begin
  Key2Array(Key, _key0);
  Result := CAM_Init(_key0, 256, ctx);
  if Result = 0 then begin
    _inmem := TMemoryStream.Create;
    _outmem := TMemoryStream.Create;
    try
      _inmem.CopyFrom(InBuf, 0);
      _inmem.Seek(0, soFromBeginning);

      ZeroMemory(@incb, SizeOf(incb));
      while (_inmem.Read(incb, SizeOf(incb)) <> 0) do begin
        if Decrypt then
          CAM_Decrypt(ctx, incb, outcb)
        else
          CAM_Encrypt(ctx, incb, outcb);
        _outmem.Write(outcb, sizeof(outcb));
        ZeroMemory(@incb, SizeOf(incb));
      end;
      OutBuf.CopyFrom(_outmem, 0);      
    finally
      _inmem.Free;
      _outmem.Free;
    end;
  end;
end;

procedure CamelliaEncrypt(Key: string; InBuf, OutBuf: TStream);
begin
  Camellia(False, Key, InBuf, OutBuf);
end;

procedure CamelliaDecrypt(Key: string; InBuf, OutBuf: TStream);
begin
  Camellia(True, Key, InBuf, OutBuf);
end;

end.
