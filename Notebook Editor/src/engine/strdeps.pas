(*
  TDiaryEditorStringsDependances

  See the comments below to know the goal of this class.
*)
unit StrDeps;

(* Please define this to enable the fast search algorithm, powered by the DCL.
   Really recommanded! *)
{$DEFINE USE_DCL}

interface

uses
  Windows, SysUtils, Classes 
  {$IFDEF USE_DCL}, HashIdx {$ENDIF};

type
  (* Contained in TDiaryEditorStringsDependances *)
  TPointerOffsetsList = class(TObject)
  private
    fItemsList: TList;
    fStringRelativeOffset: Integer;
    fIndex: Integer;
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
    property Index: Integer read fIndex;
    property StringRelativeOffset: Integer read fStringRelativeOffset;
  end;

  (*  This class is here to allow the dynamic-linking of some strings used in
      the memo.
      In fact some string in the memo are pointed by multi-offsets, that means
      you have only one string entry in the MSTR section but multi-offsets in
      the MEMO sections. Example: 'Hello', pointed by 0x0F and 0x10, that means
      we have two times 'Hello' shown in the UI.
      This class is here to update each pointers with the new string value. *)
  TDiaryEditorStringsDependances = class(TObject)
  private
{$IFDEF USE_DCL}
    fIndexOptimizer: THashIndexOptimizer;
{$ENDIF}
    fItemsList: TList;
    function GetCount: Integer;
    function GetItem(
      Index: Integer): TPointerOffsetsList;
  protected
{$IFDEF USE_DCL}
    property IndexOptimizer: THashIndexOptimizer read fIndexOptimizer;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const StringRelativeOffset: Integer; ItemEntry: Pointer;
      var NewItem: Boolean);
    procedure Clear;
    function IndexOf(const StringRelativeOffset: Integer;
      var ItemIndex: Integer): Boolean;
    procedure ExportToCSV(const FileName: TFileName);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPointerOffsetsList
      read GetItem; default;
  end;                           

implementation

uses
  MemoEdit;
  
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
  const StringRelativeOffset: Integer; ItemEntry: Pointer;
  var NewItem: Boolean);
var
  Index: Integer;
  Item: TPointerOffsetsList;
  ItemFound: Boolean;
  
begin
  NewItem := False;
  ItemFound := IndexOf(StringRelativeOffset, Index);

  // Adding a new StringRelativeOffset dependance entry to the list
  if not ItemFound then begin
    Item := TPointerOffsetsList.Create;
    Item.fStringRelativeOffset := StringRelativeOffset;
    Item.fIndex := fItemsList.Add(Item);
{$IFDEF USE_DCL}
    IndexOptimizer.Add(StringRelativeOffset, Item.Index);
{$ENDIF}
    NewItem := True;
  end else
    Item := Items[Index];

  // Adding the StringPointerOffset to the StringRelativeOffset entry
  Item.Add(ItemEntry);

(*{$IFDEF DEBUG}
  WriteLn('  #', Item.Index, ' ', Item.StringRelativeOffset, ': ',
    TDiaryEditorMessagesListItem(ItemEntry).Text);
{$ENDIF}*)
end;

procedure TDiaryEditorStringsDependances.Clear;
var
  i: Integer;
  
begin
  for i := 0 to fItemsList.Count - 1 do
    TPointerOffsetsList(fItemsList[i]).Free;
  fItemsList.Clear;
{$IFDEF USE_DCL}
  IndexOptimizer.Clear;
{$ENDIF}
end;

constructor TDiaryEditorStringsDependances.Create;
begin
  fItemsList := TList.Create;
{$IFDEF USE_DCL}
  fIndexOptimizer := THashIndexOptimizer.Create;
{$ENDIF}
end;

destructor TDiaryEditorStringsDependances.Destroy;
begin
  Clear;
  fItemsList.Free;
{$IFDEF USE_DCL}
  IndexOptimizer.Free;
{$ENDIF}
  inherited;
end;

procedure TDiaryEditorStringsDependances.ExportToCSV(const FileName: TFileName);
var
  i, j: Integer;
  Buffer: TStringList;
  Item: TPointerOffsetsList;

begin
  Buffer := TStringList.Create;
  try
    Buffer.Add('String Relative Offset (in MSTR section);' +
      'String Pointer Offset (in MEMO section)');
    for i := 0 to Count - 1 do begin
      Item := Items[i];
      for j := 0 to Item.Count - 1 do begin
        Buffer.Add(Format('%d;%d', [Items[i].StringRelativeOffset,
          TDiaryEditorMessagesListItem(Item[j]).StringPointerOffset]));
      end;
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
{$IFNDEF USE_DCL}
var
  MaxIndex: Integer;
{$ENDIF}

begin
{$IFDEF USE_DCL}
  // Use optimization HashMap

  ItemIndex := IndexOptimizer.IndexOf(StringRelativeOffset);
  Result := ItemIndex <> -1;
  
{$ELSE}

  // Classical loop (non-optimized)
  Result := False;
  ItemIndex := -1;
  MaxIndex := Count - 1;
  while not (Result or (ItemIndex = MaxIndex)) do begin
    Inc(ItemIndex);
    Result := Items[ItemIndex].StringRelativeOffset = StringRelativeOffset;
  end;

{$ENDIF}
end;

end.
