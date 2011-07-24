unit SNCFEdit;

interface

uses
  Windows, SysUtils, Classes;

type
  { Game Version }
  TGameVersion = (
    gvUndef,          // (Undefined)
    gvWhatsShenmue,   // What's Shenmue [Demo] (NTSC-J) (DC)
    gvShenmueJ,       // Shenmue I (NTSC-J) (DC)
    gvShenmue,        // Shenmue I (PAL) (NTSC-U) (DC) / US Shenmue (NTSC-J) (DC)
    gvShenmue2J,      // Shenmue II (NTSC-J) (DC)
    gvShenmue2,       // Shenmue II (PAL) (DC)
    gvShenmue2X       // Shenmue II (PAL) (XBOX)
  );

  { General "SCNF" section header }
  TSceneFileHeader = record
    Magic: array[0..3] of Char;       // "SCNF"
    Size: LongWord;                   // SCNF section size
    SectionCount: LongWord;           // Number of subtitles section
    Unknow: LongWord;                 // Seems to be always the same value (kind of version ?)
  end;

  { "SCNF" inlay section header
    See "TSceneFileHeader.SectionCount" to get how many
    TSectionHeaderRawBinaryEntry you can find in this SCNF package }
  TSceneSectionHeader = record
    Name: array[0..3] of Char;        // The section Magic signature, usually a CharID
    Size: LongWord;                   // Section size
    CharIDCount: LongWord;            // Number of CharID codes ("A" = "AKIR" or "RYO_" (player), "B" = whatever...)
    Crap1: LongWord;                  // Seems to be 4 bytes always at 0x0
    VoiceIDOffset: LongWord;          // Offset to "/p38/prj38sc/.../<CharID>"
    UnknowDataTableOffset: LongWord;  // Offset to an unknow data table
    SubsTableHeaderOffset: LongWord;  // Offset to the subtitles table header
    Crap2: LongWord;                  // Unknow crap
    CharIDTableOffset: LongWord;      // Characters ID table ["AKIR", "DOOR"]...
    Padding: array[0..27] of Byte;    // 28 bytes of pad    
  end;

  { Structure to read subtitle entry from header table }
  TSubtitleHeaderEntry = record
    SubTextOffset: LongWord;             // Offset of the subtitle itself
    SubCodeOffset: LongWord;             // Offset to the VoiceID associated to the subtitle
    SubCode: array[0..3] of Char;       // Subtitle code (eg "A001")
    UnknowCrap: Integer;                // Unknow crap that we don't care about
  end;

  TSCNFEditor = class;

  TCharactersTable = class;

  TSubtitlesList = class;

  // contains a sub entry
  TSubtitlesListItem = class(TObject)
  private
    fEditorOwner: TSCNFEditor;
    fOwner: TSubtitlesList;

    fStartSubtitleEntry: string;                  // string before each subtitle text

    fSubTextOffset: Integer;
    fSubCodeOffset: Integer;
    fUnknowValue: LongWord;

    fCode: string;
    fText: string;
    fCharID: string;
    fVoiceID: string;

    function GetText: string;
    procedure SetText(const Value: string);
    function GetPhysicalText: string;
  protected
    procedure AbsoluteSeek(F: TFileStream; RelativeOffset: LongWord);
    procedure DoParse(F: TFileStream);
    property PhysicalText: string read GetPhysicalText; // to be written in the file
  public
    constructor Create(Owner: TSubtitlesList);
    property CharID: string read fCharID;
    property Code: string read fCode;
    property CodeOffset: Integer read fSubCodeOffset;
    property EditorOwner: TSCNFEditor read fEditorOwner;
    property Owner: TSubtitlesList read fOwner;
    property RawText: string read fText;
    property Text: string read GetText write SetText;
    property TextOffset: Integer read fSubTextOffset;
    property UnknowValue: LongWord read fUnknowValue;
    property VoiceID: string read fVoiceID;
  end;

  // contains all subtitles
  TSceneSectionItem = class;
  TSubtitlesList = class(TObject)
  private
    fOwner: TSceneSectionItem;
    fList: TList;
    function GetItem(Index: Integer): TSubtitlesListItem;
    function GetCount: Integer;
  protected
    function Add(F: TFileStream;
      Entry: TSubtitleHeaderEntry): TSubtitlesListItem;
    procedure Clear;
  public
    constructor Create(AOwner: TSceneSectionItem);
    destructor Destroy; override;
    function ExportToFile(const FileName: TFileName): Boolean;
    function ImportFromFile(const FileName: TFileName): Boolean;
//    function IndexOfSubtitleByCode(const Code: string): Integer;
//    function FindSubtitleByCode(const Code: string): TSubtitlesListItem;
    property Items[Index: Integer]: TSubtitlesListItem read GetItem; default;
    property Count: Integer read GetCount;
    property Owner: TSceneSectionItem read fOwner;
  end;
    
  // Enable to translate letters "A", "B" to "RYO_", ...
  TCharactersTableItem = class(TObject)
  private
    fCode: Char;
    fCharID: string;
  public
    property CharID: string read fCharID;
    property Code: Char read fCode;
  end;

  // container of TCharactersTableItem
  TCharactersTable = class(TObject)
  private
    fOwner: TSceneSectionItem;
    fList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TCharactersTableItem;
  protected
    function Add(CharID: string): Integer;
    procedure Clear;
  public
    constructor Create(AOwner: TSceneSectionItem);
    destructor Destroy; override;
    function GetCharIDByCode(const Code: Char): string;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TCharactersTableItem read GetItem; default;
    property Owner: TSceneSectionItem read fOwner;
  end;
  
  TSceneSectionsList = class;

  TUnknowDataTable = array of Byte;
  TSceneSectionItem = class(TObject)
  private
    fOwner: TSceneSectionsList;
    fRawEntry: TSceneSectionHeader;
    fSubtitles: TSubtitlesList;
    fOffset: LongWord;
    fVoiceID: string;
    fVoicePath: string;
    fCharactersTable: TCharactersTable;
    fUnknowDataTable: TUnknowDataTable;
    fVoicePathPadding: LongWord;
    fGameVersion: TGameVersion;
    function GetCharID: string;
    function GetEditor: TSCNFEditor;
    function GetSize: Integer;
  protected
    procedure AbsoluteSeek(F: TFileStream; RelativeOffset: LongWord);
    procedure DoParse(F: TFileStream);
    function Write(F: TFileStream): LongWord;
    property RawEntry: TSceneSectionHeader read fRawEntry;
    property UnknowDataTable: TUnknowDataTable read fUnknowDataTable;
  public
    constructor Create(AOwner: TSceneSectionsList);
    destructor Destroy; override;
    property CharID: string read GetCharID; // section name id
    property GameVersion: TGameVersion read fGameVersion;
    property Editor: TSCNFEditor read GetEditor;
    property Offset: LongWord read fOffset;
    property Size: Integer read GetSize;
    property CharactersTable: TCharactersTable read fCharactersTable;
    property Subtitles: TSubtitlesList read fSubtitles;
    property Owner: TSceneSectionsList read fOwner;
    property VoiceID: string read fVoiceID;
    property VoicePath: string read fVoicePath;
    property VoicePathPadding: LongWord read fVoicePathPadding;
  end;

  // SCNF sections
  TSceneSectionsList = class(TObject)
  private
    fOwner: TSCNFEditor;
    fList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSceneSectionItem;
  protected
    function Add(F: TFileStream; SectionEntry: TSceneSectionHeader;
      AOffset: LongWord): Integer;
    procedure Clear;
  public
    constructor Create(Owner: TSCNFEditor);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSceneSectionItem read GetItem; default;
    property Owner: TSCNFEditor read fOwner;
  end;

  // Main class
  TSCNFEditor = class(TObject)
  private
    fSceneFileHeader: TSceneFileHeader;
    fSourceFileName: TFileName;
    fSectionsList: TSceneSectionsList;
    fLoaded: Boolean;
  protected
    property SceneFileHeader: TSceneFileHeader read fSceneFileHeader;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    function LoadFromFile(const FileName: TFileName): Boolean;
    procedure Save;
    procedure SaveToFile(const FileName: TFileName);

    property Loaded: Boolean read fLoaded;
    property Sections: TSceneSectionsList read fSectionsList;
    property SourceFileName: TFileName read fSourceFileName;
  end;

implementation

uses
  SysTools,
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants;

const
  TABLE_STR_ENTRY_BEGIN = #$A1#$D6; // start string
  TABLE_STR_ENTRY_END   = #$A1#$D7; // end string

// Get the game version
function GetGameVersion(VoicePath: string): TGameVersion;
type
  TVersionItem = record
    VoicePath: string;
    Version: TGameVersion;
  end;

const
  GAME_VERSIONS: array[0..5] of TVersionItem = (
    // What's Shenmue (DC) (NTSC-J)
    (
      VoicePath: '/prj16sc/MSG/voice/';
      Version: gvWhatsShenmue
    ),
    // Shenmue I (DC) (NTSC-J)
    (
      VoicePath: '/prj16sc2/MSG/voice/';
      Version: gvShenmueJ
    ),
    // Shenmue I (DC) (PAL) (NTSC-U) / US Shenmue (DC) (NTSC-J)
    (
      VoicePath: '/p38/prj38sc/Msg/voice/';
      Version: gvShenmue
    ),
    // Shenmue II (DC) (NTSC-J)
    (
      VoicePath: '/p39/prj39sc/Msg/voice/';
      Version: gvShenmue2J
    ),
    // Shenmue II (DC) (PAL)
    (
      VoicePath: '/p48/prj48sc/Voice/';
      Version: gvShenmue2
    ),
    // Shenmue II (XBOX) (PAL)
    (
      VoicePath: '/usr1/people/muramatsu/yoshizawa/humans/data/voice/';
      Version: gvShenmue2X
    )
  );

var
  i: Integer;

begin
  Result := gvUndef;
  for i := Low(GAME_VERSIONS) to High(GAME_VERSIONS) do
    if IsInString(GAME_VERSIONS[i].VoicePath, VoicePath) then begin
      Result := GAME_VERSIONS[i].Version;
      Break;
    end;
end;

//------------------------------------------------------------------------------
// TSCNFEditor
//------------------------------------------------------------------------------

procedure TSCNFEditor.Clear;
begin
  fLoaded := False;
  fSourceFileName := '';
  Sections.Clear;
end;

constructor TSCNFEditor.Create;
begin
  fLoaded := False;
  fSourceFileName := '';
  fSectionsList := TSceneSectionsList.Create(Self);
end;

destructor TSCNFEditor.Destroy;
begin
  fSectionsList.Free;
  inherited;
end;

function TSCNFEditor.LoadFromFile(const FileName: TFileName): Boolean;
var
  F: TFileStream;
  i: Integer;
  SectionHeader: TSceneSectionHeader;
  Offset: LongWord;

begin
{$IFDEF DEBUG}
  WriteLn('*** LOADING FILE ***', sLineBreak,
          sLineBreak,
          'FileName: "', FileName, '"');
{$ENDIF}

  // Open the target file
  F := TFileStream.Create(FileName, fmOpenRead);
  try
    try
      // Read SCNF header
      F.Read(fSceneFileHeader, SizeOf(TSceneFileHeader));
{$IFDEF DEBUG}
      WriteLn('SCNF Header Size: ', SceneFileHeader.Size, sLineBreak,
              'Sections Count: ', SceneFileHeader.SectionCount, sLineBreak,
              'Unknow Value: ', SceneFileHeader.Unknow);
{$ENDIF}

      // Parse each section in the SCNF file
{$IFDEF DEBUG}
      WriteLn('Listing SCNF Sections:');
{$ENDIF}
      for i := 0 to SceneFileHeader.SectionCount - 1 do begin
        Offset := F.Position;
        F.Read(SectionHeader, SizeOf(TSceneSectionHeader));
        Sections.Add(F, SectionHeader, Offset);
        F.Seek(Offset + SectionHeader.Size, soFromBeginning);
      end;

      // Storing useful properties...
      fLoaded := True;
      fSourceFileName := FileName;

      Result := Loaded;
    except
      on E:Exception do begin
{$IFDEF DEBUG}
        WriteLn('LoadFromFile.EXCEPTION : "', E.Message, '"');
{$ENDIF}
        Result := False;
      end;
    end;

  finally
    F.Free;
  end;
end;

procedure TSCNFEditor.Save;
begin
  SaveToFile(SourceFileName);
end;

procedure TSCNFEditor.SaveToFile(const FileName: TFileName);
var
  F: TFileStream;
  i: Integer;
  NewSize, CurrentSize: LongWord;

begin
{$IFDEF DEBUG}
  WriteLn('*** SAVING FILE ***', sLineBreak);
{$ENDIF}

  // Open the destination file
  F := TFileStream.Create(FileName, fmCreate);
  try
    // Reserving space for the header by writing the old one...
    F.Write(fSceneFileHeader, SizeOf(TSceneFileHeader));
    NewSize := SizeOf(TSceneFileHeader);

    // Writing each section in the SCNF file...
    for i := 0 to Sections.Count - 1 do begin
      CurrentSize := Sections[i].Write(F);
      Inc(NewSize, CurrentSize);
{$IFDEF DEBUG}
      WriteLn('SCNF Current Size: ', NewSize);
{$ENDIF}
    end;

    // Padding for 32 bytes
    WriteNullBlock(F, 32);

    // Updating SCNF section size
    F.Seek(4, soFromBeginning); // skipping 'SCNF' magic
    F.Write(NewSize, UINT32_SIZE); // writing section size

    // Done !
  finally
    F.Free;
  end;
end;

//------------------------------------------------------------------------------
// TSceneSectionsList
//------------------------------------------------------------------------------

function TSceneSectionsList.Add;
var
  Item: TSceneSectionItem;

begin
  // Creating object
  Item := TSceneSectionItem.Create(Self);

  // Initializing object
  Item.fRawEntry := SectionEntry;
  Item.fOffset := AOffset;

  // Adding the object to the list
  Result := fList.Add(Item);

{$IFDEF DEBUG}
  WriteLn('  #', Result, ': ', SectionEntry.Name);
{$ENDIF}

  // Parsing the section
  Item.DoParse(F);
end;

procedure TSceneSectionsList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TSceneSectionsList.Create(Owner: TSCNFEditor);
begin
  fList := TList.Create;
  fOwner := Owner;
end;

destructor TSceneSectionsList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TSceneSectionsList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TSceneSectionsList.GetItem(Index: Integer): TSceneSectionItem;
begin
  Result := TSceneSectionItem(fList[Index]);
end;

//------------------------------------------------------------------------------
// TSceneSectionItem
//------------------------------------------------------------------------------

procedure TSceneSectionItem.AbsoluteSeek;
var
  WorkingOffset: LongWord;

begin
  WorkingOffset := Offset + RelativeOffset;
  F.Seek(WorkingOffset, soFromBeginning);
end;

constructor TSceneSectionItem.Create(AOwner: TSceneSectionsList);
begin
  fGameVersion := gvUndef;
  fOwner := AOwner;
  fSubtitles := TSubtitlesList.Create(Self);
  fCharactersTable := TCharactersTable.Create(Self);
end;

destructor TSceneSectionItem.Destroy;
begin
//  Clear;
  fSubtitles.Free;
  fCharactersTable.Free;
  inherited;
end;

procedure TSceneSectionItem.DoParse(F: TFileStream);
var
  SavedOffset: LongWord;
  i, SubsCount: Integer;
  Buf: array[0..3] of Char;
  BufSize: LongWord;
  SubtitleEntry: TSubtitleHeaderEntry;

begin
  // Reading the full VoiceID
  AbsoluteSeek(F, RawEntry.VoiceIDOffset);
  fVoicePath := ReadNullTerminatedString(F);
  fVoiceID := ExtremeRight('/', fVoicePath);
{$IFDEF DEBUG}
  WriteLn('  VoiceID: "', fVoicePath, '"');
{$ENDIF}

  // Determinate if we must pad the VoiceID full string or not
  fVoicePathPadding := 0;
  BufSize := RawEntry.UnknowDataTableOffset - RawEntry.VoiceIDOffset - 1; // excepted VoiceID string length (-1 for $00 null terminated string)
  if LongWord(Length(VoicePath)) < BufSize then
    fVoicePathPadding := BufSize - LongWord(Length(VoicePath));
{$IFDEF DEBUG}
    WriteLn('  VoiceID padding: ', VoicePathPadding);
{$ENDIF}

  // Determinate the Game Version...
  fGameVersion := GetGameVersion(VoicePath);

  // Reading the CharID table
{$IFDEF DEBUG}
  WriteLn('  CharID table:');
{$ENDIF}
  AbsoluteSeek(F, RawEntry.CharIDTableOffset);
  for i := 0 to RawEntry.CharIDCount - 1 do begin
    F.Read(Buf, SizeOf(Buf));
    CharactersTable.Add(Buf);
  end;
                               
  // Reading the unknow data table before the subtitles header table
  BufSize := RawEntry.SubsTableHeaderOffset - RawEntry.UnknowDataTableOffset;
  AbsoluteSeek(F, RawEntry.UnknowDataTableOffset);
  SetLength(fUnknowDataTable, BufSize);
  F.Read(fUnknowDataTable[0], BufSize);

  // Reading the subtitles table
  AbsoluteSeek(F, RawEntry.SubsTableHeaderOffset);

  // Reading the first entry (will be added after in the for loop)
  F.Read(SubtitleEntry, SizeOf(TSubtitleHeaderEntry));

  // Calculating subtitles count
  SubsCount := (SubtitleEntry.SubCodeOffset - RawEntry.SubsTableHeaderOffset)
    div SizeOf(TSubtitleHeaderEntry);

  // Reading subtitles
{$IFDEF DEBUG}
  WriteLn('  Subtitles:');
{$ENDIF}
  for i := 0 to SubsCount - 1 do begin
    SavedOffset := F.Position;
    Subtitles.Add(F, SubtitleEntry);
    F.Seek(SavedOffset, soFromBeginning);
    F.Read(SubtitleEntry, SizeOf(TSubtitleHeaderEntry));
  end;

{$IFDEF DEBUG}
  WriteLn('Subtitles Count: ', Subtitles.Count, sLineBreak);
{$ENDIF}
end;

function TSceneSectionItem.GetCharID: string;
begin
  Result := RawEntry.Name;
end;

function TSceneSectionItem.GetEditor: TSCNFEditor;
begin
  Result := Owner.Owner;
end;

function TSceneSectionItem.GetSize: Integer;
begin
  Result := RawEntry.Size;
end;

function TSceneSectionItem.Write;
var
  SectionStartOffset, SubtitlesBodyOffset: LongWord;
  i: Integer;
  SubtitleHeader: TSubtitleHeaderEntry;

begin
  // Init section size
  Result := 0;
  
  // Updating the start position of the current section
  SectionStartOffset := F.Position;

  // Writing section header (reserving space)
  F.Write(fRawEntry, SizeOf(TSceneSectionHeader));

  // Writing CharID table
  for i := 0 to CharactersTable.Count - 1 do
    WriteNullTerminatedString(F, CharactersTable[i].CharID, False);

  // Writing VoiceID full string
  WriteNullTerminatedString(F, VoicePath);

  // Padding VoiceID full string if necessary
  if VoicePathPadding > 0 then  
    WriteNullBlock(F, VoicePathPadding);

  // Writing unknow data
  F.Write(fUnknowDataTable[0], Length(fUnknowDataTable));

  // Calculating the start offset of the subtitles text table
  SubtitlesBodyOffset := (F.Position - SectionStartOffset)
    + (Subtitles.Count * SizeOf(TSubtitleHeaderEntry));

  // Writing subtitles table...
  for i := 0 to Subtitles.Count - 1 do begin
    SubtitleHeader.SubCodeOffset := SubtitlesBodyOffset;
    SubtitleHeader.SubTextOffset := SubtitlesBodyOffset + LongWord(Length(Subtitles[i].VoiceID)) + 1; // 1 for $00
    StrCopy(SubtitleHeader.SubCode, PChar(Subtitles[i].Code));
    SubtitleHeader.UnknowCrap := Subtitles[i].UnknowValue;
    F.Write(SubtitleHeader, SizeOf(TSubtitleHeaderEntry));
    SubtitlesBodyOffset := SubtitlesBodyOffset + LongWord(Length(Subtitles[i].VoiceID) + Length(Subtitles[i].PhysicalText)) + 2;
{$IFDEF DEBUG}
  WriteLn('   ', SubtitleHeader.SubCode, ': ', Subtitles[i].PhysicalText);
{$ENDIF}
  end;

  // Writing the subtitles text...
  for i := 0 to Subtitles.Count - 1 do begin
    WriteNullTerminatedString(F, Subtitles[i].VoiceID);
    WriteNullTerminatedString(F, Subtitles[i].PhysicalText);
  end;

  // Calculating section size
  Result := F.Position - SectionStartOffset;
{$IFDEF DEBUG}
  WriteLn('Section Raw Size : ', Result);
{$ENDIF}

  // Writing section padding if needed
  Result := Result + WritePaddingSection(F, Result, pm4b);

{$IFDEF DEBUG}
  WriteLn('Section Real Size : ', Result);
{$ENDIF}

  // Updating section size in the section header
  F.Seek(SectionStartOffset + 4, soFromBeginning);
  F.Write(Result, UINT32_SIZE);
  F.Seek(SectionStartOffset + Result, soFromBeginning);
end;

//------------------------------------------------------------------------------
// TSCNFCharsDecodeTable
//------------------------------------------------------------------------------

function TCharactersTable.Add(CharID: string): Integer;
var
  Item: TCharactersTableItem;
  
begin
  Item := TCharactersTableItem.Create;
  Item.fCharID := CharID;
  Result := fList.Add(Item);
  Item.fCode := Chr(Ord('A') + Result);
{$IFDEF DEBUG}
  WriteLn('   ', Item.Code, ': ', Item.CharID);
{$ENDIF}
end;

procedure TCharactersTable.Clear;
var
  i: Integer;
  
begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TCharactersTable.Create;
begin
  fList := TList.Create;
  fOwner := AOwner;
end;

destructor TCharactersTable.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TCharactersTable.GetCharIDByCode(const Code: Char): string;
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

function TCharactersTable.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TCharactersTable.GetItem(
  Index: Integer): TCharactersTableItem;
begin
  Result := TCharactersTableItem(fList[Index]);
end;

//------------------------------------------------------------------------------
// TSubtitlesList
//------------------------------------------------------------------------------

function TSubtitlesList.Add;
begin
  Result := TSubtitlesListItem.Create(Self);

  // Filling object with the raw subtitle entry from the table header
  with Entry do begin
    Result.fSubTextOffset := SubTextOffset;
    Result.fSubCodeOffset := SubCodeOffset;
    Result.fCode := SubCode;
    Result.fCharID := Owner.CharactersTable.GetCharIDByCode(SubCode[0]);
    Result.fUnknowValue := UnknowCrap;
  end;

  // Reading subtitle info
  Result.DoParse(F);

  // Adding the item to the list
  fList.Add(Result);
end;

procedure TSubtitlesList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TSubtitlesList.Create;
begin
  fList := TList.Create;
  fOwner := AOwner;
end;

destructor TSubtitlesList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TSubtitlesList.ExportToFile(const FileName: TFileName): Boolean;
var
  XMLRoot: IXMLDocument;
  RootNode, Node: IXMLNode;
  i: Integer;

  function GetInputFileEncoding: string;
  begin
    Result := 'utf-8';
    (*if JapaneseCharset then
      Result := 'iso-8859-1';*)
  end;
  
begin
  XMLRoot := TXMLDocument.Create(nil);
  try
    with XMLRoot do begin
      Options := [doNodeAutoCreate, doAttrNull, doNodeAutoIndent];
      ParseOptions := [poPreserveWhiteSpace];
      Active := True;
      Version := '1.0';
      Encoding := GetInputFileEncoding;
    end;

    // Creating the root
    XMLRoot.DocumentElement := XMLRoot.CreateNode('systalk');

    // Original file name
    Node := XMLRoot.CreateNode('filecode');
    Node.NodeValue := Owner.CharID; // section id
    XMLRoot.DocumentElement.ChildNodes.Add(Node);

    Node := XMLRoot.CreateNode('gameversion');
    Node.NodeValue := Owner.GameVersion;
    XMLRoot.DocumentElement.ChildNodes.Add(Node);

    // Subtitle list
    RootNode := XMLRoot.CreateNode('subtitles');
    RootNode.Attributes['count'] := Count;
    XMLRoot.DocumentElement.ChildNodes.Add(RootNode);
    for i := 0 to Count - 1 do begin
      Node := XMLRoot.CreateNode('subtitle');
      with Items[i] do begin
        Node.Attributes['charid'] := CharID;
        Node.Attributes['code'] := Code;
        Node.NodeValue := RawText;
      end;
      RootNode.ChildNodes.Add(Node);
    end;

    // Saving the result
    XMLRoot.SaveToFile(FileName);
    Result := FileExists(FileName);

    // Changing the encoding...
    //SwitchJapaneseEncoding(FileName);
  finally
    // Destroying the XML file
    XMLRoot.Active := False;
    XMLRoot := nil;
  end;
end;

function TSubtitlesList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TSubtitlesList.GetItem(Index: Integer): TSubtitlesListItem;
begin
  Result := TSubtitlesListItem(fList[Index]);
end;

function TSubtitlesList.ImportFromFile(const FileName: TFileName): Boolean;
var
  XMLRoot: IXMLDocument;
  RootNode, Node: IXMLNode;
  i, j: Integer;
  ValidImportFile: Boolean;

  function GetInputFileEncoding: string;
  begin
    Result := 'utf-8';
    //if JapaneseCharset then
    //  Result := 'euc-jp';    
  end;

begin
  Result := False;
  if not FileExists(FileName) then Exit;

  // Loading the imported file
  XMLRoot := TXMLDocument.Create(nil);
  try
    try

      with XMLRoot do begin
        Options := [doNodeAutoCreate, doAttrNull, doNodeAutoIndent];
        ParseOptions := [poPreserveWhiteSpace];
        Active := True;
        Version := '1.0';
        Encoding := GetInputFileEncoding;
      end;

      // Loading the file
      XMLRoot.LoadFromFile(FileName);

      // Reading the root
      ValidImportFile := (XMLRoot.DocumentElement.NodeName = 'systalk');

      // Reading XML tree
      if ValidImportFile then begin
        // Subtitle list
        RootNode := XMLRoot.DocumentElement.ChildNodes.FindNode('subtitles');
        Result := RootNode.Attributes['count'] = Count; // Check count
        if Result then begin
          i := 0;
          j := 0;
          while j < Count do begin
            Node := RootNode.ChildNodes.Nodes[i];
            if VariantToString(Node.NodeName) = 'subtitle' then begin
              Owner.Subtitles[j].fText := VariantToString(Node.NodeValue);
              Inc(j);
            end;
            Inc(i);
          end; // while
        end; // Result
      end; // srfeditor

    except
{$IFDEF DEBUG}
      on E:Exception do
        WriteLn('ImportFromFile / Exception: ', E.Message);
{$ENDIF}
    end;

  finally
    // Destroying the XML file
    XMLRoot.Active := False;
    XMLRoot := nil;
  end;
end;

//------------------------------------------------------------------------------
// TSubItem
//------------------------------------------------------------------------------

procedure TSubtitlesListItem.AbsoluteSeek(F: TFileStream;
  RelativeOffset: LongWord);
var
  SectionOffset, WorkingOffset: LongWord;

begin
  SectionOffset := Owner.Owner.Offset;
  WorkingOffset := SectionOffset + RelativeOffset;
  F.Seek(WorkingOffset, soFromBeginning);
end;

constructor TSubtitlesListItem.Create;
begin
  fOwner := Owner;
end;

procedure TSubtitlesListItem.DoParse;
var
  RawSub: string;

begin
  // Reading Subtitle VoiceID
  AbsoluteSeek(F, CodeOffset);
  fVoiceID := ReadNullTerminatedString(F);

  // Reading the raw subtitle
  AbsoluteSeek(F, TextOffset);
  RawSub := ReadNullTerminatedString(F);

  fStartSubtitleEntry := Left(TABLE_STR_ENTRY_BEGIN, RawSub);
  fText := ExtractStr(TABLE_STR_ENTRY_BEGIN, TABLE_STR_ENTRY_END, RawSub);

{$IFDEF DEBUG}
  WriteLn('   ', Code, ': ', Text);
{$ENDIF}
end;

function TSubtitlesListItem.GetPhysicalText: string;
begin
  Result := fStartSubtitleEntry + TABLE_STR_ENTRY_BEGIN + RawText + TABLE_STR_ENTRY_END;
end;

function TSubtitlesListItem.GetText;
begin
  Result := fText;
end;

procedure TSubtitlesListItem.SetText;
begin
  // the shenmue charset conversion must be implemented...
  fText := Value;
end;

//------------------------------------------------------------------------------

initialization
  CoInitialize(nil);

finalization
  CoUninitialize();
  
end.