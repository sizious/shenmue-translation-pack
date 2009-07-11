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
  Windows, SysUtils, Classes, DCL_Intf, HashMap;

type
  // This object stores the FileName and subtitle Code where the subtitle text
  // aka the "key" of the hashmap was found.
  TTextDataItem = class(TObject)
  private
    fCode: string;
    fFileName: TFileName;
  protected
    function GetCode: string;
    function GetFileName: TFileName;
  public
    property Code: string read GetCode;
    property FileName: TFileName read GetFileName;
  end;

  ISubtitleInfoList = interface
  ['{75C8579B-4D5D-A9E2-8418-AEA75456791D}']
    procedure Add(Item: TTextDataItem); overload;
    procedure Add(const Code: string; const FileName: TFileName); overload;
    function Count: Integer;
    procedure Clear;
    function GetItem(Index: Integer): TTextDataItem;
    property Items[Index: Integer]: TTextDataItem read GetItem;
  end;

  TSubtitleInfoList = class(TInterfacedObject, ISubtitleInfoList)
  private
    fList: TList;
    procedure Add(Item: TTextDataItem); overload;
    procedure Add(const Code: string; const FileName: TFileName); overload;
    procedure Clear;
  protected
    function GetItem(Index: Integer): TTextDataItem;
  public
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    property Items[Index: Integer]: TTextDataItem read GetItem;
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
    function IsSubtitleExists(const Text: string): Boolean;
    function PutSubtitleInfo(const Text, Code: string; const FileName: TFileName): Boolean;
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

function TMultiTranslationTextData.PutSubtitleInfo(const Text, Code: string;
  const FileName: TFileName): Boolean;
var
  SubtitleInfoList: ISubtitleInfoList;
  TextDataItem: TTextDataItem;
  
begin
  Result := False;

  if not IsSubtitleExists(Text) then begin
    // add a new text subtitle inside the hash map and store the filename / sub code
    SubtitleInfoList := TSubtitleInfoList.Create;
    SubtitleInfoList.Add(Code, FileName);
    fHashMap.PutValue(Text, SubtitleInfoList);
    Result := True;
    // Adding the subtitle in the list
    fSubtitles.Add(Text);
{$IFDEF DEBUG} WriteLn('CREATING: "', Text, '", Code: "', Code, '", FileName: "', ExtractFileName(FileName), '"'); {$ENDIF}
  end else begin
    // add a new filename / sub code to an existing subtitle
    SubtitleInfoList := GetSubtitleInfo(Text);
    SubtitleInfoList.Add(Code, FileName);
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

procedure TSubtitleInfoList.Add(const Code: string; const FileName: TFileName);
var
  TextDataItem: TTextDataItem;

begin
  TextDataItem := TTextDataItem.Create;
  TextDataItem.fCode := Code;
  TextDataItem.fFileName := FileName;
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

end.
