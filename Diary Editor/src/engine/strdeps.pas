unit StrDeps;

(* Please define this to enable the fast search algorithm, powered by the DCL.
   Really recommanded! *)
{$DEFINE USE_DCL}

interface

uses
  Windows, SysUtils, Classes
  {$IFDEF USE_DCL}, DCL_intf, HashMap {$ENDIF};

type
  TPointerOffsetsList = class(TObject)
  private
    fItemsList: TList;
    fStringRelativeOffset: Integer;
    function GetCount: Integer;
    function GetItem(Index: Integer): Pointer;
  protected
    procedure Add(P: Pointer);
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: Pointer read GetItem; default;
    property StringRelativeOffset: Integer read fStringRelativeOffset;
  end;

  TDiaryEditorStringsDependances = class(TObject)
  private
    fItemsList: TList;
    function GetCount: Integer;
    function GetItem(
      Index: Integer): TPointerOffsetsList;
  protected
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const StringRelativeOffset: Integer; ItemEntry: Pointer);
    function IndexOf(const StringRelativeOffset: Integer;
      var ItemIndex: Integer): Boolean;
    procedure ExportToCSV(const FileName: TFileName);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPointerOffsetsList
      read GetItem; default;
  end;

implementation

{ TStringPointerOffsetsList }

procedure TPointerOffsetsList.Add(P: Pointer);
begin
  fItemsList.Add(P);
end;

procedure TPointerOffsetsList.Clear;
begin
  fItemsList.Clear;
end;

constructor TPointerOffsetsList.Create;
begin
  fItemsList := TList.Create;
end;

destructor TPointerOffsetsList.Destroy;
begin
  Clear;
  fItemsList.Free;
  inherited;
end;

function TPointerOffsetsList.GetCount: Integer;
begin
  Result := fItemsList.Count;
end;

function TPointerOffsetsList.GetItem(Index: Integer): Pointer;
begin
  Result := fItemsList[Index];
end;

{ TDiaryEditorStringsDependances }

procedure TDiaryEditorStringsDependances.Add(
  const StringRelativeOffset: Integer; ItemEntry: Pointer);
var
  Index: Integer;
  Item: TPointerOffsetsList;
  ItemFound: Boolean;
  
begin
  ItemFound := IndexOf(StringRelativeOffset, Index);

  // Adding a new StringRelativeOffset dependance entry to the list
  if not ItemFound then begin
    Item := TPointerOffsetsList.Create;
    Item.fStringRelativeOffset := StringRelativeOffset;
    fItemsList.Add(Item);
  end else
    Item := Items[Index];

  // Adding the StringPointerOffset to the StringRelativeOffset entry
  Item.Add(ItemEntry);
end;

procedure TDiaryEditorStringsDependances.Clear;
var
  i: Integer;
  
begin
  for i := 0 to fItemsList.Count - 1 do
    TPointerOffsetsList(fItemsList[i]).Free;
  fItemsList.Clear;
end;

constructor TDiaryEditorStringsDependances.Create;
begin
  fItemsList := TList.Create;
end;

destructor TDiaryEditorStringsDependances.Destroy;
begin
  Clear;
  fItemsList.Free;
  inherited;
end;

procedure TDiaryEditorStringsDependances.ExportToCSV(const FileName: TFileName);
var
  i, j: Integer;
  Buffer: TStringList;

begin
  Buffer := TStringList.Create;
  try
    Buffer.Add('String Relative Offset (in MSTR section);' +
      'String Pointer Offset (in MEMO section)');
    for i := 0 to Count - 1 do
      for j := 0 to Items[i].Count - 1 do begin
        Buffer.Add(Format('%d;%d', [Items[i].StringRelativeOffset,
          Items[i][j]]));
      end;
    Buffer.SaveToFile(FileName);
  finally
    Buffer.Free;
  end;
end;

function TDiaryEditorStringsDependances.GetCount: Integer;
begin
  Result := fItemsList.Count;
end;

function TDiaryEditorStringsDependances.GetItem(
  Index: Integer): TPointerOffsetsList;
begin
  Result := TPointerOffsetsList(fItemsList[Index]);
end;

function TDiaryEditorStringsDependances.IndexOf(
  const StringRelativeOffset: Integer; var ItemIndex: Integer): Boolean;
var
  MaxIndex: Integer;

begin
  Result := False;

  // Classical loop (non-optimized)
  ItemIndex := -1;
  MaxIndex := Count - 1;
  while not (Result or (ItemIndex = MaxIndex)) do begin
    Inc(ItemIndex);
    Result := Items[ItemIndex].StringRelativeOffset = StringRelativeOffset;
  end;
  
end;

end.
