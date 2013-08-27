//    This file is part of Shenmue AiO Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue AiO Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

(*
  Unit TextData

  This unit was developed for manage all the Multi-Translation process.

  The unit multiscan.pas will scan all PAKS files from the opened folder and
  every thing will be stored by this unit.

  The global structure of this unit is :

  [ TMultiTranslationTextData ]
     |
     +-- Key "Subtitle", Value "TSubtitleInfoList"
                         |
                         +-- [ TTextDataItem 1 ]
                         +-- [ TTextDataItem n ]
*)

unit textdata;

{$DEFINE USE_DCL}

interface

uses
  Windows, SysUtils, Classes, ScnfUtil, NPCInfo
  {$IFDEF USE_DCL}
  , DCL_Intf, HashMap
  {$ENDIF}
  ;

type
  // This object stores the FileName and subtitle Code where the subtitle text
  // aka the "key" of the hashmap was found.
  // This object is a TSubtitleInfoList entry item.
  TTextDataItem = class(TObject)
  private
    fCode: string;
    fFileName: TFileName;
    fGameVersion: TGameVersion;
    fGender: TGenderType;
  public
    procedure Assign(Source: TTextDataItem);
    property Code: string read fCode write fCode;
    property FileName: TFileName read fFileName write fFileName;
    property GameVersion: TGameVersion read fGameVersion write fGameVersion;
    property Gender: TGenderType read fGender write fGender;
  end;

  TMultiTranslationTextData = class;
  
  { This class is a TTextDataItem container. }
  TSubtitlesInfoList = class(TObject)
  private
    fTextDataList: TList;
    fNewSubtitle: string;
    fOwner: TMultiTranslationTextData;
    fSubtitleKey: string;
//    fIndex: Integer;
    procedure Add(Item: TTextDataItem); overload;
    procedure Clear;
  protected
    function GetTextDataItem(Index: Integer): TTextDataItem;
  public
    constructor Create(Owner: TMultiTranslationTextData);
    destructor Destroy; override;

    function Count: Integer;
    procedure Merge(SubtitlesInfoList: TSubtitlesInfoList);
    procedure Delete;
    
    property NewSubtitle: string read fNewSubtitle write fNewSubtitle;
    property SubtitleKey: string read fSubtitleKey;
    property Items[Index: Integer]: TTextDataItem read GetTextDataItem; default;
//    property Index: Integer read fIndex;
    property Owner: TMultiTranslationTextData read fOwner;
  end;

  { Main Class
    This class is TSubtitlesInfoList container. }
  TMultiTranslationTextData = class(TObject)
  private
    fSubtitleInfoList: TList;
{$IFDEF USE_DCL}
    fOptimizationHashMap: IStrMap;
{$ENDIF}
    function GetItemByInteger(Index: Integer): TSubtitlesInfoList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(const SubtitleKey: string; SubtitleInfo: TTextDataItem);
    
    procedure Clear;
    function Count: Integer;
    function IndexOfSubtitleKey(SubtitleKey: string): Integer;
    function FindBySubtitleKey(SubtitleKey: string): TSubtitlesInfoList;
    
{$IFDEF DEBUG}
    procedure SaveDump(const FileName: TFileName);
{$ENDIF}

    // Return the position of the NewSubtitleKey in the TextData list.
    function UpdateSubtitleKey(const SubtitleKey: string; NewSubtitleKey: string): Integer;

    property Subtitles[Index: Integer]: TSubtitlesInfoList read GetItemByInteger; default;
  end;

implementation

{$IFDEF DEBUG}

uses
  TypInfo;
  
{$ENDIF}

{$IFDEF USE_DCL}

type
  TTextDataIndexHashItem = class(TObject)
  private
    fItemIndex: Integer;
  public
    property ItemIndex: Integer read fItemIndex write fItemIndex;
  end;

{$ENDIF}

{ TMultiTranslationTextData }

procedure TMultiTranslationTextData.Add(const SubtitleKey: string;
  SubtitleInfo: TTextDataItem);
var
  Item: TSubtitlesInfoList;
{$IFDEF USE_DCL}
  Index: Integer;
  HashItem: TTextDataIndexHashItem;
{$ENDIF}

begin
  Item := FindBySubtitleKey(SubtitleKey);

  if not Assigned(Item) then begin
    // Adding new subtitle

    Item := TSubtitlesInfoList.Create(Self);

    Item.fNewSubtitle := SubtitleKey;
    Item.fSubtitleKey := SubtitleKey; // Original subtitle in encoded form (Shenmue charset) [not modified]
    Item.Add(SubtitleInfo);

    // Adding new TSubtitlesInfoList item to fSubtitleInfoList list
{$IFDEF USE_DCL}
    Index := fSubtitleInfoList.Add(Item);
    
    HashItem := TTextDataIndexHashItem.Create;
    HashItem.ItemIndex := Index;
    fOptimizationHashMap.PutValue(SubtitleKey, HashItem);
{$ELSE}
    fSubtitleInfoList.Add(Item);
{$ENDIF}

    // Saving item position
//    Item.fIndex := Index;

{$IFDEF DEBUG}
    WriteLn('CREATING: "', SubtitleKey, '"');
{$ENDIF}

  end else begin
    // Updating subtitle
    
    Item.Add(SubtitleInfo);

{$IFDEF DEBUG}
    WriteLn('UPDATING: "', SubtitleKey, '"');
{$ENDIF}
  end;
end;

procedure TMultiTranslationTextData.Clear;
var
  i: Integer;
  Item: TSubtitlesInfoList;

begin
  // Cleaning subtitles list
  for i := 0 to Count - 1 do
    if Assigned(fSubtitleInfoList[i]) then begin
      Item := TSubtitlesInfoList(fSubtitleInfoList[i]);
      Item.fSubtitleKey := ''; // workaround delphi bug... memory leaks!
      Item.Free;
    end;
  fSubtitleInfoList.Clear;

{$IFDEF USE_DCL}
  // Cleaning OptimizationHashMap
  fOptimizationHashMap.Clear;
{$ENDIF}
end;

constructor TMultiTranslationTextData.Create;
begin
{$IFDEF USE_DCL}
  fOptimizationHashMap := TStrHashMap.Create;
{$ENDIF}
  fSubtitleInfoList := TList.Create;
end;

destructor TMultiTranslationTextData.Destroy;
begin
  Clear;
  fSubtitleInfoList.Free;
  
  inherited Destroy;
end;

function TMultiTranslationTextData.Count: Integer;
begin
  Result := fSubtitleInfoList.Count;
end;

function TMultiTranslationTextData.GetItemByInteger(
  Index: Integer): TSubtitlesInfoList;
begin
  Result := TSubtitlesInfoList(fSubtitleInfoList.Items[Index]);
end;

function TMultiTranslationTextData.IndexOfSubtitleKey(
  SubtitleKey: string): Integer;
var
{$IFDEF USE_DCL}
  Obj: TTextDataIndexHashItem;
{$ELSE}
  Index: Integer;
{$ENDIF}

begin
  Result := -1;

{$IFDEF USE_DCL}

  Obj := TTextDataIndexHashItem(fOptimizationHashMap.GetValue(SubtitleKey));
  if Assigned(Obj) then
    Result := Obj.ItemIndex;

{$ELSE}

  for Index := 0 to Count - 1 do
    if Assigned(Subtitles[Index]) then
      if Subtitles[Index].SubtitleKey = SubtitleKey then
      begin
        Result := Index;
        Break;
      end;

{$ENDIF}
end;

{$IFDEF DEBUG}

procedure TMultiTranslationTextData.SaveDump(const FileName: TFileName);
var
  i, j: Integer;
  Buf: TStringList;
  Item: TTextDataItem;

begin
  Buf := TStringList.Create;
  try
    Buf.Add('SubtitleIndex;SubtitleKey;TextDataItemIndex;FileName;Code;GameVersion;Gender');

    for i := 0 to Count - 1 do
      for j := 0 to Subtitles[i].Count - 1 do begin
        Item := Subtitles[i].Items[j];
        Buf.Add(IntToStr(i) + ';' + Subtitles[i].SubtitleKey + ';'
          + IntToStr(j) + ';' + Item.FileName + ';' + Item.Code + ';'
          + GetEnumName(TypeInfo(TGameVersion), Ord(Item.GameVersion))
          + ';' + GetEnumName(TypeInfo(TGenderType), Ord(Item.Gender)));
      end;
      
    Buf.SaveToFile(FileName);
  finally
    Buf.Free;
  end;
end;

{$ENDIF}

function TMultiTranslationTextData.UpdateSubtitleKey(const SubtitleKey: string;
  NewSubtitleKey: string): Integer;
var
  SubtitleKeyIndex, NewSubtitleKeyIndex: Integer;
{$IFDEF USE_DCL}
  SubtitleKeyHash, NewSubtitleKeyHash: TTextDataIndexHashItem;
{$ENDIF}

begin
  Result := -1;
  SubtitleKeyIndex := IndexOfSubtitleKey(SubtitleKey);
  NewSubtitleKeyIndex := IndexOfSubtitleKey(NewSubtitleKey);

  if SubtitleKeyIndex <> -1 then begin

    if NewSubtitleKeyIndex = -1 then begin
      // The new value isn't in the array
      Subtitles[SubtitleKeyIndex].fSubtitleKey := NewSubtitleKey;
      Result := SubtitleKeyIndex;
      
{$IFDEF DEBUG}
      WriteLn('  REPLACING: SubtitleKey at Index = ', SubtitleKeyIndex);
{$ENDIF}

    end else begin
      // The new value is already in the array.
      // in Multi-Translation mode, we must update the CacheList.
      Subtitles[NewSubtitleKeyIndex].Merge(Subtitles[SubtitleKeyIndex]);
      Subtitles[SubtitleKeyIndex].Delete;
      Result := NewSubtitleKeyIndex;

{$IFDEF DEBUG}
      WriteLn('  MERGING: SubtitleKey at Index = ', SubtitleKeyIndex,
        ' with Index = ', NewSubtitleKeyIndex);
{$ENDIF}

    end;

{$IFDEF USE_DCL}
    SubtitleKeyHash := TTextDataIndexHashItem(fOptimizationHashMap.GetValue(SubtitleKey));
    if Assigned(SubtitleKeyHash) then begin
      // Removing old SubtitleKey entry from the HashMap
      // TIndexHashItem(fOptimizationHashMap.Remove(SubtitleKey)).Free; // BUG IN THE DCL THAT NOT FREE OBJECTS!!!
      TTextDataIndexHashItem(fOptimizationHashMap.GetValue(SubtitleKey)).ItemIndex := -1;
      
      // Checking if already exists NewText
      NewSubtitleKeyHash := TTextDataIndexHashItem(fOptimizationHashMap.GetValue(NewSubtitleKey));

      if not Assigned(NewSubtitleKeyHash) then begin
        // Adding new key
        NewSubtitleKeyHash := TTextDataIndexHashItem.Create;
        NewSubtitleKeyHash.ItemIndex := SubtitleKeyIndex;
        fOptimizationHashMap.PutValue(NewSubtitleKey, NewSubtitleKeyHash);
      end;
      
    end;
{$ENDIF}

  end;
end;

function TMultiTranslationTextData.FindBySubtitleKey(SubtitleKey: string): TSubtitlesInfoList;
var
  i: Integer;

begin
  Result := nil;
  
  i := IndexOfSubtitleKey(SubtitleKey);
  if i <> -1 then
    Result := Subtitles[i];
end;

{ TSubtitleInfoList }

procedure TSubtitlesInfoList.Add(Item: TTextDataItem);
begin
  fTextDataList.Add(Item);
end;

procedure TSubtitlesInfoList.Clear;
var
  i: Integer;

begin
  for i := 0 to fTextDataList.Count - 1 do
    TTextDataItem(fTextDataList[i]).Free;
  fTextDataList.Clear;
end;

function TSubtitlesInfoList.Count: Integer;
begin
  Result := fTextDataList.Count;
end;

constructor TSubtitlesInfoList.Create(Owner: TMultiTranslationTextData);
begin
  fOwner := Owner;
  fTextDataList := TList.Create;
end;

destructor TSubtitlesInfoList.Destroy;
begin
  Clear;
  fTextDataList.Free;
  inherited;
end;

function TSubtitlesInfoList.GetTextDataItem(Index: Integer): TTextDataItem;
begin
  Result := fTextDataList[Index];
end;

procedure TSubtitlesInfoList.Merge(SubtitlesInfoList: TSubtitlesInfoList);
var
  i: Integer;
  Item: TTextDataItem;

begin
  for i := 0 to SubtitlesInfoList.Count - 1 do begin
    Item := TTextDataItem.Create;
    Item.Assign(SubtitlesInfoList[i]);
    Add(Item);
  end;
end;

procedure TSubtitlesInfoList.Delete;
{ var
  Index: Integer; }

begin
  fSubtitleKey := '';
{  with Owner do begin
    Index := IndexOfSubtitleKey(SubtitleKey);
    if Index <> -1 then
      fSubtitleInfoList[Index] := nil;
  end;
  FreeAndNil(Self); }
end;

{ TTextDataItem }

procedure TTextDataItem.Assign(Source: TTextDataItem);
begin
  fCode := Source.fCode;
  fFileName := Source.fFileName;
  fGameVersion := Source.fGameVersion;
  fGender := Source.fGender;
end;

end.
