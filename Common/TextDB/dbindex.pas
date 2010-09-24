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
unit DBIndex;

{$DEFINE USE_DCL}

interface

uses
  Windows, SysUtils, Classes
  {$IFDEF USE_DCL}, HashIdx {$ENDIF}
  ;
  
type
  TTextDatabaseIndex = class;

  TTextDatabaseIndexItem = class
  private
    fDiscIndex: Integer;
    fTextFileName: TFileName; // path to the TCD file
    fFileIndex: Integer;
    fOwner: TTextDatabaseIndex;
    fHashKey: string;
  public
    constructor Create(Owner: TTextDatabaseIndex);
    property HashKey: string read fHashKey;
    property FileIndex: Integer read fFileIndex;
    property DiscIndex: Integer read fDiscIndex;
    property TextDatabaseFileName: TFileName read fTextFileName;
    property Owner: TTextDatabaseIndex read fOwner;
  end;

  TTextDatabaseIndex = class
  private
    fTextDatabaseIndexList: TList;
    fDatabaseFileIndex: TFileName;
    fDatabaseRootDirectory: TFileName;
    fLoaded: Boolean;
{$IFDEF USE_DCL}
    fOptimizationHashMap: THashIndexOptimizer;
{$ENDIF}
    function GetCount: Integer;
    function GetItems(Index: Integer): TTextDatabaseIndexItem;
  protected
    procedure Add(const HashKey: string; const FileIndex, DiscIndex: Integer);
    procedure Clear;
{$IFDEF USE_DCL}
    property HashMap: THashIndexOptimizer read fOptimizationHashMap;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    function FindByHashKey(const HashKey: string): TTextDatabaseIndexItem;
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

{ TTextDatabaseIndex }

procedure TTextDatabaseIndex.Add(const HashKey: string; const FileIndex,
  DiscIndex: Integer);
var
  Item: TTextDatabaseIndexItem;
{$IFDEF USE_DCL}
  Index: Integer;
{$ENDIF}

begin
  Item := TTextDatabaseIndexItem.Create(Self);
  Item.fHashKey := HashKey;
  Item.fFileIndex := FileIndex;
  Item.fDiscIndex := DiscIndex;
  Item.fTextFileName := fDatabaseRootDirectory + IntToStr(Item.fDiscIndex) + '\'
    + IntToStr(Item.fFileIndex) + '.tcd';

{$IFDEF USE_DCL}

  // Adding in the HashMap
  Index := fTextDatabaseIndexList.Add(Item);
  HashMap.Add(HashKey, Index);
  
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
  HashMap.Clear;
{$ENDIF}  
end;

constructor TTextDatabaseIndex.Create;
begin
  fTextDatabaseIndexList := TList.Create;
{$IFDEF USE_DCL}
  fOptimizationHashMap := THashIndexOptimizer.Create;
{$ENDIF}  
end;

destructor TTextDatabaseIndex.Destroy;
begin
  Clear;
  fTextDatabaseIndexList.Destroy;
{$IFDEF USE_DCL}
  HashMap.Free;
{$ENDIF}
  inherited;
end;

function TTextDatabaseIndex.FindByHashKey(
  const HashKey: string): TTextDatabaseIndexItem;
var
  i: Integer;

begin
  Result := nil;

{$IFDEF USE_DCL}

  i := HashMap.IndexOf(HashKey);
  if i > -1 then
    Result := Items[i];

{$ELSE}

  for i := 0 to Count - 1 do
    if (Items[i].HashKey = HashKey) then begin
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
  HashKey: string;

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
              HashKey := InputFileEntry.NodeName;
              TCD_FileIndex := InputFileEntry.Attributes['i'];
              TCD_DiscIndex := InputFileEntry.Attributes['d'];

              // Adding entry to the database
              Add(HashKey, TCD_FileIndex, TCD_DiscIndex);
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
