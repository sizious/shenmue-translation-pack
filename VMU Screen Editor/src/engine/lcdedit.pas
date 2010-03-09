unit lcdedit;

interface

uses
  Windows, SysUtils, Classes, Graphics;

type
  TImageDimension = record
    Width: Byte;
    Height: Byte;
  end;
  
  TVmuLcdEditor = class;

  TVmuLcdEntry = class
  private
    fName: string;
    fSize: LongWord;
    fOffset: LongWord;
    fUpdated: Boolean;
    fImportedFileName: TFileName;
    fOwner: TVmuLcdEditor;
    fNewSize: LongWord;
    fDimension: TImageDimension;
    fNewOffset: LongWord;
    fNewDimension: TImageDimension;
  protected
    procedure WriteEntry(var InStream, OutStream: TFileStream);
    property NewDimension: TImageDimension read fNewDimension;
    property NewSize: LongWord read fNewSize;
    property NewOffset: LongWord read fNewOffset;    
  public
    constructor Create(Owner: TVmuLcdEditor);
    procedure CancelImport;
    procedure Dump(const FileName: TFileName);
    procedure ExportToFile(const FileName: TFileName);
    function ImportFromFile(const FileName: TFileName): Boolean;
    property Dimension: TImageDimension read fDimension;
    property ImportedFileName: TFileName read fImportedFileName;
    property Name: string read fName;
    property Offset: LongWord read fOffset;
    property Owner: TVmuLcdEditor read fOwner;
    property Size: LongWord read fSize;
    property Updated: Boolean read fUpdated;
  end;

  TVmuLcdEditor = class
  private
    fVmuLcdEntryList: TList;
    fSourceFileName: TFileName;
    function GetItem(Index: Integer): TVmuLcdEntry;
    function GetCount: Integer;
  protected
    procedure Add(var IwadFile: TFileStream; Offset, Size: LongWord; Name: string);
    function GetImageSize(var Iwad: TFileStream; Offset: LongWord): TImageDimension;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function LoadFromFile(const FileName: TFileName): Boolean;
    function Save: Boolean;
    function SaveToFile(const FileName: TFileName): Boolean;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TVmuLcdEntry read GetItem; default;
    property SourceFileName: TFileName read fSourceFileName;
  end;

implementation

uses
  SysTools;
  
const
  IWAD_SIGN = 'IWAD';
  
type
  TIwadHeader = record
    Signature: array[0..3] of Char;
    EntriesCount: LongWord;
    TableOffset: LongWord;
  end;

  TIwadTableEntry = record
    Name: array[0..7] of Char;
    Size: LongWord;
    Offset: LongWord;
  end;
  
{ TVmuLcdEditor }

procedure TVmuLcdEditor.Add(var IwadFile: TFileStream; Offset, Size: LongWord;
  Name: string);
var
  Item: TVmuLcdEntry;
  ImageSize: TImageDimension;
{$IFDEF DEBUG}
  Index: Integer;
{$ENDIF}

begin
  // Retrieving the image size
  ImageSize := GetImageSize(IwadFile, Offset);

  // Creating the TVmuLcd entry
  Item := TVmuLcdEntry.Create(Self);
  Item.fDimension.Height := ImageSize.Height;
  Item.fDimension.Width := ImageSize.Width;
  Item.fOffset := Offset;
  Item.fSize := Size;
  Item.fName := Name;    
{$IFDEF DEBUG} Index := {$ENDIF} fVmuLcdEntryList.Add(Item);

{$IFDEF DEBUG}
  WriteLn('  #', Index, ': Name: "', Name, '", Offset: ', Offset, 
    ', Size: ', Size, ', Image Size: ', Item.Dimension.Width, 'x',
    Item.Dimension.Height);
{$ENDIF}
end;

procedure TVmuLcdEditor.Clear;
var
  i: Integer;
  
begin
  for i := 0 to Count - 1 do
    TVmuLcdEntry(fVmuLcdEntryList[i]).Free;
  fVmuLcdEntryList.Clear;
end;

constructor TVmuLcdEditor.Create;
begin
  fVmuLcdEntryList := TList.Create;
end;

destructor TVmuLcdEditor.Destroy;
begin
  Clear;
  fVmuLcdEntryList.Free;
  inherited;
end;

function TVmuLcdEditor.GetCount: Integer;
begin
  Result := fVmuLcdEntryList.Count;
end;

function TVmuLcdEditor.GetImageSize(var Iwad: TFileStream; 
  Offset: LongWord): TImageDimension;
var
  SavedOffset: Int64;

begin
  SavedOffset := Iwad.Position;

  // Read the Width and the Height of the Image
  Iwad.Seek(Offset, soFromBeginning);
  Iwad.Read(Result, SizeOf(TImageDimension));
  
  Iwad.Seek(SavedOffset, soFromBeginning);
end;

function TVmuLcdEditor.GetItem(Index: Integer): TVmuLcdEntry;
begin
  Result := TVmuLcdEntry(fVmuLcdEntryList.Items[Index]);
end;

function TVmuLcdEditor.LoadFromFile(const FileName: TFileName): Boolean; 
var
  Header: TIwadHeader;
  Entry: TIwadTableEntry;
  IwadFile: TFileStream;
  i: Integer;
  
begin
  Result := False;
  IwadFile := TFileStream.Create(FileName, fmOpenRead);
  try
    // Read the header
    IwadFile.Read(Header, SizeOf(Header));

    // If the file is an IWAD...
    if Header.Signature = IWAD_SIGN then begin

      // Saving the FileName
      fSourceFileName := FileName;
      
      // Reading the IWAD table
      IwadFile.Seek(Header.TableOffset, soFromBeginning);
      for i := 0 to Header.EntriesCount - 1 do begin
        IwadFile.Read(Entry, SizeOf(TIwadTableEntry));    
        Add(IwadFile, Entry.Offset, Entry.Size, Entry.Name);
      end;

      // OK!    
      Result := True;
    end;
    
  finally
    IwadFile.Free;
  end;
end;

function TVmuLcdEditor.Save: Boolean;
begin
  Result := SaveToFile(SourceFileName);
end;

function TVmuLcdEditor.SaveToFile(const FileName: TFileName): Boolean;
var
  Header: TIwadHeader;
  Entry: TIwadTableEntry;
  InStream, OutStream: TFileStream;
  TableOffsetValueLocation, SavedPosition: LongWord;
  i: Integer;
  Overwrite: Boolean;
  TempFileName: TFileName;

begin
  Result := False;
  if not FileExists(SourceFileName) then Exit;

  Overwrite := UpperCase(SourceFileName) = UpperCase(FileName);
  TempFileName := GetTempFileName;

  // Initialize Streams
  InStream := TFileStream.Create(SourceFileName, fmOpenRead);
  OutStream := TFileStream.Create(TempFileName, fmCreate);
  try

    // Initializing header
    StrCopy(Header.Signature, PChar(IWAD_SIGN));
    Header.EntriesCount := Count;
    TableOffsetValueLocation :=
      SizeOf(Header.Signature) + SizeOf(Header.EntriesCount);    
    Header.TableOffset := $FFFFFFFF; // need to be updated

    // Writing header
    OutStream.Write(Header, SizeOf(TIwadHeader));

    // Writing IWAD content
    for i := 0 to Count - 1 do begin
      Items[i].WriteEntry(InStream, OutStream);

      // Updating entry if needed (the source file was overwrited)
      if Overwrite then
        with Items[i] do begin
          fSize := NewSize;
          fOffset := NewOffset;
          fDimension := NewDimension;
          CancelImport; // reset import status
        end;
    end;

    // Writing IWAD TableOffset value in the header
    SavedPosition := OutStream.Position;
    OutStream.Seek(TableOffsetValueLocation, soFromBeginning);
    OutStream.Write(SavedPosition, SizeOf(Header.TableOffset));
    OutStream.Seek(SavedPosition, soFromBeginning);

    // Writing IWAD Table
    for i := 0 to Count - 1 do begin
      StrCopy(Entry.Name, PChar(Items[i].Name));
      Entry.Size := Items[i].NewSize;
      Entry.Offset := Items[i].NewOffset;
      OutStream.Write(Entry, SizeOf(TIwadTableEntry));
    end;

  finally
    InStream.Free;
    OutStream.Free;

    // Deleting the old source file
    if Overwrite then
      DeleteFile(SourceFileName);
    if FileExists(FileName) then
      DeleteFile(FileName);

    // Copying the new file
    Result := MoveFile(TempFileName, FileName);
  end;
end;

{ TVmuLcdEntry }

procedure TVmuLcdEntry.CancelImport;
begin
  fImportedFileName := '';
  fUpdated := False;
end;

constructor TVmuLcdEntry.Create(Owner: TVmuLcdEditor);
begin
  fOwner := Owner;
end;

procedure TVmuLcdEntry.Dump(const FileName: TFileName);
var
  IwadFile, OutFile: TFileStream;
  
begin
  IwadFile := TFileStream.Create(Owner.SourceFileName, fmOpenRead);
  OutFile := TFileStream.Create(FileName, fmCreate);
  try
    IwadFile.Seek(Offset + SizeOf(TImageDimension), soFromBeginning);
    OutFile.CopyFrom(IwadFile, Size - 2);
  finally
    IwadFile.Free;
    OutFile.Free;
  end;
end;

procedure TVmuLcdEntry.WriteEntry(var InStream, OutStream: TFileStream);
var
  Bitmap: TBitmap;
  Buffer: array[0..255] of Byte;
  X, Y, b, i, BitPower: Integer;
  Padding: array[0..31] of Byte;
  PaddingSize: LongWord;
  
  function ColorToBit(Color: TColor; Power: LongWord): Byte;
  begin
    Result := 0;

    // If the color is black, the bit is on
    if (Color = clBlack) then
      Result := 128 shr Power; // Power is the bit position where the bit must be powered on in the LCD
  end;

begin
  if Updated then begin
    // Write the patched LCD data

    Bitmap := TBitmap.Create;
    try
      fNewOffset := OutStream.Position;

      // Loading the Bitmap
      Bitmap.LoadFromFile(ImportedFileName);
      Bitmap.Monochrome := True;

      // Writing the new size of the image
      fNewDimension.Width := Bitmap.Width;
      fNewDimension.Height := Bitmap.Height;
      OutStream.Write(NewDimension, SizeOf(TImageDimension));

      // Initialize
      i := -1;
      fNewSize := Bitmap.Height * (Round(Bitmap.Width / 8));
      ZeroMemory(@Buffer, NewSize);
      
      // Encoding the Bitmap data
      for Y := 0 to Bitmap.Height - 1 do
        for X := 0 to Bitmap.Width - 1 do begin
          BitPower := X mod 8;
          
          (*
            Each 8 pixels are encoded on one Byte:
            One Byte = [ 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 ]
            Each cell can be on when setting the bit at 1
            For example if the Byte = 128, the left pixel is on
            If the Byte = 129 (128 + 1), the left and the most right pixels are on 
          *)
          if BitPower = 0 then
            Inc(i);

          // Retrieving the Pixel state
          b := ColorToBit(Bitmap.Canvas.Pixels[X, Y], BitPower);
          Buffer[i] := Buffer[i] + b;
        end;

      // Writing the encoded data
      OutStream.Write(Buffer, NewSize);

      // Adding the TImageDimension Size
      Inc(fNewSize, SizeOf(TImageDimension));
    finally
      Bitmap.Free;
    end;

  end else begin
    // Copy the LCD data from the source IWAD
    InStream.Seek(Offset, soFromBeginning);
    OutStream.CopyFrom(InStream, Size);

    // Copying previous values
    fNewSize := Size;
    fNewOffset := Offset;
  end;

  // Writing Padding
  PaddingSize := NewSize mod 4;
  ZeroMemory(@Padding, PaddingSize);
(*  padding[0] := $de;
  padding[1] := $ad; *)
  OutStream.Write(Padding, PaddingSize);
end;

procedure TVmuLcdEntry.ExportToFile(const FileName: TFileName);
var
  IwadFileStream: TFileStream;
  Bitmap: TBitmap;
  Buffer: array[0..255] of Byte;
  i, b, Factor, X, Y: Integer;
  PixelOn: Boolean;
  
begin
  IwadFileStream := TFileStream.Create(Owner.SourceFileName, fmOpenRead);
  Bitmap := TBitmap.Create;
  try
    // Init Bitmap properties
    with Bitmap do begin
      Monochrome := True; // 1bpp
      Width := Dimension.Width;
      Height := Dimension.Height;
    end;

    // Skipping Image Size infos
    IwadFileStream.Seek(Offset + SizeOf(TImageDimension), soFromBeginning);

    // Reading the LCD data entry
    IwadFileStream.Read(Buffer, Size);
    
    // Initializing 1bpp decoder
    Factor := Size div Dimension.Height; // 8 bits in one Byte
    X := 0;
    
    // Decoding LCD data
    for i := 0 to Size - 1 do begin

      // Pre-calculating coordonates
      Y := i div Factor;    
      if (i mod Factor) = 0 then
        X := 0;

      // Drawing on the Bitmap 
      for b := 7 downto 0 do begin
        PixelOn := ((Buffer[i] shr b) and 1) = 1;
        if PixelOn then
          Bitmap.Canvas.Pixels[X, Y] := clBlack;
        Inc(X);
      end;
    end;

    Bitmap.SaveToFile(FileName);
  finally
    Bitmap.free;
    IwadFileStream.Free;
  end;
end;

function TVmuLcdEntry.ImportFromFile(const FileName: TFileName): Boolean;
begin
  Result := FileExists(FileName);
  if not Result then Exit;
  
  fImportedFileName := FileName;
  fUpdated := True;
end;

end.
