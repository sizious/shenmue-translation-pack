unit FilesLst;

{$DEFINE USE_DCL}

interface

// implémente la liste des fichiers traités par le log

uses
  Windows, SysUtils, Classes {$IFDEF USE_DCL}, HashIdx {$ENDIF};

type
  TFilesList = class;
  
  TFileEntry = class(TObject)
  private
    fOwner: TFilesList;
    fFileName: TFileName;
    function GetExtension: string;
    function GetIndex: Integer;
  public
    constructor Create(const FileName: TFileName);
    function Exists: Boolean;
    function ExtractedPath: TFileName;
    function ExtractedFileName: TFileName; overload;
    function ExtractedFileName(NewExtension: string): TFileName; overload;
    function ExtractedFileName(NewExtension: string; AppendNewExtension: Boolean): TFileName; overload;
    function HasExtension: Boolean;
    function Remove: Boolean;
    property Extension: string read GetExtension;
    property FileName: TFileName read fFileName write fFileName;
    property Index: Integer read GetIndex;
    property Owner: TFilesList read fOwner;
  end;

  TFilesList = class(TObject)
  private
{$IFDEF USE_DCL}
    fHashMap: THashIndexOptimizer;
{$ENDIF}
    fList: TList;
    function GetItem(Index: Integer): TFileEntry;
    procedure SetItem(Index: Integer; const Value: TFileEntry);
    function GetCount: Integer;
{$IFDEF USE_DCL}
    property HashMap: THashIndexOptimizer read fHashMap write fHashMap;
{$ENDIF}
  public
    function Add(const FileName: TFileName): Integer;
    procedure Assign(Source: TFilesList); overload;
    procedure Assign(Directory: TFileName; SourceFileNames: TStrings); overload;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function IndexOf(const FileName: TFileName): Integer;
    procedure SaveToFile(const FileName: TFileName);    
    function Remove(Index: Integer): Boolean;
    property Count: Integer read GetCount;
    property Files[Index: Integer]: TFileEntry read GetItem write SetItem; default;
  end;

implementation

{ TFilesList }

function TFilesList.Add(const FileName: TFileName): Integer;
var
  Item: TFileEntry;

begin
  Result := IndexOf(FileName);
  if Result = -1 then begin
    // Add the new filename to the list.
    Item := TFileEntry.Create(FileName);
    Result := fList.Add(Item);
    Item.fOwner := Self;
{$IFDEF USE_DCL}
    HashMap.Add(FileName, Result);
{$ENDIF}
  end;
end;

procedure TFilesList.Assign(Source: TFilesList);
var
  i: Integer;

begin
  for i := 0 to Source.Count - 1 do
    Add(Source[i].FileName);
end;

procedure TFilesList.Assign(Directory: TFileName; SourceFileNames: TStrings);
var
  i: Integer;

begin
  Directory := IncludeTrailingPathDelimiter(Directory);
  for i := 0 to SourceFileNames.Count - 1 do
    Add(Directory + SourceFileNames[i]);
end;

procedure TFilesList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TFilesList(fList[i]).Free;
  fList.Clear;
{$IFDEF USE_DCL}
  HashMap.Clear;
{$ENDIF}
end;

constructor TFilesList.Create;
begin
  fList := TList.Create;
{$IFDEF USE_DCL}
  fHashMap := THashIndexOptimizer.Create;
{$ENDIF}
end;

destructor TFilesList.Destroy;
begin
  Clear;
  fList.Free;
{$IFDEF USE_DCL}
  HashMap.Free;
{$ENDIF}
  inherited Create;
end;

function TFilesList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TFilesList.GetItem(Index: Integer): TFileEntry;
begin
  Result := TFileEntry(fList[Index]);
end;

function TFilesList.IndexOf(const FileName: TFileName): Integer;
{$IFNDEF USE_DCL}
var
  MaxIndex: Integer;
  Found: Boolean;
{$ENDIF}

begin
{$IFDEF USE_DCL}

  // Use optimization HashMap

  Result := HashMap.IndexOf(FileName);

{$ELSE}

  // Classical loop (non-optimized)
  Found := False;
  Result := -1;
  MaxIndex := Count - 1;
  while not (Found or (Result = MaxIndex)) do begin
    Inc(Result);
    Found := (Files[Result].FileName = FileName);
  end;

  if not Found then
    Result := -1;
  
{$ENDIF}
end;

function TFilesList.Remove(Index: Integer): Boolean;
begin
  Result := False;
  if (Index >= 0) and (Index < Count) then
    Result := Files[Index].Remove;
end;

procedure TFilesList.SaveToFile(const FileName: TFileName);
var
  SL: TStringList;
  i: Integer;

begin
  SL := TStringList.Create;
  try
    for i := 0 to Count - 1 do
      SL.Add(Files[i].FileName);
    SL.SaveToFile(FileName);
  finally
    SL.Free;
  end;
end;

procedure TFilesList.SetItem(Index: Integer; const Value: TFileEntry);
begin
  fList[Index] := TFileEntry(Value);
end;

{ TFileEntry }

constructor TFileEntry.Create(const FileName: TFileName);
begin
  fOwner := nil;
  fFileName := FileName;
end;

function TFileEntry.Exists: Boolean;
begin
  Result := FileExists(FileName);
end;

function TFileEntry.ExtractedFileName: TFileName;
begin
  Result := ExtractFileName(FileName);
end;

function TFileEntry.ExtractedFileName(NewExtension: string): TFileName;
begin
  Result := ChangeFileExt(ExtractedFileName, NewExtension);
end;

function TFileEntry.ExtractedFileName(NewExtension: string;
  AppendNewExtension: Boolean): TFileName;
begin
  if not AppendNewExtension then
    Result := ExtractedFileName(NewExtension)
  else
    Result := ExtractedFileName + NewExtension;
end;

function TFileEntry.ExtractedPath: TFileName;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(FileName));
end;

function TFileEntry.GetExtension: string;
begin
  Result := ExtractFileExt(FileName);
end;

function TFileEntry.GetIndex: Integer;
begin
  Result := -1;
  if Assigned(Owner) then
    Result := Owner.fList.IndexOf(Self);
end;

function TFileEntry.HasExtension: Boolean;
begin
  Result := Extension <> '';
end;

function TFileEntry.Remove: Boolean;
begin
  Result := True;
  try
    Owner.fList.Delete(Index);
{$IFDEF USE_DCL}
    Owner.HashMap.Delete(FileName);
{$ENDIF}
    Free;
  except
    Result := False;
  end;
end;

end.
