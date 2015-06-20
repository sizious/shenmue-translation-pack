unit SectExpl;

interface

uses
  Windows, SysUtils, Classes, FSParser;

type
  TSectionsExplorer = class;
  
  TSectionsExplorerListItem = class
  private
    fUpdated: Boolean;
    fDescription: string;
    fName: string;
    fIndex: Integer;
    fSize: LongWord;
    fOffset: LongWord;
    fOwner: TSectionsExplorer;
    fFileExtension: string;
    fImportedFile: TFileName;
    fOutputFileName: TFileName;
  public
    constructor Create(AOwner: TSectionsExplorer);
    procedure CancelImport;
    procedure ExportToFolder(const Directory: TFileName);
    function LoadFromFile(const FileName: TFileName): Boolean;
    procedure SaveToFile(const FileName: TFileName);
    property Description: string read fDescription;
    property FileExtension: string read fFileExtension;
    property Index: Integer read fIndex;
    property Name: string read fName;
    property Offset: LongWord read fOffset;
    property OutputFileName: TFileName read fOutputFileName;
    property Owner: TSectionsExplorer read fOwner;
    property Size: LongWord read fSize;
    property Updated: Boolean read fUpdated;
  end;

  TSectionsExplorerList = class
  private
    fList: TList;
    fOwner: TSectionsExplorer;
    procedure Add(const AName: string; const AOffset, ASize: LongWord);
    procedure Clear;
    function GetItem(Index: Integer): TSectionsExplorerListItem;
    function GetCount: Integer;
  public
    constructor Create(AOwner: TSectionsExplorer);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSectionsExplorerListItem
      read GetItem; default;
    property Owner: TSectionsExplorer read fOwner;
  end;

  TSectionsExplorer = class
  private
    fSections: TSectionsExplorerList;
    fFileLoaded: Boolean;
    fSourceFileName: TFileName;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function LoadFromFile(const FileName: TFileName): Boolean;
    function Save: Boolean;
    function SaveToFile(const FileName: TFileName): Boolean;
    property Loaded: Boolean read fFileLoaded;
    property Sections: TSectionsExplorerList read fSections;
    property SourceFileName: TFileName read fSourceFileName;
  end;

implementation

uses
  SysTools, WorkDir, SectUtil;
    
{ TSectionsExplorer }

procedure TSectionsExplorer.Clear;
begin
  fFileLoaded := False;
  fSourceFileName := '';
  Sections.Clear;
end;

constructor TSectionsExplorer.Create;
begin
  fSections := TSectionsExplorerList.Create(Self);
end;

destructor TSectionsExplorer.Destroy;
begin
  fSections.Free;
  inherited;
end;

function TSectionsExplorer.LoadFromFile(const FileName: TFileName): Boolean;
var
  F: TFileStream;
  Buffer: TFileSectionsList;
  i: Integer;

begin
  Clear;
  Buffer := TFileSectionsList.Create;
  F := TFileStream.Create(FileName, fmOpenRead);
  try
    try
      fSourceFileName := FileName;
      ParseFileSections(F, Buffer); // I avoid the TFileSectionsList(fSections) cast; it seems to be buggy

      for i := 0 to Buffer.Count - 1 do
        with Buffer.Items[i] do
          if (Size > 0) and (Size <= F.Size) and (Length(Name) > 2) then
            Sections.Add(Name, Offset, Size);

      Result := Buffer.Count = Sections.Count;
      fFileLoaded := Result;
    except
      on E:Exception do
      begin
        Result := False;
{$IFDEF DEBUG}
        WriteLn('LoadFromFile: ', E.Message);
{$ENDIF}
      end;
    end;
  finally
    F.Free;
    Buffer.Free;
  end;
  if not Result then
    fSourceFileName := '';
end;

function TSectionsExplorer.Save: Boolean;
begin
  Result := SaveToFile(SourceFileName);
  Result := Result and LoadFromFile(SourceFileName);
end;

function TSectionsExplorer.SaveToFile(const FileName: TFileName): Boolean;
var
  OutputFileName, ImportedFileName: TFileName;
  ImportedFileStream, InStream, OutStream: TFileStream;
  i: Integer;
  
begin
  OutputFileName := GetWorkingTempFileName;
  InStream := TFileStream.Create(SourceFileName, fmOpenRead);
  OutStream := TFileStream.Create(OutputFileName, fmCreate);
  try
    try
      for i := 0 to Sections.Count - 1 do

        if Sections[i].Updated then
        begin
          // Importing the new section
          ImportedFileName := Sections[i].fImportedFile;
          ImportedFileStream := TFileStream.Create(ImportedFileName, fmOpenRead);
          try
            OutStream.CopyFrom(ImportedFileStream, ImportedFileStream.Size);
          finally
            ImportedFileStream.Free;
          end;
        end else begin
          // Raw Copy of the section
          InStream.Seek(Sections[i].Offset, soFromBeginning);
          OutStream.CopyFrom(InStream, Sections[i].Size);
        end;

      Result := True;
    except
      on E:Exception do
      begin
{$IFDEF DEBUG}
        WriteLn('SaveToFile: ', E.Message);
{$ENDIF}
        Result := False;
      end;
    end;
  finally
    InStream.Free;
    OutStream.Free;
  end;
  if Result then  
    Result := MoveTempFile(OutputFileName, FileName, False);
end;

{ TSectionsExplorerList }

procedure TSectionsExplorerList.Add(const AName: string; const AOffset,
  ASize: LongWord);
var
  Item: TSectionsExplorerListItem;
  SourceName: TFileName;
  SectionInfo: TSectionInfo;
  AExtension, ADescription: string;

begin
  Item := TSectionsExplorerListItem.Create(Self.Owner);
  SourceName := ExtractFileName(Self.Owner.SourceFileName);

  AExtension := Copy(AName, 1, 3);
  ADescription := '';
  if QuerySectionInfo(AName, SectionInfo) then
  begin
    AExtension := SectionInfo.Extension;
    ADescription := SectionInfo.Description;
  end;

  with Item do
  begin
    fName := AName;
    fOffset := AOffset;
    fSize := ASize;
    fDescription := ADescription;
    fFileExtension := '.' + AExtension;
    fOutputFileName := ChangeFileExt(SourceName, fFileExtension);
    fIndex := fList.Add(Item);
  end;
end;

procedure TSectionsExplorerList.Clear;
var
  i: Integer;

begin
  for i := 0 to fList.Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TSectionsExplorerList.Create(AOwner: TSectionsExplorer);
begin
  fOwner := AOwner;
  fList := TList.Create;
end;

destructor TSectionsExplorerList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TSectionsExplorerList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TSectionsExplorerList.GetItem(
  Index: Integer): TSectionsExplorerListItem;
begin
  Result := TSectionsExplorerListItem(fList[Index]);
end;

{ TSectionsExplorerListItem }

procedure TSectionsExplorerListItem.CancelImport;
begin
  fImportedFile := '';
  fUpdated := False;
end;

constructor TSectionsExplorerListItem.Create(AOwner: TSectionsExplorer);
begin
  fOwner := AOwner;
  fDescription := '';
end;

procedure TSectionsExplorerListItem.ExportToFolder(const Directory: TFileName);
var
  FileName: TFileName;

begin
  FileName := IncludeTrailingPathDelimiter(Directory) + OutputFileName;
  SaveToFile(FileName);
end;

function TSectionsExplorerListItem.LoadFromFile(
  const FileName: TFileName): Boolean;
begin
  Result := False;
  if not FileExists(FileName) then Exit;
  fImportedFile := FileName;
  fUpdated := True;
  Result := True;
end;

procedure TSectionsExplorerListItem.SaveToFile(const FileName: TFileName);
var
  InF, OutF: TFileStream;

begin
  InF := TFileStream.Create(Owner.SourceFileName, fmOpenRead);
  OutF := TFileStream.Create(FileName, fmCreate);
  try
    InF.Seek(Offset, soFromBeginning);
    OutF.CopyFrom(InF, Size);
  finally
    InF.Free;
    OutF.Free;
  end;
end;

end.
