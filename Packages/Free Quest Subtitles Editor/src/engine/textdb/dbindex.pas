(*
  T E X T D B  M O D U L E
  This file is part of the TextDB Module, the Text Correction Database.

  The Text Correction Database is a module made to store EVERY original subtitles
  in order for you to correct the subtitles.

  This file is here to load DBI file, which are a Database index file in order to
  index TCD files. This unit load the DBI file in memory and then build a list
  which contains every NPC info and the corresponding TCD file for each.

  Steps to use:
  1) Load the DBI file (index file)
  2) Call the FindNPC function and passing ShortVoiceID and CharID
  3) Get the result of the FindNPC function and calling the TextDatabaseFileName
     property to get the corresponding TCD file
*)
unit dbindex;

{$DEFINE USE_DCL}

interface

uses
  Windows, SysUtils, Classes
  {$IFDEF USE_DCL}, DCL_intf, HashMap {$ENDIF}
  ;
  
type
  TTextDatabaseIndex = class;

  TTextDatabaseIndexItem = class
  private
    fDiscIndex: Integer;
    fVoiceID: string;
    fTextFileName: TFileName;
    fFileIndex: Integer;
    fCharID: string;
    fOwner: TTextDatabaseIndex;
  public
    constructor Create(Owner: TTextDatabaseIndex);
    property VoiceID: string read fVoiceID;
    property CharID: string read fCharID;
    property FileIndex: Integer read fFileIndex;
    property DiscIndex: Integer read fDiscIndex;
    property TextDatabaseFileName: TFileName read fTextFileName; // path to the TCD file
    property Owner: TTextDatabaseIndex read fOwner;
  end;

  TTextDatabaseIndex = class
  private
    fTextDatabaseIndexList: TList;
    fDatabaseFileIndex: TFileName;
    fDatabaseRootDirectory: TFileName;
    fLoaded: Boolean;
{$IFDEF USE_DCL}
    fOptimizationHashMap: IStrMap;
{$ENDIF}
    function GetCount: Integer;
    function GetItems(Index: Integer): TTextDatabaseIndexItem;
  protected
    procedure Add(VoiceID, CharID: string; FileIndex, DiscIndex: Integer);
    procedure Clear;    
  public
    constructor Create;
    destructor Destroy; override;
    function FindNPC(VoiceID, CharID: string): TTextDatabaseIndexItem;
    function LoadDatabaseIndex(const XMLInputFileIndex: TFileName): Boolean;
    property Count: Integer read GetCount;
    property DatabaseFileIndex: TFileName read fDatabaseFileIndex;
    property DatabaseRootDirectory: TFileName read fDatabaseRootDirectory;
    property Loaded: Boolean read fLoaded;
    property Items[Index: Integer]: TTextDatabaseIndexItem read GetItems; default;
  end;

implementation

uses
  SysTools, XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX;

{$IFDEF USE_DCL}

type
  TTextDatabaseIndexHashItem = class(TObject)
  private
    fItemIndex: Integer;
    fNPCHashKey: string;
  public
    property NPCHashKey: string read fNPCHashKey write fNPCHashKey;
    property ItemIndex: Integer read fItemIndex write fItemIndex;
  end;

{$ENDIF}

{ TTextDatabaseIndex }

procedure TTextDatabaseIndex.Add(VoiceID, CharID: string; FileIndex,
  DiscIndex: Integer);
var
  Item: TTextDatabaseIndexItem;
{$IFDEF USE_DCL}
  Index: Integer;
  HashItem: TTextDatabaseIndexHashItem;
{$ENDIF}

begin
  Item := TTextDatabaseIndexItem.Create(Self);
  Item.fVoiceID := VoiceID;
  Item.fCharID := CharID;
  Item.fFileIndex := FileIndex;
  Item.fDiscIndex := DiscIndex;
  Item.fTextFileName := fDatabaseRootDirectory
    + IntToStr(Item.fDiscIndex) + '\' + IntToStr(Item.fFileIndex) + '.tcd';

{$IFDEF USE_DCL}
  Index := fTextDatabaseIndexList.Add(Item);

  // Adding in the HashMap
  HashItem := TTextDatabaseIndexHashItem.Create;
  HashItem.NPCHashKey := VoiceID + '_' + CharID;
  HashItem.ItemIndex := Index;

  fOptimizationHashMap.PutValue(HashItem.NPCHashKey, HashItem);
{$ELSE}
  // Adding normal
  fTextDatabaseIndexList.Add(Item);
{$ENDIF}
end;

procedure TTextDatabaseIndex.Clear;
var
  i: Integer;

begin
  fLoaded := False;
  fDatabaseFileIndex := '';
  fDatabaseRootDirectory := '';
  for i := 0 to Count - 1 do
    TTextDatabaseIndexItem(fTextDatabaseIndexList[i]).Free;
  fTextDatabaseIndexList.Clear;
{$IFDEF USE_DCL}
  fOptimizationHashMap.Clear;
{$ENDIF}  
end;

constructor TTextDatabaseIndex.Create;
begin
  fTextDatabaseIndexList := TList.Create;
{$IFDEF USE_DCL}
  fOptimizationHashMap := TStrHashMap.Create;
{$ENDIF}  
end;

destructor TTextDatabaseIndex.Destroy;
begin
  Clear;
  fTextDatabaseIndexList.Destroy;
  inherited;
end;

function TTextDatabaseIndex.FindNPC(VoiceID,
  CharID: string): TTextDatabaseIndexItem;
var
{$IFDEF USE_DCL}
  HashKey: string;
  HashIndex: TTextDatabaseIndexHashItem;
{$ELSE}
  i: Integer;
{$ENDIF}

begin
  Result := nil;

{$IFDEF USE_DCL}
  HashKey := VoiceID + '_' + CharID;
  HashIndex := TTextDatabaseIndexHashItem(fOptimizationHashMap.GetValue(HashKey));
  if Assigned(HashIndex) then
    Result := Items[HashIndex.ItemIndex];

{$ELSE}

  for i := 0 to Count - 1 do
    if (Items[i].VoiceID = VoiceID) and (Items[i].CharID = CharID) then begin
      Result := Items[i];
      Break;
    end;
    
{$ENDIF}
end;

function TTextDatabaseIndex.GetCount: Integer;
begin
  Result := fTextDatabaseIndexList.Count;
end;

function TTextDatabaseIndex.GetItems(Index: Integer): TTextDatabaseIndexItem;
begin
  Result := TTextDatabaseIndexItem(fTextDatabaseIndexList[Index]);
end;

function TTextDatabaseIndex.LoadDatabaseIndex(
  const XMLInputFileIndex: TFileName): Boolean;
var
  XMLDatabaseIndex: IXMLDocument;
  EntriesRootNode,
  InputFileEntry: IXMLNode;
  TCD_FileIndex,
  TCD_DiscIndex, i: Integer;
  VoiceID, CharID: string;

begin
  Result := False;
  if not FileExists(XMLInputFileIndex) then Exit;
  Clear;

  // setting the file / directory properties
  fLoaded := True;
  fDatabaseFileIndex := XMLInputFileIndex;
  fDatabaseRootDirectory :=
    IncludeTrailingPathDelimiter(ExtractFilePath(XMLInputFileIndex));

  // parsing the XML index file
  XMLDatabaseIndex := TXMLDocument.Create(nil);
  try

    try
      // initialization for the XML file
      XMLDatabaseIndex.LoadFromFile(XMLInputFileIndex);
      XMLDatabaseIndex.Active := True;

{$IFDEF DEBUG}
      WriteLn(sLineBreak, '*** PARSING DATABASE INDEX XML FILE ***');
{$ENDIF}

      // Getting root
      if XMLDatabaseIndex.DocumentElement.NodeName = 'TextCorrectorDatabaseIndex' then begin

          EntriesRootNode := XMLDatabaseIndex.DocumentElement.ChildNodes.FindNode('Entries');

          for i := 0 to EntriesRootNode.Attributes['Count'] - 1 do begin
            InputFileEntry := EntriesRootNode.ChildNodes[i];
            if Assigned(InputFileEntry) then begin
              VoiceID := Left('_', InputFileEntry.NodeName);
              CharID := Right('_', InputFileEntry.NodeName);
              TCD_FileIndex := InputFileEntry.Attributes['i'];
              TCD_DiscIndex := InputFileEntry.Attributes['d'];

(*{$IFDEF DEBUG}
              WriteLn('   #', i, ': VoiceID = ', VoiceID, ', CharID = ',
                CharID, ', TCD_FileIndex = ', TCD_FileIndex,
                ', TCD_DiscIndex = ', TCD_DiscIndex);
{$ENDIF}*)

              // Adding entry to the database
              Add(VoiceID, CharID, TCD_FileIndex, TCD_DiscIndex);
            end;
          end; // for

      end; // NodeName = 'TextCorrectorDatabaseIndex'

{$IFDEF DEBUG}
      WriteLn('Database entries loaded count: ', Count);
{$ENDIF}

      Result := True;
      
    except
      on E:Exception do begin
{$IFDEF DEBUG}
        WriteLn('LoadDatabaseIndex Exception: "' + E.Message + '"');
{$ENDIF}
        Result := False;
      end;
    end;

  finally
    XMLDatabaseIndex.Active := False;
    XMLDatabaseIndex := nil;
  end;
end;

{ TTextDatabaseIndexItem }

constructor TTextDatabaseIndexItem.Create(Owner: TTextDatabaseIndex);
begin
  fOwner := Owner;
end;

end.
