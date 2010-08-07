unit HashIdx;

interface

uses
  Windows, SysUtils, DCL_intf, HashMap;

type
  THashItemIndex = class(TObject)
  private
    fItemIndex: Integer;
    fStringKey: string;
  public
    property StringKey: string read fStringKey write fStringKey;
    property ItemIndex: Integer read fItemIndex write fItemIndex;
  end;

  THashIndexOptimizer = class(TObject)
  private
    fOptimizationHashMap: IStrMap;
    function GetValue(const Key: string; var ResultObj: THashItemIndex): Boolean;
    function Update(const Key: string; ItemIndex: Integer): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const Key: string; const Index: Integer); overload;
    procedure Add(const Key, Index: Integer); overload;
    procedure Clear;
    function Delete(const Key: string): Boolean; overload;
    function Delete(const Key: Integer): Boolean; overload;
    function IndexOf(const Key: string): Integer; overload;
    function IndexOf(const Key: Integer): Integer; overload;
  end;

implementation

{ THashIndexOptimizer }

procedure THashIndexOptimizer.Add(const Key: string; const Index: Integer);
var
  HashItem: THashItemIndex;

begin
  if not GetValue(Key, HashItem) then begin
    // The item is not present in the hash map.
    HashItem := THashItemIndex.Create;
    with HashItem do begin
      StringKey := Key;
      ItemIndex := Index;
    end;
    fOptimizationHashMap.PutValue(Key, HashItem);
  end else begin
    // The item is in the hash map. Update the ItemIndex value.
    Update(Key, Index);
  end;
end;

procedure THashIndexOptimizer.Add(const Key, Index: Integer);
begin
  Add(IntToStr(Key), Index);
end;

procedure THashIndexOptimizer.Clear;
begin
  fOptimizationHashMap.Clear;
end;

constructor THashIndexOptimizer.Create;
begin
  fOptimizationHashMap := TStrHashMap.Create;
end;

function THashIndexOptimizer.Delete(const Key: string): Boolean;
begin
// fOptimizationHashMap.Remove(Key);   // THIS SHIT DON'T WORK!!
  Result := Update(Key, -1);
end;

function THashIndexOptimizer.Delete(const Key: Integer): Boolean;
begin
  Result := Delete(IntToStr(Key));
end;

destructor THashIndexOptimizer.Destroy;
begin
  Clear;
  inherited;
end;

function THashIndexOptimizer.GetValue(const Key: string;
  var ResultObj: THashItemIndex): Boolean;
begin
  ResultObj := THashItemIndex(fOptimizationHashMap.GetValue(Key));
  Result := Assigned(ResultObj);
end;

function THashIndexOptimizer.IndexOf(const Key: Integer): Integer;
begin
  Result := IndexOf(IntToStr(Key));
end;

function THashIndexOptimizer.Update(const Key: string; ItemIndex: Integer): Boolean;
var
  HashItem: THashItemIndex;
  
begin
  Result := GetValue(Key, HashItem);
  if Result then
    HashItem.ItemIndex := ItemIndex;
end;

function THashIndexOptimizer.IndexOf(const Key: string): Integer;
var
  HashItem: THashItemIndex;

begin
  Result := -1;
  if GetValue(Key, HashItem) then
    Result := HashItem.ItemIndex;
end;

end.
