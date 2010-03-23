unit nbikedit;

interface

uses
  Windows, SysUtils, Classes;
  
type
  TNozomiMotorcycleSequenceEditor = class;

  // JAP versions are unsupported!
  TNozomiMotorcycleSequenceGameVersion = (
    gvUnknow, gvJapDisc3, gvJapDisc4, gvUsaDisc3, gvPalDisc3, gvUsaPalDisc4
  );

  TNozomiMotorcycleSequenceSubtitleItem = class(TObject)
  private
    fText: string;
    fIndex: Integer;
    fOwner: TNozomiMotorcycleSequenceEditor;
    fPointerOffset: Integer;
  protected
    procedure WriteSubtitle(var F: TFileStream);
  public
    property Index: Integer read fIndex;
    property Text: string read fText write fText;
    property PointerOffset: Integer read fPointerOffset;
    property Owner: TNozomiMotorcycleSequenceEditor read fOwner;
  end;

  TNozomiMotorcycleSequenceEditor = class(TObject)
  private
    fSubtitleList: TList;
    fSourceFileName: TFileName;
    function GetCount: Integer;
    function GetSubtitleItem(Index: Integer): TNozomiMotorcycleSequenceSubtitleItem;
  protected
    procedure Add(StringPointerOffset: Integer; var Input: TFileStream);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromFile(const FileName: TFileName);
    procedure SaveToFile(const FileName: TFileName);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TNozomiMotorcycleSequenceSubtitleItem 
      read GetSubtitleItem; default;
    property SourceFileName: TFileName read fSourceFileName;
  end;

implementation

type
  TGameVersionDetector = record
    Offset: Integer;
    Value: Integer;
    Result: TNozomiMotorcycleSequenceGameVersion;
  end;
  
const
  // DISC3: Subtitles offset where to update
  DISC3_ALL_POINTERS_SUBTITLES: array[0..11] of Integer = (
    $03A8, // Like a dream I once saw,<br>it passes by as it touches my cheek.
    $03C3, // This street leading to the ocean<br>carries the smell of sea.
    $03D9, // Before love makes me tell a white lie.
    $03EE, // This loneliness...<br>I want you to hold it in your arms now.
    $0403, // If you will always be by my side,
    $0418, // there'll be no sorrow or tears in my eyes.
    $042E, // Can't live without you.<br>Why did you have to decide?
    $0443, // You won't be aware of my pains and lies.
    $0458, // Don't leave me alone, stay with me.
    $046D, // I don't know if you'll ever look back.
    $0482, // I'll remember you forever.
    $0EBF  // (End of the subtitle table)
  );

  // DISC3: Offset to update with new locations
  DISC3_PAL_POINTERS_UPDATE: array[0..18] of Integer = (
    $0FB7, // $71 $FC $00 $00 $33 $13 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
    $102E, // $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
    $14A7, // $CD $CC $CC $3D $CD $CC $CC $3D $CD $CC $CC $3D $CD $CC $CC $3D
    $15EE, // $9A $99 $99 $3E $9A $99 $99 $3E $9A $99 $99 $3E $9A $99 $99 $3E
    $1732, // $00 $00 $20 $41 $00 $00 $48 $43 $00 $00 $40 $3F $12 $06 $00 $FF
    $1744, // $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
    $174F, // SCROLL27.SPR
    $1754, // sprite
    $1760, // 01BIKEB
    $176E, // a1_nbike.snd
    $1792, // SCROLL25.SPR
    $1797, // sprite
    $17A6, // M_01BIKE.BIN
    $184D, // SCROLL25.SPR
    $1852, // sprite
    $1861, // M_01BIKE.BIN
    $1886, // SCROLL25.SPR
    $188B, // sprite
    $189A  // M_01BIKE.BIN
  );

  DISC3_USA_POINTERS_UPDATE: array[0..18] of Integer = (
    $0FB7, // $71 $FC $00 $00 $33 $13 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
    $102E, // $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
    $1375, // $CD $CC $CC $3D $CD $CC $CC $3D $CD $CC $CC $3D $CD $CC $CC $3D
    $14BC, // $9A $99 $99 $3E $9A $99 $99 $3E $9A $99 $99 $3E $9A $99 $99 $3E
    $1600, // $00 $00 $20 $41 $00 $00 $48 $43 $00 $00 $40 $3F $12 $06 $00 $FF
    $1612, // $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
    $161D,
    $1622,
    $162E,
    $163C,
    $1660,
    $1665,
    $1674,
    $171B,
    $1720,
    $172F,
    $1754,
    $1759,
    $1768
  );

  // DISC4: Subtitles offset where to update
  DISC4_ALL_POINTERS_SUBTITLES: array[0..11] of Integer = (
    $0409, // Like a dream I once saw,<br>it passes by as it touches my cheek.
    $0424, // This street leading to the ocean<br>carries the smell of sea.
    $043A, // Before love makes me tell a white lie.
    $044F, // This loneliness...<br>I want you to hold it in your arms now.
    $0464, // If you will always be by my side,
    $0479, // there'll be no sorrow or tears in my eyes.
    $048F, // Can't live without you.<br>Why did you have to decide?
    $04A4, // You won't be aware of my pains and lies.
    $04B9, // Don't leave me alone, stay with me.
    $04CE, // I don't know if you'll ever look back.
    $04E3, // I'll remember you forever.
    $0C48  // (End of the subtitle table)
  );

  // DISC4: Offset to update with new locations
  DISC4_ALL_POINTERS_UPDATE: array[0..12] of Integer = (
    $0D40,
    $0DB7,
    $1230,
    $1377,
    $14C6,
    $14D8,
    $14E3,
    $14E8,
    $14F4,
    $1502,
    $1526,
    $152B,
    $1539
  );

  SUBTITLE_DELIMITER  =  #$81#$9C#$90#$C2;
  SUBTITLE_LINEBREAK  =  #$81#$95;

  GAME_VERSION_DETECTION: array[0..4] of TGameVersionDetector = (
    (Offset: $135A; Value: $50; Result: gvJapDisc3),  // Unsupported!
    (Offset: $135A; Value: $70; Result: gvPalDisc3),
    (Offset: $135A; Value: $13; Result: gvUsaDisc3),
    (Offset: $135A; Value: $00; Result: gvJapDisc4),  // Unsupported!
    (Offset: $135A; Value: $10; Result: gvUsaPalDisc4)
  );

{ TNozomiMotorcycleSequenceEditor }

procedure TNozomiMotorcycleSequenceEditor.Add(StringPointerOffset: Integer; 
  var Input: TFileStream);
var
  NewItem: TNozomiMotorcycleSequenceSubtitleItem;
  Subtitle: string;
  StringOffsetValue: Integer;
  c: Char;
  Done: Boolean;
  
begin
  // Initializing the Subtitle decoder
  Done := False;
  Subtitle := '';
  Input.Read(StringOffsetValue, 4);
  Input.Seek(StringOffsetValue, soFromBeginning);

  // Reading the subtitle
  while not Done do begin  
    Input.Read(c, 1);
    if c <> #0 then
      Subtitle := Subtitle + c
    else
      Done := True;
  end;

  // Parsing the subtitle
  Subtitle := StringReplace(Subtitle, SUBTITLE_DELIMITER, '', [rfReplaceAll]);
  Subtitle := StringReplace(Subtitle, SUBTITLE_LINEBREAK, '<br>', [rfReplaceAll]);
  
  // Adding the new item to the internal list
  NewItem := TNozomiMotorcycleSequenceSubtitleItem.Create;
  with NewItem do begin
    fOwner := Self;
    fPointerOffset := StringPointerOffset;
    fText := Subtitle; 
  end;
  NewItem.fIndex := fSubtitleList.Add(NewItem);

{$IFDEF DEBUG}
  WriteLn(IntToHex(StringPointerOffset, 4), ': "', NewItem.Text, '"');
{$ENDIF}
end;

procedure TNozomiMotorcycleSequenceEditor.Clear;
var
  i: Integer;

begin
  for i := 0 to fSubtitleList.Count - 1 do
    TNozomiMotorcycleSequenceSubtitleItem(fSubtitleList[i]).Free;
  fSubtitleList.Clear;
end;

constructor TNozomiMotorcycleSequenceEditor.Create;
begin
  fSubtitleList := TList.Create;
end;

destructor TNozomiMotorcycleSequenceEditor.Destroy;
begin
  Clear;
  fSubtitleList.Free;
  inherited;
end;

function TNozomiMotorcycleSequenceEditor.GetCount: Integer;
begin
  Result := fSubtitleList.Count;
end;

function TNozomiMotorcycleSequenceEditor.GetSubtitleItem(
  Index: Integer): TNozomiMotorcycleSequenceSubtitleItem;
begin
  Result := TNozomiMotorcycleSequenceSubtitleItem(Items[Index]);
end;

procedure TNozomiMotorcycleSequenceEditor.LoadFromFile(
  const FileName: TFileName);
var
  Input: TFileStream;
  i: Integer;
  
begin
  Input := TFileStream.Create(FileName, fmOpenRead);
  try         
    fSourceFileName := FileName;
    
    // Detect the file version

    // Reading the subtitle table
    for i := Low(DISC3_ALL_POINTERS_SUBTITLES) to High(DISC3_ALL_POINTERS_SUBTITLES) do begin
      Input.Seek(DISC3_ALL_POINTERS_SUBTITLES[i], soFromBeginning);
      Add(DISC3_ALL_POINTERS_SUBTITLES[i], Input);
    end;
    
  finally
    Input.Free;
  end;  
end;

procedure TNozomiMotorcycleSequenceEditor.SaveToFile(const FileName: TFileName);
var
  Input, Output: TFileStream;

begin
  Input := TFileStream.Create(SourceFileName, fmOpenRead);
  Output := GetTempFileName;
end;

{ TNozomiMotorcycleSubtitleItem }

procedure TNozomiMotorcycleSequenceSubtitleItem.WriteSubtitle(var F: TFileStream);
begin

end;

end.
