unit utils;

interface

uses
  Windows, SysUtils, Classes;

procedure CopyFileBlock(var FromF, ToF: file; StartOffset, BlockSize: Integer);

implementation

procedure CopyFileBlock(var FromF, ToF: file; StartOffset, BlockSize: Integer);
const
  MAX_BUF_SIZE = 512;

var
  Buf: array[0..MAX_BUF_SIZE-1] of Char;
  i, j, BufSize, _Last_BufEntry_Size: Integer;

begin
  Seek(FromF, StartOffset);

  BufSize := SizeOf(Buf);
  _Last_BufEntry_Size := (BlockSize mod BufSize);

  j := BlockSize div BufSize;
  for i := 0 to j - 1 do begin
    BlockRead(FromF, Buf, SizeOf(Buf), BufSize);
    BlockWrite(ToF, Buf, BufSize);
  end;

  BlockRead(FromF, Buf, _Last_BufEntry_Size, BufSize);
  BlockWrite(ToF, Buf, BufSize);
end;

end.
