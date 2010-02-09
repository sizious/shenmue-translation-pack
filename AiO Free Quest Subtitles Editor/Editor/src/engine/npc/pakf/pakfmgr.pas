unit pakfmgr;

interface

function GetTextureIndexForSpecialCharID(const CharID: string): Integer;
function IsFaceTexture(TextureName: string): Boolean;

implementation

uses
  SysUtils, SysTools;

type
  TSpecialNPC = record
    CharID        : string;
    TextureIndex  : Integer;
  end;

(*
    These CharIDs are errornous extracted if we don't set properly the right
    texture to extract. Check the SPECIAL_CHARIDS_PAKF_TEXTURE_INDEX array to
    know the texture index to extract from the PAKF. The TextureNumber starts
    at 1 (not 0), so the first texture in the PKF package is 1.

    Example: In the HDEI PKF package, the Face texture is the N°4.
*)
const
  SPECIAL_NPCS: array [0..20] of TSpecialNPC = (
    (CharID: 'HDEI'; TextureIndex: 4), (CharID: 'KOGA'; TextureIndex: 4),
    (CharID: 'MORN'; TextureIndex: 4), (CharID: 'YMGC'; TextureIndex: 4),
    (CharID: '04B_'; TextureIndex: 7), (CharID: '05B_'; TextureIndex: 5),
    (CharID: '06B_'; TextureIndex: 5), (CharID: '07B_'; TextureIndex: 5),
    (CharID: '08B_'; TextureIndex: 5), (CharID: '09B_'; TextureIndex: 5),
    (CharID: 'C07_'; TextureIndex: 6), (CharID: 'EDL_'; TextureIndex: 7),
    (CharID: 'KJN_'; TextureIndex: 7), (CharID: 'KUD_'; TextureIndex: 4),
    (CharID: 'KUN_'; TextureIndex: 7), (CharID: 'KYG_'; TextureIndex: 4),
    (CharID: 'MEY_'; TextureIndex: 7), (CharID: 'MM5_'; TextureIndex: 2),
    (CharID: 'RNP_'; TextureIndex: 6), (CharID: 'SYM_'; TextureIndex: 5),
    (CharID: 'TSK_'; TextureIndex: 6)
  );

//------------------------------------------------------------------------------

function IsSpecialNPC(SourceArray: array of TSpecialNPC;
  CharID: string; var IndexResult: Integer): Boolean;
var
  i: Integer;

begin
  Result := False;
  i := Low(SourceArray);
  while (not Result) and (i <= High(SourceArray)) do begin
    Result := (Pos(SourceArray[i].CharID, CharID) > 0);
    if not Result then
      Inc(i);
  end;
  if Result then
    IndexResult := i
  else
    IndexResult := -1;
end;

//------------------------------------------------------------------------------

function IsFaceTexture(TextureName: string): Boolean;
const
  SM1_FACE_TEXNAME_SIGN: array[0..12] of string = (
    'KAO', 'HED', 'KAA', 'FAC', 'KAF',
    'KAJ', 'MET', 'HIR', 'FCF', 'KAK',
    'RKA', 'NFA', 'KAC'); // 'MUF', 'ALL', 'AAA', 'L'

  SM2_FACE_TEXNAME_SIGN: array[0..1] of string = (
    '}Y_1', '}Y¾‡'
  );

begin
  TextureName := UpperCase(TextureName);

  // Shenmue I
  Result := StringArraySequentialSearch(SM1_FACE_TEXNAME_SIGN, TextureName) <> -1;

  // Shenmue II
  if not Result then begin
    TextureName[6] := 'Y'; // fix for some Shenmue II PAKF...
    Result := StringArraySequentialSearch(SM2_FACE_TEXNAME_SIGN, TextureName) <> -1;
  end;
end;

//------------------------------------------------------------------------------

// Sucks function but who cares???
function GetTextureIndexForSpecialCharID(const CharID: string): Integer;
var
  i: Integer;

begin
  // Setting default texture number (By Default, it will search for the texture name)
  Result := -1;

  // Handling special CharID (sucks too much... I know)
  if IsSpecialNPC(SPECIAL_NPCS, CharID, i) then begin
    Result := SPECIAL_NPCS[i].TextureIndex;

{$IFDEF DEBUG}
    WriteLn('  Special CharID: "', CharID, '", TextureNumber: ', Result);
{$ENDIF}
  end;
end;

//------------------------------------------------------------------------------

end.
