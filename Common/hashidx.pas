unit HashIdx;

interface

uses
  Windows, SysUtils, DCL_intf, HashMap;

type
  THashIndexOptimizer = class(TObject)
  private
    fOptimizationHashMap: IStrMap;
  public
    constructor Create;
    procedure Add(const Key: string; const Index: Integer);
    procedure Clear;
    function IndexOf(const Key: string): Integer;
  end;

implementation

type
  THashItemIndex = class(TObject)
  private
    fItemIndex: Integer;
    fStringKey: string;
  public
    property StringKey: string read fStringKey write fStringKey;
    property ItemIndex: Integer read fItemIndex write fItemIndex;
  end;
  
{ THashIndexOptimizer }

procedure THashIndexOptimizer.Add(const Key: string; const Index: Integer);
var
  HashItem: THashItemIndex;

begin
  HashItem := THashItemIndex.Create;
  with HashItem do begin
    StringKey := Key;
    ItemIndex := Index;
  end;
  fOptimizationHashMap.PutValue(Key, HashItem);
end;

procedure THashIndexOptimizer.Clear;
begin
  fOptimizationHashMap.Clear;
end;

constructor THashIndexOptimizer.Create;
begin
  fOptimizationHashMap := TStrHashMap.Create;
end;

function THashIndexOptimizer.IndexOf(const Key: string): Integer;
var
  HashItem: THashItemIndex;

begin
  Result := -1;
  HashItem := THashItemIndex(fOptimizationHashMap.GetValue(Key));
  if Assigned(HashItem) then
    Result := HashItem.ItemIndex;
end;

end.
