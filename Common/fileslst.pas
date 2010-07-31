unit FilesLst;

interface

// implémente la liste des fichiers traités par le log

uses
  Windows, SysUtils, Classes;

type
  TFileEntry = class(TObject)
  private
    fFileName: TFileName;
    fIndex: Integer;
  public
    constructor Create(const FileName: TFileName);
    function Exists: Boolean;
    function ExtractedPath: TFileName;
    function ExtractedFileName: TFileName; overload;
    function ExtractedFileName(NewExtension: string): TFileName; overload;
    function ExtractedFileName(NewExtension: string; AppendNewExtension: Boolean): TFileName; overload;
    function HasExtension: Boolean;
    property Index: Integer read fIndex;
    property FileName: TFileName read fFileName write fFileName;
  end;

  TFilesList = class(TObject)
  private
    fList: TList;
    function GetItem(Index: Integer): TFileEntry;
    procedure SetItem(Index: Integer; const Value: TFileEntry);
    function GetCount: Integer;
  public
    function Add(const FileName: TFileName): Integer;
    procedure Assign(Source: TFilesList); overload;
    procedure Assign(Directory: TFileName; SourceFileNames: TStrings); overload;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    property Count: Integer read GetCount;
    property Files[Index: Integer]: TFileEntry read GetItem write SetItem; default;
  end;

implementation

{ TFilesList }

function TFilesList.Add(const FileName: TFileName): Integer;
var
  Item: TFileEntry;

begin
  Item := TFileEntry.Create(FileName);
  Result := fList.Add(Item);
  Item.fIndex := Result;
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

constructor TFileEntry.Create(const FileName: TFileName);
begin
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

function TFileEntry.HasExtension: Boolean;
begin
  Result := ExtractFileExt(FileName) <> '';
end;

end.
