//    This file is part of Shenmue AiO Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit npcinfo;

interface

uses
  Windows, SysUtils, Classes, ScnfUtil;
  
type
  TGenderType = (gtUndef, gtMale, gtFemale);
  TAgeType = (atUndef, atAdult, atChild);

  // This class implements an entry in the TNPCInfosTable.
  // It contains every infos on a CharID (Gender / AgeType).
  TNPCInfosTableEntry = class
  private
    fAgeType: TAgeType;
    fGender: TGenderType;
    fCharID: string;
    fGameVersion: TGameVersion;
  public
    property CharID: string read fCharID;
    property Gender: TGenderType read fGender;
    property AgeType: TAgeType read fAgeType;
    property GameVersion: TGameVersion read fGameVersion;
  end;

  // Main class
  // This class implements all entries read from the CSV file
  // It contains every TNPCInfosTableEntry for each NPC character.
  TNPCInfosTable = class
  private
    fList: TList;
    fCharsInfoLoaded: Boolean;
    fLoadedFileName: TFileName;
    function GetItem(Index: Integer): TNPCInfosTableEntry;
    function GetCount: Integer;
  protected
    procedure AddEntry(GameVersion: TGameVersion; CharID: string; Gender: TGenderType;
      AgeType: TAgeType);
    function StringToGameVersion(const GameVersion: string): TGameVersion;
    function CharToGenderType(const Age: Char): TGenderType;
    function CharToAgeType(const Gender: Char): TAgeType;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    function GetInfosFromCharID(const CharID: string; GameVersion: TGameVersion): Integer;
    function LoadFromFile(const FileName: TFileName): Boolean; overload;
    function LoadFromFile(const FileName: TFileName;
      const ContainsTitleLine: Boolean): Boolean; overload;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TNPCInfosTableEntry read GetItem; default;
    property Loaded: Boolean read fCharsInfoLoaded;
    property LoadedFileName: TFileName read fLoadedFileName;
  end;

implementation

{ TCharIdInfosTable }

uses
  CharsCnt;
  
procedure TNPCInfosTable.AddEntry(GameVersion: TGameVersion; CharID: string;
  Gender: TGenderType; AgeType: TAgeType);
var
  Item: TNPCInfosTableEntry;
  
begin
  Item := TNPCInfosTableEntry.Create;
  Item.fCharID := CharID;
  Item.fGender := Gender;
  Item.fAgeType := AgeType;
  Item.fGameVersion := GameVersion;
  fList.Add(Item);
end;

function TNPCInfosTable.CharToAgeType(const Gender: Char): TAgeType;
begin
  Result := atUndef;
  case Gender of
    'A': Result := atAdult;
    'C': Result := atChild;
  end;
end;

function TNPCInfosTable.CharToGenderType(const Age: Char): TGenderType;
begin
  Result := gtUndef;
  case Age of
    'M': Result := gtMale;
    'F': Result := gtFemale;
  end;
end;

procedure TNPCInfosTable.Clear;
var
  i: Integer;

begin
  for i := 0 to fList.Count - 1 do
    TNPCInfosTableEntry(fList.Items[i]).Free;
  fList.Clear;
end;

constructor TNPCInfosTable.Create;
begin
  fList := TList.Create;
end;

destructor TNPCInfosTable.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TNPCInfosTable.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TNPCInfosTable.GetInfosFromCharID(const CharID: string; GameVersion: TGameVersion): Integer;
var
  i: Integer;

begin
  Result := -1;

  // Shenmue2X, Shenmue2J and Shenmue2 has same NPC characters
  if (GameVersion = gvShenmue2X) or (GameVersion = gvShenmue2J) then
    GameVersion := gvShenmue2;

  // ShenmueJ and Shenmue has same NPC characters
  if GameVersion = gvShenmueJ then
    GameVersion := gvShenmue;

  for i := 0 to Count - 1 do
    if ((UpperCase(Items[i].CharID) = UpperCase(CharID))
      and (Items[i].GameVersion = GameVersion)) then begin
      Result := i;
      Break;
    end;
end;

function TNPCInfosTable.GetItem(Index: Integer): TNPCInfosTableEntry;
begin
  Result := TNPCInfosTableEntry(fList.Items[Index]);
end;

function TNPCInfosTable.LoadFromFile(const FileName: TFileName): Boolean;
begin
  Result := LoadFromFile(FileName, True);
end;

function TNPCInfosTable.LoadFromFile(const FileName: TFileName; const ContainsTitleLine: Boolean): Boolean;
var
  F:TextFile;
  mainLine: string;
  GameVer, ChrCode: string;
  Gender, AgeType: Char;
  FirstLine: Boolean;
  GV: TGameVersion;
  
begin
  Result := False;
  if not FileExists(FileName) then Exit;
  fLoadedFileName := FileName;

  Clear;

  //Opening the file
  AssignFile(F, FileName);
  Reset(F);

  // Reading all the lines
  FirstLine := True;
  repeat
    ReadLn(F, mainLine);
    if (mainLine <> '') and (mainLine[1] <> '#') then begin

      if not (FirstLine and ContainsTitleLine) then begin
        try
          GameVer := parse_section(';', mainLine, 0);
          ChrCode := parse_section(';', mainLine, 1);
          Gender := parse_section(';', mainLine, 2)[1];
          AgeType := parse_section(';', mainLine, 3)[1];
        except
          Gender := 'U';
          AgeType := 'U';
        end;

        // Adding entry if the game version is recognised
        // SM1: gvShenmue
        // SM2: gvShenmue2 and gvShenmue2X
        // WSM: gvWhatsShenmue
        GV := StringToGameVersion(GameVer);
        if GV <> gvUndef then
          AddEntry(GV, ChrCode, CharToGenderType(Gender), CharToAgeType(AgeType));
      end;

      FirstLine := False;
    end;
  until EOF(F);

  fCharsInfoLoaded := Count > 0;
  Result := fCharsInfoLoaded;

  CloseFile(F);
end;

function TNPCInfosTable.StringToGameVersion(
  const GameVersion: string): TGameVersion;
begin
  Result := gvUndef;
  if UpperCase(GameVersion) = 'SM1' then
    Result := gvShenmue
  else
    if UpperCase(GameVersion) = 'WSM' then
      Result := gvWhatsShenmue
    else
      if UpperCase(GameVersion) = 'SM2' then
        Result := gvShenmue2;
end;

end.
