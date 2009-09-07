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
    property Code: string read fCode write fCode;
    property FileName: TFileName read fFileName write fFileName;
    property GameVersion: TGameVersion read fGameVersion write fGameVersion;
    property Gender: TGenderType read fGender write fGender;
  end;

  { This class is a TTextDataItem container. }
  TSubtitlesInfoList = class(TObject)
  private
    fTextDataList: TList;
    fNewSubtitle: string;
    fSubtitleKey: string;
    procedure Add(Item: TTextDataItem); overload;
    procedure Clear;
  protected
    function GetTextDataItem(Index: Integer): TTextDataItem;
  public
    constructor Create;
    destructor Destroy; override;

    function Count: Integer;

    property NewSubtitle: string read fNewSubtitle write fNewSubtitle;
    property SubtitleKey: string read fSubtitleKey;
    property Items[Index: Integer]: TTextDataItem read GetTextDataItem; default;
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
    function FindBySubtitleKey(SubtitleKey: string): TSubtitlesInfoList;
    function UpdateSubtitleKey(const Text: string; NewText: string): Boolean;

    property Subtitles[Index: Integer]: TSubtitlesInfoList read GetItemByInteger; default;
  end;

implementation

{$IFDEF USE_DCL}

type
  TIndexHashItem = class(TObject)
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
  HashItem: TIndexHashItem;
{$ENDIF}

begin
  Item := FindBySubtitleKey(SubtitleKey);

  if not Assigned(Item) then begin
    // Adding new subtitle

    Item := TSubtitlesInfoList.Create;

    Item.fNewSubtitle := SubtitleKey;
    Item.fSubtitleKey := SubtitleKey; // Original subtitle in encoded form (Shenmue charset) [not modified]
    Item.Add(SubtitleInfo);

{$IFDEF USE_DCL}

    Index := fSubtitleInfoList.Add(Item);
    
    HashItem := TIndexHashItem.Create;
    HashItem.ItemIndex := Index;
    fOptimizationHashMap.PutValue(SubtitleKey, HashItem);

{$ELSE}

    fSubtitleInfoList.Add(Item);

{$ENDIF}

    {$IFDEF DEBUG} WriteLn('CREATING: "', SubtitleKey, '"'); {$ENDIF}
  end else begin
    // Updating subtitle
    
    Item.Add(SubtitleInfo);
    {$IFDEF DEBUG} WriteLn('UPDATING: "', SubtitleKey, '"'); {$ENDIF}
  end;
end;

procedure TMultiTranslationTextData.Clear;
var
  i: Integer;

begin
{$IFDEF USE_DCL}
  // Cleaning OptimizationHashMap
  fOptimizationHashMap.Clear;
{$ENDIF}

  // Cleaning subtitles list
  for i := 0 to Count - 1 do
    TSubtitlesInfoList(fSubtitleInfoList[i]).Free;
  fSubtitleInfoList.Clear;
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

function TMultiTranslationTextData.UpdateSubtitleKey(const Text: string;
  NewText: string): Boolean;
begin
  raise Exception.Create('TO DO');
end;

function TMultiTranslationTextData.FindBySubtitleKey(SubtitleKey: string): TSubtitlesInfoList;
var
  Index: Integer;
{$IFDEF USE_DCL}
  Obj: TIndexHashItem;
{$ENDIF}
  
begin
  Result := nil;

{$IFDEF USE_DCL}

  Obj := TIndexHashItem(fOptimizationHashMap.GetValue(SubtitleKey));
  if Assigned(Obj) then begin
    Index := Obj.ItemIndex;
    Result := Subtitles[Index];
  end;

{$ELSE}

  for Index := 0 to Count - 1 do
    if Subtitles[Index].SubtitleKey = SubtitleKey then
    begin
      Result := Subtitles[Index];
      Break;
    end;

{$ENDIF}
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

constructor TSubtitlesInfoList.Create;
begin
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

end.
