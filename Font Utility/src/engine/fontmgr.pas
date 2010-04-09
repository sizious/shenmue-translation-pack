unit FontMgr;

// {$DEFINE DEBUG_FONTMGR}

// Define this to put Application.ProcessMessage inside the functions.
{$DEFINE PROCESS_MESSAGES}

interface

uses
  Windows, SysUtils, Classes, Graphics;

type
  TEncodeResult = (erFailed, erIncorrectBitmapDimension, erSuccess);
   
(*
  Shenmue Font Utility Encoder/Decoder

  This unit contains two functions:
  - EncodeFontFile
  Written to encode the Monochrome Bitmap to a Shenmue Binary Font. 

  - DecodeFontFile:
  Written to decode the Shenmue Binary Font to a Monochrome Bitmap.

  The parameters are commons:
    - InFile :
      The Shenmue Binary Font ('DC_KANJI.FON', 'DC_KANA.FON', 'RYOU.FON',
      'WAZA.FON' (from What's Shenmue).

    - OutFile :
      The result Bitmap generated by the function

    - BytesPerLine :
      This parameter is important. It says how the font is coded. For example,
      for the 'DC_KANA.FON' or 'RYOU.FON', each 2 Bytes on the file represents
      a single line in the destination Bitmap. In clear, 2 Bytes in the coded
      file = 1 row for the character in the destination Bitmap. 1 Byte = 8 bits,
      so 8 pixels on the Bitmap. That's why the
      CharWidth = 8 * 2 Bytes = 16 pixels. For the 'DC_KANJI.FON', each line is
      coded with 3 Bytes. So the CharWidth for this font is :
      3 * 8 bits = 24 pixels. Each character on the 'DC_KANJI.FON' is 24 pixels
      of width.

    - BitmapCharsPerLine :
      Indicates how characters you want by line in the destination Bitmap. If
      the CharCount / BitmapCharsPerLine isn't a integer number, one more row
      will be added to show each characters. In clear, if you have to
      display 16 characters on a 3 columns Bitmap (so BitmapCharsPerLine = 3),
      the Bitmap font height will be Ceil(16 / 3) * CharHeight[15] = 90, instead
      of 16 / 3 * CharHeight[15] = 75. So the last row will be filled only with
      one character (yeah, because 3 * 6 = 18 characters slot and we have only
      16 characters to display).
      By the way, BitmapCharsPerLine = ColumnsCount in the result Bitmap.

*)
procedure DecodeFontFile(const InFile, OutFile: TFileName; const BytesPerLine,
  BitmapCharsPerLine: Integer);

function EncodeFontFile(const InFile, OutFile: TFileName; const BytesPerLine,
  BitmapCharsPerLine: Integer): TEncodeResult;
  
//==============================================================================
implementation
//==============================================================================

uses
{$IFDEF PROCESS_MESSAGES}
  Forms,
{$ENDIF}
  Math;

const
  SHENMUE_FONT_CHAR_HEIGHT = 15;

//------------------------------------------------------------------------------

procedure ComputeNextCoordinates(const MaxCharWidth, CharWidth,
  CharHeight: Integer; var X, Y: Integer);
begin
  if X mod CharWidth = (CharWidth - 1) then begin
  
    if (Y mod CharHeight) = (CharHeight - 1) then begin

      if X = (MaxCharWidth - 1) then begin
        (* we have drawn the entire character, restart to draw in the next line
          at left *)
        X := 0;
        Inc(Y);
      end else begin
        // Skip to the new character
        Inc(X);
        Dec(Y, CharHeight - 1);
      end;

    end else begin
      // Draw the next line for the current character
      Dec(X, CharWidth - 1);
      Inc(Y);
    end;

  end else
    Inc(X); // draw the next pixel
end;

//------------------------------------------------------------------------------

procedure GetIdealBitmapSize(const CharWidth, CharHeight, CharCount,
  BitmapCharsPerLine: Integer; var IdealWidth, IdealHeight: Integer);
begin
{$IFDEF DEBUG} {$IFDEF DEBUG_FONTMGR}
  WriteLn('CharWidth: ', CharWidth, ', CharHeight: ', CharHeight,
    ', CharCount: ', CharCount);
{$ENDIF} {$ENDIF}

  IdealWidth := CharWidth * BitmapCharsPerLine;
  IdealHeight := Ceil(CharCount / BitmapCharsPerLine) * CharHeight;

{$IFDEF DEBUG} {$IFDEF DEBUG_FONTMGR}
  WriteLn('IdealWidth: ', IdealWidth, ', IdealHeight: ', IdealHeight);
{$ENDIF} {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure DecodeFontFile(const InFile, OutFile: TFileName; const BytesPerLine,
  BitmapCharsPerLine: Integer);
const
  MAX_BUFFER_SIZE = 65536;

var
  BitmapFont: TBitmap;
  InStream: TFileStream;
  Buffer: array[0..MAX_BUFFER_SIZE - 1] of Byte;
  CharCount, CharWidth, NumRead, BitmapIdealWidth, BitmapIdealHeight,
  X, Y, i, b: Integer;
  PixelOn: Boolean;

begin
  InStream := TFileStream.Create(InFile, fmOpenRead);
  BitmapFont := TBitmap.Create;
  try

    // Calculate the result Bitmap size
    CharWidth := 8 * BytesPerLine;
    CharCount := (InStream.Size div BytesPerLine) div SHENMUE_FONT_CHAR_HEIGHT;
    GetIdealBitmapSize(CharWidth, SHENMUE_FONT_CHAR_HEIGHT, CharCount,
      BitmapCharsPerLine, BitmapIdealWidth, BitmapIdealHeight);

    // Init Bitmap properties
    with BitmapFont do begin
      Monochrome := True; // 1bpp
      Width := BitmapIdealWidth;
      Height := BitmapIdealHeight;
    end;

    // Initializing 1bpp decoder
    X := 0;
    Y := 0;

    // Reading each data block from the file
    repeat
      NumRead := InStream.Read(Buffer, MAX_BUFFER_SIZE);

{$IFDEF PROCESS_MESSAGES}
      Application.ProcessMessages;
{$ENDIF}

      // Decoding Font data
      for i := 0 to NumRead - 1 do begin

        // Drawing on the Bitmap
        for b := 0 to 7 do begin
          PixelOn := ((Buffer[i] shr b) and 1) = 1;
          if PixelOn then
            BitmapFont.Canvas.Pixels[X, Y] := clBlack;

{$IFDEF DEBUG} {$IFDEF DEBUG_FONTMGR}
          WriteLn('X: ', X, ', Y: ', Y);
{$ENDIF} {$ENDIF}

          // Calculating next coordonates for the result BitmapFont
          ComputeNextCoordinates(BitmapFont.Width, CharWidth,
            SHENMUE_FONT_CHAR_HEIGHT, X, Y);

        end; // for b

      end; // for i

    until (NumRead = 0);

    // Saving the result to a file
    BitmapFont.SaveToFile(OutFile);
    
  finally
    BitmapFont.Free;
    InStream.Free;
  end;
end;

//------------------------------------------------------------------------------

function ColorToBit(Color: TColor; Power: LongWord): Byte;
begin
  Result := 0;

  (* If the color is black, the bit is on
     Power is the bit position where the bit must be powered on in the LCD *)
  if (Color = clBlack) then
    Result := 1 shl Power;
end;

//------------------------------------------------------------------------------

function EncodeFontFile(const InFile, OutFile: TFileName; const BytesPerLine,
  BitmapCharsPerLine: Integer): TEncodeResult;
const
  MAX_BUFFER_SIZE = 65536;

var
  BitmapFont: TBitmap;
  OutStream: TFileStream;
  Buffer: array[0..MAX_BUFFER_SIZE - 1] of Byte;
  CharCount, CharWidth, IdealWidth, IdealHeight, BitPower,
  X, Y, i, CurrentBlockSize, BlockReadMissingCount, Bit: Integer;

begin
  Result := erFailed;
  if not FileExists(InFile) then Exit;

  
  OutStream := TFileStream.Create(OutFile, fmCreate);
  BitmapFont := TBitmap.Create;
  try

    // Load the Bitmap
    BitmapFont.LoadFromFile(InFile);

    CharWidth := 8 * BytesPerLine;
    CharCount := (BitmapFont.Width div CharWidth) *
      (BitmapFont.Height div SHENMUE_FONT_CHAR_HEIGHT);

    // Check the bitmap dimension
    GetIdealBitmapSize(CharWidth, SHENMUE_FONT_CHAR_HEIGHT, CharCount,
      BitmapCharsPerLine, IdealWidth, IdealHeight);
    if (BitmapFont.Height <> IdealHeight) or (BitmapFont.Width <> IdealWidth) then begin
      Result := erIncorrectBitmapDimension;
      Exit; // go to the finally section
    end;

    // Initializing 1bpp encoder
    X := 0;
    Y := 0;
    BlockReadMissingCount := CharCount * (SHENMUE_FONT_CHAR_HEIGHT * BytesPerLine);

    // BlockReadMissingCount contains atm the total size of the output encoded file.

    // Encoding the source Bitmap to the data file
    while BlockReadMissingCount <> 0 do begin   

      // CurrentBlockSize contains the size of the block currently filled.
      CurrentBlockSize := (BlockReadMissingCount mod SizeOf(Buffer));
      if CurrentBlockSize = 0 then
        CurrentBlockSize := SizeOf(Buffer);
      Dec(BlockReadMissingCount, CurrentBlockSize);

      // Initializing block
      ZeroMemory(@Buffer, SizeOf(Buffer));

      // For each value of the Buffer
      for i := 0 to CurrentBlockSize - 1 do begin

{$IFDEF PROCESS_MESSAGES}
      Application.ProcessMessages;
{$ENDIF}

        // For each bit in Buffer[j] (One Byte = 8 bits, so b := 0 to 7)
        for Bit := 0 to 7 do begin

          BitPower := Bit mod 8;

          // Adding the current bit state to the current Buffer[j] value
          Buffer[i] :=
            Buffer[i] + ColorToBit(BitmapFont.Canvas.Pixels[X, Y], BitPower);

{$IFDEF DEBUG} {$IFDEF DEBUG_FONTMGR}
          WriteLn('X: ', X, ', Y:', Y, ', bit #',
            Bit, ' of Buffer[', i, '], ',
            'Color: ', ColorToBit(BitmapFont.Canvas.Pixels[X, Y], BitPower));
{$ENDIF} {$ENDIF}

          // Calculating next coordonates used in the Bitmap Font
          ComputeNextCoordinates(BitmapFont.Width, CharWidth,
            SHENMUE_FONT_CHAR_HEIGHT, X, Y);

        end; // for k

      end; // for j

      // Write the current data block
      OutStream.Write(Buffer, CurrentBlockSize);
      
    end; // for i

    Result := erSuccess;
    
  finally
    BitmapFont.Free;
    OutStream.Free;
  end;
end;

//------------------------------------------------------------------------------

end.
