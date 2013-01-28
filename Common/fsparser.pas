(*
  This unit was designed to parse the Shenmue files data.
  Very suitable for multi-sections files, combined in one single file.
  A very good example is COLD.BIN, MT files, MAPINFO.BIN files...
*)
unit FSParser;

(* Please define this to enable the fast search algorithm, powered by the DCL.
   Really recommanded! *)
{$DEFINE USE_DCL}

interface

uses
  Windows, SysUtils, Classes, SysTools
  {$IFDEF USE_DCL}, HashIdx {$ENDIF};
  
type
  TFileSectionsList = class;

  // Item of TFileSectionsList
  TFileSectionsListItem = class
  private
    fName: string;
    fSize: LongWord;
    fAbsoluteOffset: LongWord;
    fOwner: TFileSectionsList;
    fIndex: Integer;
  public
    constructor Create(Owner: TFileSectionsList);
    property Index: Integer read fIndex;
    property Name: string read fName;
    property Offset: LongWord read fAbsoluteOffset;
    property Size: LongWord read fSize;
    property Owner: TFileSectionsList read fOwner;
  end;
  
  // Store every file sections
  TFileSectionsList = class
  private
{$IFDEF USE_DCL}
    fOptimizationHashMap: THashIndexOptimizer;
{$ENDIF}
    fOwner: TObject;
    fList: TList;
    function GetCount: Integer;
  protected
    function Add(Name: string; AbsoluteOffset, Size: LongWord): Integer;
    procedure Clear;
    function GetItem(Index: Integer): TFileSectionsListItem;    
  public
    constructor Create; overload;
    constructor Create(AOwner: TObject); overload;
    destructor Destroy; override;
    function IndexOf(SectionName: string): Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TFileSectionsListItem read GetItem; default;
    property Owner: TObject read fOwner;
  end;

procedure ParseFileSections(var FS: TFileStream; var Result: TFileSectionsList);

// -----------------------------------------------------------------------------
implementation
// -----------------------------------------------------------------------------

const
  UNIT_NAME = 'FSParser';

procedure ParseFileSections(var FS: TFileStream; var Result: TFileSectionsList);
var
  SectionEntry: TSectionEntry;
  SavedOffset, Offset, NextSectionOffset: LongWord;
  Done: Boolean;

begin
{$IFDEF DEBUG}
  WriteLn(sLineBreak, 'Parsing file sections:');
{$ENDIF}

  try
    SavedOffset := FS.Position;

    // Initializing the parser
    Result.Clear;
    NextSectionOffset := SavedOffset;
    
    // Parsing the file...
    repeat
      FS.Seek(NextSectionOffset, soFromBeginning);

      Offset := FS.Position;

      // Reading the header
      FS.Read(SectionEntry, SizeOf(TSectionEntry));
      if (SectionEntry.Name <> '') or
        ((SectionEntry.Size > 0) and (SectionEntry.Size <= FS.Size)) then
        Result.Add(SectionEntry.Name, Offset, SectionEntry.Size);
      NextSectionOffset := Offset + SectionEntry.Size;

      // Skipping section
      Done := (NextSectionOffset >= FS.Size) or (SectionEntry.Size = 0);
    until Done or (FS.Position >= FS.Size);

    FS.Seek(SavedOffset, soFromBeginning);

{$IFDEF DEBUG}
    WriteLn('');
{$ENDIF}

  except
    on E:Exception do begin
      E.Message := Format('%s.ParseFileSections: %s', [UNIT_NAME, E.Message]);
      raise;
    end;
  end; // try
end;

{ TFileSectionsList }

function TFileSectionsList.Add(Name: string; AbsoluteOffset, Size: LongWord): Integer;
var
  Item: TFileSectionsListItem;

begin
  Item := TFileSectionsListItem.Create(Self);
  Item.fName := Name;
  Item.fAbsoluteOffset := AbsoluteOffset;
  Item.fSize := Size;
  Result := fList.Add(Item);
  Item.fIndex := Result;

{$IFDEF USE_DCL}
  // Adding the entry in the Hash map.
  fOptimizationHashMap.Add(Item.Name, Result);
{$ENDIF}

{$IFDEF DEBUG}
  WriteLn('  #', Result, ': Name: ', Name, ', AbsoluteOffset: ',
    AbsoluteOffset, ', Size: ', Size);
{$ENDIF}
end;

procedure TFileSectionsList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TFileSectionsListItem(fList[i]).Free;
  fList.Clear;
{$IFDEF USE_DCL}
  fOptimizationHashMap.Clear;
{$ENDIF}
end;

constructor TFileSectionsList.Create;
begin
  Self.Create(nil);
end;

constructor TFileSectionsList.Create(AOwner: TObject);
begin
  fList := TList.Create;
  fOwner := AOwner;
{$IFDEF USE_DCL}
  fOptimizationHashMap := THashIndexOptimizer.Create;
{$ENDIF}
end;

destructor TFileSectionsList.Destroy;
begin
  Clear;
  fList.Free;
{$IFDEF USE_DCL}
  fOptimizationHashMap.Free;
{$ENDIF}
  inherited;
end;

function TFileSectionsList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TFileSectionsList.GetItem(Index: Integer): TFileSectionsListItem;
begin
  Result := TFileSectionsListItem(fList[Index]);
end;

function TFileSectionsList.IndexOf(SectionName: string): Integer;
{$IFNDEF USE_DCL}
var
  MaxIndex: Integer;
  Found: Boolean;  
{$ENDIF}

begin
  Result := -1;  
  if Count = 0 then Exit;

{$IFDEF USE_DCL}

  // Using the Optimization HashMap

  Result := fOptimizationHashMap.IndexOf(SectionName);

{$ELSE}

  // Classical loop (non-optimized)
  Found := False;
  MaxIndex := Count - 1;
  while not (Found or (ItemIndex = MaxIndex)) do begin
    Inc(Result);
    Found := SameText(Items[Result].Name, SectionName);
  end;

  if not Found then
    Result := -1;

{$ENDIF}
end;

{ TFileSectionsListItem }

constructor TFileSectionsListItem.Create(Owner: TFileSectionsList);
begin
  fOwner := Owner;
end;

end.