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

// Analyze IPAC section to know if the section type is "Extended" (used by IpacMgr)
function AnalyzeIpacSection(const KindName: string;
  var SourceFileStream: TFileStream; Offset, Size: LongWord;
  var ExpandedKindFound: Boolean): TIpacSectionKind;

// Standard Kind for UI
function GetKindIndex(const KindName: string): Integer;
function GetStandardKind(Index: Integer): TIpacSectionKind;
function GetStandardKindCount: Integer;

implementation

uses
 SysTools, Forms;

const
  UNKNOW_DESCRIPTION_KIND = '(Unknow)';

  (*  IPAC footer section type
      Raw read in the footer to determine section type. *)
  STANDARD_COUNT = 8;
  IPAC_SECTION_STANDARD_KINDS: array[0..STANDARD_COUNT - 1] of TIpacSectionKind = (
    (Name: 'BIN '; Extension: 'BIN'; Description: 'Generic Binary'),
    (Name: 'CHRM'; Extension: 'CRM'; Description: 'Character Model'),
    (Name: 'CHRT'; Extension: 'CHT'; Description: 'Character Properties'),
    (Name: 'MAPM'; Extension: 'MAP'; Description: 'Map Information'),
    (Name: 'MOTN'; Extension: 'MOT'; Description: 'Motion Data'),
    (Name: 'AUTH'; Extension: 'ATH'; Description: 'Sequence Data'),
    (Name: 'DYNM'; Extension: 'DYM'; Description: 'Dynamics Info'),
    (Name: 'SCR0'; Extension: 'SRL'; Description: 'Scroll Data')
  );

  (*  Extended IPAC section entries.
      When we read the Ipac section signature we can determinate if the section
      can be identified by a more specific type. In fact, in the footer,
      we have (at least for now) only two types: 'BIN ' and 'CHRM'. But a 'BIN '
      section can be a PVR, SPR... or anything else. *)
  EXTENDED_COUNT = 14;
  IPAC_SECTION_EXTENDED_KINDS: array[0..EXTENDED_COUNT - 1] of TIpacSectionKind = (
    (Name: 'TEXN'; Extension: 'SPR'; Description: 'Sprite Package'),
    (Name: 'GBIX'; Extension: 'PVR'; Description: 'PowerVR Texture'),
    (Name: 'PVRT'; Extension: 'PVR'; Description: 'PowerVR Texture'),
    (Name: 'SCNF'; Extension: 'SNF'; Description: 'Subtitles Table'),
    (Name: 'IWAD'; Extension: 'IWD'; Description: 'LCD Table'),
    (Name: 'WDAT'; Extension: 'WDT'; Description: 'Weather Data'),
    (Name: 'MVSD'; Extension: 'MVS'; Description: 'MVS Data'),
    (Name: 'MDP7'; Extension: 'MP7'; Description: 'MP7 Model'),
    (Name: 'MDC7'; Extension: 'MC7'; Description: 'MC7 Model'),
    (Name: 'MDPX'; Extension: 'MPX'; Description: 'MPX Model'),
    (Name: 'MDCX'; Extension: 'MCX'; Description: 'MCX Model'),
    (Name: 'HRCM'; Extension: 'HCM'; Description: 'HCM Model'),
    (Name: 'MDL7'; Extension: 'ML7'; Description: 'ML7 Model'),
    (Name: 'MDLX'; Extension: 'MLX'; Description: 'MLX Model')
  );
  
//------------------------------------------------------------------------------

function GetStandardKind(Index: Integer): TIpacSectionKind;
begin
  Result.Name := '';
  Result.Extension := '';
  Result.Description := UNKNOW_DESCRIPTION_KIND;
  if (Index < 0) or (Index > (STANDARD_COUNT - 1)) then Exit;

  Result := IPAC_SECTION_STANDARD_KINDS[Index];
end;

//------------------------------------------------------------------------------

function GetStandardKindCount: Integer;
begin
  Result := STANDARD_COUNT;
end;

//------------------------------------------------------------------------------

function SectionKindSequentialSearch(SourceArray: array of TIpacSectionKind;
  const Value: string; var ResultItem: TIpacSectionKind;
  var ResultIndex: Integer): Boolean;
var
  i: Integer;

begin
  i := Low(SourceArray);
  ResultIndex := i - 1;
  Result := False;
  repeat
    if SourceArray[i].Name = Value then begin
      ResultItem := SourceArray[i];
      ResultIndex := i;
      Result := True;
    end;
    Inc(i);
  until Result or (i > High(SourceArray));
end;

//------------------------------------------------------------------------------

function GetStandardKindDetails(const KindName: string;
  var ResultItem: TIpacSectionKind): Boolean;
var
  NotUsedCrap: Integer;

begin
  Result := SectionKindSequentialSearch(IPAC_SECTION_STANDARD_KINDS, KindName,
    ResultItem, NotUsedCrap);
end;

//------------------------------------------------------------------------------

function GetExtendedKindDetails(const SectionName: string;
  var ResultItem: TIpacSectionKind): Boolean;
var
  NotUsedCrap: Integer;

begin
  Result := SectionKindSequentialSearch(IPAC_SECTION_EXTENDED_KINDS, SectionName,
    ResultItem, NotUsedCrap);
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
  StandardKindFound: Boolean;

begin
  (*  Saving the offset, because this Stream is coming from the LoadFromFile
      function, and currently scanning the source file! *)
  SavedOffset := SourceFileStream.Position;

  //  EXPANDED KIND INFO -------------------------------------------------------
  (*  Trying to get the section details (is the section SPR, PVR or anything
      else?)... In fact, the IPAC footer may indicate only if the file is "BIN "
      type, but it can be more specific. *)
  SourceFileStream.Seek(Offset, soFromBeginning);
  MaxPos := SourceFileStream.Position + Size;

  // scanning section
  repeat
    // Parsing header
    SourceFileStream.Read(SectionHeader, SizeOf(SectionHeader));
    ExpandedKindFound := GetExtendedKindDetails(SectionHeader.Name, Result);

    // Checking if we found an expanded kind and/or if the next section is invalid
    Done := ExpandedKindFound or (SectionHeader.Size = 0)
      or (SectionHeader.Size >= MaxPos);
    if not Done then
      SourceFileStream.Seek(SectionHeader.Size, soFromBeginning);

    Application.ProcessMessages;
  until (Done) or (SourceFileStream.Position >= MaxPos);

  SourceFileStream.Seek(SavedOffset, soFromBeginning);

  // STANDARD KIND INFO --------------------------------------------------------
  // By default, it's the kind from the IPAC footer
  if not ExpandedKindFound then begin
    StandardKindFound := GetStandardKindDetails(KindName, Result);

    // UNKNOW STANDARD KIND INFO -----------------------------------------------
    // The worst case, we don't know anything on this IPAC entry!
    if not StandardKindFound then begin
      Result.Extension := '';
      Result.Description := UNKNOW_DESCRIPTION_KIND;
    end;
    
  end;
end;

//------------------------------------------------------------------------------

function GetKindIndex(const KindName: string): Integer;
var
  Crap: TIpacSectionKind;
  Found: Boolean;

begin
  // Seaching Extended first   
  Found := SectionKindSequentialSearch(IPAC_SECTION_EXTENDED_KINDS,
    KindName, Crap, Result);

  // Searching Standard kinds after
  if not Found then begin
    Found := SectionKindSequentialSearch(IPAC_SECTION_STANDARD_KINDS, KindName,
      Crap, Result);
    Inc(Result, EXTENDED_COUNT); // Standard Images are after the Extended ones
  end;

 // Result + 1: The "0" is for the "Unknow" ImageIndex.
  if Found then
    Inc(Result)
  else
    Result := 0;
end;

//------------------------------------------------------------------------------

end.
