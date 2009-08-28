//    This file is part of Shenmue II Free Quest Subtitles Editor.
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

interface

uses
  Windows, SysUtils, Classes, DCL_Intf, HashMap, ScnfUtil;

type
  // This object stores the FileName and subtitle Code where the subtitle text
  // aka the "key" of the hashmap was found.
  TTextDataItem = class(TObject)
  private
    fCode: string;
    fFileName: TFileName;
    fGameVersion: TGameVersion;
  protected
    function GetCode: string;
    function GetFileName: TFileName;
  public
    property Code: string read GetCode;
    property FileName: TFileName read GetFileName;
    property GameVersion: TGameVersion read fGameVersion;
  end;

  ISubtitleInfoList = interface
  ['{75C8579B-4D5D-A9E2-8418-AEA75456791D}']
    procedure Add(Item: TTextDataItem); overload;
    procedure Add(const Code: string; const FileName: TFileName;
      const GameVersion: TGameVersion); overload;
    function Count: Integer;
    procedure Clear;

    function GetItem(Index: Integer): TTextDataItem;
    function GetNewSubtitle: string;
    procedure SetNewSubtitle(const Value: string);

    property Items[Index: Integer]: TTextDataItem read GetItem;
    property NewSubtitle: string read GetNewSubtitle write SetNewSubtitle;
  end;

  TSubtitleInfoList = class(TInterfacedObject, ISubtitleInfoList)
  private
    fList: TList;
    fNewSubtitle: string;
    procedure Add(Item: TTextDataItem); overload;
    procedure Add(const Code: string; const FileName: TFileName;
      const GameVersion: TGameVersion); overload;
    procedure Clear;
    function GetNewSubtitle: string;
    procedure SetNewSubtitle(const Value: string);
  protected
    function GetItem(Index: Integer): TTextDataItem;
  public
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    property Items[Index: Integer]: TTextDataItem read GetItem;
    property NewSubtitle: string read GetNewSubtitle write SetNewSubtitle;
  end;

  TMultiTranslationTextData = class
  private
    fHashMap: IStrIntfMap;
    fSubtitles: TStringList;
    function GetSubtitles: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function GetSubtitleInfo(const Text: string): ISubtitleInfoList;
{    function ModifySubtitle(SubIndexToModify: Integer;
      const NewSubtitle: string): Boolean;}
    function IsSubtitleExists(const Text: string): Boolean;
    function PutSubtitleInfo(const Text: string; const Code: string; const FileName: TFileName; const GameVersion: TGameVersion): Boolean;
    property Subtitles: TStringList read GetSubtitles;
  end;

implementation

{ TMultiTranslationTextData }

procedure TMultiTranslationTextData.Clear;
var
  Iterator: IIntfIterator;

begin
  // Retrieve the iterator to clear all SubtitleInfoList stored in the HashMap
  Iterator := fHashMap.Values.First;
  while Iterator.HasNext do
    ISubtitleInfoList(Iterator.Next).Clear;

  // Cleaning HashMap
  fHashMap.Clear;

  // Cleaning subtitles list
  fSubtitles.Clear;
end;

constructor TMultiTranslationTextData.Create;
begin
  fHashMap := TStrIntfHashMap.Create(16);
  fSubtitles := TStringList.Create;
end;

destructor TMultiTranslationTextData.Destroy;
begin
  Clear;
  fSubtitles.Free;
  inherited;
end;

function TMultiTranslationTextData.GetSubtitleInfo(const Text: string): ISubtitleInfoList;
begin
  Result := ISubtitleInfoList(fHashMap.GetValue(Text));
end;

function TMultiTranslationTextData.GetSubtitles: TStringList;
begin
  Result := fSubtitles;
end;

function TMultiTranslationTextData.IsSubtitleExists(const Text: string): Boolean;
begin
  Result := fHashMap.ContainsKey(Text);
end;

(*function TMultiTranslationTextData.ModifySubtitle(SubIndexToModify: Integer;
  const NewSubtitle: string): Boolean;
var
  OldSubtitle: string;
  SubtitleInfoList: ISubtitleInfoList;
  i: Integer;
  Item: TTextDataItem;

begin
  Result := False;

  // Get the old subtitle
  OldSubtitle := Subtitles[SubIndexToModify];
  Subtitles[SubIndexToModify] := NewSubtitle;
  if not IsSubtitleExists(OldSubtitle) then Exit;

  // Updating the hashmap
  SubtitleInfoList := GetSubtitleInfo(OldSubtitle);
  for i := 0 to SubtitleInfoList.Count - 1 do begin
    Item := SubtitleInfoList.Items[i];
    PutSubtitleInfo(NewSubtitle, Item.Code, Item.FileName);
  end;
  SubtitleInfoList.Clear;
//  TSubtitleInfoList(fHashMap.GetValue(OldSubtitle)).Free;

  // Removing the old subtitle from the hashmap
  SubtitleInfoList := ISubtitleInfoList(fHashMap.Remove(OldSubtitle));
  FreeAndNil(SubtitleInfoList);
end;*)

function TMultiTranslationTextData.PutSubtitleInfo(const Text: string;
  const Code: string; const FileName: TFileName;
  const GameVersion: TGameVersion): Boolean;
var
  SubtitleInfoList: ISubtitleInfoList;
//  TextDataItem: TTextDataItem;
  
begin
  Result := False;
  if Trim(Text) = '' then Exit;

  if not IsSubtitleExists(Text) then begin
    // add a new text subtitle inside the hash map and store the filename / sub code
    SubtitleInfoList := TSubtitleInfoList.Create;
    SubtitleInfoList.Add(Code, FileName, GameVersion);
    SubtitleInfoList.NewSubtitle := Text;
    fHashMap.PutValue(Text, SubtitleInfoList);
    Result := True;
    // Adding the subtitle in the list
    fSubtitles.Add(Text);
{$IFDEF DEBUG} WriteLn('CREATING: "', Text, '", Code: "', Code, '", FileName: "', ExtractFileName(FileName), '"'); {$ENDIF}
  end else begin
    // add a new filename / sub code to an existing subtitle
    SubtitleInfoList := GetSubtitleInfo(Text);
    SubtitleInfoList.Add(Code, FileName, GameVersion);
{$IFDEF DEBUG} WriteLn('UPDATING: "', Text, '", Code: "', Code, '", FileName: "', ExtractFileName(FileName), '"'); {$ENDIF}
  end;
end;

{ TTextDataItem }

function TTextDataItem.GetCode: string;
begin
  Result := Self.fCode;
end;

function TTextDataItem.GetFileName: TFileName;
begin
  Result := Self.fFileName;
end;

{ TSubtitleInfoList }

procedure TSubtitleInfoList.Add(Item: TTextDataItem);
begin
  fList.Add(Item);
end;

procedure TSubtitleInfoList.Add(const Code: string; const FileName: TFileName;
  const GameVersion: TGameVersion);
var
  TextDataItem: TTextDataItem;

begin
  TextDataItem := TTextDataItem.Create;
  TextDataItem.fCode := Code;
  TextDataItem.fFileName := FileName;
  TextDataItem.fGameVersion := GameVersion;
  Add(TextDataItem);
end;

procedure TSubtitleInfoList.Clear;
var
  i: Integer;

begin
  for i := 0 to fList.Count - 1 do
    TTextDataItem(fList[i]).Free;
  fList.Clear;
end;

function TSubtitleInfoList.Count: Integer;
begin
  Result := fList.Count;
end;

constructor TSubtitleInfoList.Create;
begin
  fList := TList.Create;
end;

destructor TSubtitleInfoList.Destroy;
begin
  fList.Clear;
  fList.Free;
  inherited;
end;

function TSubtitleInfoList.GetItem(Index: Integer): TTextDataItem;
begin
  Result := fList[Index];
end;

function TSubtitleInfoList.GetNewSubtitle: string;
begin
  Result := fNewSubtitle;
end;

procedure TSubtitleInfoList.SetNewSubtitle(const Value: string);
begin
  fNewSubtitle := Value;
end;

end.
