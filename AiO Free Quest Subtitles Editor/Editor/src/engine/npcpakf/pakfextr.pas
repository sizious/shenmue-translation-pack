unit pakfextr;

interface

uses
  Windows, SysUtils, Classes;

type
  TPAKFExtractionResult = (perUnknow, perNotValidFile, perTargetAlreadyExists,
    perConversionFailed, perSuccess);
  
function ExtractFaceFromPAKF(PAKFInFile, OutDir: TFileName
  {$IFDEF DEBUG};var DebugStringResult: string{$ENDIF}): TPAKFExtractionResult;
  
//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  PakfUtil;

const
  PAKF_SIGN = 'PAKF';
  TEXN_SIGN = 'TEXN';

type
  TFileHeader = record
    Name: array[0..3] of Char;
    Size: Integer;
    Crap: Integer;
    TexturesCount: Integer;
  end;

  TSectionEntry = record
    Name: array[0..3] of Char;
    Size: Integer;
    TextureName: array[0..7] of Char;
  end;

//------------------------------------------------------------------------------
  
procedure DumpBlockToFile(var Stream: TFileStream; Size: Integer;
  const OutFile: TFileName);
var
  TargetFile: TFileStream;
  
begin
  TargetFile := TFileStream.Create(OutFile, fmCreate);
  try
    TargetFile.CopyFrom(Stream, Size);
  finally
    TargetFile.Free;    
  end;
end;

//------------------------------------------------------------------------------

function IsValueInArray(SourceArray: array of string;
  ValueToSearch: string; var ArrayIndexResult: Integer): Boolean;
var
  i: Integer;
  
begin
  Result := False;
  i := Low(SourceArray);
  while (not Result) and (i <= High(SourceArray)) do begin
    Result := (Pos(SourceArray[i], ValueToSearch) > 0);
    if not Result then
      Inc(i);
  end;
  if Result then
    ArrayIndexResult := i
  else
    ArrayIndexResult := -1;
end; 

//------------------------------------------------------------------------------

function IsFaceTexture(TextureName: string): Boolean;
const
  SM1_FACE_TEXN_SIGN: array[0..12] of string = (
    'KAO', 'HED', 'KAA', 'FAC', 'KAF',
    'KAJ', 'MET', 'HIR', 'FCF', 'KAK',
    'RKA', 'NFA', 'KAC'); // 'MUF', 'ALL', 'AAA', 'L'
  SM2_FACE_TEXN_SIGN = '}Y_1';


var
  i: Integer;
    
begin
  Result := False;
  TextureName := UpperCase(TextureName);

  i := Low(SM1_FACE_TEXN_SIGN);
  while (not Result) and (i <= High(SM1_FACE_TEXN_SIGN)) do begin
    Result := (Pos(SM1_FACE_TEXN_SIGN[i], TextureName) > 0);
    Inc(i);
  end;

  if not Result then begin
    TextureName[6] := 'Y'; // fix for some Shenmue II PAKF...
    Result :=  (Pos(SM2_FACE_TEXN_SIGN, TextureName) > 0);
  end;
end;

//------------------------------------------------------------------------------

(*  I don't know how to retrieve the CharID inside the CHRM section... for now.
    But I know that in the most case, the CharID is located at 0x30 position
    inside the CHRM section.

    In special cases (INE_.PKF in the Shenmue 1 for example), the position
    become 0x50 inside the CHRM. AND I DON'T KNOW WHY.

    The function below is my try to retrieve logically (not "bruteforce") the
    CharID, but it doesn't work. I kept it here, if I (or you) want to try.

    The new GetCharID function is "bruteforce". It handle special case. It sucks,
    but it doesn't matter really, because it's only for reading and extracting
    PVR files. Right ?
*)

(*function GetCharID(var Stream: TFileStream; IpacOffset: Integer): string;
type
  TSection = packed record
    Name: array[0..3] of Char;
    Size: Integer;
  end;

const
  STRING_SECTION_SIGN = 'STRG';
  CHRS_SECTION_SIGN = 'CHRS';
  CHRS_SECTION_RECORD_SIZE = 4;
  MAX_STRG_BUFFER_SIZE = 2048;
  STRING_CHARACTER_SIGN = 'character';

var
  SavedPos: Int64;
  CharID: array[0..3] of Char;
  Section: TSection;
  SectionsFound: Boolean;

  StrBuf: string;
  i, Offset, STRGOffset, CHRSOffset,
  IPACSectionEndOffset: Integer;
  Buf: array[0..MAX_STRG_BUFFER_SIZE - 1] of Char;
  StringList: TStringList;

begin
  SavedPos := Stream.Position;
  Stream.Seek(IpacOffset, soBeginning);

  // Retrieving the Size of IPAC section to determine when we must stop the search
  Stream.Read(Section, SizeOf(Section));
  IPACSectionEndOffset := IpacOffset + Section.Size;

  // Go to the first IPAC section
  Stream.Seek(IpacOffset + 16, soBeginning);

  // Finding CHRM and STRG sections offset
  CHRSOffset := -1;
  STRGOffset := -1;
  repeat
    Offset := Stream.Position;

    // Reading the next section
    Stream.Read(Section, SizeOf(Section));

    // Parsing the section structure
    if Section.Name = STRING_SECTION_SIGN then
      STRGOffset := Offset
    else if Section.Name = CHRS_SECTION_SIGN then
      CHRSOffset := Offset;

    // If we got all we need
    SectionsFound := (STRGOffset <> -1) and (CHRSOffset <> -1);

    // Skipping the current section
    if not SectionsFound then
      Stream.Seek(Offset + Section.Size, soFromBeginning);
  until (Stream.Position >= IPACSectionEndOffset) or (SectionsFound);

  if not SectionsFound then Exit;

  StringList := TStringList.Create;
  try

    // Dumping the STRG section to the Buffer
    Stream.Seek(STRGOffset, soFromBeginning);
    Stream.Read(Section, SizeOf(Section));
    Stream.Read(Buf, Section.Size);

    // Building the StringList containing each STRG entry
    StrBuf := '';
    for i := 0 to Section.Size - 1 do begin
      if (Buf[i] = #0) then begin
        if StrBuf <> '' then StringList.Add(StrBuf);
        StrBuf := '';
      end else
        StrBuf := StrBuf + LowerCase(Buf[i]);
    end;

    // Have we an CharID in this String Section ?
    i := StringList.IndexOf(STRING_CHARACTER_SIGN);
    if i <> -1 then begin
      Inc(i); // StringList begin at 0
      Stream.Seek(CHRSOffset, soFromBeginning);
      Stream.Read(Section, SizeOf(Section));
      Stream.Seek(CHRSOffset + (i * CHRS_SECTION_RECORD_SIZE), soFromBeginning);
      Stream.Read(CharID, SizeOf(CharID));
      Result := CharID;
    end;

  finally
    StringList.Free;
    Stream.Seek(SavedPos, soFromBeginning);
  end;
end;*)

function GetCharID(var Stream: TFileStream; IpacOffset: Integer): string;
var
  SavedPos: Int64;
  CharID: array[0..3] of Char;
  
begin
  SavedPos := Stream.Position;
  Stream.Seek(IpacOffset, soBeginning);

  // Read the CharID inside the CHRM section... sucks but I don't care!
  Stream.Seek(IpacOffset + $60, soBeginning);
  Stream.Read(CharID, SizeOf(CharID));

  // Handling special cases (sucks!!)
  if (CharID = 'INE_') or (CharID = 'FUKU') then
    Result := CharID
  else begin
    Stream.Seek(IpacOffset + $40, soBeginning);
    Stream.Read(CharID, SizeOf(CharID));
    Result := CharID;
  end;

  Stream.Seek(SavedPos, soFromBeginning);  
end;

//------------------------------------------------------------------------------

// Sucks function but who cares???
function HandleSpecialCharID(const CharID: string;
  var TextureNumber: Integer): Boolean;
const
  EXCLUDE_CHARIDS: array[0..11] of string = (
    'CATA', 'CATB', 'CATC', 'DOOR', 'DORG',
    'FUKU', 'KYHN', 'MRIG', 'SBNK', 'SONZ',
    'TOMC', 'TOMD'
  );

  SPECIAL_CHARIDS: array[0..3] of string = (
    'HDEI', 'KOGA', 'MORN', 'YMGC'
  );

  SPECIAL_CHARIDS_PAKF_TEXTURE_INDEX: array[0..3] of Integer = (
    4, 4, 4, 4
  );
  
var
  i: Integer;
  
begin
  // Setting default texture number (By Default, it will search for the texture name)
  TextureNumber := -1;

  (*  Exclude these PKF files
      If the CharID is in the EXCLUDE_CHARIDS array, the result will be FALSE
      aka not a valid CharID *)
  Result := not IsValueInArray(EXCLUDE_CHARIDS, CharID, i);

{$IFDEF DEBUG}
  // Not a valid CharID then
  if not Result then begin
    WriteLn('*** NOT A VALID CHARID: "', CharID, '"');
  end;  
{$ENDIF}

  // Handling special CharID (sucks too much... I know)
  if Result and (IsValueInArray(SPECIAL_CHARIDS, CharID, i)) then begin
    TextureNumber := SPECIAL_CHARIDS_PAKF_TEXTURE_INDEX[i];
{$IFDEF DEBUG}
    WriteLn('*** SPECIAL CHARID: "', CharID, '", TextureNumber: ', TextureNumber);
{$ENDIF}
  end;
end;

//------------------------------------------------------------------------------

function ExtractFaceFromPAKF(PAKFInFile, OutDir: TFileName
  {$IFDEF DEBUG};var DebugStringResult: string{$ENDIF}): TPAKFExtractionResult;
var
  PAKFStream: TFileStream;
  Header: TFileHeader;
  SectionEntry: TSectionEntry;
  TexturesCount, TextureNumber,
  CurrentOffset, SpecialCharID_TextureIndex: Integer;
  FaceFound, ValidCharID: Boolean;
  OutFile, JPEGOutFile: TFileName;
  CharID: string;
  
begin
{$IFDEF DEBUG}
  DebugStringResult := '';
  WriteLn(#13#10, 'PAKF File: "', ExtractFileName(PAKFInFile), '"');
{$ENDIF}

  OutDir := IncludeTrailingPathDelimiter(OutDir);
  if OutDir = '\' then OutDir := '.\';

  PAKFStream := TFileStream.Create(PAKFInFile, fmOpenRead);
  try
    Result := perUnknow;
    try
      // Read the header
      PAKFStream.Read(Header, SizeOf(Header));
      if Header.Name <> PAKF_SIGN then Exit;

      TexturesCount := Header.TexturesCount;
      TextureNumber := 0;
      FaceFound := False;

      // Handling the CharID
      Result := perNotValidFile;
      CharID := GetCharID(PAKFStream, Header.Size);
      ValidCharID := HandleSpecialCharID(CharID, SpecialCharID_TextureIndex);  // very important function

      // Tests if the JPEG image file already exists, if yes, we skip it
      if ValidCharID then begin
        JPEGOutFile := OutDir + CharID + '.JPG';

        // The JPEG File for the CharID is already there, we don't need to do it
        if IsValidFaceImage(JPEGOutFile) then begin
          Result := perTargetAlreadyExists;
          ValidCharID := False; // exits the function           
        end;
      end;
      
      // This CharID is a valid PKF file !
      if ValidCharID then begin
        // For each section in this file
        repeat
          CurrentOffset := PAKFStream.Position;
          PAKFStream.Read(SectionEntry, SizeOf(SectionEntry));

          // TEXN section found
          if SectionEntry.Name = TEXN_SIGN then begin
            Inc(TextureNumber);

            // Handling special chars
            if SpecialCharID_TextureIndex <> -1 then
              FaceFound := TextureNumber = SpecialCharID_TextureIndex
            else // General chars
              FaceFound := IsFaceTexture(SectionEntry.TextureName);

{$IFDEF DEBUG}
            WriteLn('  Name: "', SectionEntry.Name, ', Size: "', SectionEntry.Size,
              '", Texture #', TextureNumber, ': "',
              SectionEntry.TextureName, '", IsFace: ', FaceFound);
{$ENDIF}
            // The texture face was found
            if FaceFound then begin
              OutFile := OutDir + CharID + '.PVR';
{$IFDEF DEBUG}
              DebugStringResult := '"' + CharID + '";"'
                + SectionEntry.TextureName + '"';
              WriteLn('Output File: "', ExtractFileName(OutFile), '"');
{$ENDIF}
              DumpBlockToFile(PAKFStream, SectionEntry.Size - SizeOf(SectionEntry),
                OutFile);

              // Convert the extracted PVR
              if ConvertFaceTexture(OutDir, OutFile) then
                Result := perSuccess
              else
                Result := perConversionFailed;

            end;
{$IFDEF DEBUG}
          end else
            WriteLn('  Name: "', SectionEntry.Name, '", Size: "',
              SectionEntry.Size, '"');
{$ELSE}
          end;
{$ENDIF}

          PAKFStream.Seek(CurrentOffset + SectionEntry.Size, soBeginning);
        until (TextureNumber >= TexturesCount) or (FaceFound);

      end; // ValidCharID

    except
      Result := perNotValidFile;
    end;
  finally
    PAKFStream.Free;
  end;
end;

//------------------------------------------------------------------------------

end.
