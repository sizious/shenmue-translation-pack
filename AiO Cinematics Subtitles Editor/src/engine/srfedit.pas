unit SRFEdit;

interface

uses
  Windows, SysUtils, Classes, SysTools, FileSpec, SRFKeyDB, ChrCodec;

const
  SRF_DATABLOCK_SIZE = 1024;
  
type
  ESRFEditor = class(Exception);
  EGetExtraData = class(ESRFEditor);

  TSRFEditor = class;
  TSRFSubtitlesList = class;

  TSRFDataBlock = array[0..SRF_DATABLOCK_SIZE - 1] of Char;

  TSRFSubtitlesListItem = class(TObject)
  private
    fText: string;
    fOwner: TSRFSubtitlesList;
    fCharID: string;
    fExtraDataStream: TMemoryStream;
    function GetText: string;
    procedure SetText(const Value: string);
    function GetExtraData: TSRFDataBlock;
    function GetExtraDataSize: LongWord;
    function GetRecordSize: LongWord;
    function GetOwnerEditor: TSRFEditor;
    function GetTextPaddingSize: LongWord;
    function GetExtraDataString: string;
  protected
    procedure WriteShenmueEntry(F: TFileStream);
    procedure WriteShenmue2Entry(F: TFileStream);
    property Editor: TSRFEditor read GetOwnerEditor;
    property ExtraDataStream: TMemoryStream read fExtraDataStream;
    property TextPaddingSize: LongWord read GetTextPaddingSize;
  public
    constructor Create(AOwner: TSRFSubtitlesList);
    destructor Destroy; override;
    property CharID: string read fCharID;
    property ExtraData: TSRFDataBlock read GetExtraData;
    property ExtraDataSize: LongWord read GetExtraDataSize;
    property ExtraDataString: string read GetExtraDataString;
    property RawText: string read fText;
    property RecordSize: LongWord read GetRecordSize;
    property Text: string read GetText write SetText;
    property Owner: TSRFSubtitlesList read fOwner;
  end;

  TSRFImportFileFormat = (iffXML, iffText);

  TSRFSubtitlesList = class(TObject)
  private
    fInternalSubtitlesList: TList;
    fOwner: TSRFEditor;
    fDecodeText: Boolean;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSRFSubtitlesListItem;
    function GetJapaneseCharset: Boolean;
  protected
    function Add: TSRFSubtitlesListItem;
    procedure Clear;
    function ImportFromText(const FileName: TFileName): Boolean;
    function ImportFromXML(const FileName: TFileName): Boolean;
    procedure SwitchJapaneseEncoding(const FileName: TFileName);
  public
    constructor Create(AOwner: TSRFEditor);
    destructor Destroy; override;
    function ExportToFile(const FileName: TFileName): Boolean;
    function ImportFromFile(const FileName: TFileName;
      FileFormat: TSRFImportFileFormat): Boolean; overload;
    function ImportFromFile(const FileName: TFileName): Boolean; overload;
    function TransformText(const Subtitle: string): string;
    property Count: Integer read GetCount;
    property DecodeText: Boolean read fDecodeText write fDecodeText;
    property Items[Index: Integer]: TSRFSubtitlesListItem read GetItem; default;
    property JapaneseCharset: Boolean read GetJapaneseCharset;
    property Owner: TSRFEditor read fOwner;
  end;

  TSRFEditor = class(TObject)
  private
    fCinematicsHashKeyDatabase: TCinematicsHashKeyDatabase;
    fSRFSubtitlesList: TSRFSubtitlesList;
    fGameVersion: TGameVersion;
    fFileLoaded: Boolean;
    fSourceFileName: TFileName;
    fMakeBackup: Boolean;
    fCharset: TShenmueCharsetCodec;
    fHashKey: string;
    fPlatformVersion: TPlatformVersion;
    property CinematicsHashKeyDatabase: TCinematicsHashKeyDatabase
      read fCinematicsHashKeyDatabase;
  protected
    function ComputeHashKey: string;
    function DetectGameVersion(var InStream: TFileStream): TGameVersion;
    procedure ParseShenmueFormat(var InStream: TFileStream);
    procedure ParseShenmue2Format(var InStream: TFileStream);
  public
    constructor Create; overload;
    constructor Create(const DataDirectory: TFileName); overload;
    destructor Destroy; override;
    procedure Clear;
    function LoadFromFile(const FileName: TFileName): Boolean;
    function Save: Boolean;
    function SaveToFile(const FileName: TFileName): Boolean;
    property Charset: TShenmueCharsetCodec read fCharset;
    property GameVersion: TGameVersion read fGameVersion;
    property HashKey: string read fHashKey;
    property Loaded: Boolean read fFileLoaded;
    property MakeBackup: Boolean read fMakeBackup write fMakeBackup;
    property PlatformVersion: TPlatformVersion read fPlatformVersion;
    property SourceFileName: TFileName read fSourceFileName;
    property Subtitles: TSRFSubtitlesList read fSRFSubtitlesList;
  end;

function DataBlockToString(D: TSRFDataBlock; ADataSize: LongWord): string;

implementation

uses
  {$IFDEF DEBUG}TypInfo, {$ENDIF}
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants, MD5Api;

const
  SHENMUE_SIGN                = #$08#$00#$00#$00;
  SHENMUE2_SIGN               = 'CHID';
  SHENMUE2_SUBTITLE_DATA      = 'STDL';
  SHENMUE2_SUBTITLE_EXTRADATA = 'EXTD';
  SHENMUE2_SUBTITLE_CLIPDATA  = 'CLIP';
  SHENMUE2_SUBTITLE_ENTRYEND  = 'ENDC';
  
type
  TShenmueSubtitleHeader = record
    Name: array[0..3] of Char;
    CharID: array[0..3] of Char;
    SubtitleLength: LongWord;
  end;

  TShenmue2SubtitleHeader = record
    Name: array[0..3] of Char;
    Size: LongWord;
    CharID: array[0..3] of Char;
  end;

function DataBlockToString(D: TSRFDataBlock; ADataSize: LongWord): string;
var
  i: Integer;

begin
  Result := '';
  for i := 0 to ADataSize - 1 do
    Result := Result + IntToHex(Ord(D[i]), 2);
end;

{ TSRFSubtitlesListItem }

constructor TSRFSubtitlesListItem.Create(AOwner: TSRFSubtitlesList);
begin
  fOwner := AOwner;
  fExtraDataStream := TMemoryStream.Create;
end;

destructor TSRFSubtitlesListItem.Destroy;
begin
  fExtraDataStream.Free;
  inherited;
end;

function TSRFSubtitlesListItem.GetExtraData: TSRFDataBlock;
begin
  try
    CopyMemory(@Result, ExtraDataStream.Memory, ExtraDataStream.Size);
  except
    on E:Exception do
      raise EGetExtraData.Create(
        'GetExtraData: Unable to perform CopyMemory (Size='
        + IntToStr(ExtraDataStream.Size) + '), Reason: '
        + E.Message + ', Class='
        + E.ClassName);
  end;
end;

function TSRFSubtitlesListItem.GetExtraDataSize: LongWord;
begin
  Result := LongWord(ExtraDataStream.Size);
end;

function TSRFSubtitlesListItem.GetExtraDataString: string;
begin
  Result := DataBlockToString(ExtraData, ExtraDataSize);
end;

function TSRFSubtitlesListItem.GetOwnerEditor: TSRFEditor;
begin
  Result := Owner.Owner;
end;

function TSRFSubtitlesListItem.GetRecordSize: LongWord;
begin
  Result := ExtraDataSize + LongWord(Length(RawText));
  case Editor.GameVersion of
    gvShenmue:
      // Result + Size of the sub header (12) + DataSize header (4)
      Result := Result + SizeOf(TShenmueSubtitleHeader) + UINT32_SIZE + TextPaddingSize;
    gvShenmue2:
      begin
        // Result + Size of the CHID section (12) + ENDC header (8)
        Result := Result + SizeOf(TShenmue2SubtitleHeader) + SizeOf(TSectionEntry);
        // If the subtitle is not empty, add the STDL header (8) + sub padding
        if RawText <> '' then
          Result := Result + SizeOf(TSectionEntry) + TextPaddingSize;
      end;
  end;
end;

function TSRFSubtitlesListItem.GetText: string;
begin
  if Owner.DecodeText then
    Result := Owner.TransformText(fText)
  else
    Result := fText;
end;

function TSRFSubtitlesListItem.GetTextPaddingSize: LongWord;
begin
  Result := 0;
  if RawText <> '' then
    Result := 4 - (Length(RawText) mod 4);
end;

procedure TSRFSubtitlesListItem.SetText(const Value: string);
begin
  if Owner.DecodeText then
    fText := Editor.Charset.Encode(Value)
  else
    fText := Value;
end;

procedure TSRFSubtitlesListItem.WriteShenmue2Entry(F: TFileStream);
var
  Header: TShenmue2SubtitleHeader;
  SectionHeader: TSectionEntry;

begin
  // Writing header
  StrToFourCC(Header.Name, SHENMUE2_SIGN);
  Header.Size := SizeOf(TShenmue2SubtitleHeader);
// FUCK!! This StrCopy hang the main func, the BlockSize var was resetted to 0... (?)
// StrCopy(Header.CharID, PChar(CharID));
  StrToFourCC(Header.CharID, CharID);
  F.Write(Header, Header.Size);

  // Writing text
  if RawText <> '' then begin
    StrToFourCC(SectionHeader.Name, SHENMUE2_SUBTITLE_DATA);
    SectionHeader.Size := SizeOf(TSectionEntry) + LongWord(Length(RawText))
      + TextPaddingSize;
    F.Write(SectionHeader, SizeOf(TSectionEntry));
    WriteNullTerminatedString(F, RawText, False);
    WriteNullBlock(F, TextPaddingSize);
  end;

  // Writing extra data
  F.CopyFrom(ExtraDataStream, 0);

  // Writing ENDC
  StrToFourCC(SectionHeader.Name, SHENMUE2_SUBTITLE_ENTRYEND);
  SectionHeader.Size := 0;
  F.Write(SectionHeader, SizeOf(TSectionEntry));
end;

procedure TSRFSubtitlesListItem.WriteShenmueEntry(F: TFileStream);
var
  Header: TShenmueSubtitleHeader;
  DataSize: LongWord;

begin
  // Writing header
  ZeroMemory(@Header.Name, SizeOf(Header.Name));
//  StrToFourCC(Header.Name, SHENMUE_SIGN);
  StrCopy(Header.Name, SHENMUE_SIGN);
  StrToFourCC(Header.CharID, CharID);
  Header.SubtitleLength := UINT32_SIZE;
  if RawText <> '' then
    Inc(Header.SubtitleLength, LongWord(Length(RawText)) + TextPaddingSize);
  F.Write(Header, SizeOf(TShenmueSubtitleHeader));

  // Writing text
  if RawText <> '' then begin
    WriteNullTerminatedString(F, RawText, False);
    WriteNullBlock(F, TextPaddingSize);
  end;

  // Writing extra data
  DataSize := ExtraDataSize + UINT32_SIZE;
  F.Write(DataSize, UINT32_SIZE);
  F.CopyFrom(ExtraDataStream, 0);
end;

{ TSRFSubtitlesList }

function TSRFSubtitlesList.Add: TSRFSubtitlesListItem;
begin
  Result := TSRFSubtitlesListItem.Create(Self);
  fInternalSubtitlesList.Add(Result);
end;

procedure TSRFSubtitlesList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fInternalSubtitlesList.Clear;
end;

constructor TSRFSubtitlesList.Create(AOwner: TSRFEditor);
begin
  fOwner := AOwner;
  fInternalSubtitlesList := TList.Create;
end;

destructor TSRFSubtitlesList.Destroy;
begin
  Clear;
  fInternalSubtitlesList.Free;
  inherited;
end;

function TSRFSubtitlesList.ExportToFile(const FileName: TFileName): Boolean;
var
  XMLRoot: IXMLDocument;
  RootNode, Node: IXMLNode;
  i: Integer;

  function GetInputFileEncoding: string;
  begin
    Result := 'utf-8';
    if JapaneseCharset then
      Result := 'iso-8859-1';
  end;
  
begin
  XMLRoot := TXMLDocument.Create(nil);
  try
    with XMLRoot do begin
      Options := [doNodeAutoCreate, doAttrNull];
      ParseOptions := [poPreserveWhiteSpace];
      Active := True;
      Version := '1.0';
      Encoding := GetInputFileEncoding;
    end;

    // Creating the root
    XMLRoot.DocumentElement := XMLRoot.CreateNode('srfeditor');

    // Original file name
    Node := XMLRoot.CreateNode('filecode');
    Node.NodeValue := ChangeFileExt(ExtractFileName(Owner.SourceFileName), '');
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
        Node.NodeValue := RawText;
      end;
      RootNode.ChildNodes.Add(Node);
    end;

    // Saving the result
    XMLRoot.SaveToFile(FileName);
    Result := FileExists(FileName);

    // Changing the encoding...
    SwitchJapaneseEncoding(FileName);
  finally
    // Destroying the XML file
    XMLRoot.Active := False;
    XMLRoot := nil;
  end;
end;

function TSRFSubtitlesList.GetCount: Integer;
begin
  Result := fInternalSubtitlesList.Count;
end;

function TSRFSubtitlesList.GetItem(Index: Integer): TSRFSubtitlesListItem;
begin
  Result := TSRFSubtitlesListItem(fInternalSubtitlesList[Index]);
end;

function TSRFSubtitlesList.GetJapaneseCharset: Boolean;
begin
// !!! THIS IS BIG SHIT I NEED TO FIX THIS !!!
  Result := False;
  if (Count > 0) then
    Result := IsJapaneseString(Items[0].RawText);
end;

function TSRFSubtitlesList.ImportFromFile(const FileName: TFileName;
  FileFormat: TSRFImportFileFormat): Boolean;
begin
  Result := False;
  case FileFormat of
    iffXML: Result := ImportFromXML(FileName);
    iffText: Result := ImportFromText(FileName);
  end;
end;

function TSRFSubtitlesList.ImportFromFile(const FileName: TFileName): Boolean;
begin
  Result := ImportFromFile(FileName, iffXML);
end;

function TSRFSubtitlesList.ImportFromText(const FileName: TFileName): Boolean;
var
  SL: TStringList;
  LinePtr, SubIndex, SubsCount: Integer;
  CharID: string;
  SubtitleText: WideString;
  
begin
  Result := False;
  if not FileExists(FileName) then Exit;

  SL := TStringList.Create;
  try
    LoadUnicodeTextFile(SL, FileName);
    
    // ImportFile[0]: Filename. Ignore this
    SubsCount := StrToIntDef(SL[1], 0);
    if Count <> SubsCount then Exit;

    LinePtr := 2;
    while LinePtr < SL.Count do begin
      // Reading the entry
      SubIndex := StrToIntDef(SL[LinePtr + 1], -1);
      CharID := SL[LinePtr + 2];
      SubtitleText := SL[LinePtr + 3];

{$IFDEF DEBUG}
      WriteLn('SubIndex: ', SubIndex, ', CharID: ', CharID,
        ', SubtitleText: ', SubtitleText);
{$ENDIF}

      // Modifying the entry if possible
      if (SubIndex <> -1) and (Items[SubIndex].CharID = CharID) then
        Items[SubIndex].fText := SubtitleText;

      // Passing to the next entry
      Inc(LinePtr, 4);
    end;

    Result := True;
  finally
    SL.Free;
  end;
end;

function TSRFSubtitlesList.ImportFromXML(const FileName: TFileName): Boolean;
var
  XMLRoot: IXMLDocument;
  RootNode, Node: IXMLNode;
  i: Integer;
  LegacyFormat, ValidImportFile: Boolean;
  SubtitlesRoot: string;

  function GetInputFileEncoding: string;
  begin
    Result := 'utf-8';
    if JapaneseCharset then
      Result := 'euc-jp';    
  end;

begin
  Result := False;
  if not FileExists(FileName) then Exit;

  // Loading the imported file
  XMLRoot := TXMLDocument.Create(nil);
  try
    try

      with XMLRoot do begin
        Options := [doNodeAutoCreate, doAttrNull];
        ParseOptions := [poPreserveWhiteSpace];
        Active := True;
        Version := '1.0';
        Encoding := GetInputFileEncoding;
      end;

      // Loading the file
      XMLRoot.LoadFromFile(FileName);

      // Reading the root
      LegacyFormat := (XMLRoot.DocumentElement.NodeName = 'subseditor');  // 1.x editor
      ValidImportFile := LegacyFormat
        or (XMLRoot.DocumentElement.NodeName = 'srfeditor');  // new editor!

      // Legacy support
      SubtitlesRoot := 'subtitles';
      if LegacyFormat then
        SubtitlesRoot := 'list';

      // Reading XML tree
      if ValidImportFile then begin
        // Subtitle list
        RootNode := XMLRoot.DocumentElement.ChildNodes.FindNode(SubtitlesRoot);
        Result := RootNode.Attributes['count'] = Count; // Check count
        if Result then
          for i := 0 to Count - 1 do begin
            Node := RootNode.ChildNodes.Nodes[i];
            Owner.Subtitles[i].fText := VariantToString(Node.NodeValue);
            RootNode.ChildNodes.Add(Node);
          end; // for
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

procedure TSRFSubtitlesList.SwitchJapaneseEncoding(const FileName: TFileName);
var
  SL: TStringList;
  
begin
  if not JapaneseCharset then Exit;

  // Modifing the charset
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    SL[0] := '<?xml version="1.0" encoding="euc-jp"?>'; // it's crap but it works!
    SL.SaveToFile(FileName);
  finally
    SL.Free;
  end;
end;

function TSRFSubtitlesList.TransformText(const Subtitle: string): string;
type
  TCharsetFunc = function(S: string): string of object;

var
  CharsetFunc: TCharsetFunc;
  
begin
  if DecodeText then
    CharsetFunc := Owner.Charset.Decode
  else
    CharsetFunc := Owner.Charset.Encode;
  Result := CharsetFunc(Subtitle);
end;

{ TSRFEditor }

procedure TSRFEditor.Clear;
begin
  fGameVersion := gvUndef;
  fFileLoaded := False;
  Subtitles.Clear;
  fSourceFileName := '';
  fHashKey := '';
end;

function TSRFEditor.ComputeHashKey: string;
var
  i: Integer;
  DataString: string;

begin
  Result := '';
  (* Compute a MD5 Hash key based on the ExtraData, used to identify the
     file, even if the subtitles are modified. *)
  try
    for i := 0 to Subtitles.Count - 1 do
    begin
      DataString := Subtitles[i].ExtraDataString;
      Result := MD5(Result + DataString);
    end;
    Result := 'K' + UpperCase(Result);
  except
  end;
end;

constructor TSRFEditor.Create;
begin
  fSRFSubtitlesList := TSRFSubtitlesList.Create(Self);
  fCharset := TShenmueCharsetCodec.Create;
  Subtitles.DecodeText := True;
  fCinematicsHashKeyDatabase := TCinematicsHashKeyDatabase.Create;
  Clear;
end;

constructor TSRFEditor.Create(const DataDirectory: TFileName);
begin
  Create;
  CinematicsHashKeyDatabase.OpenDatabase(DataDirectory + 'srfkeys.db');
end;

destructor TSRFEditor.Destroy;
begin
  fSRFSubtitlesList.Free;
  fCharset.Free;
  fCinematicsHashKeyDatabase.Free;
  inherited;
end;

function TSRFEditor.DetectGameVersion(
  var InStream: TFileStream): TGameVersion;
var
  Header: array[0..3] of Char;

begin
  // Reading the file signature
  Result := gvUndef;
  InStream.Seek(0, soFromBeginning);
  InStream.Read(Header, SizeOf(Header));
  if StrEquals(Header, SHENMUE_SIGN) then
    Result := gvShenmue
  else if StrEquals(Header, PChar(SHENMUE2_SIGN)) then
    Result := gvShenmue2;
  InStream.Seek(0, soFromBeginning);
end;

function TSRFEditor.LoadFromFile(const FileName: TFileName): Boolean;
var
  InStream: TFileStream;
  CurrentGameVersion: TGameVersion;

begin
  Result := False;
  if not FileExists(FileName) then Exit;

{$IFDEF DEBUG}
  WriteLn(sLineBreak, '*** LOADING FILE ***', sLineBreak);
{$ENDIF}

  // Loading the file
  InStream := TFileStream.Create(FileName, fmOpenRead);
  try
    try

      // Reading the first entry header to detect the file version
      CurrentGameVersion := DetectGameVersion(InStream);

      // The file is valid so we can continue
      if CurrentGameVersion <> gvUndef then begin
        // Clearing the object
        Clear;

        // Setting the new GameVersion
        fGameVersion := CurrentGameVersion;

        // Reading the subtitles table
        case GameVersion of

          // Shenmue I
          gvShenmue:
            ParseShenmueFormat(InStream);

          // Shenmue II
          gvShenmue2:
            ParseShenmue2Format(InStream);

        end;

        // The file is loaded and the result is OK
        fFileLoaded := True;
        Result := True;
        fSourceFileName := FileName;

        // Compute MD5 Hash Key
        fHashKey := ComputeHashKey;

        // Reading the platform version
        fPlatformVersion := pvUndef;
        with CinematicsHashKeyDatabase do
          if Loaded then begin
            fPlatformVersion := GetPlatformVersion(HashKey);
          end;
      end;
      
    except
      Result := False;
    end;

  finally
    InStream.Free;
  end;
end;

procedure TSRFEditor.ParseShenmue2Format(var InStream: TFileStream);
var
  Header: TShenmue2SubtitleHeader;
  PaddingSize, BlockCount, BlockOffset: LongWord;
  StrBuf: string;
  Section: TSectionEntry;
  CurrentItem: TSRFSubtitlesListItem;

  function ValidExtraSection(SectionName: string): Boolean;
  begin
    Result := StrEquals(SectionName, SHENMUE2_SUBTITLE_EXTRADATA)
      or StrEquals(SectionName, SHENMUE2_SUBTITLE_CLIPDATA);
  end;

  function EndSubtitleRecord(SectionName: string): Boolean;
  begin
    Result := StrEquals(Section.Name, SHENMUE2_SUBTITLE_ENTRYEND);
  end;

begin
  BlockCount := 1;

  repeat
    BlockOffset := InStream.Position;
    InStream.Read(Header, SizeOf(TShenmue2SubtitleHeader));

    if StrEquals(Header.Name, SHENMUE2_SIGN) then begin
      // Create the entry
      CurrentItem := Subtitles.Add;
      CurrentItem.fCharID := Header.CharID;
      
      repeat
        InStream.Read(Section, SizeOf(TSectionEntry));

        // Read the STDL section...
        if StrEquals(Section.Name, SHENMUE2_SUBTITLE_DATA) then begin
          // read the subtitle
          StrBuf := ReadNullTerminatedString(InStream, Section.Size - SECTIONENTRY_SIZE);
          CurrentItem.fText := StrBuf;

{$IFDEF DEBUG}
        WriteLn(sLineBreak,
          '0x', IntToHex(InStream.Position, 8), ': ',
          sLineBreak, '  "', StrBuf, '"');
{$ENDIF}
        end else begin

          // Read the extra data
          if Assigned(CurrentItem) and ValidExtraSection(Section.Name) then begin
            InStream.Seek(-SECTIONENTRY_SIZE, soFromCurrent);
            with CurrentItem.ExtraDataStream do begin
              Seek(0, soFromEnd);
              CopyFrom(InStream, Section.Size);
            end;
          end;

        end;

      until EndSubtitleRecord(Section.Name) or EOFS(InStream);
      
    end else begin
      // Compute the padding to find the next subtitle entry
      PaddingSize := (BlockCount * GAME_BLOCK_SIZE) - BlockOffset;
      InStream.Seek(BlockOffset + PaddingSize, soFromBeginning);
{$IFDEF DEBUG}
      WriteLn('* Block Padding: ', PaddingSize);
{$ENDIF}
    end;

    // Another complete block was read
    if (InStream.Position mod GAME_BLOCK_SIZE) = 0 then
      Inc(BlockCount);

  until EOFS(InStream);
end;

procedure TSRFEditor.ParseShenmueFormat(var InStream: TFileStream);
const
  SPECIAL_GAME_BLOCK_SIZE = 2012;

type
  TPaddingSeekDemand = (psdNoPadding, psdNormalPadding, psdExtraPadding);
  
var
  Header: TShenmueSubtitleHeader;
// BlockOffset
  PaddingSize, BlockCount, SubDataSize, LastEntryOffset, LastBlockCount: LongWord;
  StrBuf: string;
  CurrentItem: TSRFSubtitlesListItem;
  PaddingSeekDemand: TPaddingSeekDemand;
  ReadHalted: Boolean;

begin
  PaddingSize := 0;
  BlockCount := 1;
  LastBlockCount := BlockCount;  
  PaddingSeekDemand := psdNoPadding;
  ReadHalted := False;
  LastEntryOffset := 0;
  
  repeat
//    BlockOffset := InStream.Position;
    InStream.Read(Header, SizeOf(TShenmueSubtitleHeader));

    if StrEquals(Header.Name, SHENMUE_SIGN) then begin

{$IFDEF DEBUG}
      WriteLn(sLineBreak, '0x', IntToHex(InStream.Position - SizeOf(TShenmueSubtitleHeader), 8), ':');
{$ENDIF}

      PaddingSeekDemand := psdNoPadding;
      StrBuf := ReadNullTerminatedString(InStream, Header.SubtitleLength - 4);

{$IFDEF DEBUG}
      WriteLn('  "', StrBuf, '"');
{$ENDIF}

      // Create the subtitle item
      CurrentItem := Subtitles.Add;
      with CurrentItem do begin
        fText := StrBuf;
        fCharID := Header.CharID;
      end;

      // Read the data size
      InStream.Read(SubDataSize, UINT32_SIZE);
      Dec(SubDataSize, 4);

      // Read the data
      // Fix by SiZ! on 2012-05-20: If the SubDataSize=0, then the block is copied entierly...
      // we don't need this Delphi behaviour
      if SubDataSize > 0 then
      begin
        with CurrentItem.ExtraDataStream do begin
          Seek(0, soFromBeginning);
          CopyFrom(InStream, SubDataSize);
        end;
      end; // SubDataSize

      LastEntryOffset := InStream.Position;
      LastBlockCount  := BlockCount;

{$IFDEF DEBUG}
      WriteLn('  DataSize: ', SubDataSize, ', Subtitle Size: ', Header.SubtitleLength);
{$ENDIF}

    end else begin

      // Compute the padding to find the next subtitle entry
      if PaddingSeekDemand = psdNoPadding then begin
        PaddingSize := GAME_BLOCK_SIZE;
        PaddingSeekDemand := psdNormalPadding;
      end else if PaddingSeekDemand = psdNormalPadding then begin
        // This case only happened with ONE old SRF file... the first intro A0100.SRF.
        // The padding is 2012 bytes, not 2048... very strange...
        PaddingSize := SPECIAL_GAME_BLOCK_SIZE;
        PaddingSeekDemand := psdExtraPadding;
      end else
        // Unable to find the next subtitle, we stop to read now
        ReadHalted := True;

      // Seeking to the new location
      PaddingSize := (LastBlockCount * PaddingSize) - LastEntryOffset;
      InStream.Seek(LastEntryOffset + PaddingSize, soFromBeginning);
      
{$IFDEF DEBUG}
      WriteLn(
        ' * Block Padding: ', PaddingSize, sLineBreak,
        '   PaddingType  : ', Ord(PaddingSeekDemand), sLineBreak,
        '   ReadHalted   : ', ReadHalted
      );
{$ENDIF}
    end;

    // Another complete block was read
//    if (PaddingSeekDemand <> psdExtraPadding) // only if the ExtraPadding wasn't detected
    if (InStream.Position mod GAME_BLOCK_SIZE = 0) then
      Inc(BlockCount);

  until EOFS(InStream) or ReadHalted;

end;

function TSRFEditor.Save: Boolean;
begin
  Result := SaveToFile(SourceFileName);
end;

function TSRFEditor.SaveToFile(const FileName: TFileName): Boolean;
var
  OutStream: TFileStream;
  BlockSize, PaddingSize, NextBlockSize: LongWord;
  i: Integer;
  OutFileName: TFileName;

begin
  Result := False;
  if not Loaded then Exit;

{$IFDEF DEBUG}
  WriteLn(sLineBreak, '*** SAVING FILE ***', sLineBreak);
{$ENDIF}

  OutFileName := GetTempFileName;
  OutStream := TFileStream.Create(OutFileName, fmCreate);
  try

    BlockSize := 0;

    for i := 0 to Subtitles.Count - 1 do begin

{$IFDEF DEBUG}
      WriteLn(
        '#', i, ': "', Subtitles[i].Text, '"', sLineBreak,
        ' RecordSize: ', Subtitles[i].RecordSize
      );
{$ENDIF}

      // Manage the padding if necessary
      NextBlockSize := BlockSize + Subtitles[i].RecordSize;
      if NextBlockSize > GAME_BLOCK_SIZE then begin
        PaddingSize := GAME_BLOCK_SIZE - BlockSize;
        WriteNullBlock(OutStream, PaddingSize);
        BlockSize := 0;
{$IFDEF DEBUG}
        WriteLn('  *** PADDING #', i, ': BlockSize: ', BlockSize,
          ', PaddingSize: ', PaddingSize);
{$ENDIF}
      end;

      // Write the subtitle
      case GameVersion of
        gvShenmue:
          Subtitles[i].WriteShenmueEntry(OutStream);
        gvShenmue2:
          Subtitles[i].WriteShenmue2Entry(OutStream);
      end;

      // Update the written BlockSize
      Inc(BlockSize, Subtitles[i].RecordSize);
    end; // for

    Result := True;
  finally
    OutStream.Free;

    // Replacing file
    MoveTempFile(OutFileName, FileName, MakeBackup);
  end;
end;

initialization
  CoInitialize(nil);

end.
