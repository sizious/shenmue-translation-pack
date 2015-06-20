unit fileslst;

interface

// implémente la liste des fichiers traités par le log

uses
  Windows, SysUtils, Classes;

type
  TFilesList = class;
  TFilesListAddedEvent = procedure(Sender: TObject; FileName: TFileName;
    ListIndex: Integer) of object;

  TFileEntry = class(TObject)
  private
    fFileName: TFileName;
    fOwner: TFilesList;
    function GetIndex: Integer;
  public
    constructor Create(Owner: TFilesList; const FileName: TFileName);
    function Exists: Boolean;
    function ExtractedExtension: string;
    function ExtractedPath: TFileName;
    function ExtractedFileName: TFileName; overload;
    function ExtractedFileName(NewExtension: string): TFileName; overload;
    function ExtractedFileName(NewExtension: string; AppendNewExtension: Boolean): TFileName; overload;
    procedure RemoveEntry;
    property FileName: TFileName read fFileName write fFileName;
    property Index: Integer read GetIndex;
    property Owner: TFilesList read fOwner;
  end;

  TFilesList = class(TObject)
  private
    fList: TList;
    fItemAdded: TFilesListAddedEvent;
    fListCleared: TNotifyEvent;
    function GetItem(Index: Integer): TFileEntry;
    procedure SetItem(Index: Integer; const Value: TFileEntry);
    function GetCount: Integer;
  public
    procedure Add(const FileName: TFileName);
    procedure Assign(Source: TFilesList);
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    // Properties
    property Count: Integer read GetCount;
    property Files[Index: Integer]: TFileEntry read GetItem write SetItem; default;

    // Events
    property OnListCleared: TNotifyEvent read fListCleared write fListCleared;
    property OnItemAdded: TFilesListAddedEvent read fItemAdded write fItemAdded;
  end;

implementation

{ TFilesList }

procedure TFilesList.Add(const FileName: TFileName);
var
  Item: TFileEntry;
  Index: Integer;

begin
  Item := TFileEntry.Create(Self, FileName);
  Index := fList.Add(Item);

  // send the event
  if Assigned(fItemAdded) then
    fItemAdded(Self, FileName, Index);
end;

procedure TFilesList.Assign(Source: TFilesList);
var
  i: Integer;

begin
  for i := 0 to Source.Count - 1 do
    Add(Source[i].FileName);
end;

procedure TFilesList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TFilesList(fList[i]).Free;
  fList.Clear;

  // send the event
  if Assigned(fListCleared) then
    fListCleared(Self);
end;

constructor TFilesList.Create;
begin
  fList := TList.Create;
end;

destructor TFilesList.Destroy;
begin
  Clear;
  fList.Free;
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

procedure TFilesList.SetItem(Index: Integer; const Value: TFileEntry);
begin
  fList[Index] := TFileEntry(Value);
end;

{ TFileEntry }

constructor TFileEntry.Create(Owner: TFilesList; const FileName: TFileName);
begin
  fOwner := Owner;
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

function TFileEntry.ExtractedExtension: string;
begin
  Result := ExtractFileExt(FileName);
  if Result <> '' then
    Result := Copy(Result, 2, Length(Result) - 1);
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

function TFileEntry.GetIndex: Integer;
begin
  Result := Owner.fList.IndexOf(Self);
end;

procedure TFileEntry.RemoveEntry;
begin
  Owner.fList.Delete(Index);
  Free;
end;

end.
