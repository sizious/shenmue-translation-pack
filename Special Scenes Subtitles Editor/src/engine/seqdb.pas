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

  TStringPointersListItem = class
  private
    fStringPointer: LongWord;
    fStringValue: string;
  public
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

  TSequenceDatabaseItem = class
  private
    fGame: TGameVersion;
    fPlatform: TPlatformVersion;
    fSequenceID: string;
    fRegion: TGameRegion;
    fDiscID: Byte;
    fSignature: TSequenceSignature;
    fStringPointersList: TStringPointersList;
    fPlaceHolders: TPlaceHoldersList;
  public
    constructor Create;
    destructor Destroy; override;
    property DiscID: Byte read fDiscID;
    property Game: TGameVersion read fGame;
    property Platform: TPlatformVersion read fPlatform;
    property Region: TGameRegion read fRegion;
    property SequenceID: string read fSequenceID;
    property Signature: TSequenceSignature read fSignature;
    property StringPointers: TStringPointersList read
      fStringPointersList;
    property PlaceHolders: TPlaceHoldersList read
      fPlaceHolders;
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
  SequenceInfoNode: IXMLNode;
  SequenceInfoItem: TSequenceDatabaseItem;
  NodeList: IXMLNodeList;
  StringPointerItem: TStringPointersListItem;
  PlaceHoldersItem: TPlaceHoldersListItem;

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
          NodeList :=
            SequenceInfoNode.ChildNodes.FindNode('StringPointers').ChildNodes;
          for j := 0 to NodeList.Count - 1 do
          begin
            StringPointerItem := TStringPointersListItem.Create;
            StringPointerItem.fStringValue :=
              NodeList[j].Attributes['String'];
            StringPointerItem.fStringPointer :=
              ParseTextToValue(NodeList[j].NodeValue, 0);
            StringPointers.Add(StringPointerItem);
          end;

          // Read 'PlaceHolders'
          NodeList :=
            SequenceInfoNode.ChildNodes.FindNode('PlaceHolders').ChildNodes;
          for j := 0 to NodeList.Count - 1 do
          begin
            PlaceHoldersItem := TPlaceHoldersListItem.Create;
            PlaceHoldersItem.fOffset :=
              ParseTextToValue(NodeList[j].Attributes['Offset'], 0);
            PlaceHoldersItem.fSize :=
              ParseTextToValue(NodeList[j].Attributes['Size'], 0);
            PlaceHolders.Add(PlaceHoldersItem);
          end;
                    
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
  fPlaceHolders := TPlaceHoldersList.Create;
end;

destructor TSequenceDatabaseItem.Destroy;
begin
  fSignature.Free;
  fStringPointersList.Free;
  fPlaceHolders.Free;
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

initialization
  CoInitialize(nil);

end.
