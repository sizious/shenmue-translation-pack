//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

{
  Extracted from Shenmue II Subtitles Editor v4.2
  Modified by Manic
  Converted to a class by [big_fury]SiZiOUS
}

unit charslst;

interface

uses
  Classes, SysUtils, UIntList, Windows, Dialogs;

type
  TSubsCharsListEntry = class(TObject)
  private
    fCode: Integer;
    fCharacter: Char;
  public
    property Character: Char read fCharacter;
    property Code: Integer read fCode;
  end;

  TSubsCharsList = class(TObject)
  private
    fList: TList;
    fCharsListLoaded: Boolean;
    fActive: Boolean;
    fLoadedFileName: TFileName;
    procedure AddEntry(Character: Char; Code: Integer);
    procedure Clear;
    function GetItem(Index: Integer): TSubsCharsListEntry;
    function GetCount: Integer;
    procedure SetActive(const Value: Boolean);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSubsCharsListEntry read GetItem; default;
    function DecodeChar(C: Char): Char;
    function EncodeChar(C: Char): Char;
  public
    constructor Create;
    destructor Destroy; override;
    property Active: Boolean read fActive write SetActive;
    function EncodeSubtitle(Text: string): string;
    function DecodeSubtitle(Text: string): string;
    function LoadFromFile(FileName: TFileName): Boolean;
    property Loaded: Boolean read fCharsListLoaded;
    property LoadedFileName: TFileName read fLoadedFileName; 
  end;

implementation

uses
  CharsCnt, ScnfUtil;

{ TCharsList }

procedure TSubsCharsList.AddEntry(Character: Char; Code: Integer);
var
  Item: TSubsCharsListEntry;

begin
  Item := TSubsCharsListEntry.Create;
  Item.fCharacter := Character;
  Item.fCode := Code;
  fList.Add(Item);
end;

procedure TSubsCharsList.Clear;
var
  i: Integer;

begin
  for i := 0 to fList.Count - 1 do
    TSubsCharsListEntry(fList[i]).Free;
  fList.Clear;
end;

constructor TSubsCharsList.Create;
begin
  fList := TList.Create;
  fCharsListLoaded := False;
end;

function TSubsCharsList.DecodeChar(C: Char): Char;
var
  i: Integer;

begin
  Result := C;
  for i := 0 to Count - 1 do
    if Items[i].Code = Ord(C) then begin
      Result := Items[i].Character;
      Break;
    end;
end;

function TSubsCharsList.DecodeSubtitle(Text: string): string;
var
  i: Integer;

begin
  Result := Text;
  if (not Loaded) or (not Active) then Exit;

  Text := StringReplace(Text, TABLE_STR_CR, '<br>', [rfReplaceAll]);
  Text := StringReplace(Text, '=@', '...', [rfReplaceAll]);

  Result := '';
  for i := 1 to Length(Text) do
    Result := Result + DecodeChar(Text[i]);
end;

destructor TSubsCharsList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TSubsCharsList.EncodeChar(C: Char): Char;
var
  i: Integer;

begin
  Result := C;
  for i := 0 to Count - 1 do
    if Items[i].Character = C then begin
      Result := Chr(Items[i].Code);
      Break;
    end;
end;

function TSubsCharsList.EncodeSubtitle(Text: string): string;
var
  i: Integer;

begin
  Result := Text;
  if (not Loaded) or (not Active) then Exit;

  Result := '';
  for i := 1 to Length(Text) do
    Result := Result + EncodeChar(Text[i]);

  Result := StringReplace(Result, '<br>', TABLE_STR_CR, [rfReplaceAll]);
  Result := StringReplace(Result, #13#10, TABLE_STR_CR, [rfReplaceAll]);
  Result := StringReplace(Result, '...', '=@', [rfReplaceAll]);
end;

function TSubsCharsList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TSubsCharsList.GetItem(Index: Integer): TSubsCharsListEntry;
begin
  Result := TSubsCharsListEntry(fList[Index]);
end;

function TSubsCharsList.LoadFromFile(FileName: TFileName): Boolean;
var
  F:TextFile;
  mainLine: string;
  ChrCode: Integer;
  Chr: Char;

begin
  Result := False;
  if not FileExists(FileName) then Exit;
  fLoadedFileName := FileName;

  Clear;

  //Opening the file (probable chrlist1.csv or chrlist2.csv)
  AssignFile(F, FileName);
  Reset(F);

  // Reading all the lines
  repeat
    ReadLn(F, mainLine);
    if (mainLine <> '') and (mainLine[1] <> '#') then begin
      ChrCode := StrToInt(parse_section(';', mainLine, 0));
      Chr := AnsiDequotedStr(parse_section(';', mainLine, 1), '''')[1];
      AddEntry(Chr, ChrCode);
    end;
  until EOF(F);

  fCharsListLoaded := Count > 0;
  Result := fCharsListLoaded;

  CloseFile(F);
end;

procedure TSubsCharsList.SetActive(const Value: Boolean);
begin
  if not Loaded then Exit;  
  fActive := Value;
end;

end.
