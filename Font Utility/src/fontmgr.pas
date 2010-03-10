unit fontmgr;

interface

uses
  Windows, SysUtils, Classes, Graphics;

procedure DecodeFontFile(const InFile, OutFile: TFileName);

implementation

procedure DecodeFontFile(const InFile, OutFile: TFileName);
const
  MAX_BUFFER_SIZE = 65536;
  BYTES_PER_LINE = 3;

var
  BitmapFont: TBitmap;
  InStream: TFileStream;
  Buffer: array[0..MAX_BUFFER_SIZE - 1] of Byte;
  i, j, b, X, Y: Integer;
  PixelOn: Boolean;
  Size, NumRead: LongWord;
  
begin
  InStream := TFileStream.Create(InFile, fmOpenRead);
  BitmapFont := TBitmap.Create;
  try

    // Init Bitmap properties
    with BitmapFont do begin
      Monochrome := True; // 1bpp
      Width := 8 * BYTES_PER_LINE;
      Height := InStream.Size div BYTES_PER_LINE;
    end;

    // Initializing 1bpp decoder
    X := 0;
    j := 0;

    // Reading the data entry
    repeat
      NumRead := InStream.Read(Buffer, MAX_BUFFER_SIZE);

      // Decoding Font data
      for i := 0 to NumRead - 1 do begin

        // Pre-calculating coordonates
        Y := j div BYTES_PER_LINE;
        if (j mod BYTES_PER_LINE) = 0 then
          X := 0;

        // Drawing on the Bitmap
        for b := 0 to 7 do begin
          PixelOn := ((Buffer[i] shr b) and 1) = 1;
          if PixelOn then
            BitmapFont.Canvas.Pixels[X, Y] := clBlack;
          Inc(X);
        end;

        Inc(j);
      end;
    until (NumRead = 0);

    BitmapFont.SaveToFile(OutFile);
    
  finally
    BitmapFont.Free;
    InStream.Free;
  end;
end;

end.
