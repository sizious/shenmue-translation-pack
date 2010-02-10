unit ipacmgr;

interface

uses
  Windows, SysUtils, Classes;

type
  TIpacEditor = class;
  TIpacSectionsList = class;
  TFileSectionsList = class;

  // Item of TFileSectionsList
  TFileSectionsListItem = class
  private
    fName: string;
    fSize: Integer;
    fAbsoluteOffset: Integer;
    fOwner: TFileSectionsList;
  public
    constructor Create(Owner: TFileSectionsList);
    property Name: string read fName;
    property Offset: Integer read fAbsoluteOffset;
    property Size: Integer read fSize;
    property Owner: TFileSectionsList read fOwner;
  end;

  // Store every file sections
  TFileSectionsList = class
  private
    fOwner: TIpacEditor;
    fList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TFileSectionsListItem;
  protected
    function Add(Name: string; AbsoluteOffset, Size: Integer): Integer;
    procedure Clear;
  public
    constructor Create(Owner: TIpacEditor);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TFileSectionsListItem read GetItem; default;
    property Owner: TIpacEditor read fOwner;
  end;

  // IPAC section entry
  TIpacSectionsListItem = class
  private
    fOwner: TIpacSectionsList;
    fName: string;
    fKind: string;
    fSize: Integer;
    fRelativeOffset: Integer;
    fAbsoluteOffset: Integer;
    fImportedFileName: TFileName;
    fIsImported: Boolean;
  protected
    procedure WriteIpacSection(var FS: TFileStream);
  public
    constructor Create(Owner: TIpacSectionsList);

    procedure CancelImport;
    procedure ExportToFile(const FileName: TFileName);
    function ExportToFolder(const Folder: TFileName): TFileName; overload;
    function GetOutputFileName: TFileName;
    function ImportFromFile(const FileName: TFileName): Boolean;    

    property AbsoluteOffset: Integer read fAbsoluteOffset;
    property ImportedFileName: TFileName read fImportedFileName;
    property IsImported: Boolean read fIsImported;
    property Name: string read fName;
    property Kind: string read fKind;
    property RelativeOffset: Integer read fRelativeOffset;
    property Size: Integer read fSize;
    property Owner: TIpacSectionsList read fOwner;
  end;

  // IPAC sections manager
  TIpacSectionsList = class
  private
    fOwner: TIpacEditor;
    fList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TIpacSectionsListItem;
  protected
    function Add(Name, Kind: string; AbsoluteOffset, RelativeOffset,
      Size: Integer): Integer;
    procedure Clear;
    procedure WriteIpacFooter(var FS: TFileStream);
  public
    constructor Create(Owner: TIpacEditor);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TIpacSectionsListItem read GetItem; default;
    property Owner: TIpacEditor read fOwner;    
  end;

  // Main class
  TIpacEditor = class
  private
    fSections: TIpacSectionsList;
    fMakeBackup: Boolean;
    fFileSectionsList: TFileSectionsList;
    fSourceFileName: TFileName;
  protected
    procedure ParseIpacSections(var FS: TFileStream; IpacOffset, IpacSize: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function LoadFromFile(const FileName: TFileName): Boolean;
    function SaveToFile(const FileName: TFileName): Boolean;
    function Save: Boolean;

    // This stores every IPAC sections
    property Content: TIpacSectionsList read fSections;

    // This flag is here to make backup if needed
    property MakeBackup: Boolean read fMakeBackup write fMakeBackup;

    // This stores every file section [IPAC section included]
    property Sections: TFileSectionsList read fFileSectionsList;

    property SourceFileName: TFileName read fSourceFileName;
  end;

implementation

uses
  SysTools;
  
type
  TSectionEntry = record
    Name: array[0..3] of Char;
    Size: Integer;
  end;

  TIpacSectionEntry = record
    Name: array[0..7] of Char;
    Kind: array[0..3] of Char; // type of the footer entry ('BIN ', 'CHRM...')
    Offset: Integer;
    Size: Integer;
  end;

const
  IPAC_SIGN = 'IPAC';
  
{ TIpacSectionsListItem }

procedure TIpacSectionsListItem.CancelImport;
begin
  fImportedFileName := '';
  fIsImported := False;
end;

constructor TIpacSectionsListItem.Create(Owner: TIpacSectionsList);
begin
  fOwner := Owner;
end;

procedure TIpacSectionsListItem.ExportToFile(const FileName: TFileName);
begin
  
end;

function TIpacSectionsListItem.ExportToFolder(
  const Folder: TFileName): TFileName;
begin

end;

function TIpacSectionsListItem.GetOutputFileName: TFileName;
begin

end;

function TIpacSectionsListItem.ImportFromFile(
  const FileName: TFileName): Boolean;
begin
  fImportedFileName := FileName;
  fIsImported := True;
end;

procedure TIpacSectionsListItem.WriteIpacSection(var FS: TFileStream);
begin

end;

{ TIPACEditor }

procedure TIPACEditor.Clear;
begin
  fSections.Clear;
end;

constructor TIPACEditor.Create;
begin
  fSections := TIpacSectionsList.Create(Self);
  fFileSectionsList := TFileSectionsList.Create(Self);
end;

destructor TIPACEditor.Destroy;
begin
  fSections.Free;
  fFileSectionsList.Free;
  inherited;
end;

function TIPACEditor.LoadFromFile(const FileName: TFileName): Boolean;
var
  FS: TFileStream;
  SectionEntry: TSectionEntry;
  Offset: Integer;
  
begin
  Result := False;
  if not FileExists(FileName) then Exit;

  fSourceFileName := FileName;
  Clear;

  FS := TFileStream.Create(FileName, fmOpenRead);
  try

{$IFDEF DEBUG}
    WriteLn('*** PARSING FILE ***');
{$ENDIF}

    // Parsing the file...
    repeat
      Offset := FS.Position;

      // Reading the header
      FS.Read(SectionEntry, SizeOf(TSectionEntry));
      Sections.Add(SectionEntry.Name, Offset, SectionEntry.Size);

      // We found the IPAC section
      if SectionEntry.Name = IPAC_SIGN then begin
        Result := True;
        ParseIpacSections(FS, Offset, SectionEntry.Size); // parse the IPAC section
      end;

      // Skipping section
      FS.Seek(Offset + SectionEntry.Size, soFromBeginning);
      
    until Result or (FS.Position >= FS.Size);

    // Not a valid file...
    if not Result then
      Clear;

  finally
    FS.Free;
  end;
end;

procedure TIPACEditor.ParseIpacSections(var FS: TFileStream; IpacOffset, IpacSize: Integer);
var
  IpacSectionsCount: Longword;
  IpacSection: TIpacSectionEntry;
  i: Integer;

begin
  (*  We have previously read the "IPAC" signature and the section size so we
      can read the IPAC sections count. *)
  FS.Read(IpacSectionsCount, SizeOf(Longword));
  
  // Seeking the end of the IPAC section
  FS.Seek(IpacOffset, soFromBeginning); // rewind
  FS.Seek(IpacSize, soFromCurrent);

  // Reading every IPAC entries in the footer
{$IFDEF DEBUG}
  WriteLn(sLineBreak, '*** READING IPAC SECTION ***');
{$ENDIF}

  for i := 0 to IpacSectionsCount - 1 do begin
    FS.Read(IpacSection, SizeOf(TIpacSectionEntry));
    with IpacSection do
      Content.Add(Name, Kind, (IpacOffset + Offset), Offset, Size);
  end;

{$IFDEF DEBUG}
  WriteLn('');
{$ENDIF}
end;

function TIPACEditor.Save: Boolean;
begin
  Result := SaveToFile(SourceFileName);
end;

function TIPACEditor.SaveToFile(const FileName: TFileName): Boolean;
var
  InStream, OutStream: TFileStream;
  OutFile: TFileName;
  i: Integer;
  
begin
  Result := False;

  OutFile := GetTempFileName;

  // Opening the file
  OutStream := TFileStream.Create(FileName, fmCreate);
  InStream := TFileStream.Create(SourceFileName, fmOpenRead);
  try

    // Writing each file section
    for i := 0 to Sections.Count - 1 do begin

      if Sections[i].Name = IPAC_SIGN then begin
        (*InStream.Seek(Sections[i].Offset, soFromBeginning);
        OutStream.CopyFrom(InStream, Sections[i].Size);*)

        // Writing IPAC footer
        Content.WriteIpacFooter(OutStream);

      end else begin
        // Raw Copy of the section
        InStream.Seek(Sections[i].Offset, soFromBeginning);
        OutStream.CopyFrom(InStream, Sections[i].Size);
      end;

    end;

    // Checking target
    if FileExists(FileName) then
      if (MakeBackup) and (FileName = SourceFileName) then
        RenameFile(FileName, FileName + '.BAK')
      else
        DeleteFile(FileName);

    // Copying the right file
    Result := CopyFile(OutFile, FileName, True);

  finally
    OutStream.Free;
    InStream.Free;
  end;
end;

{ TIpacSectionsList }

function TIpacSectionsList.Add(Name, Kind: string; AbsoluteOffset, RelativeOffset,
  Size: Integer): Integer;
var
  NewItem: TIpacSectionsListItem;

begin
  NewItem := TIpacSectionsListItem.Create(Self);
  NewItem.fAbsoluteOffset := AbsoluteOffset;
  NewItem.fName := Name;
  NewItem.fKind := Kind;
  NewItem.fRelativeOffset := RelativeOffset;
  NewItem.fSize := Size;
  Result := fList.Add(NewItem);

{$IFDEF DEBUG}
  WriteLn('  #', Result, ': Name: ', Name, ', Kind: ', Kind,
    ', ROffset: ', RelativeOffset, ', AOffset: ', AbsoluteOffset,
    ', Size: ', Size);
{$ENDIF}
end;

procedure TIpacSectionsList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TIpacSectionsListItem(fList.Items[i]).Free;
  fList.Clear;
end;

constructor TIpacSectionsList.Create(Owner: TIPACEditor);
begin
  fOwner := Owner;
  fList := TList.Create;
end;

destructor TIpacSectionsList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TIpacSectionsList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TIpacSectionsList.GetItem(Index: Integer): TIpacSectionsListItem;
begin
  Result := TIpacSectionsListItem(fList.Items[Index]);
end;

procedure TIpacSectionsList.WriteIpacFooter(var FS: TFileStream);
var
  i: Integer;
  Entry: TIpacSectionEntry;

begin
  for i := 0 to Count - 1 do begin
    // Preparing the Entry raw string fields
    ZeroMemory(@Entry.Name, Length(Entry.Name));
    ZeroMemory(@Entry.Kind, Length(Entry.Kind));

    // Initializing members
    StrCopy(Entry.Name, PChar(Items[i].Name));
    StrCopy(Entry.Kind, PChar(Items[i].Kind));
    Entry.Offset := Items[i].RelativeOffset;
    Entry.Size := Items[i].Size;

    // Writing to the file
    FS.Write(Entry, SizeOf(TIpacSectionEntry));
  end;
end;

{ TFileSectionsList }

function TFileSectionsList.Add(Name: string; AbsoluteOffset, Size: Integer): Integer;
var
  Item: TFileSectionsListItem;

begin
  Item := TFileSectionsListItem.Create(Self);
  Item.fName := Name;
  Item.fAbsoluteOffset := AbsoluteOffset;
  Item.fSize := Size;
  Result := fList.Add(Item);

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
end;

constructor TFileSectionsList.Create(Owner: TIpacEditor);
begin
  fList := TList.Create;
  fOwner := Owner;
end;

destructor TFileSectionsList.Destroy;
begin
  Clear;
  fList.Free;
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

{ TFileSectionsListItem }

constructor TFileSectionsListItem.Create(Owner: TFileSectionsList);
begin
  fOwner := Owner;
end;

end.
