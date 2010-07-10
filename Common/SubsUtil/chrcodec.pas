(*
  This file is part of Shenmue Translation Pack.

  You should have received a copy of the GNU General Public License along with
  this file. If not, see <http://www.gnu.org/licenses/>.
*)

(*
  Shenmue <-> Windows Characters Set Encoder/Decoder

  Extracted from Shenmue II Subtitles Editor v4.2
  Original code is (C) Manic
  Extended remake class code is (C) [big_fury]SiZiOUS

  The main class to use is "TShenmueCharsetCodec".
*)

unit ChrCodec;

(* Please define this to enable the fast search algorithm, powered by the DCL.
   Really recommanded! *)
{$DEFINE USE_DCL}

interface

uses
  Windows, SysUtils, Classes {$IFDEF USE_DCL}, HashIdx {$ENDIF};

type
  TCharsetListItem = class(TObject)
  private
    fWindowsCode: string;
    fShenmueCode: string;
  public
    property WindowsCode: string read fWindowsCode;
    property ShenmueCode: string read fShenmueCode;
  end;

  TTranslateOperation = (toEncode, toDecode);
  
  TCharsetList = class(TObject)
  private
{$IFDEF USE_DCL}
    fShenmueCodeFastHashMap: THashIndexOptimizer;
    fWindowsCodeFastHashMap: THashIndexOptimizer;
{$ENDIF}
    fList: TList;
    fWindowsCodeMaxLength: Integer;
    fShenmueCodeMaxLength: Integer;
    function GetCount: Integer;
    function GetItem(Index: Integer): TCharsetListItem;
  protected
    procedure Add(ShenmueCode, WindowsCode: string);
    function BytesToString(const EncodedString: string): string;    
    procedure Clear;
    function TranslateChar(Operation: TTranslateOperation;
      const EncodedChar: string; var DecodedChar: string): Boolean;
    function TranslateString(Operation: TTranslateOperation;
      const S: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TCharsetListItem read GetItem; default;
  end;

  TShenmueCharsetCodec = class(TObject)
  private
    fCharset: TCharsetList;
    fCharsListLoaded: Boolean;
    fActive: Boolean;
    fLoadedFileName: TFileName;
    procedure SetActive(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    property Active: Boolean read fActive write SetActive;
    function Encode(WindowsText: string): string;
    function Decode(ShenmueText: string): string;
    function LoadFromFile(FileName: TFileName; AutoActive: Boolean): Boolean; overload;
    function LoadFromFile(FileName: TFileName): Boolean; overload;
    property Charset: TCharsetList read fCharset;    
    property Loaded: Boolean read fCharsListLoaded;
    property SourceFileName: TFileName read fLoadedFileName; 
  end;

function IsJapaneseString(const S: string): Boolean;

implementation

uses
  SysTools;

{$IFDEF USE_DCL}

(*
type
  TCodeIndexHashItem = class(TObject)
  private
    fItemIndex: Integer;
    fCode: string;
  public
    property Code: string read fCode write fCode;
    property ItemIndex: Integer read fItemIndex write fItemIndex;
  end;
*)

{$ENDIF}

function IsJapaneseString(const S: string): Boolean;
var
  i: Integer;
  
begin
  Result := False;
  if S <> '' then
    for i := 1 to Length(S) do
      Result := Result or (S[i] in [#$A4, #$B6, #$A5, #$BB]);
end;

{ TShenmueCharsetCodec }

constructor TShenmueCharsetCodec.Create;
begin
  fCharset := TCharsetList.Create;
  fActive := False;
  fCharsListLoaded := False;
end;

function TShenmueCharsetCodec.Decode(ShenmueText: string): string;
begin
  if Active then  
    Result := Charset.TranslateString(toDecode, ShenmueText)
  else
    Result := ShenmueText;
end;

destructor TShenmueCharsetCodec.Destroy;
begin
  fCharset.Free;
  inherited;
end;

function TShenmueCharsetCodec.Encode(WindowsText: string): string;
begin
  if Active then
    Result := Charset.TranslateString(toEncode, WindowsText)
  else
    Result := WindowsText;
end;

function TShenmueCharsetCodec.LoadFromFile(FileName: TFileName): Boolean;
begin
  Result := LoadFromFile(FileName, True);
end;


function TShenmueCharsetCodec.LoadFromFile(FileName: TFileName;
  AutoActive: Boolean): Boolean;
var
  F: TextFile;
  MainLine, ShenmueCode, WindowsCode: string;

begin
  Result := False;
  if not FileExists(FileName) then Exit;
  fLoadedFileName := FileName;
  fActive := False;

  Charset.Clear;

  // Opening the file (probable chrlist1.csv or chrlist2.csv)
  AssignFile(F, FileName);
  Reset(F);

  // Reading all the lines
  repeat
    ReadLn(F, mainLine);               

    if (mainLine <> '') and (mainLine[1] <> '''') then begin
      ShenmueCode := AnsiDequotedStr(ParseStr(';', mainLine, 0), '"');
      WindowsCode := AnsiDequotedStr(ParseStr(';', mainLine, 1), '"');
      Charset.Add(ShenmueCode, WindowsCode);
    end;

  until EOF(F);

  fCharsListLoaded := (Charset.Count > 0);
  Result := fCharsListLoaded;

  // Auto-enable the codec
  Active := AutoActive;

  // Closing file
  CloseFile(F);
end;

procedure TShenmueCharsetCodec.SetActive(const Value: Boolean);
begin
  fActive := Value and Loaded;
end;

{ TCharsetList }

procedure TCharsetList.Add(ShenmueCode, WindowsCode: string);
var
  Item: TCharsetListItem;
  CodeLength: Integer;
{$IFDEF USE_DCL}
  Index: Integer;
//  HashItem: TCodeIndexHashItem;
{$ENDIF}

begin
  ShenmueCode := BytesToString(ShenmueCode);
  WindowsCode := BytesToString(WindowsCode);
  
  // Adding the new item to the Charset
  Item := TCharsetListItem.Create;
  Item.fWindowsCode := WindowsCode;
  Item.fShenmueCode := ShenmueCode;

{$IFDEF USE_DCL}
  Index := {$ENDIF} fList.Add(Item);

{$IFDEF USE_DCL}
  // Adding the ShenmueCode in the HashMap
(*  HashItem := TCodeIndexHashItem.Create;
  with HashItem do begin
    Code := Item.WindowsCode;
    ItemIndex := Index;
  end;
  fWindowsCodeFastHashMap.PutValue(Item.WindowsCode, HashItem); *)
  fWindowsCodeFastHashMap.Add(Item.WindowsCode, Index);

  // Adding the WindowsCode in the HashMap
(*  HashItem := TCodeIndexHashItem.Create;
  with HashItem do begin
    Code := Item.ShenmueCode;
    ItemIndex := Index;
  end;
  fShenmueCodeFastHashMap.PutValue(Item.ShenmueCode, HashItem);*)
  fShenmueCodeFastHashMap.Add(Item.ShenmueCode, Index);
{$ENDIF}

  // Calculating the ShenmueCode Max Length
  CodeLength := Length(ShenmueCode);
  if CodeLength > fShenmueCodeMaxLength then
    fShenmueCodeMaxLength := CodeLength;

  // Calculating the WindowsCode Max Length
  CodeLength := Length(WindowsCode);
  if CodeLength > fWindowsCodeMaxLength then
    fWindowsCodeMaxLength := CodeLength;
end;

procedure TCharsetList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TCharsetListItem(fList[i]).Free;
  fList.Clear;
  fShenmueCodeMaxLength := 0;
  fWindowsCodeMaxLength := 0;
  
{$IFDEF USE_DCL}
  fShenmueCodeFastHashMap.Clear;
  fWindowsCodeFastHashMap.Clear;
{$ENDIF}
end;

constructor TCharsetList.Create;
begin
  fList := TList.Create;
  
{$IFDEF USE_DCL}
  fShenmueCodeFastHashMap := THashIndexOptimizer.Create;
  fWindowsCodeFastHashMap := THashIndexOptimizer.Create;
{$ENDIF}  
end;

function TCharsetList.TranslateChar(Operation: TTranslateOperation;
  const EncodedChar: string; var DecodedChar: string): Boolean;
var
  ItemIndex: Integer;
{$IFDEF USE_DCL}
//  HashIndex: TCodeIndexHashItem;
  FastHashMap: THashIndexOptimizer;
{$ELSE}
  ReadEncodedChar: string;
  MaxIndex: Integer;
{$ENDIF}

begin
  Result := False;
  DecodedChar := '';
  if Count = 0 then Exit;

{$IFDEF USE_DCL}

  // Using the Optimization HashMap
  FastHashMap := nil;
  case Operation of
    toEncode:
      FastHashMap := fWindowsCodeFastHashMap;
    toDecode:
      FastHashMap := fShenmueCodeFastHashMap;
  end;

(*  HashIndex := TCodeIndexHashItem(FastHashMap.GetValue(EncodedChar));
  if Assigned(HashIndex) then begin
    ItemIndex := HashIndex.ItemIndex;
    Result := True;
  end;*)
  ItemIndex := FastHashMap.IndexOf(EncodedChar);
  Result := ItemIndex <> -1;

{$ELSE}

  // Classical loop (non-optimized)

  ItemIndex := -1;
  MaxIndex := Count - 1;
  while not (Result or (ItemIndex = MaxIndex)) do begin
    Inc(ItemIndex);

    if Operation = toEncode then
      ReadEncodedChar := Items[ItemIndex].WindowsCode
    else if Operation = toDecode then
      ReadEncodedChar := Items[ItemIndex].ShenmueCode;

    Result := SameText(ReadEncodedChar, EncodedChar);
  end;

{$ENDIF}

  // Getting the result!

  if Result then
    if Operation = toEncode then
      DecodedChar := Items[ItemIndex].ShenmueCode
    else if Operation = toDecode then
      DecodedChar := Items[ItemIndex].WindowsCode;
end;

destructor TCharsetList.Destroy;
begin
  Clear;
  fList.Free;
  // we don't need to free HashMaps...
  inherited;
end;

function TCharsetList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TCharsetList.GetItem(Index: Integer): TCharsetListItem;
begin
  Result := TCharsetListItem(fList[Index]);
end;

function TCharsetList.BytesToString(const EncodedString: string): string;
var
  StringList: TStringList;
  Value, i: Integer;

begin
  Result := EncodedString;
  if (Pos('#', EncodedString) = 0) or (EncodedString = '#') then Exit;

  Result := '';
  StringList := TStringList.Create;
  try
    StringList.Delimiter := '#';
    StringList.DelimitedText := EncodedString;

    // For each value in the string
    for i := 0 to StringList.Count - 1 do begin

      // Parsing the value
      if Copy(StringList[i], 1, 1) = '$' then
        // This's a hexadecimal value
        Value := HexToInt(Copy(StringList[i], 2, Length(StringList[i]) - 1))
      else
        // This is a decimal value
        Value := StrToIntDef(StringList[i], -1);

      // Converting the value
      if (Value > -1) and (Value < 256) then
        Result := Result + Chr(Value);

    end; // for

  finally
    StringList.Free;
  end;
end;

function TCharsetList.TranslateString(Operation: TTranslateOperation;
  const S: string): string;
var
  StartPos, OriginalCodeWorkingLength, OriginalCodeMaxLength,
  OriginalLength: Integer;
  Success: Boolean;
  OriginalCode, TranslatedCode: string;

begin
  Result := '';
  if S = '' then Exit;

  StartPos := 1;
  OriginalLength := Length(S);

  OriginalCodeMaxLength := 0;
  case Operation of
    toEncode:
      OriginalCodeMaxLength := fWindowsCodeMaxLength;
    toDecode:
      OriginalCodeMaxLength := fShenmueCodeMaxLength;
  end;

  // for each S character
  repeat

    // Initializing the codec engine
    OriginalCodeWorkingLength := (OriginalLength - StartPos) + 1;
    if OriginalCodeWorkingLength > OriginalCodeMaxLength then
      OriginalCodeWorkingLength := OriginalCodeMaxLength;
    OriginalCode := Copy(S, StartPos, OriginalCodeWorkingLength);

    // for each OriginalCodeWorkingLength character try to encode/decode
    repeat

      // Try to encode/decode the current OriginalCode
      Success := TranslateChar(Operation, OriginalCode, TranslatedCode);

      if Success then begin
        // passing the characters used to encode/decode the 'string character'
        StartPos := StartPos + OriginalCodeWorkingLength;
        Result := Result + TranslatedCode;
      end else begin
        // Try with lesser characters
        Dec(OriginalCodeWorkingLength);

        if OriginalCodeWorkingLength = 0 then begin
          // We don't have encoded the current character, so there is no
          // transformation available for this character.
          Inc(StartPos);
          Result := Result + OriginalCode; // we kept the character "as is".
        end else
          // Getting the next 'string character' and try to encode/decode it
          OriginalCode := Copy(OriginalCode, 1, OriginalCodeWorkingLength);
      end;

    until Success or (OriginalCodeWorkingLength = 0);

  until (StartPos > OriginalLength);
end;

end.
