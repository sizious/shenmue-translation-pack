unit ipacutil;

interface

uses
  Windows, SysUtils, Classes;
  
type
  TIpacSectionKind = record
    Name: string;
    Extension: string;
    Description: string;
  end;

const
  IPAC_BIN  = 'BIN ';
  IPAC_CHRM = 'CHRM';
  IPAC_CHRT = 'CHRT';

  (*  IPAC footer section type
      Raw read in the footer to determine section type. *)
  IPAC_SECTION_KINDS: array[0..2] of TIpacSectionKind = (
    (Name: IPAC_BIN ; Extension: 'BIN'; Description: 'Generic Binary'),
    (Name: IPAC_CHRM; Extension: 'CHR'; Description: 'Character Model'),
    (Name: IPAC_CHRT; Extension: 'CHT'; Description: 'Character PAKF')
  );

  (*  Extended IPAC section entries.
      When we read the Ipac section signature we can determinate if the section
      can be identified by a more specific type. In fact, in the footer,
      we have (at least for now) only two types: 'BIN ' and 'CHRM'. But a 'BIN '
      section can be a PVR, SPR... or anything else. *)
  IPAC_SECTION_PARSE_RESULTS: array[0..6] of TIpacSectionKind = (
    (Name: 'TEXN'; Extension: 'SPR'; Description: 'Sprite Package'),
    (Name: 'GBIX'; Extension: 'PVR'; Description: 'PowerVR Texture'),
    (Name: 'PVRT'; Extension: 'PVR'; Description: 'PowerVR Texture'),
    (Name: 'SCNF'; Extension: 'SNF'; Description: 'Subtitles Table'),
    (Name: 'IWAD'; Extension: 'IWD'; Description: 'LCD Table'),
    (Name: 'WDAT'; Extension: 'WDT'; Description: 'Weather Data'),
    (Name: 'MVSD'; Extension: 'MVS'; Description: 'MVS Data')
  );

function AnalyzeIpacSection(const KindName: string;
  var SourceFileStream: TFileStream; Offset, Size: LongWord;
  var ExpandedKindFound: Boolean): TIpacSectionKind;

implementation

uses
 SysTools, Forms;

//------------------------------------------------------------------------------

function SectionKindSequentialSearch(SourceArray: array of TIpacSectionKind;
  const Value: string; var ResultItem: TIpacSectionKind): Boolean;
var
  i: Integer;
  
begin
  i := Low(SourceArray);
  Result := False;
  repeat
    if SourceArray[i].Name = Value then begin
      ResultItem := SourceArray[i];
      Result := True;
    end;
    Inc(i);
  until Result or (i > High(SourceArray));
end;

//------------------------------------------------------------------------------

function GetKindDetails(const KindName: string;
  var ResultItem: TIpacSectionKind): Boolean;
begin
  Result := SectionKindSequentialSearch(IPAC_SECTION_KINDS, KindName, ResultItem);
end;

//------------------------------------------------------------------------------

function GetParseResultDetails(const SectionName: string;
  var ResultItem: TIpacSectionKind): Boolean;
begin
  Result := SectionKindSequentialSearch(IPAC_SECTION_PARSE_RESULTS, SectionName, ResultItem);
end;

//------------------------------------------------------------------------------

function AnalyzeIpacSection(const KindName: string;
  var SourceFileStream: TFileStream; Offset, Size: LongWord;
  var ExpandedKindFound: Boolean): TIpacSectionKind;
type
  TSectionHeader = record
    Name: array[0..3] of Char;
    Size: LongWord;
  end;

var
  SavedOffset, MaxPos: LongWord;
  Done: Boolean;
  SectionHeader: TSectionHeader;
  
begin
  (*  Saving the offset, because this Stream is coming from the LoadFromFile function,
      and currently scanning the source file! *)
  SavedOffset := SourceFileStream.Position;

  // Trying to get the section details (is the section SPR, PVR or anything else?)...
  SourceFileStream.Seek(Offset, soFromBeginning);
  MaxPos := SourceFileStream.Position + Size;

  // scanning section
  repeat
    // Parsing header
    SourceFileStream.Read(SectionHeader, SizeOf(SectionHeader));
    ExpandedKindFound := GetParseResultDetails(SectionHeader.Name, Result);

    // Checking if we found an expanded kind and/or if the next section is invalid
    Done := ExpandedKindFound or (SectionHeader.Size = 0)
      or (SectionHeader.Size >= MaxPos);
    if not Done then
      SourceFileStream.Seek(SectionHeader.Size, soFromBeginning);

    Application.ProcessMessages;
  until (Done) or (SourceFileStream.Position >= MaxPos);

  SourceFileStream.Seek(SavedOffset, soFromBeginning);

  // By default, it's the kind from the IPAC footer
  if not ExpandedKindFound then
    GetKindDetails(KindName, Result);
end;

//------------------------------------------------------------------------------

end.
