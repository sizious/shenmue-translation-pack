unit DataDefs;

interface

type
  TSequenceDataHeader = record
    NameID: array[0..3] of Char;  // SCN3
    Size: Integer;
    Unknow: Integer;
    UnknowPtr1: Integer;
    UnknowPtr2: Integer;
    DataSize1: Integer;           // Size - 8
    Unknow2: Integer;
    Unknow3: Integer;
    HeaderSize: Integer;          // Header size, I guess...
    DataSize2: Integer;           // Size - 8
    Unknow4: Integer;
    Unknow5: Integer;
  end;
  
  // JAP versions are unsupported!
  TNozomiMotorcycleSequenceGameVersion = (
    gvUnknow, gvUsaDisc3, gvPalDisc3, gvUsaPalDisc4
  );
  
  TGameVersionDetector = record
    Offset: Integer;
    Value: Byte;
    Result: TNozomiMotorcycleSequenceGameVersion;
  end;
  
const
  SCENE_SECTION_ID = 'SCN3';
  
  // DISC3: Subtitles offset where to update
  DISC3_ALL_POINTERS_SUBTITLES: array[0..10] of Integer = (
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
    $0482  // I'll remember you forever.
  );

  // DISC3: Offset to update with new locations
  DISC3_PAL_POINTERS_UPDATE: array[0..19] of Integer = (
    $0EBF, // $00 (End of the subtitle table. This is a null subtitle)
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

  DISC3_USA_POINTERS_UPDATE: array[0..19] of Integer = (
    $0EBF, // $00 (End of the subtitle table. This is a null subtitle)
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
  DISC4_ALL_POINTERS_SUBTITLES: array[0..10] of Integer = (
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
    $04E3  // I'll remember you forever.
  );

  // DISC4: Offset to update with new locations
  DISC4_ALL_POINTERS_UPDATE: array[0..13] of Integer = (
    $0C48, // $00 (End of the subtitle table. This is a null subtitle)
    $0D40, // $71 $FC $00 $00 $33 $13 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
    $0DB7, // $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
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

  SUBTITLE_LINE_MAXLENGTH = 44;

  GAME_VERSION_DETECTION: array[0..2] of TGameVersionDetector = (
    (Offset: $135A; Value: $70; Result: gvPalDisc3),
    (Offset: $135A; Value: $13; Result: gvUsaDisc3),
    (Offset: $135A; Value: $10; Result: gvUsaPalDisc4)
  );
    
implementation

end.
