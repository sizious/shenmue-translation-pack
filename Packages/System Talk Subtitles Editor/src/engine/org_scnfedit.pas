unit SCNFEdit;

{$DEFINE USE_DCL}

// If you want to show PAKS info in the console uncomment the line above
{$DEFINE DEBUG_SCNFEDITOR}

interface

uses
  Windows, SysUtils, Classes, ScnfUtil,
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants
  {$IFDEF USE_DCL}, DCL_intf, HashMap {$ENDIF}
  ;

const
  GAME_INTEGER_SIZE = 4;
  SCNF_EDITOR_ENGINE_VERSION = '3.4.2';
  SCNF_EDITOR_ENGINE_COMPIL_DATE_TIME = 'June 20, 2010 @04:58PM';

type
  ESCNFEditor = class(Exception);
  ECinematicsScriptGenerator = class(ESCNFEditor);

  // Structure to read IPAC sections info from footer
  TSectionRawBinaryEntry = record
    CharID: array[0..3] of Char; // Correction for Shenmue II... (FIX v3.4.0)
    UnknowValue: Integer; // Really for Shenmue II, still unknow value... (v3.4.0)
    Name: array[0..3] of Char; // type of the footer entry ('BIN ', 'CHRM...')
    Offset: Integer;
    Size: Integer;
  end;

  // Structure to read subtitle entry from header table
  TSubRawBinaryEntry = record
    SubTextOffset: Integer;
    SubCodeOffset: Integer;
    SubCode: array[0..3] of Char;
    UnknowCrap: Integer;
  end;

  TSCNFEditor = class;

  TSCNFCharsDecodeTable = class;

  TSubList = class;

  // contains a sub entry
  TSubEntry = class(TObject)
  private
    fEditorOwner: TSCNFEditor;
    fOwner: TSubList;
    fIndex: Integer;

    fStartSubtitleEntry: string;                  // string before each subtitle text
    fStartSubtitleEntryLength: Integer;           // bytes count of that string

    fSubTextOffset: Integer;
    fSubCodeOffset: Integer;
    fUnknowValue: Integer;

    fCode: string;
    fText: string;
    fCharID: string;
    fVoiceID: string;

    procedure FillSubtitleTextFromRaw(var RawSubtitleText: array of Char);
    procedure SetText(const Value: string);
    procedure WriteHeaderEntry(var F: file);
    procedure WriteTextEntry(var F: file);
    function GetText: string;
  public
    constructor Create(Owner: TSubList);
    function IsTextEquals(const CompareText: string): Boolean;
    property CharID: string read fCharID;
    property Code: string read fCode;
    property CodeOffset: Integer read fSubCodeOffset;
    property EditorOwner: TSCNFEditor read fEditorOwner;
    property Owner: TSubList read fOwner;
    property RawText: string read fText;
    property Text: string read GetText write SetText;
    property TextOffset: Integer read fSubTextOffset;
    property VoiceID: string read fVoiceID;
  end;

  // contains all subtitles
  TSubList = class(TObject)
  private
{$IFDEF USE_DCL}
    fOptimizationHashMap: IStrMap;
{$ENDIF}  
    fOwner: TSCNFEditor;
    fList: TList;
    fCharsDecodeTable: TSCNFCharsDecodeTable;
    function GetItem(Index: Integer): TSubEntry;
    function GetCount: Integer;
    procedure WriteSubtitlesTable(var F: file);
    procedure AddXMLNode(var XMLDoc: IXMLDocument; const Key, Value: string);
      overload;
    procedure AddXMLNode(var XMLDoc: IXMLDocument; const Key: string;
      const Value: Integer); overload;
  protected
    procedure AddEntry(SubEntry: TSubRawBinaryEntry);
    procedure Clear;
  public
    constructor Create(Owner: TSCNFEditor);
    destructor Destroy; override;
    function ExportToFile(const FileName: TFileName): Boolean;
    function ImportFromFile(const FileName: TFileName): Boolean;
    function IndexOfSubtitleByCode(const Code: string): Integer;
    function FindSubtitleByCode(const Code: string): TSubEntry;
    property CharsIdDecodeTable: TSCNFCharsDecodeTable read fCharsDecodeTable;
    property Items[Index: Integer]: TSubEntry read GetItem; default;
    property Count: Integer read GetCount;
    property Owner: TSCNFEditor read fOwner;
  end;
    
  // Enable to translate letters "A", "B" to "RYO_", ...
  TSCNFCharsDecodeTableItem = class(TObject)
  private
    fOwner: TSCNFCharsDecodeTable;
    fCode: Char;
    fCharID: string;
  public
    constructor Create(Owner: TSCNFCharsDecodeTable);
    property CharID: string read fCharID;
    property Code: Char read fCode;
  end;

  // container of TSCNFCharsDecodeTableItem
  TSCNFCharsDecodeTable = class(TObject)
  private
    fOwner: TSubList;
    fList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSCNFCharsDecodeTableItem;
  protected
    function Add(CharID: string): Integer;
    procedure Clear;
  public
    constructor Create(Owner: TSubList);
    destructor Destroy; override;
    function GetCharIdFromCode(const Code: Char): string;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSCNFCharsDecodeTableItem read GetItem; default;
    property Owner: TSubList read fOwner;
  end;

  // Footer IPAC sections
  TSectionsList = class;
  
  TSectionItem = class(TObject)
  private
    fOwner: TSectionsList;
    fName: string;
    fSize: Integer;
    fOffset: Integer;
    fCharID: string;
    fUnknowValue: Integer;
    procedure WriteFooterEntry(var F: file);
    function GetEditor: TSCNFEditor;
    function GetCharID: string;
  protected
    property Editor: TSCNFEditor read GetEditor;
  public
    constructor Create(Owner: TSectionsList);
    property CharID: string read GetCharID; // Fixed in 3.4.0
    property UnknowValue: Integer read fUnknowValue; // Check GetCharID method
    property Name: string read fName;
    property Offset: Integer read fOffset;
    property Owner: TSectionsList read fOwner;
    property Size: Integer read fSize;
  end;

  TSectionsList = class(TObject)
  private
    fOwner: TSCNFEditor;
    fList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSectionItem;
  protected
    function Add(SectionEntry: TSectionRawBinaryEntry): Integer;
    procedure Clear;
  public
    constructor Create(Owner: TSCNFEditor);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSectionItem read GetItem; default;
    property Owner: TSCNFEditor read fOwner;
  end;

  // Main class
  TSCNFEditor = class(TObject)
  private
    fSourceFileName: TFileName;             // Source filename of the current instance

//    fCharsList: TSubsCharsList;

//    fGameVersion: TGameVersion;             // Game version (read at offset 0x8)

    fCharacterID: string;                   // 4 bytes length string (read at 0x48) (not modified)
    fVoiceFullID: string;                       // x length string (read at 0x112) (not modified)
    fVoiceShortID: string;                  // only the code (extracted from VoiceID) (not modified)

    fScnfCharIdHeaderOffset: Integer;     // position of the CharID offset start within the scnf header
    fScnfCharIdHeaderSize: Integer;           // size of block with SCNF + CharID header (not modified)
    fScnfStrTableHeaderOffset: Integer;         // String table header position (not modified)
    fScnfStrTableBodyOffset: Integer;           // Subtitles text string table start position (not modified)
    
    fSubList: TSubList;
    fSectionsList: TSectionsList;

    fIpacSectionSize: Integer;         // IPAC section size (modified)
    fFooterOffset: Integer;            // Footer offset that contains IPAC sections infos (modified)

    fMakeBackup: Boolean;
    fFileLoaded: Boolean;
//    fNPCInfo: TNPCInfosTable;
    function GetSubList: TSubList;
//    function GetGameVersion: TGameVersion;
    function GetCharacterID: string;
    function GetSectionsList: TSectionsList;
  protected
    procedure CopyFileBlock(var SrcF, DestF: file; SrcStartOffset, SrcBlockSize: Integer);
//    function GetGameVersionFromVoiceID(const FullVoiceID: string): TGameVersion;
    function GetTempFileName: TFileName;
    function IsValidScnfFooterEntry(var F: file; Section: TSectionItem): Boolean;
    function null_bytes_length(dataSize: Integer): Integer;    
    procedure ParseScnfSection(var F: file; ScnfOffset: Integer);
    procedure WriteSectionPadding(var F: file; DataSize: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function GetLoadedFileName: TFileName;

    function LoadFromFile(const FileName: TFileName): Boolean;
    function ReloadFile: Boolean;
    procedure SaveToFile(const FileName: TFileName);
    procedure Save;

    property CharacterID: string read GetCharacterID;
//    property GameVersion: TGameVersion read GetGameVersion;
    property VoiceFullID: string read fVoiceFullID;
    property VoiceShortID: string read fVoiceShortID;          
    property FooterOffset: Integer read fFooterOffset;
    property ScnfCharIDHeaderSize: Integer read fScnfCharIdHeaderSize;
    property StrTableHeaderOffset: Integer read fScnfStrTableHeaderOffset;
    property StrTableBodyOffset: Integer read fScnfStrTableBodyOffset;
    
    property Sections: TSectionsList read GetSectionsList;
    property Subtitles: TSubList read GetSubList;
    property SourceFileName: TFileName read fSourceFileName;
    
    property FileLoaded: Boolean read fFileLoaded;
    property MakeBackup: Boolean read fMakeBackup write fMakeBackup;
//    property CharsList: TSubsCharsList read fCharsList;
  end;

{$IFDEF DEBUG}
var
  DebugLoadFromFile: Boolean = {$IFDEF DEBUG_SCNFEDITOR} True {$ELSE} False {$ENDIF};
  DebugParseScnfSection: Boolean = {$IFDEF DEBUG_SCNFEDITOR} True {$ELSE} False {$ENDIF};
  DebugSaveToFile: Boolean = {$IFDEF DEBUG_SCNFEDITOR} True {$ELSE} False {$ENDIF};
{$ENDIF}

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  {$IFDEF DEBUG}TypInfo, {$ENDIF}
  SysTools;

{$IFDEF USE_DCL}

type
  TSCNFEditorIndexHashItem = class(TObject)
  private
    fItemIndex: Integer;
    fSubCode: string;
  public
    property SubCode: string read fSubCode write fSubCode; 
    property ItemIndex: Integer read fItemIndex write fItemIndex;
  end;

{$ENDIF}

//------------------------------------------------------------------------------
// TSCNFEditor
//------------------------------------------------------------------------------

procedure TSCNFEditor.Clear;
begin
//  Self.fGameVersion := gvUndef;

  Self.fCharacterID := '';
  Self.fVoiceFullID := '';
  Self.fVoiceShortID := '';
  Self.fScnfStrTableHeaderOffset := 0;
  Self.fScnfStrTableBodyOffset := 0;
  Self.fScnfCharIdHeaderSize := 0;

  Self.Subtitles.Clear;

  Sections.Clear;
end;

//------------------------------------------------------------------------------

constructor TSCNFEditor.Create;
begin
  fSubList := TSubList.Create(Self);
  fSectionsList := TSectionsList.Create(Self);
//  fCharsList := TSubsCharsList.Create;
  fFileLoaded := False;
end;

//------------------------------------------------------------------------------

destructor TSCNFEditor.Destroy;
begin
  fSubList.Free;
  fSectionsList.Free;
//  fCharsList.Free;
  inherited;
end;

//------------------------------------------------------------------------------

// Added by Manic
// Modified by SiZiOUS to resolve bugs when padding size must be > 29 bytes length
function TSCNFEditor.null_bytes_length(dataSize:Integer): Integer;
var current_num, total_null_bytes:Integer;
begin
  //Finding the correct number of null bytes after file data
  current_num := 0;
  total_null_bytes := 0;
  while current_num <> dataSize do
  begin
    if total_null_bytes = 0 then begin
      total_null_bytes := 31;
    end
    else begin
      Dec(total_null_bytes);
    end;
    Inc(current_num);
  end;

  // {$IFDEF DEBUG} WriteLn('null_bytes_length: dataSize: ', dataSize, ', padding: ', total_null_bytes); {$ENDIF}

  Result := total_null_bytes;
end;

//------------------------------------------------------------------------------

function TSCNFEditor.GetCharacterID: string;
begin
  Result := Self.fCharacterID;
end;

//------------------------------------------------------------------------------

(*function TSCNFEditor.GetGameVersion: TGameVersion;
begin
  Result := fGameVersion;
end;*)

//------------------------------------------------------------------------------

function TSCNFEditor.GetLoadedFileName: TFileName;
begin
  Result := fSourceFileName;
end;

//------------------------------------------------------------------------------

function TSCNFEditor.GetSectionsList: TSectionsList;
begin
  Result := Self.fSectionsList;
end;

function TSCNFEditor.GetSubList: TSubList;
begin
  Result := Self.fSubList;
end;

//------------------------------------------------------------------------------

(*function TSCNFEditor.GetGameVersionFromVoiceID(const FullVoiceID: string): TGameVersion;
const
  WSM_VOICE1 = 'T';
  WSM_VOICE2 = 'XT';
  
var
  VoiceID: string;

begin
  VoiceID := ExtremeRight('/', FullVoiceID);
  Result := gvUndef;

  if Pos(VOICE_STR_WHATS_SHENMUE, FullVoiceID) > 0 then begin
    Result := gvWhatsShenmue;
    if (Copy(VoiceID, 1, 1) <> WSM_VOICE1) and (Copy(VoiceID, 1, 2) <> WSM_VOICE2) then
      Result := gvShenmueJ; // fix for some Shenmue 1 (JAP) PKS    
  end else if Pos(VOICE_STR_SHENMUEJ, FullVoiceID) > 0 then
    Result := gvShenmueJ
  else if Pos(VOICE_STR_SHENMUE, FullVoiceID) > 0 then
    Result := gvShenmue
  else if Pos(VOICE_STR_SHENMUE2, FullVoiceID) > 0 then
    Result := gvShenmue2
  else if Pos(VOICE_STR_SHENMUE2X, FullVoiceID) > 0 then
    Result := gvShenmue2X
  else if Pos(VOICE_STR_SHENMUE2J, FullVoiceID) > 0 then
    Result := gvShenmue2J;
end;*)

//------------------------------------------------------------------------------

// ParseScnfSection is written to analyse the structure of the SCNF section inside
// a PAKS file. This's the method retrieving subtitles.
procedure TSCNFEditor.ParseScnfSection(var F: file; ScnfOffset: Integer);
const
  MAX_BUF_ARRAY = 511;

var
  BufSubCode: array[0..3] of Char;

  CharIDSectionOffset: Integer;
  SubTableHeaderReadingDone: Boolean;
  SubRawBinaryEntry: TSubRawBinaryEntry;

  Buffer: array[0..MAX_BUF_ARRAY] of Char;
  VoiceIDOffset, VoiceIDLength: Integer;
  CharsIdTableOffset, CharsIdTableSize: Integer;
  i, j: Integer;
  BufStr: string;
  SubSize: Integer;
  BytesToRead: Integer;
  
begin
  try
  {$IFDEF DEBUG}
    if DebugParseScnfSection then
      WriteLn('Loading file...');
  {$ENDIF}

    // SCNF offset
  {$IFDEF DEBUG}
    if DebugParseScnfSection then
      WriteLn('SCNF offset: ', ScnfOffset);
  {$ENDIF}

    // ---------------------------------------------------------------------------
    // READING "CharID" SECTION INSIDE SCNF SECTION
    // ---------------------------------------------------------------------------

    // CharID (Section Name)
    CharIDSectionOffset := ScnfOffset + 16;
    fScnfCharIdHeaderOffset := CharIDSectionOffset;
  {$IFDEF DEBUG}
    if DebugParseScnfSection then
      WriteLn('Char ID (in SCNF header) offset: ', fScnfCharIdHeaderOffset);
  {$ENDIF}

    // Reading the CharID within the SCNF section header
    Seek(F, CharIDSectionOffset);
    BlockRead(F, BufSubCode, SizeOf(BufSubCode));
    Self.fCharacterID := BufSubCode;
  {$IFDEF DEBUG}
    if DebugParseScnfSection then
      WriteLn('Char ID: ', CharacterID);
  {$ENDIF}

    // string table offset
    Seek(F, CharIDSectionOffset + 24);
    BlockRead(F, fScnfStrTableHeaderOffset, SizeOf(fScnfStrTableHeaderOffset));
    fScnfStrTableHeaderOffset := CharIDSectionOffset + fScnfStrTableHeaderOffset;
    fScnfCharIdHeaderSize := (fScnfStrTableHeaderOffset - CharIDSectionOffset) + 16;
  {$IFDEF DEBUG}
    if DebugParseScnfSection then
      WriteLn('StrTableHeaderOffset: ', fScnfStrTableHeaderOffset, #13#10, 'StrScnfCharIdHeaderSize: ',
        fScnfCharIdHeaderSize, #13#10, 'CharIDSectionOffset: ', CharIDSectionOffset);
  {$ENDIF}

    // Voice ID
    Seek(F, CharIDSectionOffset + 16);
    BlockRead(F, VoiceIDOffset, GAME_INTEGER_SIZE);   // start of the Voice ID string
    BlockRead(F, VoiceIDLength, GAME_INTEGER_SIZE);   // size of the Voice ID string
    VoiceIDLength := VoiceIDLength - VoiceIDOffset;

    // reading VoiceID
    Seek(F, CharIDSectionOffset + VoiceIDOffset);
    BlockRead(F, Buffer[0], VoiceIDLength);
    BufStr := PChar(@Buffer);
  
    fVoiceFullID := BufStr;
    fVoiceShortID := ExtremeRight('/', fVoiceFullID);
  {$IFDEF DEBUG}
    if DebugParseScnfSection then
      WriteLn('VoiceFullID: ', VoiceFullID);
  {$ENDIF}

    // Game version detection (NEW 3.1)
//    fGameVersion := GetGameVersionFromVoiceID(VoiceFullID);
  {$IFDEF DEBUG}
    if DebugParseScnfSection then
//      WriteLn('Game version: ', GetEnumName(TypeInfo(TGameVersion), Ord(fGameVersion)));
  {$ENDIF}

    // Filling the Characters ID decode table
    Seek(F, CharIDSectionOffset + 32);
    BlockRead(F, CharsIdTableOffset, GAME_INTEGER_SIZE);
    CharsIdTableSize := VoiceIDOffset - CharsIdTableOffset;
    j := (CharsIdTableSize div 4); // A CharID is ALWAYS on 4 chars
  
  {$IFDEF DEBUG}
    if DebugParseScnfSection then
      WriteLn('CharsIdTableOffset: ', CharsIdTableOffset, ', CharsIdTableSize: ', CharsIdTableSize);
  {$ENDIF}

    Seek(F, CharIDSectionOffset + CharsIdTableOffset);
    for i := 0 to j - 1 do begin
      BlockRead(F, BufSubCode, SizeOf(BufSubCode));
      Subtitles.CharsIdDecodeTable.Add(BufSubCode);
    end;

  {$IFDEF DEBUG}
    if DebugParseScnfSection then begin
      WriteLn('CharsID decode table:');
      for i := 0 to Subtitles.CharsIdDecodeTable.Count - 1 do
        WriteLn(' ', Subtitles.CharsIdDecodeTable[i].CharID, ': ',
          Subtitles.CharsIdDecodeTable[i].Code
        );
    end;
  {$ENDIF}

    //----------------------------------------------------------------------------
    // SUBTITLES TABLE ENTRIES SCAN
    //----------------------------------------------------------------------------

    // Retrieving String Table Body Offset (that contains every subtitles text)
    // Each sub entry starts with ShortVoiceID (Like "FEX20") and with a sub id (like "A001")
    // Where all subs starting with "A" stand for Ry� and "B" is for the NPC character.
    Seek(F, fScnfStrTableHeaderOffset + 4); // reading the first entry of the header table
    BlockRead(F, fScnfStrTableBodyOffset, GAME_INTEGER_SIZE);
    fScnfStrTableBodyOffset := CharIDSectionOffset + fScnfStrTableBodyOffset;

    // Reading String Table Header
    Seek(F, fScnfStrTableHeaderOffset);
    SubTableHeaderReadingDone := False;
    while not SubTableHeaderReadingDone do begin
      // Reading raw entry from the table
      BlockRead(F, SubRawBinaryEntry, SizeOf(TSubRawBinaryEntry));

      // adding the new entry
      Subtitles.AddEntry(SubRawBinaryEntry);

      // To get the StrTableBodyOffset (where is stored all VoiceID and Subtitle datas)
      // from file read the second value of first sub in the header table
      // To summarize, the structure of the file is : [Subtitle Table (Header)] [Str Table (Body)]
      SubTableHeaderReadingDone := (FilePos(F) = fScnfStrTableBodyOffset);
    end;

  {$IFDEF DEBUG}
    if DebugParseScnfSection then begin
      WriteLn(sLineBreak, 'String table header offset: ', fScnfStrTableHeaderOffset);
      WriteLn('String table body offset: ', fScnfStrTableBodyOffset, sLineBreak);
    end;
  {$ENDIF}

    //----------------------------------------------------------------------------
    // TABLE TEXT ENTRIES SCAN
    //----------------------------------------------------------------------------

    BytesToRead := FileSize(F) - FilePos(F);
    SubSize := SizeOf(Buffer);
  
    for i := 0 to Subtitles.Count - 1 do begin
      // Reading Subtitle VoiceID
      Seek(F, CharIDSectionOffset + Subtitles[i].CodeOffset);
      VoiceIDLength := Subtitles[i].TextOffset - Subtitles[i].CodeOffset;
      ZeroMemory(@Buffer, VoiceIDLength + 1);
      BlockRead(F, Buffer, VoiceIDLength);
      Subtitles[i].fVoiceID := Buffer;

  {$IFDEF DEBUG}
      if DebugParseScnfSection then begin
        if Pos(VoiceShortID, Subtitles[i].fVoiceID) = 0 then
          WriteLn('WARNING: Subtitle VoiceID beginning seems to be INVALID! ',
            '(Found = "', Subtitles[i].fVoiceID, '", Excepted = "', VoiceShortID,
            '"');
      end;
  {$ENDIF}

      // Reading raw subtitle text
      Seek(F, CharIDSectionOffset + Subtitles[i].TextOffset);
      ZeroMemory(@Buffer, SizeOf(Buffer));

      if BytesToRead > 0 then begin
        BytesToRead := FileSize(F) - FilePos(F);
        if BytesToRead < SizeOf(Buffer) then begin
          SubSize := BytesToRead;
        end else SubSize := SizeOf(Buffer);
      end;

      BlockRead(F, Buffer, SubSize); // we can read in single time because each sub terminates with null terminal char ($00)...
      Subtitles[i].FillSubtitleTextFromRaw(Buffer); // this will parse the raw subtitle and modify the Text properties with the real text.

      // WriteLn(BytesToRead, ' ', SubSize, ' ', FilePos(F));

  {$IFDEF DEBUG}
    if DebugParseScnfSection then
      WriteLn(Subtitles[i].Code, ': ', Subtitles[i].fText);
  {$ENDIF}
    end;

  {$IFDEF DEBUG}
    if DebugParseScnfSection then
      WriteLn('');
  {$ENDIF}
  except
{$IFDEF DEBUG}
    on E: Exception do
      WriteLn('EXCEPTION: TSCNFEditor.ParseScnfSection [File: "',
        ExtractFileName(fSourceFileName), '"]: ', E.Message);
{$ENDIF}
  end;
end;

//------------------------------------------------------------------------------

function TSCNFEditor.LoadFromFile(const FileName: TFileName): Boolean;
var
  F: file;
  IntBuf: Integer;
  ScnfSectionEntry: Integer;
  SectionEntry: TSectionRawBinaryEntry;
  ScnfSectionFound: Boolean;
{$IFDEF DEBUG}
  NewSectionItem: TSectionItem;
{$ENDIF}

begin
  Result := False;

  // If the file doesn't exists we exit
  if not FileExists(FileName) then Exit;

  // Unload previous file
  fFileLoaded := False;

  // Store filename
  fSourceFileName := FileName;

{$IFDEF DEBUG}
  if DebugLoadFromFile then  
    WriteLn(sLineBreak, '*** LOADING FILE: "', fSourceFileName, '".');
{$ENDIF}

  // Clear scnf editor object
  Clear;

  // ---------------------------------------------------------------------------
  // BEGINNING PARSING AND DISSECTING PAKS SUBTITLES FILE
  // ---------------------------------------------------------------------------

  try
    // Open the file in read mode (to extract all infos from it)
    AssignFile(F, fSourceFileName);
    FileMode := fmOpenRead;
    {$I-}Reset(F, 1);{$I+}
    if IOResult <> 0 then Exit;

    // ---------------------------------------------------------------------------
    // PARSING SCNF SECTION THAT CONTAINTS THE SUBTITLES TABLE
    // ---------------------------------------------------------------------------

    ParseScnfSection(F, 0);  // launch parsing SCNF section to retrieve subtitles !


    CloseFile(F);

  except
{$IFDEF DEBUG}
    on E: Exception do
      WriteLn('EXCEPTION: TSCNFEditor.LoadFromFile [File: "',
        ExtractFileName(fSourceFileName), '"]: ', E.Message);
{$ENDIF}
  end;
end;

//------------------------------------------------------------------------------

function TSCNFEditor.ReloadFile: Boolean;
begin
  Result := False;
  if FileLoaded then
    Result := LoadFromFile(SourceFileName);
end;

//------------------------------------------------------------------------------

procedure TSCNFEditor.CopyFileBlock(var SrcF, DestF: file; SrcStartOffset, SrcBlockSize: Integer);
const
  WORK_BUFFER_SIZE = 16384;
  
var
  i, Max: Integer;
  _Last_BufEntry_Size, BufSize: Integer;
  Buf: array[0..WORK_BUFFER_SIZE-1] of Char;

begin
  Seek(SrcF, SrcStartOffset);

  BufSize := SizeOf(Buf);
  _Last_BufEntry_Size := (SrcBlockSize mod BufSize);
  Max := SrcBlockSize div BufSize;
  for i := 0 to Max - 1 do begin
    BlockRead(SrcF, Buf, SizeOf(Buf), BufSize);
    BlockWrite(DestF, Buf, BufSize);
  end;
  BlockRead(SrcF, Buf, _Last_BufEntry_Size, BufSize);
  BlockWrite(DestF, Buf, BufSize);
end;

function TSCNFEditor.GetTempFileName: TFileName;

  function GetTempDir : string;
  var
    Dir: array[0..MAX_PATH] of Char;

  begin
    Result := '';
    if GetTempPath(SizeOf(Dir), Dir) <> 0 then
      Result := IncludeTrailingPathDelimiter(StrPas(Dir));
  end;

begin
  Result := GetTempDir + IntToHex(Random($FFFFFFF), 8) + '.SiZ';
end;

function TSCNFEditor.IsValidScnfFooterEntry(var F: file;
  Section: TSectionItem): Boolean;
var
  SectionName: array[0..3] of Char;
  SavedPosition: Int64;

begin
  Result := False;
  SavedPosition := FilePos(F);

  // Verifing if the section is valid
  if Section.Name = SCNF_FOOTER_SIGN then begin
    Seek(F, Section.Offset + 16); // 16 for PAKS header size
    BlockRead(F, SectionName[0], SizeOf(SectionName));
    Result := SectionName = SCNF_SIGN;     
  end;

  Seek(F, SavedPosition);
end;


procedure TSCNFEditor.WriteSectionPadding(var F: file; DataSize: Integer);
var
  Padding: Integer;
  Buffer: array[0..31] of Char;

begin
  Padding := null_bytes_length(DataSize);
  ZeroMemory(@Buffer, Padding);
  BlockWrite(F, Buffer, Padding);
end;

procedure TSCNFEditor.Save;
begin
  if FileLoaded then
    SaveToFile(GetLoadedFileName)
{$IFDEF DEBUG}
  else
    if DebugSaveToFile then
      WriteLn('Save: File NOT loaded!')
{$ENDIF}
    ;
end;

procedure TSCNFEditor.SaveToFile(const FileName: TFileName);
var
  F_src, F_dest: file;
  TempFile: TFileName;
  i, NewPos, NewSize, NewIpacSize, Padding: Integer;

begin
//  PatchValues; // patching offset values

  // Opening source file
  AssignFile(F_src, GetLoadedFileName());
  FileMode := fmOpenRead;
  {$I-}Reset(F_src, 1);{$I+}
  if IOResult <> 0 then Exit;

  // Opening target file
  TempFile := GetTempFileName;
  AssignFile(F_dest, TempFile);
  FileMode := fmOpenWrite;
  ReWrite(F_dest, 1);

  // ---------------------------------------------------------------------------
  // STARTING WRITING NEW PKS FILE !
  // ---------------------------------------------------------------------------

  // Init new IPAC section size
  NewIpacSize := 0;

  // Writing PAKS header
//  BlockWrite(F_dest, fPaksHeaderSectionDump, SizeOf(fPaksHeaderSectionDump));

  // Writing IPAC header (but it must be updated with fTotalPatchValue !)
//  BlockWrite(F_dest, fIpacHeaderSectionDump, SizeOf(fIpacHeaderSectionDump));

  // Writing IPAC sections
  for i := 0 to Sections.Count - 1 do begin

    // Keep the offset to update the footer value
    NewPos := FilePos(F_dest);

    // This is a SCNF section to be patched
//    if Sections[i].SubtitlesTable then begin

      // Write SCNF & CharID section header
      // + 16 for PAKS header
      CopyFileBlock(F_src, F_dest, Sections[i].Offset + 16, fScnfCharIdHeaderSize);
{$IFDEF DEBUG}
  if DebugSaveToFile then  
      WriteLn('Writing SCNF and CharID sections header offset: ', 
        Sections[i].Offset + 16, ', size: ', fScnfCharIdHeaderSize
      );
{$ENDIF}

      // Writing modified subtitles table
      Subtitles.WriteSubtitlesTable(F_dest);

      // Updating sections size
      NewSize := (FilePos(F_dest) - NewPos);

      // Writing padding of the CharID section (special padding...)
      Padding := 0;
      while (NewSize mod 4 <> 0) do begin
        BlockWrite(F_dest, Padding, 1);
        Inc(NewSize);
      end;

      // Writing the info in the SCNF header
      Sections[i].fSize := NewSize; // updating SCNF section size
      Seek(F_dest, NewPos + 4);
      BlockWrite(F_dest, NewSize, GAME_INTEGER_SIZE);

      // Writing in the CharID header
      Seek(F_dest, NewPos + 20);
      Dec(NewSize, 16);
      BlockWrite(F_dest, NewSize, GAME_INTEGER_SIZE);

      Seek(F_dest, FileSize(F_dest)); // reseeking to the original pos.

//    end else begin

    // Write normally a section
    // Writing the section from source to dest file
//    CopyFileBlock(F_src, F_dest, Sections[i].Offset + 16, Sections[i].Size);
//  end;

   // Writing padding if needed
//   if GameVersion <> gvWhatsShenmue then // FIX 3.1.1: only if game different than What's Shenmue
//    WriteSectionPadding(F_dest, Sections[i].Size);

   // Updating footer value
   Sections[i].fOffset := NewPos - 16; // - 16 for PAKS header
  end;

  NewIpacSize := FileSize(F_dest) - 16; // - 16 for PAKS header

  // All sections were written. Writing (updated!) footer now
  for i := 0 to Sections.Count - 1 do begin
    Sections[i].WriteFooterEntry(F_dest);
  end;

  // updating IPAC section size with new size value
  Seek(F_dest, 20);
  BlockWrite(F_dest, NewIpacSize, GAME_INTEGER_SIZE);
  Seek(F_dest, 28);
  BlockWrite(F_dest, NewIpacSize, GAME_INTEGER_SIZE);

  // Closing files
  CloseFile(F_src);
  CloseFile(F_dest);

  // Making backup if necessary
  if FileExists(FileName) then
    if MakeBackup then begin
      RenameFile(FileName, FileName + '.bak');
    end else
      DeleteFile(FileName);

  // Replacing old file by new one
  CopyFile(PChar(TempFile), PChar(FileName), False);

  // If target file (FileName) is different of source file (GetTempFileName)
  // we must reload the original source file (because every values has been modified).
  // ** FIX 3.2.2: NO. We must to keep the editor as it. If the user wants to
  // get the original filename he must RELOAD the file.
(*  if UpperCase(FileName) <> UpperCase(GetLoadedFileName) then
    LoadFromFile(GetLoadedFileName); *)

  // Deleting temp file
  try
    DeleteFile(TempFile);
  except
  end;
end;

//------------------------------------------------------------------------------

{ TSectionsList }

function TSectionsList.Add(SectionEntry: TSectionRawBinaryEntry): Integer;
var
  Item: TSectionItem;

begin
  Item := TSectionItem.Create(Self);
  Item.fCharID := SectionEntry.CharID;
  Item.fUnknowValue := SectionEntry.UnknowValue;
  Item.fName := SectionEntry.Name;
  Item.fOffset := SectionEntry.Offset;
  Item.fSize := SectionEntry.Size;
  Result := fList.Add(Item);
end;

procedure TSectionsList.Clear;
var
  i: Integer;

begin
  for i := 0 to Self.fList.Count - 1 do
    TSectionItem(Self.fList[i]).Free;
  fList.Clear;
end;

constructor TSectionsList.Create(Owner: TSCNFEditor);
begin
  Self.fOwner := Owner;
  Self.fList := TList.Create;
end;

destructor TSectionsList.Destroy;
begin
  Self.Clear;
  fList.Free;
  
  inherited;
end;

function TSectionsList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TSectionsList.GetItem(Index: Integer): TSectionItem;
begin
  Result := TSectionItem(Self.fList[Index]);
end;

{ TSectionItem }

constructor TSectionItem.Create(Owner: TSectionsList);
begin
  Self.fOwner := Owner;
end;

function TSectionItem.GetCharID: string;
var
  Buf: array[0..3] of Char;
  
begin
{  if (Editor.GameVersion = gvShenmue2) or (Editor.GameVersion = gvShenmue2X) then
    (*  In Shenmue II, the CharID field is 4 bytes length, and the Unknow field
        is 4 bytes too *)
    Result := fCharID
  else begin
    (*  In earlier versions, the CharID field is 8 bytes length. For
        compatibility purpose, the UnknowValue is still used, but if the
        end-user ask for the Name field he will get the full 8 bytes length, but
        in fact the field is splitted in two 4 bytes fields (CharID &
        UnknowValue). *)
    IntegerToArray(Buf, UnknowValue);
    Result := fCharID + string(Buf);
  end;}
end;

function TSectionItem.GetEditor: TSCNFEditor;
begin
  Result := Owner.Owner;
end;

procedure TSectionItem.WriteFooterEntry(var F: file);
var
  Raw: TSectionRawBinaryEntry;

begin
  StrCopy(Raw.CharID, PChar(CharID));
  Raw.UnknowValue := UnknowValue;
  StrCopy(Raw.Name, PChar(Name));
  Raw.Offset := Offset;
  Raw.Size := Size;
  BlockWrite(F, Raw, SizeOf(Raw));
end;

{ TCharsDecodeTable }

function TSCNFCharsDecodeTable.Add(CharID: string): Integer;
var
  Item: TSCNFCharsDecodeTableItem;

begin
  Item := TSCNFCharsDecodeTableItem.Create(Self);
  Item.fCharID := CharID;
  Result := fList.Add(Item);
  Item.fCode := Chr(Ord('A') + Result);
end;

procedure TSCNFCharsDecodeTable.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TSCNFCharsDecodeTableItem(fList[i]).Free;
  fList.Clear;
end;

constructor TSCNFCharsDecodeTable.Create(Owner: TSubList);
begin
  fList := TList.Create;
  fOwner := Owner;
end;

destructor TSCNFCharsDecodeTable.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TSCNFCharsDecodeTable.GetCharIdFromCode(const Code: Char): string;
var
  i: Integer;

begin
  Result := '';
  for i := 0 to Count - 1 do
    if Items[i].Code = UpCase(Code) then begin
      Result := Items[i].CharID;
      Break;
    end;
end;

function TSCNFCharsDecodeTable.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TSCNFCharsDecodeTable.GetItem(Index: Integer): TSCNFCharsDecodeTableItem;
begin
  Result := TSCNFCharsDecodeTableItem(fList.Items[Index]);
end;

{ TCharsDecodeTableItem }

constructor TSCNFCharsDecodeTableItem.Create(Owner: TSCNFCharsDecodeTable);
begin
  fOwner := Owner;
end;

//------------------------------------------------------------------------------
// TSubEntry
//------------------------------------------------------------------------------

procedure TSubList.AddEntry(SubEntry: TSubRawBinaryEntry);
var
  Item: TSubEntry;
{$IFDEF USE_DCL}
  Index: Integer;
  HashItem: TSCNFEditorIndexHashItem;
{$ENDIF}

begin
  Item := TSubEntry.Create(Self);
  Item.fIndex := fList.Count;

  // Values read in the Subtitle Header Table
  Item.fSubTextOffset := SubEntry.SubTextOffset;      // offset of the text subtitle
  Item.fSubCodeOffset := SubEntry.SubCodeOffset;      // offset of the subtitle code before text subtitle (like "F2468A001"...)
  Item.fCode := SubEntry.SubCode;                     // subtitle code
  Item.fUnknowValue := SubEntry.UnknowCrap;           // dunno what's it... may be it's a time flag or other...

  // Values read in the Subtitle Body Table
  Item.fText := '';                                   // subtitle text: not yet (read after adding this entry)
  Item.fVoiceID := '';                                // subtitle VoiceID

  // Values computed
  Item.fCharID := CharsIdDecodeTable.GetCharIdFromCode(Item.Code[1]);

{$IFDEF USE_DCL}
  Index := fList.Add(Item);

  // Adding in the HashMap
  HashItem := TSCNFEditorIndexHashItem.Create;
  HashItem.SubCode := Item.Code;
  HashItem.ItemIndex := Index;
  
  fOptimizationHashMap.PutValue(Item.Code, HashItem);
{$ELSE}
  // Adding normal
  fList.Add(Item);
{$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TSubList.Clear;
var
  i: Integer;

begin
  for i := 0 to fList.Count - 1 do
    TSubEntry(fList[i]).Free;
  fList.Clear;
  CharsIdDecodeTable.Clear;
{$IFDEF USE_DCL}
  fOptimizationHashMap.Clear;
{$ENDIF}
end;

//------------------------------------------------------------------------------

constructor TSubList.Create(Owner: TSCNFEditor);
begin
  fList := TList.Create;
  Self.fOwner := Owner;
  Self.fCharsDecodeTable := TSCNFCharsDecodeTable.Create(Self);
{$IFDEF USE_DCL}
  fOptimizationHashMap := TStrHashMap.Create;
{$ENDIF}
end;

//------------------------------------------------------------------------------

destructor TSubList.Destroy;
begin
  fCharsDecodeTable.Free;
  Clear;
  fList.Free;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TSubList.AddXMLNode(var XMLDoc: IXMLDocument;
  const Key, Value: string);
var
  CurrentNode: IXMLNode;

begin
  CurrentNode := XMLDoc.CreateNode(Key);
  CurrentNode.NodeValue := Value;
  XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
end;

//------------------------------------------------------------------------------

procedure TSubList.AddXMLNode(var XMLDoc: IXMLDocument; const Key: string;
  const Value: Integer);
begin
  AddXMLNode(XMLDoc, Key, IntToStr(Value));
end;

//------------------------------------------------------------------------------

function TSubList.ExportToFile(const FileName: TFileName): Boolean;
var
  XMLDoc: IXMLDocument;
  i: Integer;
  CurrentNode, SubCurrentNode: IXMLNode;
  IsJapanese: Boolean;

begin
  Result := False;
  XMLDoc := TXMLDocument.Create(nil);
  try
    try
      with XMLDoc do begin
        Options := [doNodeAutoCreate, doAttrNull];
        Active := True;
        Version := '1.0';
        Encoding := 'ISO-8859-1';
        ParseOptions := [poPreserveWhiteSpace]; // fix 3.4.0
      end;

      // Creating the root
      XMLDoc.DocumentElement := XMLDoc.CreateNode('freequestexport'); // old: s2freequestsubs

      // File
      AddXMLNode(XMLDoc, 'filename', ExtractFileName(Owner.fSourceFileName));

      // Game version
      (*case Owner.GameVersion of
        gvWhatsShenmue: AddXMLNode(XMLDoc, 'gameversion', 'WSM_JAP_DC');
        gvShenmueJ    : AddXMLNode(XMLDoc, 'gameversion', 'SM1_JAP_DC');
        gvShenmue     : AddXMLNode(XMLDoc, 'gameversion', 'SM1_PAL_DC');
        gvShenmue2J   : AddXMLNode(XMLDoc, 'gameversion', 'SM2_JAP_DC');
        gvShenmue2    : AddXMLNode(XMLDoc, 'gameversion', 'SM2_PAL_DC');
        gvShenmue2X   : AddXMLNode(XMLDoc, 'gameversion', 'SM2_PAL_XB');
      end;*)

      // CharID
      AddXMLNode(XMLDoc, 'charid', Owner.fCharacterID);

      // VoiceID
      AddXMLNode(XMLDoc, 'voiceid', Owner.fVoiceFullID);

      // Short VoiceID
      AddXMLNode(XMLDoc, 'shortvoiceid', Owner.fVoiceShortID);

      // Subtitles
      CurrentNode := XMLDoc.CreateNode('subtitles');
      XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
      CurrentNode.Attributes['count'] := Count;
      for i := 0 to Count - 1 do begin
        SubCurrentNode := XMLDoc.CreateNode('subtitle');
        SubCurrentNode.Attributes['code'] := Items[i].fCode;
        SubCurrentNode.NodeValue := Items[i].RawText; // don't use the Text property directly
        CurrentNode.ChildNodes.Add(SubCurrentNode);
      end;

      XMLDoc.SaveToFile(FileName);



        
      Result := FileExists(FileName);
    except
      on E:Exception do
      {$IFDEF DEBUG}
        WriteLn('ExportToFile: Exception - ', E.Message);
      {$ENDIF}
    end;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

//------------------------------------------------------------------------------

function TSubList.FindSubtitleByCode(const Code: string): TSubEntry;
var
  i: Integer;

begin
  Result := nil;
  
  i := IndexOfSubtitleByCode(Code);
  if i <> -1 then
    Result := Items[i];
end;

//------------------------------------------------------------------------------

function TSubList.IndexOfSubtitleByCode(const Code: string): Integer;
var
{$IFDEF USE_DCL}
  HashIndex: TSCNFEditorIndexHashItem;
{$ELSE}
  Found: Boolean;
{$ENDIF}

begin
  Result := -1;
  if Count = 0 then Exit;

{$IFDEF USE_DCL}

  HashIndex := TSCNFEditorIndexHashItem(fOptimizationHashMap.GetValue(Code));
  if Assigned(HashIndex) then
    Result := HashIndex.ItemIndex;

{$ELSE}

  Found := False;
    
  while ((not Found) and (Result < Count)) do begin
    Inc(Result);
    Found := SameText(Items[Result].Code, Code);
//    WriteLn(Items[Result].Code, ' -- ', Result, ' -- ', Code, ' -- ', Found);
  end;
  if Result = Count then Result := -1;

{$ENDIF}
end;

//------------------------------------------------------------------------------

function TSubList.GetCount: Integer;
begin
  Result := fList.Count;
end;

//------------------------------------------------------------------------------

function TSubList.GetItem(Index: Integer): TSubEntry;
begin
  Result := TSubEntry(fList[Index]);  
end;

//------------------------------------------------------------------------------

function TSubList.ImportFromFile(const FileName: TFileName): Boolean;
var
  XMLDoc: IXMLDocument;
  i: Integer;
  CurrentNode, LoopNode: IXMLNode;
  S, xmlSubCode, xmlSubtitle, xmlCharID, xmlVoiceID, xmlShortVoiceID: string;
  CurrentSub: TSubEntry;
  CharsListActive: Boolean;
  IsJapanese: Boolean;
  
begin
  Result := False;
  if not FileExists(FileName) then Exit;

  XMLDoc := TXMLDocument.Create(nil);
  try
    with XMLDoc do begin
      Options := [doNodeAutoCreate];
      ParseOptions:= [poPreserveWhiteSpace]; // Fix 3.4.0
      Active := True;
      Version := '1.0';
      Encoding := 'ISO-8859-1';
    end;

    XMLDoc.LoadFromFile(FileName);

    // Verifying if it's a valid XML to import
    S := XMLDoc.DocumentElement.NodeName;
    if (S <> 's2freequestsubs') and (S <> 'freequestexport') then Exit;

    // File name
    CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('filename');

    // Game version
    {CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('gameversion');
    if CurrentNode.NodeValue = 'dc' then
    Self.fGameVersion := CurrentNode.NodeValue;}

    // CharID
    CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('charid');
    xmlCharID := CurrentNode.NodeValue;

    // VoiceID
    CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('voiceid');
    xmlVoiceID := CurrentNode.NodeValue;

    // Short VoiceID
    CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('shortvoiceid');
    xmlShortVoiceID := CurrentNode.NodeValue;

    if Trim(xmlCharID) <> Trim(Owner.fCharacterID) then begin
      Exit;
    end
{    else if Trim(xmlVoiceID) <> Trim(Owner.fVoiceFullID) then begin
      Exit;
    end   }
    else if Trim(xmlShortVoiceID) <> Trim(Owner.fVoiceShortID) then begin
      Exit;
    end;

    // Disabling CharsList...
//    CharsListActive := Owner.CharsList.Active;
//    Owner.CharsList.Active := False;
    
    // Subtitles
    CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('subtitles');
    if CurrentNode.Attributes['count'] <> Count then begin
      {$IFDEF DEBUG} WriteLn('XML Subs Count <> File Subs Count...'); {$ENDIF}
      Exit;
    end;

    for i := 0 to CurrentNode.Attributes['count'] - 1 do
    begin
      LoopNode := CurrentNode.ChildNodes.Nodes[i];
      if Assigned(LoopNode) then
      begin
        try
          xmlSubCode := LoopNode.Attributes['code'];
        except
          xmlSubCode := '';
        end;
        try
          xmlSubtitle := '';
          if not VarIsNull(LoopNode.NodeValue) then
            xmlSubtitle := LoopNode.NodeValue;
        except
          xmlSubtitle := '';
        end;
        
        CurrentSub := Items[i];
        CurrentSub.fCode := xmlSubCode;
        CurrentSub.Text := xmlSubtitle;
      end;
    end;

    Result := True;
//    Owner.CharsList.Active := CharsListActive;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

procedure TSubList.WriteSubtitlesTable(var F: file);
var
  TempSubsStrFile: TFileName;
  i, ScnfBodyRelativeOffset, NewCodeOffset: Integer;
  F_sub: file;
  _null: Char;
  
begin
  // Creating temporary file to write subtitles text (this to optimize the double for-loop...)
  TempSubsStrFile := Owner.GetTempFileName;
  AssignFile(F_sub, TempSubsStrFile);
  FileMode := fmOpenWrite;
  {$I-}ReWrite(F_sub, 1);{$I+}
  if IOResult <> 0 then Exit;

  // This is the offset where will be stored the subs table (-16 for PAKS header)
  // This value is "relative" to CharID header and will be put in the subtitle
  // table header. It will be read by the game.
  ScnfBodyRelativeOffset := Owner.fScnfCharIdHeaderSize
    + (Owner.fScnfStrTableBodyOffset - Owner.fScnfStrTableHeaderOffset) - 16;
                  
  // Getting all subtitles from this PAKS file...
  _null := #$00;
  for i := 0 to Count - 1 do begin
    // Writing VoiceID subtitle
    NewCodeOffset := ScnfBodyRelativeOffset + FilePos(F_sub);
    BlockWrite(F_sub, Pointer(Items[i].VoiceID)^, Length(Items[i].VoiceID));
    BlockWrite(F_sub, _null, 1);

    // Writing subtitle text to a temp file to be merged after...
    Items[i].fSubTextOffset := ScnfBodyRelativeOffset + FilePos(F_sub);
    Items[i].fSubCodeOffset := NewCodeOffset; // updating values ...
    Items[i].WriteTextEntry(F_sub);

    // Writing subtitle header table directly to the dest file
    Items[i].WriteHeaderEntry(F);
  end;

  // Writing subtitles string table to the final dest file
  Self.fOwner.CopyFileBlock(F_sub, F, 0, FileSize(F_sub));

  CloseFile(F_sub);

  // Delete the temporary string table file
  try
    DeleteFile(TempSubsStrFile);
  except // ignore if failed to delete temp file...
  end;
end;

//==============================================================================
// TSubEntry
//==============================================================================

constructor TSubEntry.Create(Owner: TSubList);
begin
  fOwner := Owner;
  fEditorOwner := Owner.Owner;
//  fPatchValue := 0;
end;
             
//------------------------------------------------------------------------------

// METHODE A AMELIORER SANS DOUTE...
procedure TSubEntry.FillSubtitleTextFromRaw(var RawSubtitleText: array of Char);
var
  StartTextPos, EndTextPos: Integer;
  StartBufSize: Integer;

begin
  StartTextPos := Pos(TABLE_STR_ENTRY_BEGIN, RawSubtitleText); // 2 for chars code
  Self.fText := Copy(RawSubtitleText, StartTextPos + 2, Length(RawSubtitleText));
  EndTextPos := Pos(TABLE_STR_ENTRY_END, Self.fText); // -1 for chars code
  Self.fText := Copy(Self.fText, 1, EndTextPos - 1);
//  fOriginalTextLength := Length(fText); // to calculate PatchValue

  fStartSubtitleEntry := Copy(RawSubtitleText, 1, StartTextPos - 1);
  StartBufSize := Length(fStartSubtitleEntry);
  fStartSubtitleEntryLength := StartBufSize;

  // WriteLn(fStartSubtitleEntry, ' ', fStartSubtitleEntryLength);
  // WriteLn('RawSubtitleText: ', RawSubtitleText, ', StartTextPos: ', StartTextPos, ', EndTextPos: ', EndTextPos);
end;

function TSubEntry.GetText: string;
begin
  // Using CharsList to decode subtitle
//  Result := EditorOwner.CharsList.DecodeSubtitle(fText);
end;

function TSubEntry.IsTextEquals(const CompareText: string): Boolean;
var
  CText: string;

begin
//  CText := EditorOwner.CharsList.EncodeSubtitle(CompareText);
  Result := SameText(RawText, CText);
end;

procedure TSubEntry.SetText(const Value: string);
begin
//  if fText <> Value then // begin
//    fText := EditorOwner.CharsList.EncodeSubtitle(Value); // using charlist to encode subtitle
end;

procedure TSubEntry.WriteHeaderEntry(var F: file);
var
  SubEntry: TSubRawBinaryEntry;
  
begin
  // retrieving subtitle header entry
  SubEntry.SubTextOffset := fSubTextOffset;
  SubEntry.SubCodeOffset := fSubCodeOffset;
  StrCopy(SubEntry.SubCode, PChar(Code));
  SubEntry.UnknowCrap := fUnknowValue;
  BlockWrite(F, SubEntry, SizeOf(SubEntry));
end;

procedure TSubEntry.WriteTextEntry(var F: file);
const
  TABLE_SUB_START_TAG: string = #$A1#$D6;
  TABLE_SUB_END_TAG: string = #$A1#$D7#$00;   // end string

var
  _tmp: string;
//  _null: Char;

begin
  // Writing VoiceID
(*  BlockWrite(F, Pointer(VoiceID)^, Length(VoiceID));
  _null := #$00;
  BlockWrite(F, _null, 1); *)

  // Writing code and string init chars
  BlockWrite(F, Pointer(fStartSubtitleEntry)^, Length(fStartSubtitleEntry));

  // Modifying subtitle text
  // Encode subtitle with CharsList
//  _tmp := TABLE_SUB_START_TAG + Owner.Owner.CharsList.EncodeSubtitle(Text) + TABLE_SUB_END_TAG;
  //_tmp := TABLE_SUB_START_TAG + Text + TABLE_SUB_END_TAG;

  // Writing subtitle text imself
  BlockWrite(F, Pointer(_tmp)^, Length(_tmp));
end;

//==============================================================================

initialization
  Randomize;

//==============================================================================

end.
