//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

{
  S C N F  E D i T O R  :: T R A N S L A T i O N  E N G i N E

  Free Quest characters subtitles editor for Shenmue II XBOX and DC

  Version.............: 2.0.2
  Release date........: 22-12-2008 @ 20:56
  
  Main code...........: [big_fury]SiZiOUS (http://sbibuilder.shorturl.com/)
  Additional code.....: Manic
  Beta test...........: Shendream, Sadako

  Project website.....: http://shenmuesubs.sourceforge.net/
}
unit old_scnfedit;

interface

{$UNDEF DEBUG}

uses
  Windows, SysUtils, Classes, UIntList;

const
  SCNF_EDITOR_ENGINE_VERSION = '2.0.2';
  SCNF_EDITOR_ENGINE_COMPIL_DATE_TIME = 'November 22, 2008 @08:56PM';
  
type
  TGameVersion = (gvDreamcast, gvXbox);

  TSCNFEditor = class;
  TSubList = class;
  
  TSubEntry = class(TObject)
  private
    fOwner: TSubList;
    fIndex: Integer;
    
    fStartSubtitleEntry: array[0..63] of Char;  // string before each subtitle text
    fStartSubtitleEntryCount: Integer;          // bytes count of that string

    fSubOriginalOffset1: Integer;
    fSubOriginalOffset2: Integer;

    fPatchValue: Integer;
    fSubOffset1: Integer;
    fSubOffset2: Integer;
    fUnknowValue: Integer;

    fCode: string;
    fText: string;
    fOriginalTextLength: Integer;                // original (not modified) subtitle length

    procedure SetText(const Value: string);
  public
    constructor Create(Owner: TSubList);
    property Code: string read fCode;
    property Text: string read fText write SetText;
  end;

  TSubList = class(TObject)
  private
    fOwner: TSCNFEditor;
    fList: TList;
    function GetItem(Index: Integer): TSubEntry;
    function GetCount: Integer;
  protected
    procedure AddEntry(const SubOffset1, SubOffset2: Integer; const Code: string; const UnknowValue: Integer);
  public
    constructor Create(Owner: TSCNFEditor);
    destructor Destroy; override;
    procedure Clear;
    property Subtitles[Index: Integer]: TSubEntry read GetItem; default;
    property Items[Index: Integer]: TSubEntry read GetItem;
    property Count: Integer read GetCount;
  end;

  TSncfPositionType = (spUnknow, spFirstSection, spLastSection, spSpecialPks);
  
  TSCNFEditor = class(TObject)
  private
    fSourceFileName: TFileName;             // Source filename of the current instance

    fPaksSizeOriginalValue: Integer;

    fGameVersion: TGameVersion;             // Game version (read at offset 0x8)
    fPaksSizeValue: Integer;                // PAKS file size - 56 (read at 0x20 and 0x28) (need to be modified)
    fScnfPosition: Integer;                 // Original SCNF position
    fCharacterID: string;                   // 4 bytes length string (read at 0x48) (not modified)
    fChIDfoot1: string;                     // first Character ID in the footer
    fChIDfoot2: string;                     // second Character ID in the footer
    fVoiceID: string;                       // x length string (read at 0x112) (not modified)
    fShortVoiceID: string;                  // only the code (extracted from VoiceID) (not modified)
    fStrTableHeaderOffset: Integer;         // String table header position (not modified)
    fStrTableBodyOffset: Integer;           // Subtitles text string table start position (not modified)
    fCharacterModelOffset: Integer;         // Character Model start real position
    fPaksUselessDataTotalSize: Integer;     // Total size of useless sections datas (MDCX + FACE + CSLG if any)
    fCharacterModelFootSize: Integer;       // Character Model size in the footer
    fFooterUnknowValue:Integer;
    fScnfRealSectionSize: Integer;
    fScnfSectionSizeWithoutHeaderSize: Integer;
    fScnfPositionType: TSncfPositionType;   // Indicate in the internal PKS file structure the position of the SNCF section. Used to save modified files.

    fFooterSpecialPksUnknowCode: string;
    fFooterSpecialPksSectionOffset: Integer;
    fFooterSpecialPksSectionSize: Integer;

    fTotalPatchValue: Integer;          // contains sum of all subtitles PatchValue. This attribute is modified by the PatchValues() method.

    fSubList: TSubList;
    fMakeBackup: Boolean;
    fFileLoaded: Boolean;
    function GetSubList: TSubList;
    function GetGameVersion: TGameVersion;
    function GetCharacterID: string;
    function GetVoiceID: string;
    function null_bytes_length(dataSize: Integer): Integer;
    procedure PatchValues;              // Update subtitles values: modify the TotalPatchValue & do other stuffs (modifing pks values etc...).
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function GetLoadedFileName: TFileName;

    procedure ExportSubtitlesToFile(const FileName: TFileName);
    function ImportSubtitlesFromFile(const FileName: TFileName): Boolean;

    procedure LoadFromFile(const FileName: TFileName);
    procedure SaveToFile(FileName: TFileName; SaveAsMode:Boolean);

    property CharacterID: string read GetCharacterID;
    property GameVersion: TGameVersion read GetGameVersion;
    property FileLoaded: Boolean read fFileLoaded;
    property MakeBackup: Boolean read fMakeBackup write fMakeBackup;
    property SourceFileName: TFileName read fSourceFileName;
    property SubtitlesList: TSubList read GetSubList;
    property VoiceID: string read GetVoiceID;
  end;

var
  fCharsMod: Boolean;       // 'True' if CSV is loaded
  fCSVLoaded: Boolean;      // 'True' if CSV is loaded, but can't be modified

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, old_ScnfUtil, old_charsutil
  {$IFDEF DEBUG}, TypInfo {$ENDIF};

const
  TABLE_CHAR_CODE: Char = #$A1;   // special char: this's a code used by the game
  TABLE_STR_ENTRY_BEGIN: Char = #$D6; // start string
  TABLE_STR_ENTRY_END: Char = #$D7;   // end string

//------------------------------------------------------------------------------
// TSubEntry
//------------------------------------------------------------------------------

procedure TSubList.AddEntry(const SubOffset1, SubOffset2: Integer; const Code: string; const UnknowValue: Integer);
var
  i: TSubEntry;

begin
  i := TSubEntry.Create(Self);
  i.fIndex := fList.Count;
  i.fSubOffset1 := SubOffset1;
  i.fSubOriginalOffset1 := i.fSubOffset1;
  i.fSubOffset2 := SubOffset2;
  i.fSubOriginalOffset2 := i.fSubOffset2;
  i.fUnknowValue := UnknowValue;
  i.fCode := Code;
  i.fText := '';
  i.fOriginalTextLength := 0;
  fList.Add(i);
end;

//------------------------------------------------------------------------------

procedure TSubList.Clear;
var
  i: Integer;

begin
  for i := 0 to fList.Count - 1 do
    TSubEntry(fList[i]).Free;
  fList.Clear;
end;

//------------------------------------------------------------------------------

constructor TSubList.Create(Owner: TSCNFEditor);
begin
  fList := TList.Create;
  Self.fOwner := Owner;
end;

//------------------------------------------------------------------------------

destructor TSubList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
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
// TSubEntry
//------------------------------------------------------------------------------

constructor TSubEntry.Create(Owner: TSubList);
begin
  fOwner := Owner;
  fPatchValue := 0;
end;

//------------------------------------------------------------------------------

procedure TSubEntry.SetText(const Value: string);
//var
//  SC: TSCNFEditor;

begin
//  SC := Self.fOwner.fOwner;
  
  if fText <> Value then begin
    fText := Value;

    fPatchValue := (Length(fText) - Self.fOriginalTextLength);
  end;

  {$IFDEF DEBUG}
  WriteLn(
    'PatchValue: ', fPatchValue, #13#10,
    'SubOffset1: ', fSubOffset1, #13#10,
    'SubOffset2: ', fSubOffset2, #13#10,
    'PaksSizeValue: ', SC.fPaksSizeValue, #13#10
  );
  {$ENDIF}
end;

//------------------------------------------------------------------------------
// TSCNFEditor
//------------------------------------------------------------------------------

procedure TSCNFEditor.Clear;
begin
  Self.fGameVersion := gvDreamcast;
  Self.fPaksSizeValue := 0;
  Self.fScnfPosition := 0;
  Self.fCharacterID := '';
  Self.fVoiceID := '';
  Self.fShortVoiceID := '';
  Self.fStrTableHeaderOffset := 0;
  Self.fStrTableBodyOffset := 0;

  //Footer vars & misc
  Self.fCharacterModelOffset := 0;
  Self.fPaksUselessDataTotalSize := 0;
  Self.fCharacterModelFootSize := 0;
  Self.fFooterUnknowValue := 0;
  Self.fChIDfoot1 := '';
  Self.fChIDfoot2 := '';

  Self.SubtitlesList.Clear;
end;

//------------------------------------------------------------------------------

constructor TSCNFEditor.Create;
begin
  fSubList := TSubList.Create(Self);
  fFileLoaded := False;
end;

//------------------------------------------------------------------------------

destructor TSCNFEditor.Destroy;
begin
  fSubList.Free;
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

procedure TSCNFEditor.ExportSubtitlesToFile(const FileName: TFileName);
var
  XMLDoc: IXMLDocument;
  i: Integer;
  CurrentNode, SubCurrentNode: IXMLNode;

  procedure AddXMLNode(var XML: IXMLDocument; const Key, Value: string); overload;
  var
    CurrentNode: IXMLNode;
    
  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure AddXMLNode(var XML: IXMLDocument; const Key: string; const Value: Integer); overload;
  begin
    AddXMLNode(XML, Key, IntToStr(Value));
  end;
  
begin
  XMLDoc := TXMLDocument.Create(nil);
  try
    with XMLDoc do begin                  
      Options := [doNodeAutoCreate, doAttrNull];
      ParseOptions:= [];
      NodeIndentStr:= '  ';
      Active := True;
      Version := '1.0';
      Encoding := 'ISO-8859-1';
    end;

    // Creating the root
    XMLDoc.DocumentElement := XMLDoc.CreateNode('s2freequestsubs');

    // File
    AddXMLNode(XMLDoc, 'filename', ExtractFileName(fSourceFileName));

    // Game version
    case Self.fGameVersion of
      gvDreamcast : AddXMLNode(XMLDoc, 'gameversion', 'dc');
      gvXbox      : AddXMLNode(XMLDoc, 'gameversion', 'xbox');
    end;

    // CharID
    AddXMLNode(XMLDoc, 'charid', Self.fCharacterID);

    // VoiceID
    AddXMLNode(XMLDoc, 'voiceid', Self.fVoiceID);

    // Short VoiceID
    AddXMLNode(XMLDoc, 'shortvoiceid', Self.fShortVoiceID);

    // Subtitles
    CurrentNode := XMLDoc.CreateNode('subtitles');
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
    CurrentNode.Attributes['count'] := Self.SubtitlesList.Count;
    for i := 0 to Self.SubtitlesList.Count - 1 do
    begin
      SubCurrentNode := XMLDoc.CreateNode('subtitle');
      SubCurrentNode.Attributes['code'] := Self.SubtitlesList[i].fCode;
      SubCurrentNode.NodeValue := Self.SubtitlesList[i].fText;
      CurrentNode.ChildNodes.Add(SubCurrentNode);
    end;  

    XMLDoc.SaveToFile(FileName);
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

//------------------------------------------------------------------------------

function TSCNFEditor.GetCharacterID: string;
begin
  Result := Self.fCharacterID;
end;

//------------------------------------------------------------------------------

function TSCNFEditor.GetGameVersion: TGameVersion;
begin
  Result := fGameVersion;
end;

//------------------------------------------------------------------------------

function TSCNFEditor.GetLoadedFileName: TFileName;
begin
  Result := fSourceFileName;
end;

//------------------------------------------------------------------------------

function TSCNFEditor.GetSubList: TSubList;
begin
  Result := Self.fSubList;
end;

//------------------------------------------------------------------------------

function TSCNFEditor.GetVoiceID: string;
begin
  Result := Self.fShortVoiceID;
end;

//------------------------------------------------------------------------------

function TSCNFEditor.ImportSubtitlesFromFile(const FileName: TFileName): Boolean;
var
  XMLDoc: IXMLDocument;
  i: Integer;
  CurrentNode, LoopNode: IXMLNode;
  xmlSubCode, xmlSubtitle, xmlCharID, xmlVoiceID, xmlShortVoiceID: string;
  CurrentSub: TSubEntry;
begin
  Result := False;
  if not FileExists(FileName) then Exit;

  XMLDoc := TXMLDocument.Create(nil);
  try
    with XMLDoc do begin
      Options := [doNodeAutoCreate];
      ParseOptions:= [];
      NodeIndentStr:= '  ';
      Active := True;
      Version := '1.0';
      Encoding := 'ISO-8859-1';
    end;

    XMLDoc.LoadFromFile(FileName);

    // Verifying if it's a valid XML to import
    if XMLDoc.DocumentElement.NodeName <> 's2freequestsubs' then Exit;

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

    if Trim(xmlCharID) <> Trim(Self.fCharacterID) then begin
      Exit;
    end
    else if Trim(xmlVoiceID) <> Trim(Self.fVoiceID) then begin
      Exit;
    end
    else if Trim(xmlShortVoiceID) <> Trim(Self.fShortVoiceID) then begin
      Exit;
    end;

    // Subtitles
    CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('subtitles');
    if CurrentNode.Attributes['count'] <> Self.SubtitlesList.Count then begin
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
          xmlSubtitle := LoopNode.NodeValue;
        except
          xmlSubtitle := '';
        end;
        
        CurrentSub := Self.SubtitlesList[i];
        CurrentSub.fCode := xmlSubCode;
        CurrentSub.Text := xmlSubtitle;
      end;
    end;

    Result := True;
    
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

//------------------------------------------------------------------------------

procedure TSCNFEditor.LoadFromFile(const FileName: TFileName);
var
  F: file;
  BufSubCode: array[0..4] of Char;
  i, j, k, currOffset: Integer;
  BufStr, FinalStr: string;
  BufChar, _PrevChar: Char;
  subDecimalList:TIntList;
  subReading:Boolean;
  SignCodeRead: array[0..127] of Char;
  _VoiceID_Length: Integer;
  _VoiceID_Length_Null_Terminal: Integer;
  _BufSubCode_Length: Integer;
  _SizeOf_Integer: Integer;

begin
  // if the file doesn't exists we exit
  if not FileExists(FileName) then Exit;

  // store filename
  fSourceFileName := FileName;

  // clear scnf editor object
  Clear;

  // open the file in read mode (to extract all infos from it)
  AssignFile(F, fSourceFileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  // game version detection
  Seek(F, 8);
  BlockRead(F, i, SizeOf(i));
  if i <> 0 then begin
    fGameVersion := gvDreamcast;
    {$IFDEF DEBUG} WriteLn(#13#10, 'Game version: Dreamcast'); {$ENDIF}
  end else begin
    fGameVersion := gvXbox;
    {$IFDEF DEBUG} WriteLn('Game version: Xbox'); {$ENDIF}
  end;

  // Paks package Size Value
  Seek(F, 20);
  BlockRead(F, fPaksSizeValue, SizeOf(fPaksSizeValue));
  {$IFDEF DEBUG} WriteLn('PAKS size: ', fPaksSizeValue); {$ENDIF}
  fPaksSizeOriginalValue := fPaksSizeValue;

  // Finding SCNF offset
  fScnfPosition := FindScnfOffset(F);

  // SCNF section size
  Seek(F, fScnfPosition + 4);
  BlockRead(F, fScnfRealSectionSize, SizeOf(fScnfRealSectionSize));
  //{$IFDEF DEBUG}WriteLn('SCNF section real size: ', fScnfRealSectionSize);{$ENDIF}

  // Char ID
  Seek(F, fScnfPosition + 16);
  BlockRead(F, BufSubCode, SizeOf(BufSubCode));
  BufSubCode[4] := #0;
  BufStr := PChar(@BufSubCode);
  Self.fCharacterID := BufStr;
  {$IFDEF DEBUG}WriteLn('Char ID: ', PChar(@BufSubCode));{$ENDIF}

  // SCNF section size without the header
  Seek(F, fScnfPosition + 20);
  BlockRead(F, fScnfSectionSizeWithoutHeaderSize, SizeOf(fScnfSectionSizeWithoutHeaderSize));

  // string table offset
  Seek(F, fScnfPosition + 40);
  BlockRead(F, fStrTableHeaderOffset, SizeOf(fStrTableHeaderOffset));
  fStrTableHeaderOffset := fScnfPosition + fStrTableHeaderOffset + 16;

  // Voice ID
  Seek(F, fScnfPosition + 48);
  BlockRead(F, i, SizeOf(i));
  Dec(i, 64); // Why ? I dunno
  Seek(F, (fScnfPosition + 80) + i); // start of the Voice ID string
  BufStr := '';
  repeat
    BlockRead(F, BufChar, 1);
    BufStr := BufStr + BufChar;    
  until BufChar = #0;
  fVoiceID := BufStr;
  fShortVoiceID := ExtremeRight('/', fVoiceID);
  {$IFDEF DEBUG} WriteLn('VoiceID: ', fVoiceID); {$ENDIF}

  // *** SUBTITLES TABLE ENTRIES SCAN ***

  {$IFDEF DEBUG} WriteLn(#13#10, 'String table entries: '); {$ENDIF}
  Seek(F, fStrTableHeaderOffset);

  _VoiceID_Length := Length(fShortVoiceID);
  _VoiceID_Length_Null_Terminal := _VoiceID_Length - 1;
  _BufSubCode_Length := SizeOf(BufSubCode);
  _SizeOf_Integer := SizeOf(Integer);
  
  // For the first table entry (never arrives but...)
  BlockRead(F, SignCodeRead, _VoiceID_Length);
  SignCodeRead[_VoiceID_Length_Null_Terminal] := #0;
  Seek(F, fStrTableHeaderOffset);

  // each sub entry starts with ShortVoiceID (Like "FEX20") and with a sub id (like "A001")
  // Where all subs starting with "A" is for Ryô and "B" is for the NPC character.
  while (StrComp(PChar(@SignCodeRead), PChar(fShortVoiceID)) <> 0) do begin
    // read subtitle entry
    BlockRead(F, i, _SizeOf_Integer); // first offset (?)
    BlockRead(F, j, _SizeOf_Integer); // second offset (length?)
    BlockRead(F, BufSubCode, _BufSubCode_Length - 1); // subtitle code
    BufSubCode[4] := #0;
    BlockRead(F, k, _SizeOf_Integer); // dunno what's it

    // add to the subtitles list
    Self.fSubList.AddEntry(i, j, PChar(@BufSubCode), k);

    {$IFDEF DEBUG}
    WriteLn('  ', IntToHex(i, 8), ' ', IntToHex(j, 8), ' ', BufSubCode, ' ', IntToHex(k, 8));
    {$ENDIF}

    // The subtitles table ends with the FIRST subtitle. This subtitle starts with the ShortVoiceID.
    // This BlockRead's for the while condition.
    BlockRead(F, SignCodeRead, _VoiceID_Length);
    SignCodeRead[_VoiceID_Length_Null_Terminal] := #0;
    Seek(F, FilePos(F) - _VoiceID_Length);
    //{$IFDEF DEBUG}WriteLn('String Table End Char: ', PChar(@SignCodeRead));{$ENDIF}
  end;
  fStrTableBodyOffset := FilePos(F);
  
  {$IFDEF DEBUG} WriteLn(#13#10, 'String table header offset: ', fStrTableHeaderOffset); {$ENDIF}
  {$IFDEF DEBUG} WriteLn('String table body offset: ', fStrTableBodyOffset, #13#10); {$ENDIF}

  // *** Table text entries scan ***

  // Seeking to the start of the table
  currOffset := fStrTableBodyOffset;
  Seek(F, currOffset);

  for i:=0 to Self.SubtitlesList.Count-1 do
  begin
    j := currOffset;
    // Skipping Voice and Subtitle ID + one null byte
    Inc(currOffset, 10);
    Seek(F, currOffset);

    // Loop to search subtitle beginning code
    BufChar := #0;
    _PrevChar := #0;
    subReading := True;
    while subReading do begin
      if (BufChar = TABLE_STR_ENTRY_BEGIN) and (_PrevChar = TABLE_CHAR_CODE) then begin
        subReading := False;
      end
      else begin
        _PrevChar := BufChar;
        Inc(currOffset);
        Seek(F, currOffset);
        BlockRead(F, BufChar, 1);
      end;
    end;
    Inc(currOffset);

    // Keeping subtitle entry
    Seek(F, j);
    BlockRead(F, Self.fSubList[i].fStartSubtitleEntry, currOffset-j);
    // Keeping subtitle entry count
    Self.fSubList[i].fStartSubtitleEntryCount := currOffset-j;
    // Seek to subtitle text
    Seek(F, currOffset);

    // Loop to read subtitle text
    subReading := True;
    subDecimalList := TIntList.Create;
    BufChar := #0;
    _PrevChar := #0;
    BufStr := '';
    while subReading do begin
      BlockRead(F, BufChar, 1);
      Seek(F, FilePos(F)-1);
      BlockRead(F, k, 1);
      subDecimalList.Add(k);
      if (BufChar = TABLE_STR_ENTRY_END) and (_PrevChar = TABLE_CHAR_CODE) then begin
        Delete(BufStr, Length(BufStr), 1);
        subDecimalList.Delete(subDecimalList.Count-1);
        subReading := False;
      end
      else
      begin
        Inc(currOffset);
        Seek(F, currOffset);
        _PrevChar := BufChar;
        BufStr := BufStr + _PrevChar;
      end;
    end;

    //Bringing back accentuated characters...
    FinalStr := '';
    if fCSVLoaded then
    begin
      for k := 1 to Length(BufStr) do begin
        if ((BufStr[k] = '¡') and (BufStr[k+1] = 'õ')) or ((BufStr[k] = 'õ') and (BufStr[k-1] = '¡')) then begin
          FinalStr := FinalStr + BufStr[k];
        end
        else begin
          FinalStr := FinalStr + revertChar(subDecimalList[k-1], BufStr[k]);
        end;
      end;
    end
    else begin
      FinalStr := BufStr;
    end;

    subDecimalList.Free;

    //Adding subtitle to the main variable
    Self.fSubList[i].fText := FinalStr;
    Self.fSubList[i].fOriginalTextLength := Length(Self.fSubList[i].fText);
    {$IFDEF DEBUG}WriteLn(Self.fSubList[i].fCode, ': ', Self.fSubList[i].fText);{$ENDIF}

    // Seeking to the next subtitle entry
    Inc(currOffset, 2);
    Seek(F, currOffset);
  end;

  // --- READING FOOTER --------------------------------------------------------

  // keeping original "MDC" position & character models size
  if fScnfPosition > 32 then begin
    fCharacterModelOffset := 32;
    fPaksUselessDataTotalSize := fScnfPosition - 32;
    Seek(F, FileSize(F) - 24);
    BlockRead(F, Self.fCharacterModelFootSize, _SizeOf_Integer);
  end else begin
    //fCharacterModelOffset := 32 + fScnfRealSectionSize + null_bytes_length(fScnfRealSectionSize); // FIX BY SiZ (v2.0.2: this is more "beautiful" to read the value from footer)
    Seek(F, FileSize(F) - 8);
    BlockRead(F, fCharacterModelOffset, _SizeOf_Integer);
    Inc(fCharacterModelOffset, 16);
    fPaksUselessDataTotalSize := FileSize(F) - (32 + 40 + fScnfRealSectionSize + null_bytes_length(fScnfRealSectionSize));
    Seek(F, FileSize(F) - 4);
    BlockRead(F, Self.fCharacterModelFootSize, _SizeOf_Integer);
  end;

  {$IFDEF DEBUG} WriteLn(''); {$ENDIF}
  
  // reading footer Character ID (number 1 & 2)
  j := 40;
  for i := 1 to 2 do begin
    Seek(F, FileSize(F) - j);
    BlockRead(F, BufSubCode, SizeOf(BufSubCode));
    BufSubCode[4] := #0;
    if i = 1 then fChIDfoot1 := PChar(@BufSubCode);
    if i = 2 then fChIDfoot2 := PChar(@BufSubCode);
    {$IFDEF DEBUG} WriteLn('Footer / ChID #', i, ': ', PChar(@BufSubCode)); {$ENDIF}
    Dec(j, 20);
  end;

  // SiZ patch 2.0: reading footer CharID if the PKS is special (like afs01317 or afs00917 from disc1).
  // theses PKS are specials characters like arm wrestling chars.
  Self.fScnfPositionType := spUnknow;
  j := 60; // the footer of theses specials chars are 60 bytes length (instead of 40)
  Seek(F, FileSize(F) - j);
  BlockRead(F, BufSubCode, SizeOf(BufSubCode));
  BufSubCode[4] := #0;
  if PChar(@BufSubCode) = fChIDfoot1 then
    Self.fScnfPositionType := spSpecialPks;  // this is a special PKS

  // reading footer 'Unknow value'
  //if (fScnfPosition = 32) then begin   // patch SiZ v2.0
  if (fScnfPosition = 32) and (Self.fScnfPositionType = spUnknow) then begin
    Seek(F, FileSize(F)-16);
    BlockRead(F, fFooterUnknowValue, 4);
    Self.fScnfPositionType := spFirstSection;
  end else begin // sncf is the last section or this pks is special
    Seek(F, FileSize(F)-36);
    BlockRead(F, fFooterUnknowValue, 4);
    if Self.fScnfPositionType = spUnknow then Self.fScnfPositionType := spLastSection;
  end;

  // SiZ patch for V2.0
  if Self.fScnfPositionType = spSpecialPks then begin
    // unknow code
    Seek(F, FileSize(F) - 16);
    BlockRead(F, BufSubCode, SizeOf(BufSubCode));
    BufSubCode[4] := #0;
    fFooterSpecialPksUnknowCode := PChar(@BufSubCode);

    // MDPX section pos
    // + 16 for getting the real start of the MDPX model
    Seek(F, FileSize(F) - 8);
    BlockRead(F, fFooterSpecialPksSectionOffset, _SizeOf_Integer);
    fFooterSpecialPksSectionOffset := fFooterSpecialPksSectionOffset + 16;

    // MDPX section size
    Seek(F, FileSize(F) - 4);
    BlockRead(F, fFooterSpecialPksSectionSize, _SizeOf_Integer);

    // !! FIX !! Read again charactel model (MDCX or MDC7) foot real size
    // We do so because previously, we tried to read the footer but it's different
    // (remember, 60B instead of 40B), so we have read garbage datas...
    Seek(F, FileSize(F) - 24);
    BlockRead(F, fCharacterModelFootSize, _SizeOf_Integer);

    // We need to write MDPX section apart, because we need to keep this section
    // offset (to write updated value in the footer)
    // So we will subst the MDPX size from this useless data (fFooterSpecialPksSectionOffset)

    // Header standard is 40 bytes length, special PKS is 60 bytes length.
    // We have already substracted 40 bytes length before (as normal PKS), so we
    // need to substract again 20 bytes to totally remove footer size
    // (- 40 [normal footer] - 20 [more bytes to remove] = - 60 [special pks footer]).
    k := (- 20 - fFooterSpecialPksSectionSize - null_bytes_length(fFooterSpecialPksSectionSize));
    fPaksUselessDataTotalSize := fPaksUselessDataTotalSize + k;
  end;

  {$IFDEF DEBUG}
    //k := 32 + fScnfRealSectionSize + null_bytes_length(fScnfRealSectionSize);
    WriteLn(#13#10, 'Footer / Character Model Start Offset: ', fCharacterModelOffset); //, ' MODEL OFFSET OLD CALC VALUE: ', k);
    WriteLn('Footer / Character Model Size: ', fCharacterModelFootSize);
    WriteLn('Paks / Useless Data Total Size: ', fPaksUselessDataTotalSize);
    WriteLn('Footer / Unknown Value: ', fFooterUnknowValue, #13#10);
    WriteLn('Misc. / SNCF Section Position Type: ', GetEnumName(TypeInfo(TSncfPositionType), Integer(fScnfPositionType)), #13#10);
    if Self.fScnfPositionType = spSpecialPks then begin
      WriteLn('Special PKS / Second Character Model Section Offset: ', fFooterSpecialPksSectionOffset);
      WriteLn('Special PKS / Second Character Model Section Size: ', fFooterSpecialPksSectionSize, #13#10);
    end;
  {$ENDIF}

  CloseFile(F);

  fFileLoaded := True;
end;

//------------------------------------------------------------------------------

procedure TSCNFEditor.PatchValues;
var
  i, j: Integer;
  PatchValue: Integer;

begin
  fTotalPatchValue := 0;
  
  // modifing string table
  for i := 0 to SubtitlesList.Count - 1 do begin
    PatchValue := Self.SubtitlesList[i].fPatchValue;
    fTotalPatchValue := fTotalPatchValue + PatchValue;
    for j := (i + 1) to SubtitlesList.Count - 1 do begin
      Self.SubtitlesList[j].fSubOffset1 := Self.SubtitlesList[j].fSubOffset1 + PatchValue;
      Self.SubtitlesList[j].fSubOffset2 := Self.SubtitlesList[j].fSubOffset2 + PatchValue;
    end;
  end;
  
  // modifing paks value
  fPaksSizeValue := fPaksSizeOriginalValue + fTotalPatchValue;
  fScnfRealSectionSize := fScnfRealSectionSize + fTotalPatchValue;
  fScnfSectionSizeWithoutHeaderSize := fScnfSectionSizeWithoutHeaderSize + fTotalPatchValue;
end;

//------------------------------------------------------------------------------

procedure TSCNFEditor.SaveToFile(FileName: TFileName; SaveAsMode:Boolean);
const
  WORK_BUFFER_SIZE = 16384;
  // END_STR_SIGN: array[0..2] of Char = (#$0, TABLE_CHAR_CODE, TABLE_STR_ENTRY_BEGIN);
  END_STR_SIGN: array[0..2] of Char = (#$A1, #$D7, #$00);
  
var
  F_src, F_dest: file;
  Buf: array[0..WORK_BUFFER_SIZE-1] of Char;
  i, j, k, ScnfSize, SectionPos, BufSize, MDPX_NewSectionPos: Integer;
  _Last_BufEntry_Size: Integer;
  _SizeOf_Integer: Integer;
  _SizeOf_BufCode: Integer;
  StrCode: PChar;
  StrBuf: String;
  tempByte: Byte;
  TmpFile: TFileName;

  procedure CopyFileBlock(var FromF, ToF: file; StartOffset, BlockSize: Integer);
  var
    i: Integer;
    
  begin
    Seek(FromF, StartOffset);

    BufSize := SizeOf(Buf);
    _Last_BufEntry_Size := (BlockSize mod BufSize);
    j := BlockSize div BufSize;
    for i := 0 to j - 1 do begin
      BlockRead(FromF, Buf, SizeOf(Buf), BufSize);
      BlockWrite(ToF, Buf, BufSize);
    end;
    BlockRead(FromF, Buf, _Last_BufEntry_Size, BufSize);
    BlockWrite(ToF, Buf, BufSize);
  end;

  function GetTempDir : string;
  var
    Dir: array[0..MAX_PATH] of Char;

  begin
    Result := '';
    if GetTempPath(SizeOf(Dir), Dir) <> 0 then
      Result := IncludeTrailingPathDelimiter(StrPas(Dir));
  end;

  function GetTempFileName: TFileName;
  begin
    Result := GetTempDir + IntToHex(Random($FFFFFFF), 8) + '.siz';
  end;
  
begin
  PatchValues; // patching offset values

  // generate temp file
  TmpFile := GetTempFileName;
  _SizeOf_Integer := SizeOf(Integer);

  // opening source file
  AssignFile(F_src, fSourceFileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F_src, 1);{$I+}
  if IOResult <> 0 then Exit;

  // opening target file
  AssignFile(F_dest, TmpFile);
  FileMode := fmOpenWrite;
  ReWrite(F_dest, 1);

  // writing header
  BlockRead(F_src, Buf, 20);
  BlockWrite(F_dest, Buf, 20);

  // writing paks value
  BlockWrite(F_dest, fPaksSizeValue, _SizeOf_Integer);
  Seek(F_src, 24);
  BlockRead(F_src, Buf, _SizeOf_Integer);
  BlockWrite(F_dest, Buf, _SizeOf_Integer);
  BlockWrite(F_dest, fPaksSizeValue, _SizeOf_Integer);
  Seek(F_src, 32);

  // if SCNF is the last section of the file, write models now
  if fScnfPosition > 32 then begin
    CopyFileBlock(F_src, F_dest, fCharacterModelOffset, fPaksUselessDataTotalSize);
  end;

  // ---------------------------------------------------------------------------
  // WRITING PATCHED SCNF SECTION
  // ---------------------------------------------------------------------------
  
  // keeping SCNF offset, if needed
  SectionPos := FileSize(F_dest) - 16;

  // writing SCNF header
  CopyFileBlock(F_src, F_dest, fScnfPosition, 4);
  BlockWrite(F_dest, fScnfRealSectionSize, _SizeOf_Integer);
  CopyFileBlock(F_src, F_dest, fScnfPosition + 8, 12);
  BlockWrite(F_dest, fScnfSectionSizeWithoutHeaderSize, _SizeOf_Integer);
  CopyFileBlock(F_src, F_dest, fScnfPosition + 24, ((Self.fStrTableHeaderOffset - fScnfPosition) - 56) + 32);

  // writing string table
  _SizeOf_BufCode := SizeOf(Self.SubtitlesList[i].fCode);
  for i := 0 to Self.SubtitlesList.Count - 1 do begin
    BlockWrite(F_dest, Self.SubtitlesList[i].fSubOffset1, _SizeOf_Integer);
    BlockWrite(F_dest, Self.SubtitlesList[i].fSubOffset2, _SizeOf_Integer);
    StrCode := PChar(Self.SubtitlesList[i].fCode);
    BlockWrite(F_dest, (StrCode^), _SizeOf_BufCode);
    BlockWrite(F_dest, Self.SubtitlesList[i].fUnknowValue, _SizeOf_Integer);
  end;

  // writing string text table
  k := SizeOf(END_STR_SIGN);
  for i := 0 to Self.SubtitlesList.Count - 1 do begin
    BlockWrite(F_dest, SubtitlesList[i].fStartSubtitleEntry, SubtitlesList[i].fStartSubtitleEntryCount);

    // Sending characters to processChars if needed
    if fCharsMod then begin
      for j := 1 to Length(SubtitlesList[i].fText) do begin
        //Extracting each character individually
        StrBuf := SubtitlesList[i].fText[j];
        if ((StrBuf = '¡') and (SubtitlesList[i].fText[j+1] = 'õ')) or ((StrBuf = 'õ') and (SubtitlesList[i].fText[j-1] = '¡')) then begin
          tempByte := 0;
        end
        else begin
          tempByte := processChar(StrBuf); //Processing char...
        end;
        if tempByte = 0 then begin
          BlockWrite(F_dest, Pointer(StrBuf)^, Length(StrBuf));
        end
        else begin
          BlockWrite(F_dest, tempByte, SizeOf(tempByte));
        end;
      end;
    end
    else begin
      BlockWrite(F_dest, Pointer(SubtitlesList[i].fText)^, Length(SubtitlesList[i].fText));
    end;

    BlockWrite(F_dest, END_STR_SIGN, k);
  end;

  // padding before character model or footer
  ScnfSize := FileSize(F_dest) - 32;
  ZeroMemory(@Buf, null_bytes_length(ScnfSize));
  BlockWrite(F_dest, Buf, null_bytes_length(ScnfSize));

  // ---------------------------------------------------------------------------
  // WRITING USELESS DATAS (FOR US) 
  // ---------------------------------------------------------------------------
  
  // if SCNF is first section in file, keeping MCDx position & writing model
  if fScnfPosition = 32 then begin
    SectionPos := FileSize(F_dest) - 16;
    CopyFileBlock(F_src, F_dest, fCharacterModelOffset, fPaksUselessDataTotalSize);
    //{$IFDEF DEBUG} WriteLn('CharacterModelOffset: ', fCharacterModelOffset, ', CharacterModelSize: ', fCharacterModelSize);{$ENDIF}
    //{$IFDEF DEBUG} WriteLn('PaksUselessDataTotalSize : ', fPaksUselessDataTotalSize); {$ENDIF}
  end;

  //----------------------------------------------------------------------------
  // WRITING MDPX SECTION IF ANY
  //----------------------------------------------------------------------------

  // If special PKS we must write MDPX section now and keep section position offset
  // MDPX sections must be the LAST in file if presents.
  // I have scanned all XBOX & DC PAKS and it matchs, so no problem

  if Self.fScnfPositionType = spSpecialPks then begin
    MDPX_NewSectionPos := FileSize(F_dest) - 16;   // for writing in the footer
    j := fFooterSpecialPksSectionSize + null_bytes_length(fFooterSpecialPksSectionSize); // copy MDPX section + padding
    CopyFileBlock(F_src, F_dest, fFooterSpecialPksSectionOffset, j);
  end;

  // ---------------------------------------------------------------------------
  // WRITING FOOTER
  // ---------------------------------------------------------------------------
  
  // Character ID (4 bytes)
  BlockWrite(F_dest, Pointer(fChIDfoot1)^, Length(fChIDfoot1));

  // footer is different if SCNF is first or last in the file
  case fScnfPositionType of
    spFirstSection:
                    begin //if fScnfPosition = 32 then begin
                      k := 40; // footer length in bytes
                      // «0» (4 bytes)
                      j := 0;
                      BlockWrite(F_dest, j, _SizeOf_Integer);
                      // «BIN » (4 bytes)
                      StrBuf := 'BIN ';
                      BlockWrite(F_dest, Pointer(StrBuf)^, Length(StrBuf));
                      // «16» (4 bytes)
                      j := 16;
                      BlockWrite(F_dest, j, _SizeOf_Integer);
                      // SCNF section size (4 bytes)
                      BlockWrite(F_dest, fScnfRealSectionSize, _SizeOf_Integer);
                      // Character ID (4 bytes)
                      BlockWrite(F_dest, Pointer(fChIDfoot2)^, Length(fChIDfoot2));
                      // Footer unknow value (4 bytes)
                      BlockWrite(F_dest, fFooterUnknowValue, _SizeOf_Integer);
                      // «CHRM» (4 bytes)
                      StrBuf := 'CHRM';
                      BlockWrite(F_dest, Pointer(StrBuf)^, Length(StrBuf));
                      // MDCx offset (4 bytes)
                      BlockWrite(F_dest, SectionPos, _SizeOf_Integer);
                      // Models total size (4 bytes)
                      BlockWrite(F_dest, fCharacterModelFootSize, _SizeOf_Integer);
                    end;
  spLastSection:
                    begin //else begin
                      k := 40; // footer length in bytes
                      // Footer unknow value (4 bytes)
                      BlockWrite(F_dest, fFooterUnknowValue, _SizeOf_Integer);
                      // «CHRM» (4 bytes)
                      StrBuf := 'CHRM';
                      BlockWrite(F_dest, Pointer(StrBuf)^, Length(StrBuf));
                      // «16» (4 bytes)
                      j := 16;
                      BlockWrite(F_dest, j, _SizeOf_Integer);
                      // Models total size (4 bytes)
                      BlockWrite(F_dest, fCharacterModelFootSize, _SizeOf_Integer);
                      // Character ID (4 bytes)
                      BlockWrite(F_dest, Pointer(fChIDfoot2)^, Length(fChIDfoot2));
                      // «0» (4 bytes)
                      j := 0;
                      BlockWrite(F_dest, j, _SizeOf_Integer);
                      // «BIN » (4 bytes)
                      StrBuf := 'BIN ';
                      BlockWrite(F_dest, Pointer(StrBuf)^, Length(StrBuf));
                      // SCNF offset (4 bytes)
                      BlockWrite(F_dest, SectionPos, _SizeOf_Integer);
                      // SCNF section size (4 bytes)
                      BlockWrite(F_dest, fScnfRealSectionSize, _SizeOf_Integer);
                    end;
    spSpecialPks:   // SiZ PATCH V2.0
                    begin
                      k := 60; // footer length in bytes
                      // «0» (4 bytes)
                      j := 0;
                      BlockWrite(F_dest, j, _SizeOf_Integer);
                      // «BIN » (4 bytes)
                      StrBuf := 'BIN ';
                      BlockWrite(F_dest, Pointer(StrBuf)^, Length(StrBuf));
                      // «16» (4 bytes)
                      j := 16;
                      BlockWrite(F_dest, j, _SizeOf_Integer);
                      // SCNF section size (4 bytes)
                      BlockWrite(F_dest, fScnfRealSectionSize, _SizeOf_Integer);
                      // Character ID 1 again (4 bytes)
                      BlockWrite(F_dest, Pointer(fChIDfoot1)^, Length(fChIDfoot1));
                      // Footer unknow value (4 bytes)
                      BlockWrite(F_dest, fFooterUnknowValue, _SizeOf_Integer);
                      // «CHRM» (4 bytes)
                      StrBuf := 'CHRM';
                      BlockWrite(F_dest, Pointer(StrBuf)^, Length(StrBuf));
                      // MDCx offset (4 bytes)
                      BlockWrite(F_dest, SectionPos, _SizeOf_Integer);
                      // Models total size (4 bytes)
                      // Inc(fCharacterModelFootSize, Self.fTotalPatchValue);
                      BlockWrite(F_dest, fCharacterModelFootSize, _SizeOf_Integer);
                      // Character ID 2 (4 bytes)
                      BlockWrite(F_dest, Pointer(fChIDfoot2)^, Length(fChIDfoot2));

                      // unknow special footer code
                      BlockWrite(F_dest, Pointer(Self.fFooterSpecialPksUnknowCode)^, Length(Self.fFooterSpecialPksUnknowCode));
                      // «CHRM» (4 bytes)
                      StrBuf := 'CHRM';
                      BlockWrite(F_dest, Pointer(StrBuf)^, Length(StrBuf));
                      // MDPX section offset
                      // Self.fFooterSpecialPksSectionOffset := SectionPos + fCharacterModelFootSize + 4;
                      BlockWrite(F_dest, MDPX_NewSectionPos, _SizeOf_Integer);
                      // MDPX section size
                      BlockWrite(F_dest, Self.fFooterSpecialPksSectionSize, _SizeOf_Integer);
                    end;
  end;
  
  //Write correct footer value in header
  j := FileSize(F_dest) - k - 16;
  Seek(F_dest, 28);
  BlockWrite(F_dest, j, _SizeOf_Integer);

  //Closing file stream
  CloseFile(F_dest);
  CloseFile(F_src);

  // 'File/Save...' fix
  // Case "Save same file loaded": We must re-init old values with new ones
  if SaveAsMode then begin
    //part 1
    if fScnfPosition = 32 then begin
      fCharacterModelOffset := SectionPos + 16;
      {$IFDEF DEBUG} WriteLn('Save / New Character Model Offset: ', fCharacterModelOffset); {$ENDIF}
    end;
    //part 2
    for i := 0 to Self.SubtitlesList.Count - 1 do begin
      Self.SubtitlesList[i].fPatchValue := 0;
      Self.SubtitlesList[i].fOriginalTextLength := Length(Self.SubtitlesList[i].Text); // SiZ v1.04 patch
    end;
    // if special PKS we must save the new pos of the MDPX offset
    if Self.fScnfPositionType = spSpecialPks then begin
      fFooterSpecialPksSectionOffset := MDPX_NewSectionPos + 16;
      {$IFDEF DEBUG} WriteLn('Save / New Second Character Model Offset: ', fFooterSpecialPksSectionOffset); {$ENDIF}
    end;
    {$IFDEF DEBUG}WriteLn('');{$ENDIF}

    // update patched values with new ones
    Self.fPaksSizeOriginalValue := Self.fPaksSizeValue;
  end else begin
    // Case "Save as another file": We must reload original values
    LoadFromFile(Self.GetLoadedFileName);  // A AMELIORER CAR C'EST NUL DE RELIRE LE FICHIER DU DISQUE
  end;

  // Making backup if necessary
  if FileExists(FileName) then
    if fMakeBackup then begin
      RenameFile(FileName, FileName + '.bak');
    end else
      DeleteFile(FileName);
      
  CopyFile(PChar(TmpFile), PChar(FileName), False);
  try
    DeleteFile(TmpFile);
  except
  end;
end;

//------------------------------------------------------------------------------

initialization
  Randomize;

//------------------------------------------------------------------------------

end.
