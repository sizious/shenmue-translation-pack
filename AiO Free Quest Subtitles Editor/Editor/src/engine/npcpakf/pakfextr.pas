unit pakfextr;

interface

uses
  Windows, SysUtils, Classes;
  
function ExtractFaceFromPAKF(PAKFInFile, OutDir: TFileName): Boolean;

implementation

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

function IsFaceTexture(TextureName: string): Boolean;
const
  SM1_FACE_TEXN_SIGN: array[0..5] of string = (
    'KAO', 'HED', 'KAA', 'FAC', 'KAF', 'KAJ');
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

function GetCharID(var Stream: TFileStream; IpacOffset: Integer): string;
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
end;
  
function ExtractFaceFromPAKF(PAKFInFile, OutDir: TFileName): Boolean;
var
  PAKFStream: TFileStream;
  Header: TFileHeader;
  SectionEntry: TSectionEntry;
  TexturesCount,
  TextureNumber,
  CurrentOffset: Integer;
  FaceFound: Boolean;
  OutFile: TFileName;

begin
{$IFDEF DEBUG}
  WriteLn(#13#10, 'PAKF File: "', ExtractFileName(PAKFInFile), '"');
{$ENDIF}

  OutDir := IncludeTrailingPathDelimiter(OutDir);
  if OutDir = '\' then OutDir := '.\';
  PAKFStream := TFileStream.Create(PAKFInFile, fmOpenRead);
  try
    Result := False;
    try
      // Read the header
      PAKFStream.Read(Header, SizeOf(Header));
      if Header.Name <> PAKF_SIGN then Exit;

      TexturesCount := Header.TexturesCount;
      TextureNumber := 0;
      FaceFound := False;

      // For each section in this file
      repeat
        CurrentOffset := PAKFStream.Position;
        PAKFStream.Read(SectionEntry, SizeOf(SectionEntry));

        // TEXN section found
        if SectionEntry.Name = TEXN_SIGN then begin
          Inc(TextureNumber);
          FaceFound := IsFaceTexture(SectionEntry.TextureName);
          
{$IFDEF DEBUG}
          WriteLn('  Name: "', SectionEntry.Name, ', Size: "', SectionEntry.Size,
            '", Texture #', TextureNumber, ': "', 
            SectionEntry.TextureName, '", IsFace: ', FaceFound);
{$ENDIF}
          // The texture face was found
          if FaceFound then begin
            OutFile := OutDir + GetCharID(PAKFStream, Header.Size) + '.PVR';          
{$IFDEF DEBUG}
            WriteLn('Output File: "', ExtractFileName(OutFile), '"');
{$ENDIF}
            DumpBlockToFile(PAKFStream, SectionEntry.Size - SizeOf(SectionEntry), 
              OutFile);
            Result := True;
          end;
{$IFDEF DEBUG}
        end else
          WriteLn('  Name: "', SectionEntry.Name, '", Size: "', SectionEntry.Size, 
            '"');
{$ELSE}
        end;
{$ENDIF}        
        
        PAKFStream.Seek(CurrentOffset + SectionEntry.Size, soBeginning);
      until (TextureNumber >= TexturesCount) or (FaceFound);

    except
      Result := False;
    end;
  finally
    PAKFStream.Free;
  end;
end;

end.
