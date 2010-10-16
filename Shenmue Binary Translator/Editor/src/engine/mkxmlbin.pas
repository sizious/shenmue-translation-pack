unit MkXmlBin;

interface

uses
  Windows, SysUtils, Classes, FileSpec;
  
type
  TBinaryScriptEditor = class;
  
  EBinaryScriptEditor = class(Exception);

//------------------------------------------------------------------------------
// ADDRESSES LIST MANAGER
// -----------------------------------------------------------------------------

  // Generic object contaning a pointers list
  TAddressList = class(TObject)
  private
    fPointersList: TList;
    function GetItem(Index: Integer): LongWord;
    function GetCount: Integer;
  protected
    procedure Add(const Address: LongWord);
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: LongWord read GetItem; default;
  end;

//------------------------------------------------------------------------------
// POINTERS MANAGER
// -----------------------------------------------------------------------------

  TPointerTableItem = class(TObject)
  private
    fOffset: LongWord;
    fAddresses: TAddressList;
  public
    constructor Create;
    destructor Destroy; override;
    property Offset: LongWord read fOffset;
    property Addresses: TAddressList read fAddresses;
  end;

  TPointerTable = class(TObject)
  private
    fPointerTableList: TList;
    function GetItem(Index: Integer): TPointerTableItem;
    function GetCount: Integer;
  protected
    function Add: TPointerTableItem;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPointerTableItem read GetItem; default;
  end;

//------------------------------------------------------------------------------
// STRINGS MANAGER
// -----------------------------------------------------------------------------

  // Generic object containg a string and its associated pointers list
  TStringTableItem = class(TObject)
  private
    fText: string;
    fAddresses: TAddressList;
  public
    constructor Create;
    destructor Destroy; override;
    property Addresses: TAddressList read fAddresses;
    property Text: string read fText write fText;
  end;

  TStringTable = class(TObject)
  private
    fStringTableList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TStringTableItem;
  protected
    function Add: TStringTableItem;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TStringTableItem read GetItem; default;
  end;

//------------------------------------------------------------------------------
// FIXED STRINGS MANAGER
// -----------------------------------------------------------------------------

  TFixedStringTableItem = class(TObject)
  private
    fText: string;
    fAddresses: TAddressList;
  public
    constructor Create;
    destructor Destroy; override;
    property Text: string read fText;
    property Addresses: TAddressList read fAddresses;
  end;

  TFixedStringTable = class(TObject)
  private
    fFixedStringTableList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TFixedStringTableItem;
  protected
    function Add: TFixedStringTableItem;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TFixedStringTableItem read GetItem; default;
  end;

//------------------------------------------------------------------------------
// SECTIONS TABLE
// -----------------------------------------------------------------------------

  TSectionTableItem = class(TObject)
  private
    fStringTable: TStringTable;
    fName: string;
  public
    constructor Create;
    destructor Destroy; override;
    property Name: string read fName;
    property Table: TStringTable read fStringTable;
  end;

  // Object containing every string can be translated by the tool
  TSectionTable = class(TObject)
  private
    fSectionTableList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSectionTableItem;
  protected    
    function Add: TSectionTableItem;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSectionTableItem read GetItem; default;
  end;

//------------------------------------------------------------------------------
// BLOCKS ALLOCATION TABLE
// -----------------------------------------------------------------------------

  TAllocationTable = class;

  TAllocationTableItem = class(TObject)
  private
    fSize: LongWord;
    fOffset: LongWord;
  public
    property Offset: LongWord read fOffset;
    property Size: LongWord read fSize;
  end;

  TAllocationTable = class(TObject)
  private
    fBlocksList: TList;
    function GetItem(Index: Integer): TAllocationTableItem;
    function GetCount: Integer;
  protected    
    procedure Add(const AOffset, ASize: Integer);
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TAllocationTableItem read GetItem; default;
  end;

//------------------------------------------------------------------------------
// HEADER INFOS
// -----------------------------------------------------------------------------

  TBinaryHeader = class(TObject)
  private
    fVersion: TGameVersion;
    fPlatformKind: TPlatformVersion;
    fRegion: TGameRegion;
  protected
    procedure Clear;
  public
    property Region: TGameRegion read fRegion;
    property PlatformKind: TPlatformVersion read fPlatformKind;
    property Version: TGameVersion read fVersion;
  end;

//------------------------------------------------------------------------------
// MAIN CLASS
// -----------------------------------------------------------------------------

  TBinaryScriptEditor = class(TObject)
  private
    fAllocations: TAllocationTable;
    fSections: TSectionTable;
    fPointers: TPointerTable;
    fReserved: TFixedStringTable;
    fFileLoaded: Boolean;
    fHeader: TBinaryHeader;
    fDocType: string;
    fSourceFileName: TFileName;
  protected
    procedure Clear;
    property DocType: string read fDocType;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromFile(const FileName: TFileName): Boolean;
    function SaveToFile(const FileName: TFileName): Boolean;
    property Allocations: TAllocationTable read fAllocations;
    property Constants: TFixedStringTable read fReserved;
    property Header: TBinaryHeader read fHeader;
    property Loaded: Boolean read fFileLoaded;
    property Sections: TSectionTable read fSections;
    property SourceFileName: TFileName read fSourceFileName;
    property Pointers: TPointerTable read fPointers;
  end;

//==============================================================================
implementation
//==============================================================================

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, SysTools;

{ TAddressList }

procedure TAddressList.Add(const Address: LongWord);
begin
  fPointersList.Add(Pointer(Address));
end;

procedure TAddressList.Clear;
begin
  fPointersList.Clear;
end;

constructor TAddressList.Create;
begin
  fPointersList := TList.Create;
end;

destructor TAddressList.Destroy;
begin
  fPointersList.Free;
  inherited;
end;

function TAddressList.GetCount: Integer;
begin
  Result := fPointersList.Count;
end;

function TAddressList.GetItem(Index: Integer): LongWord;
begin
  Result := LongWord(fPointersList[Index]);
end;

{ TPointerTable }

function TPointerTable.Add: TPointerTableItem;
begin
  Result := TPointerTableItem.Create;
  fPointerTableList.Add(Result);
end;

procedure TPointerTable.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fPointerTableList.Clear;
end;

constructor TPointerTable.Create;
begin
  fPointerTableList := TList.Create;
end;

destructor TPointerTable.Destroy;
begin
  Clear;
  fPointerTableList.Free;
  inherited;
end;

function TPointerTable.GetCount: Integer;
begin
  Result := fPointerTableList.Count;
end;

function TPointerTable.GetItem(Index: Integer): TPointerTableItem;
begin
  Result := TPointerTableItem(fPointerTableList[Index]);
end;

{ TStringTableItem }

constructor TStringTableItem.Create;
begin
  fAddresses := TAddressList.Create;
end;

destructor TStringTableItem.Destroy;
begin
  fAddresses.Free;
  inherited;
end;

{ TStringTable }

function TStringTable.Add: TStringTableItem;
begin
  Result := TStringTableItem.Create;
  fStringTableList.Add(Result);
end;

procedure TStringTable.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fStringTableList.Clear;
end;

constructor TStringTable.Create;
begin
  fStringTableList := TList.Create;
end;

destructor TStringTable.Destroy;
begin
  Clear;
  fStringTableList.Free;
  inherited;
end;

function TStringTable.GetCount: Integer;
begin
  Result := fStringTableList.Count;
end;

function TStringTable.GetItem(Index: Integer): TStringTableItem;
begin
  Result := TStringTableItem(fStringTableList[Index]);
end;

{ TSectionTable }

function TSectionTable.Add: TSectionTableItem;
begin
  Result := TSectionTableItem.Create;
  fSectionTableList.Add(Result);
end;

procedure TSectionTable.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fSectionTableList.Clear;
end;

constructor TSectionTable.Create;
begin
  fSectionTableList := TList.Create;
end;

destructor TSectionTable.Destroy;
begin
  Clear;
  fSectionTableList.Free;
  inherited;
end;

function TSectionTable.GetCount: Integer;
begin
  Result := fSectionTableList.Count;
end;

function TSectionTable.GetItem(Index: Integer): TSectionTableItem;
begin
  Result := TSectionTableItem(fSectionTableList[Index]);
end;

{ TAllocationTable }

procedure TAllocationTable.Add(const AOffset, ASize: Integer);
var
  Item: TAllocationTableItem;

begin
  Item := TAllocationTableItem.Create;
  with Item do begin
    Item.fSize := ASize;
    Item.fOffset := AOffset;
  end;
  fBlocksList.Add(Item);
end;

procedure TAllocationTable.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fBlocksList.Clear;
end;

constructor TAllocationTable.Create;
begin
  fBlocksList := TList.Create;
end;

destructor TAllocationTable.Destroy;
begin
  Clear;
  fBlocksList.Free;
  inherited;
end;

function TAllocationTable.GetCount: Integer;
begin
  Result := fBlocksList.Count;
end;

function TAllocationTable.GetItem(Index: Integer): TAllocationTableItem;
begin
  Result := TAllocationTableItem(fBlocksList[Index]);
end;

{ TBinaryScriptEditor }

procedure TBinaryScriptEditor.Clear;
begin
  fSourceFileName := '';
  fFileLoaded := False;
  Allocations.Clear;
  Sections.Clear;
  Pointers.Clear;
  Constants.Clear;
  Header.Clear;
end;

constructor TBinaryScriptEditor.Create;
begin
  fAllocations := TAllocationTable.Create;
  fSections := TSectionTable.Create;
  fPointers := TPointerTable.Create;
  fReserved := TFixedStringTable.Create;
  fHeader := TBinaryHeader.Create;
  Header.Clear;  
end;

destructor TBinaryScriptEditor.Destroy;
begin
  fAllocations.Free;
  fSections.Free;
  fPointers.Free;
  fReserved.Free;
  fHeader.Free;
  inherited;
end;

function TBinaryScriptEditor.LoadFromFile(const FileName: TFileName): Boolean;
type
  TScriptNodeType = (sntUndef, sntSection, sntInsert, sntPatch);
  
var
  ScriptDocument: IXMLDocument;
  RootNode, ScriptNode,
  WorkingNode, TranslateNode,
  AllocationsNode, HeaderNode: IXMLNode;
  i, j: Integer;

// IsValidScriptFile
function IsValidScriptFile: Boolean;
begin
  Result := ScriptDocument.DocumentElement.NodeName = 'translation';
end;

// GetNodeType
function GetNodeType: TScriptNodeType;
begin
  Result := sntUndef;
  if WorkingNode.NodeName = 'section' then
    Result := sntSection
  else if WorkingNode.NodeName = 'insert' then
    Result := sntInsert
  else if WorkingNode.NodeName = 'patch' then
    Result := sntPatch;
end;

// ParseAddresses
procedure ParseAddresses(Node: IXMLNode; Addresses: TAddressList);
var
  k: Integer;

begin
  for k := 0 to Node.ChildNodes.Count - 1 do
    Addresses.Add(Node.ChildNodes[k].Attributes['addr']);
end;

// Main
begin
  Result := False;
  if not FileExists(FileName) then Exit;
  Clear;

  // setting the file / directory properties
  fFileLoaded := True;

  // parsing the XML index file
  ScriptDocument := TXMLDocument.Create(nil);
  try

    try
      // initialization for the XML file
      ScriptDocument.LoadFromFile(FileName);
      ScriptDocument.Active := True;

{$IFDEF DEBUG}
      WriteLn(sLineBreak, '*** PARSING XML SCRIPT ***');
{$ENDIF}

      // Getting root
      if IsValidScriptFile then begin
        RootNode := ScriptDocument.DocumentElement;

        // Getting the DOCTYPE
        fDocType := GetXMLDocType(ScriptDocument.XML.Text);

        // Parsing header
        HeaderNode := RootNode.ChildNodes.FindNode('header');
        with Header do begin
          fVersion := CodeStringToGameVersion(HeaderNode.Attributes['game']);
          fPlatformKind :=
            CodeStringToPlatformVersion(HeaderNode.Attributes['platform']);
          fRegion := CodeStringToGameRegion(HeaderNode.Attributes['region']);
        end;

        // Parsing script
        ScriptNode := RootNode.ChildNodes.FindNode('script');
        for i := 0 to ScriptNode.ChildNodes.Count - 1 do begin
          WorkingNode := ScriptNode.ChildNodes[i];

          // Determine the current WorkingNode type
          case GetNodeType of
            // Node = "translate"
            sntSection:
              with Sections.Add do begin
                fName := WorkingNode.Attributes['name']; // section name
                // parsing each string to translate
                for j := 0 to WorkingNode.ChildNodes.Count - 1 do begin
                  TranslateNode := WorkingNode.ChildNodes[j];
                  with Table.Add do begin
                    fText := TranslateNode.Attributes['text'];
                    // parsing each address binded to the string
                    ParseAddresses(TranslateNode, Addresses);
                  end; // Table.Add
                end; // ChildNodes[j]
              end; // Sections.Add

            // Node = "insert"
            sntInsert:
              with Constants.Add do begin
                fText := WorkingNode.Attributes['text'];
                // reading each address binded to the string
                ParseAddresses(WorkingNode, Addresses);
              end;

            // Node = "patch"
            sntPatch:
              with Pointers.Add do begin
                fOffset := WorkingNode.Attributes['addr'];
                // reading each address binded to the string
                ParseAddresses(WorkingNode, Addresses);
              end;
              
          end; // NodeType
        end; // ScriptNode

        // Allocation Node
        AllocationsNode := RootNode.ChildNodes.FindNode('allocation_table');
        if Assigned(AllocationsNode) then        
          for i := 0 to AllocationsNode.ChildNodes.Count - 1 do
            with AllocationsNode.ChildNodes[i] do
              Allocations.Add(Attributes['addr'], Attributes['size']);

      end; // IsValidScriptFile

      Result := True;
      fSourceFileName := FileName;
      
    except
      on E:Exception do begin
{$IFDEF DEBUG}
        WriteLn('LoadFromFile Exception: "' + E.Message + '"');
{$ENDIF}
        Result := False;
      end;
    end;

  finally
    ScriptDocument.Active := False;
    ScriptDocument := nil;
  end;
end;

function TBinaryScriptEditor.SaveToFile(const FileName: TFileName): Boolean;
var
  ScriptDocument: IXMLDocument;
  HeaderNode, ScriptNode, SectionNode,
  TranslateNode, PointerNode: IXMLNode;
  WorkingSection: TSectionTableItem;
  WorkingStringItem: TStringTableItem;
  FixedInsertString: TFixedStringTableItem;
  PointerItem: TPointerTableItem;
  i, j, k: Integer;

  function IntelHex(Value: LongWord): string;
  begin
    Result := '0x' + LowerCase(IntToHex(Value, 2));
  end;

begin
//  Result := False;
  ScriptDocument := TXMLDocument.Create(nil);
  try
    try
      with ScriptDocument do begin
        Options := [doNodeAutoCreate];
        ParseOptions:= [];
        NodeIndentStr:= '  ';
        Active := True;
        Version := '1.0';
        Encoding := 'utf-8';

        // Creating the root
        DocumentElement := CreateNode('translation');

        // Writing the header
        HeaderNode := CreateNode('header');
        HeaderNode.Attributes['game'] :=
          GameVersionToCodeString(Header.Version);
        HeaderNode.Attributes['platform'] :=
          PlatformVersionToCodeString(Header.PlatformKind);
        HeaderNode.Attributes['region'] :=
          GameRegionToCodeString(Header.Region);
        DocumentElement.ChildNodes.Add(HeaderNode);

        // Writing the script node
        ScriptNode := CreateNode('script');
        DocumentElement.ChildNodes.Add(ScriptNode);

        // Writing the 'sections' nodes
        for i := 0 to Sections.Count - 1 do begin
          WorkingSection := Sections[i];

          // Creating the section root node
          SectionNode := CreateNode('section');
          SectionNode.Attributes['name'] := WorkingSection.Name;
          ScriptNode.ChildNodes.Add(SectionNode);

          // writing strings
          for j := 0 to WorkingSection.Table.Count - 1 do begin
            WorkingStringItem := WorkingSection.Table[j];

            // creating the string entry in the xml
            TranslateNode := CreateNode('translate');
            TranslateNode.Attributes['text'] := WorkingStringItem.Text;
            SectionNode.ChildNodes.Add(TranslateNode);

            // writing addresses of that string
            for k := 0 to WorkingStringItem.Addresses.Count - 1 do begin
              PointerNode := CreateNode('ptr');
              PointerNode.Attributes['addr'] :=
                IntelHex(WorkingStringItem.Addresses[k]);
              TranslateNode.ChildNodes.Add(PointerNode);
            end; // k
          end; // j
        end; // i

        // Writing the 'insert' nodes
        for i := 0 to Constants.Count - 1 do begin
          FixedInsertString := Constants[i];

          // adding the 'insert' node
          TranslateNode := CreateNode('insert');
          TranslateNode.Attributes['text'] := FixedInsertString.Text;
          ScriptNode.ChildNodes.Add(TranslateNode);

          // adding addresses of that string
          for j := 0 to FixedInsertString.Addresses.Count - 1 do begin
            PointerNode := CreateNode('ptr');
            PointerNode.Attributes['addr'] :=
              IntelHex(FixedInsertString.Addresses[j]);
            TranslateNode.ChildNodes.Add(PointerNode);
          end;
        end;

        // Writing the 'patch' nodes
        for i := 0 to Pointers.Count - 1 do begin
          PointerItem := Pointers[i];

          // adding the 'patch' node
          TranslateNode := CreateNode('patch');
          TranslateNode.Attributes['addr'] := IntelHex(PointerItem.Offset);
          ScriptNode.ChildNodes.Add(TranslateNode);

          // writing the addresses
          for j := 0 to PointerItem.Addresses.Count - 1 do begin
            PointerNode := CreateNode('ptr');
            PointerNode.Attributes['addr'] :=
              IntelHex(PointerItem.Addresses[j]);
            TranslateNode.ChildNodes.Add(PointerNode);
          end;
        end;

        // Writing the 'allocation_table' nodes
        ScriptNode := CreateNode('allocation_table');
        for i := 0 to Allocations.Count - 1 do begin
          PointerNode := CreateNode('block');
          PointerNode.Attributes['addr'] := IntelHex(Allocations[i].Offset);
          PointerNode.Attributes['size'] := IntelHex(Allocations[i].Size);
          ScriptNode.ChildNodes.Add(PointerNode);
        end;
        DocumentElement.ChildNodes.Add(ScriptNode);

        // adding the DOCTYPE
        SetXMLDocType(ScriptDocument, DocType);
      end; // ScriptDocument

      // Saving the file!
      ScriptDocument.SaveToFile(FileName);
    except
      on E:Exception do begin
{$IFDEF DEBUG}
        WriteLn('SaveToFile Exception: "' + E.Message + '"');
{$ENDIF}
//        Result := False;
      end;
    end;
  finally
    ScriptDocument.Active := False;
    ScriptDocument := nil;
    Result := FileExists(FileName);
  end;
end;

{ TSectionTableItem }

constructor TSectionTableItem.Create;
begin
  fStringTable := TStringTable.Create;
end;

destructor TSectionTableItem.Destroy;
begin
  fStringTable.Free;
  inherited;
end;

{ TFixedStringTableItem }

constructor TFixedStringTableItem.Create;
begin
  fAddresses := TAddressList.Create;
end;

destructor TFixedStringTableItem.Destroy;
begin
  fAddresses.Free;
  inherited;
end;

{ TFixedStringTable }

function TFixedStringTable.Add: TFixedStringTableItem;
begin
  Result := TFixedStringTableItem.Create;
  fFixedStringTableList.Add(Result);
end;

procedure TFixedStringTable.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fFixedStringTableList.Clear;
end;

constructor TFixedStringTable.Create;
begin
  fFixedStringTableList := TList.Create;
end;

destructor TFixedStringTable.Destroy;
begin
  Clear;
  fFixedStringTableList.Free;
  inherited;
end;

function TFixedStringTable.GetCount: Integer;
begin
  Result := fFixedStringTableList.Count;
end;

function TFixedStringTable.GetItem(Index: Integer): TFixedStringTableItem;
begin
  Result := TFixedStringTableItem(fFixedStringTableList[Index]);
end;

{ TPointerTableItem }

constructor TPointerTableItem.Create;
begin
  fAddresses := TAddressList.Create;
end;

destructor TPointerTableItem.Destroy;
begin
  fAddresses.Free;
  inherited;
end;

{ TBinaryHeader }

procedure TBinaryHeader.Clear;
begin
  fVersion := gvUndef;
  fPlatformKind := pvUndef;
  fRegion := prUndef;
end;

initialization
  CoInitialize(nil);
  
end.
