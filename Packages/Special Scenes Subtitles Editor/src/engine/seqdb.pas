(*
  Sequence Database

  This class (TSequenceDatabase) was made to handle the file 'seqinfo.xml'
  which contains all the info needed for translating special MAPINFO.BIN files.
*)
unit SeqDB;

interface

uses
  Windows, SysUtils, Classes, XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX,
  SysTools, FileSpec;

type
  ESequenceDatabaseGeneric = class(Exception);

  TExtraPointersListItem = class
  private
    fOffset: LongWord;
    fInitialValue: LongWord;
  public
    property Offset: LongWord read fOffset;
    property Value: LongWord read fInitialValue;    
  end;

  TExtraPointersList = class
  private
    fList: TList;
    function Add(NewItem: TExtraPointersListItem): Integer;
    procedure Clear;
    function GetCount: Integer;
    function GetItem(Index: Integer): TExtraPointersListItem;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TExtraPointersListItem
      read GetItem; default;
  end;

  TPlaceHoldersListItem = class
  private
    fSize: LongWord;
    fOffset: LongWord;
  public
    property Offset: LongWord read fOffset;
    property Size: LongWord read fSize;
  end;
  
  TPlaceHoldersList = class
  private
    fList: TList;
    function Add(NewItem: TPlaceHoldersListItem): Integer;
    procedure Clear;
    function GetCount: Integer;
    function GetItem(Index: Integer): TPlaceHoldersListItem;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPlaceHoldersListItem
      read GetItem; default;
  end;

  TMemoryInformation = class
  private
    fExpandable: Boolean;
    fExtraPointersList: TExtraPointersList;
    fPlaceHolders: TPlaceHoldersList;
    fExpandablePlaceHolder: TPlaceHoldersListItem;
  public
    constructor Create;
    destructor Destroy; override;
    property Expandable: Boolean read fExpandable;
    property ExpandablePlaceHolder: TPlaceHoldersListItem
      read fExpandablePlaceHolder;
    property ExtraPointers: TExtraPointersList read fExtraPointersList;
    property PlaceHolders: TPlaceHoldersList read fPlaceHolders;
  end;

  TStringPointersListItem = class
  private
    fStringPointer: LongWord;
    fStringValue: string;
    fStringStartTag: string;
  public
    property StringStartTag: string read fStringStartTag;
    property StringPointer: LongWord read fStringPointer;
    property StringValue: string read fStringValue;
  end;

  TStringPointersList = class
  private
    fList: TList;
    function Add(NewItem: TStringPointersListItem): Integer;
    procedure Clear;
    function GetCount: Integer;
    function GetItem(Index: Integer): TStringPointersListItem;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TStringPointersListItem
      read GetItem; default;
  end;

  TSequenceSignature = class
  private
    fValue: TBytes;
    fOffset: LongWord;
  public
    property Offset: LongWord read fOffset;
    property Value: TBytes read fValue;
  end;

  TSequenceOriginalHeaderValues = class
  private
    fDataSize2: LongWord;
    fDataSize1: LongWord;
    fSize: LongWord;
  public
    property DataSize1: LongWord read fDataSize1;
    property DataSize2: LongWord read fDataSize2;
    property Size: LongWord read fSize;
  end;

  TSequenceDatabaseItem = class
  private
    fOriginalHeaderValues: TSequenceOriginalHeaderValues;
    fGame: TGameVersion;
    fPlatform: TPlatformVersion;
    fSequenceID: string;
    fRegion: TGameRegion;
    fDiscID: Byte;
    fSignature: TSequenceSignature;
    fStringPointersList: TStringPointersList;
    fMemoryInformation: TMemoryInformation;
  public
    constructor Create;
    destructor Destroy; override;
    property DiscID: Byte read fDiscID;
    property Game: TGameVersion read fGame;
    property OriginalHeaderValues: TSequenceOriginalHeaderValues
      read fOriginalHeaderValues;
    property MemoryInformation: TMemoryInformation
      read fMemoryInformation;
    property Platform: TPlatformVersion read fPlatform;
    property Region: TGameRegion read fRegion;
    property SequenceID: string read fSequenceID;
    property Signature: TSequenceSignature read fSignature;
    property StringPointers: TStringPointersList read
      fStringPointersList;
  end;

  TSequenceDatabase = class
  private
    fList: TList;
    fLoadedDatabase: TFileName;
    function Add(NewItem: TSequenceDatabaseItem): Integer;
    procedure Clear;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSequenceDatabaseItem;
  public
    constructor Create;
    destructor Destroy; override;
    function IdentifyFile(F: TFileStream): Integer; overload;
    function IdentifyFile(const SequenceFileName: TFileName): Integer; overload;
    function LoadDatabase(const FileName: TFileName): Boolean;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSequenceDatabaseItem
      read GetItem; default;
    property LoadedDatabase: TFileName read fLoadedDatabase;
  end;

implementation

{ TSequenceLibrary }

function TSequenceDatabase.Add;
begin
  Result := fList.Add(NewItem);
end;

procedure TSequenceDatabase.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TSequenceDatabase.Create;
begin
  fList := TList.Create;
end;

destructor TSequenceDatabase.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TSequenceDatabase.GetCount;
begin
  Result := fList.Count;
end;

function TSequenceDatabase.GetItem;
begin
  Result := TSequenceDatabaseItem(fList.Items[Index]);
end;

function TSequenceDatabase.IdentifyFile(
  const SequenceFileName: TFileName): Integer;
var
  F: TFileStream;

begin
  F := TFileStream.Create(SequenceFileName, fmOpenRead);
  try
    Result := IdentifyFile(F);
  finally
    F.Free;
  end;
end;

function TSequenceDatabase.IdentifyFile(F: TFileStream): Integer;
var
  Offset: Int64;
  Found: Boolean;
  i, Size: Integer;
  Item: TSequenceSignature;
  Buf: TBytes;

begin
  Offset := F.Position;

  Result := -1;
  Found := False;
  i := -1;
  while (not Found) and (i < Count - 1) do
  begin
    Inc(i);
    Item := Items[i].Signature;
    F.Seek(Item.Offset, soFromBeginning);
    Size := Length(Item.Value);
    SetLength(Buf, Size);
    F.Read(Buf[0], Size);
    Found := CompareMem(Buf, Item.Value, Size);
  end;

  if Found then
    Result := i;

  F.Seek(Offset, soFromBeginning);
end;

function TSequenceDatabase.LoadDatabase;
var
  XMLDocument: IXMLDocument;
  i, j: Integer;
  SequenceInfoNode, CurrentNode, CurrentSubNode: IXMLNode;
  SequenceInfoItem: TSequenceDatabaseItem;
  NodeList, SubNodeList: IXMLNodeList;
  StringPointerItem: TStringPointersListItem;
  PlaceHoldersItem: TPlaceHoldersListItem;
  ExpandablePlaceHolderDetected,
  ExpandablePlaceHolderDoubleEntryDetected: Boolean;
  GenericStringStartTag, Buf: string;
  ExtraPointersListItem: TExtraPointersListItem;
  
begin
  Result := FileExists(FileName);
  if not Result then Exit;
  XMLDocument := LoadXMLDocument(FileName);
  try
    fLoadedDatabase := FileName;
    try
      // Read the XML Content

      for i := 0 to XMLDocument.DocumentElement.ChildNodes.Count - 1 do
      begin
        SequenceInfoNode := XMLDocument.DocumentElement.ChildNodes[i];
        SequenceInfoItem := TSequenceDatabaseItem.Create;
        with SequenceInfoItem do
        begin
          // Read 'Signature' attributes
          Signature.fOffset :=
            ParseTextToValue(SequenceInfoNode.Attributes['Offset'], 0);
          ParseTextToByteArray(SequenceInfoNode.Attributes['Id'], Signature.fValue);

          // Read 'Identifier'
          NodeList :=
            SequenceInfoNode.ChildNodes.FindNode('Identifier').ChildNodes;
          fSequenceID := VariantToString(NodeList.FindNode('SequenceID').NodeValue);
          fDiscID := StrToIntDef(VariantToString(NodeList.FindNode('DiscID').NodeValue), 0);
          fGame := CodeStringToGameVersion(
            VariantToString(NodeList.FindNode('Game').NodeValue));
          fRegion := CodeStringToGameRegion(
            VariantToString(NodeList.FindNode('Region').NodeValue));
          fPlatform := CodeStringToPlatformVersion(
            VariantToString(NodeList.FindNode('Platform').NodeValue));

          // Read 'StringPointers'

          // Extract StringStartTag if applicable
          GenericStringStartTag := '';
          CurrentNode := SequenceInfoNode.ChildNodes.FindNode('StringPointers');
          Buf := VariantToString(CurrentNode.Attributes['StringStartTag']);
          if Buf <> '' then
          begin
            GenericStringStartTag := ParseTextToString(Buf);
          end;

          // Read StringPointer table
          NodeList := CurrentNode.ChildNodes;
          for j := 0 to NodeList.Count - 1 do
          begin
            CurrentNode := NodeList[j];
            StringPointerItem := TStringPointersListItem.Create;
            StringPointerItem.fStringValue :=
              CurrentNode.Attributes['String'];
            StringPointerItem.fStringPointer :=
              ParseTextToValue(CurrentNode.NodeValue, 0);

            // Handle String Start Tag.
            Buf := VariantToString(CurrentNode.Attributes['StartTag']);
            if Buf = '' then
              Buf := GenericStringStartTag;
            StringPointerItem.fStringStartTag := Buf;

            StringPointers.Add(StringPointerItem);
          end;

          // Read 'MemoryInformation' node
          CurrentNode :=
            SequenceInfoNode.ChildNodes.FindNode('MemoryInformation');

          // Check if MemoryInformation is Expandable or not.
          SequenceInfoItem.MemoryInformation.fExpandable :=
            ParseTextToBoolean(VariantToString(CurrentNode.Attributes['Expandable']));

          // If Expandable, then read ExpandablePlaceHolder and ExtraPointers if applicable
          if SequenceInfoItem.MemoryInformation.Expandable then begin
            // Read ExpandablePlaceHolder
            CurrentSubNode := CurrentNode.ChildNodes.FindNode('ExpandablePlaceHolder');
            with SequenceInfoItem.MemoryInformation.ExpandablePlaceHolder do begin
              fSize := ParseTextToValue(CurrentSubNode.Attributes['Size'], 0);
              fOffset := ParseTextToValue(CurrentSubNode.NodeValue, 0);
            end;

            // Read ExtraPointers if possible
            CurrentSubNode := CurrentNode.ChildNodes.FindNode('ExtraPointers');
            if Assigned(CurrentSubNode) then
            begin
              SubNodeList := CurrentSubNode.ChildNodes;
              if Assigned(SubNodeList) then
                for j := 0 to SubNodeList.Count - 1 do begin
                  ExtraPointersListItem := TExtraPointersListItem.Create;
                  with ExtraPointersListItem do begin
                    fOffset := ParseTextToValue(SubNodeList[j].NodeValue, 0);
                    fInitialValue := ParseTextToValue(SubNodeList[j].Attributes['Value'], 0);
                  end;
                  SequenceInfoItem.MemoryInformation.ExtraPointers.Add(
                    ExtraPointersListItem
                  );
                end;
            end;

          end else begin
            // MemoryInformation is NOT Expandable

            raise ESequenceDatabaseGeneric.Create('NEED TO BE TESTED!');
            
            NodeList := CurrentNode.ChildNodes.FindNode('PlaceHolders').ChildNodes;
            for j := 0 to NodeList.Count - 1 do
            begin
              CurrentNode := NodeList[j];
              PlaceHoldersItem := TPlaceHoldersListItem.Create;
              PlaceHoldersItem.fOffset :=
                ParseTextToValue(CurrentNode.Attributes['Offset'], 0);
              PlaceHoldersItem.fSize :=
                ParseTextToValue(CurrentNode.NodeValue, 0);
              SequenceInfoItem.MemoryInformation.PlaceHolders.Add(PlaceHoldersItem);
            end;
            
          end;

          // Read 'OriginalHeaderValues'
          NodeList :=
            SequenceInfoNode.ChildNodes.FindNode('OriginalHeaderValues').ChildNodes;
          with OriginalHeaderValues do
          begin
            fSize := ParseTextToValue(NodeList.FindNode('Size').NodeValue, 0);
            fDataSize1 := ParseTextToValue(NodeList.FindNode('DataSize1').NodeValue, 0);
            fDataSize2 := ParseTextToValue(NodeList.FindNode('DataSize2').NodeValue, 0);
          end;

          // Read 'SpecificCharset' don't know if it really needed or not
          // ...
                    
        end;

        // Add the current parsed 'SequenceFileInfo' element
        Add(SequenceInfoItem);
      end;

    except
      on E:Exception do
      begin
{$IFDEF DEBUG}
        WriteLn('LoadFromFile: ', E.Message);
{$ENDIF}
        Result := False;
      end;
    end;

  finally
    XMLDocument.Active := False;
    XMLDocument := nil;
  end;
end;

{ TSequenceInfoItem }

constructor TSequenceDatabaseItem.Create;
begin
  fSignature := TSequenceSignature.Create;
  fStringPointersList := TStringPointersList.Create;
  fOriginalHeaderValues := TSequenceOriginalHeaderValues.Create;
  fMemoryInformation := TMemoryInformation.Create;
end;

destructor TSequenceDatabaseItem.Destroy;
begin
  fSignature.Free;
  fStringPointersList.Free;
  fOriginalHeaderValues.Free;
  fMemoryInformation.Free;
  inherited;
end;

{ TStringPointersList }

function TStringPointersList.Add;
begin
  Result := fList.Add(NewItem);
end;

procedure TStringPointersList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TStringPointersList.Create;
begin
  fList := TList.Create;
end;

destructor TStringPointersList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TStringPointersList.GetCount;
begin
  Result := fList.Count;
end;

function TStringPointersList.GetItem;
begin
  Result := TStringPointersListItem(fList.Items[Index]);
end;

{ TPlaceHoldersList }

function TPlaceHoldersList.Add;
begin
  Result := fList.Add(NewItem);
end;

procedure TPlaceHoldersList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TPlaceHoldersList.Create;
begin
  fList := TList.Create;
end;

destructor TPlaceHoldersList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TPlaceHoldersList.GetCount;
begin
  Result := fList.Count;
end;

function TPlaceHoldersList.GetItem;
begin
  Result := TPlaceHoldersListItem(fList.Items[Index]);
end;

{ TExtraPointersList }

function TExtraPointersList.Add;
begin
  Result := fList.Add(Pointer(NewItem));
end;

procedure TExtraPointersList.Clear;
var
  i: Integer;

begin
  for i := 0 to fList.Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TExtraPointersList.Create;
begin
  fList := TList.Create;
end;

destructor TExtraPointersList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TExtraPointersList.GetCount;
begin
  Result := fList.Count;
end;

function TExtraPointersList.GetItem;
begin
  Result := TExtraPointersListItem(fList.Items[Index]);
end;

{ TMemoryInformation }

constructor TMemoryInformation.Create;
begin
  fExtraPointersList := TExtraPointersList.Create;
  fPlaceHolders := TPlaceHoldersList.Create;
  fExpandablePlaceHolder := TPlaceHoldersListItem.Create;
end;

destructor TMemoryInformation.Destroy;
begin
  fExtraPointersList.Free;
  fPlaceHolders.Free;
  fExpandablePlaceHolder.Free;
  inherited;
end;

initialization
  CoInitialize(nil);

end.
