unit SRFNPCDB;

{$DEFINE USE_DCL}

interface

uses
  Windows, SysUtils, Classes
  {$IFDEF USE_DCL}, HashIdx {$ENDIF};

type
  TDiscNumbers = array[1..3] of Boolean;

  TCinematicsScriptDatabaseItem = class(TObject)
  private
    fDiscNumbers: TDiscNumbers;
    fVoiceID: string;
    fSubtitleID: string;
  public
    property DiscNumbers: TDiscNumbers read fDiscNumbers;
    property VoiceID: string read fVoiceID;       // Like 'F0001'
    property SubtitleID: string read fSubtitleID; // Code, like 'A001'...
  end;
  
  TCinematicsScriptDatabase = class(TObject)
  private
{$IFDEF USE_DCL}
    fIndexOptimizer: THashIndexOptimizer;
{$ENDIF}
    fList: TList;
    function Add(VoiceID, SubtitleID: string): TCinematicsScriptDatabaseItem;
    procedure Clear;
    function GetItem(Index: Integer): TCinematicsScriptDatabaseItem;
    function GetCount: Integer;
{$IFDEF USE_DCL}
    property IndexOptimizer: THashIndexOptimizer read fIndexOptimizer;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    function Find(const VoiceID, SubtitleID: string;
      var ItemFound: TCinematicsScriptDatabaseItem): Boolean;
    function IndexOf(const VoiceID, SubtitleID: string): Integer;
    function LoadFromFile(const FileName: TFileName): Boolean;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TCinematicsScriptDatabaseItem read GetItem; default;
  end;
  
implementation

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants;
  
{ TCinematicsScriptDatabase }

function TCinematicsScriptDatabase.Add(
  VoiceID, SubtitleID: string): TCinematicsScriptDatabaseItem;
{$IFDEF USE_DCL}
var
  ItemIndex: Integer;
{$ENDIF}

begin
  Result := TCinematicsScriptDatabaseItem.Create;
  Result.fVoiceID := VoiceID;
  Result.fSubtitleID := SubtitleID;
{$IFDEF USE_DCL}
  ItemIndex := fList.Add(Result);
  IndexOptimizer.Add(VoiceID + SubtitleID, ItemIndex);
{$ELSE}
  fList.Add(Result);
{$ENDIF}
end;

procedure TCinematicsScriptDatabase.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TCinematicsScriptDatabaseItem(fList[i]).Free;
  fList.Clear;
{$IFDEF USE_DCL}
  IndexOptimizer.Clear;
{$ENDIF}  
end;

constructor TCinematicsScriptDatabase.Create;
begin
  fList := TList.Create;
{$IFDEF USE_DCL}
  fIndexOptimizer := THashIndexOptimizer.Create;
{$ENDIF}  
end;

destructor TCinematicsScriptDatabase.Destroy;
begin
  Clear;
  fList.Free;
{$IFDEF USE_DCL}
  IndexOptimizer.Free;
{$ENDIF}  
  inherited;
end;

function TCinematicsScriptDatabase.Find(
  const VoiceID, SubtitleID: string;
  var ItemFound: TCinematicsScriptDatabaseItem): Boolean;
var
  ItemIndex: Integer;

begin
  ItemFound := nil;
  ItemIndex := IndexOf(VoiceID, SubtitleID);
  Result := ItemIndex <> -1;
  if Result then
    ItemFound := Items[ItemIndex];
end;

function TCinematicsScriptDatabase.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TCinematicsScriptDatabase.GetItem(
  Index: Integer): TCinematicsScriptDatabaseItem;
begin
  Result := TCinematicsScriptDatabaseItem(fList[Index]);
end;

function TCinematicsScriptDatabase.IndexOf(
  const VoiceID, SubtitleID: string): Integer;
{$IFNDEF USE_DCL}
var
  MaxIndex: Integer;
  Found: Boolean;
{$ENDIF}

begin
{$IFDEF USE_DCL}

  // Use optimization HashMap

  Result := IndexOptimizer.IndexOf(VoiceID + SubtitleID);

{$ELSE}

  // Classical loop (non-optimized)
  Found := False;
  Result := -1;
  MaxIndex := Count - 1;
  while not (Found or (Result = MaxIndex)) do begin
    Inc(Result);
    Found := (Items[Result].VoiceID = VoiceID) and
             (Items[Result].SubtitleID = SubtitleID);
  end;

  if not Found then
    Result := -1;
  
{$ENDIF}
end;

function TCinematicsScriptDatabase.LoadFromFile(
  const FileName: TFileName): Boolean;
const
  ROOT_NODE = 'CinematicsScriptDatabase';

var
  XMLDatabase: IXMLDocument;
  VoiceNode, SubtitleCodeNode: IXMLNode;
  Item: TCinematicsScriptDatabaseItem;
  i: Integer;

begin
  XMLDatabase := TXMLDocument.Create(nil);
  try
    try

      with XMLDatabase do begin
        Options := [doNodeAutoCreate, doAttrNull];
        ParseOptions:= [];
        Active := True;
        Version := '1.0';
        Encoding := 'utf-8';
      end;

      XMLDatabase.LoadFromFile(FileName);
      if XMLDatabase.DocumentElement.NodeName = ROOT_NODE then begin

        VoiceNode := XMLDatabase.DocumentElement.ChildNodes.First;
        while VoiceNode <> nil do begin
//          WriteLn(VoiceNode.NodeName);

          // Browse the SubtitleID nodes
          SubtitleCodeNode := VoiceNode.ChildNodes.First;
          while SubtitleCodeNode <> nil do begin
//            WriteLn('  ', SubtitleCodeNode.NodeName);

            // Adding the current SubtitleID node
            Item := Add(VoiceNode.NodeName, SubtitleCodeNode.NodeName);
            if Assigned(Item) then
              for i := Low(TDiscNumbers) to High(TDiscNumbers) do
                Item.fDiscNumbers[i] := SubtitleCodeNode.Attributes['d' + IntToStr(i)];

            // Next SubtitleID node
            SubtitleCodeNode := SubtitleCodeNode.NextSibling;
          end;

          VoiceNode := VoiceNode.NextSibling;
        end;
        
      end; // DocumentElement

      Result := True;
    except
      Result := False;
    end;

  finally
    XMLDatabase.Active := False;
    XMLDatabase := nil;
  end;
end;


end.
