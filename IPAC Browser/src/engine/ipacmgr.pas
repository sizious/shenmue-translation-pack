unit ipacmgr;

interface

uses
  Windows, SysUtils, Classes, IpacUtil;

type
  TIpacEditor = class;
  TIpacSectionList = class;
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
    fOwner: TIpacEditor;
    fList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TFileSectionsListItem;
  protected
    function Add(Name: string; AbsoluteOffset, Size: LongWord): Integer;
    procedure Clear;
  public
    constructor Create(Owner: TIpacEditor);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TFileSectionsListItem read GetItem; default;
    property Owner: TIpacEditor read fOwner;
  end;

  // IPAC section entry
  TIpacSectionListItem = class
  private
    fOwner: TIpacSectionList;
    fName: string;
    fKind: string;
    fSize: LongWord;
    fRelativeOffset: LongWord;
    fAbsoluteOffset: LongWord;
    fImportedFileName: TFileName;
    fUpdated: Boolean;
    fIndex: Integer;
    fExpandedKind: TIpacSectionKind;
    fExpandedKindAvailable: Boolean;

    // Updated value (for the SaveToFile function)
    fNewAbsoluteOffset: LongWord;
    fNewRelativeOffset: LongWord;
    fNewSize: LongWord;
    fNewPaddingSize: LongWord;
    
    function GetSourceFileName: TFileName;
  protected
    procedure AnalyzeSection(var SourceFileStream: TFileStream);
    function GetSectionPaddingSize(DataSize: LongWord): LongWord;
    procedure WriteIpacSection(var InStream, OutStream: TFileStream);
    property SourceFileName: TFileName read GetSourceFileName;
  public
    constructor Create(Owner: TIpacSectionList);

    procedure CancelImport;
    procedure ExportToFile(const FileName: TFileName);
    function ExportToFolder(const Folder: TFileName): TFileName;
    function GetOutputFileName: TFileName;
    function ImportFromFile(const FileName: TFileName): Boolean;

    property AbsoluteOffset: LongWord read fAbsoluteOffset;
    property ExpandedKind: TIpacSectionKind read fExpandedKind;    
    property ExpandedKindAvailable: Boolean read fExpandedKindAvailable;
    property Index: Integer read fIndex;
    property ImportedFileName: TFileName read fImportedFileName;
    property Name: string read fName;
    property Kind: string read fKind;
    property RelativeOffset: LongWord read fRelativeOffset;
    property Size: LongWord read fSize;
    property Owner: TIpacSectionList read fOwner;
    property Updated: Boolean read fUpdated;    
  end;

  // IPAC sections manager
  TIpacSectionList = class
  private
    fIpacSectionSizeAbsoluteOffset1: LongWord;
    fIpacSectionSizeAbsoluteOffset2: LongWord;
    fOwner: TIpacEditor;
    fList: TList;
    fIpacFileSectionIndex: Integer;
    function GetCount: Integer;
    function GetItem(Index: Integer): TIpacSectionListItem;
    function GetIpacFileSection: TFileSectionsListItem;
  protected
    function Add(var SourceFileStream: TFileStream; Name, Kind: string;
      AbsoluteOffset, RelativeOffset, Size: LongWord): Integer;
    procedure Clear;
    procedure WriteIpacHeader(var FS: TFileStream);
    procedure WriteIpacFooter(var FS: TFileStream);
  public
    constructor Create(Owner: TIpacEditor);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TIpacSectionListItem read GetItem; default;
    property IpacSection: TFileSectionsListItem read GetIpacFileSection;
    property Owner: TIpacEditor read fOwner;
  end;

  // Main class
  TIpacEditor = class
  private
    fSections: TIpacSectionList;
    fMakeBackup: Boolean;
    fFileSectionsList: TFileSectionsList;
    fSourceFileName: TFileName;
    fCompressed: Boolean;
    fInternalWorkingSourceFile: TFileName;
  protected
    procedure InitWorkingSelectedFile(InputFileName: TFileName);
    procedure ParseIpacSections(var FS: TFileStream; IpacOffset, IpacSize: LongWord);
    property InternalWorkingSourceFile: TFileName read fInternalWorkingSourceFile
      write fInternalWorkingSourceFile;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function LoadFromFile(const FileName: TFileName): Boolean;
    function SaveToFile(const FileName: TFileName): Boolean;
    function Save: Boolean;

    // This stores every IPAC sections
    property Content: TIpacSectionList read fSections;

    property Compressed: Boolean read fCompressed;

    // This flag is here to make backup if needed
    property MakeBackup: Boolean read fMakeBackup write fMakeBackup;

    // This stores every file section [IPAC section included]
    property Sections: TFileSectionsList read fFileSectionsList;

    property SourceFileName: TFileName read fSourceFileName;
  end;

implementation

uses
  SysTools, Utils, GZipMgr;
  
type
  TSectionEntry = record
    Name: array[0..3] of Char;
    Size: LongWord;
  end;

  TIpacSectionEntry = record
    Name: array[0..7] of Char;
    Kind: array[0..3] of Char; // type of the footer entry ('BIN ', 'CHRM...')
    Offset: LongWord;
    Size: LongWord;
  end;

const
  IPAC_SIGN = 'IPAC';
  UNIT_NAME = 'ipacmgr'; // For Exception handling

{ TIpacSectionsListItem }

procedure TIpacSectionListItem.CancelImport;
begin
  fImportedFileName := '';
  fUpdated := False;
end;

constructor TIpacSectionListItem.Create(Owner: TIpacSectionList);
begin
  fOwner := Owner;
end;

procedure TIpacSectionListItem.ExportToFile(const FileName: TFileName);
var
  InStream, OutStream: TFileStream;

begin
  OutStream := TFileStream.Create(FileName, fmCreate);
  InStream := TFileStream.Create(GetSourceFileName, fmOpenRead);
  try
    try
      InStream.Seek(AbsoluteOffset, soFromBeginning);
      OutStream.CopyFrom(InStream, Size);
    except
      on E:Exception do begin
        E.Message := Format('%s.ExportToFile: %s [AbsoluteOffset: %d, '
          + 'SourceFileName: "%s", TargetFileName: "%s"]', [UNIT_NAME,
          E.Message, AbsoluteOffset, GetSourceFileName, FileName]);
        raise;
      end;
    end;
  finally
    OutStream.Free;
    InStream.Free;
  end;
end;

function TIpacSectionListItem.ExportToFolder(const Folder: TFileName): TFileName;
begin
  Result := IncludeTrailingPathDelimiter(Folder) + GetOutputFileName;
  ExportToFile(Result);
end;

procedure TIpacSectionListItem.AnalyzeSection(var SourceFileStream: TFileStream);
begin
  try
    fExpandedKind := AnalyzeIpacSection(Kind, SourceFileStream,
      AbsoluteOffset, Size, fExpandedKindAvailable);
  except
    on E:Exception do begin
      E.Message := Format('%s.AnalyzeSection: %s [Kind: %s, ' +
        'SourceFileName: "%s", AbsoluteOffset: %d, Size: %d]',
        [UNIT_NAME, E.Message, Kind, SourceFileStream.FileName, AbsoluteOffset,
        Size]);
      raise;
    end;
  end;
end;

function TIpacSectionListItem.GetOutputFileName: TFileName;
var
  Ext: string;

begin
  Ext := ExpandedKind.Extension;
  if Ext <> '' then
    Ext := '.' + Ext;  
  Result := Name + Ext;
end;

function TIpacSectionListItem.ImportFromFile(
  const FileName: TFileName): Boolean;
begin
  Result := FileExists(FileName);
  if not Result then Exit;

  fImportedFileName := FileName;
  fUpdated := True;
end;

procedure TIpacSectionListItem.WriteIpacSection(var InStream, OutStream: TFileStream);
var
  Offset, IpacAbsoluteOffset,
  NewSectionSize, NewPaddingSize: LongWord;
  ImportedFileStream: TFileStream;
  Buffer: array[0..31] of Char;

begin
  NewPaddingSize := $FFFFFFFF;
  Offset := OutStream.Position;
  IpacAbsoluteOffset := Owner.IpacSection.Offset;
  
  try

    if Updated then begin

      // Importing the new section
      ImportedFileStream := TFileStream.Create(ImportedFileName, fmOpenRead);
      try
        NewSectionSize := ImportedFileStream.Size;
        OutStream.CopyFrom(ImportedFileStream, NewSectionSize);
      finally
        ImportedFileStream.Free;
      end;  

    end else begin
      // Raw Copy of the section
      NewSectionSize := Size;
      InStream.Seek(AbsoluteOffset, soFromBeginning);
      OutStream.CopyFrom(InStream, NewSectionSize);
    end;

    // Writing section padding
    NewPaddingSize := GetSectionPaddingSize(NewSectionSize);
    ZeroMemory(@Buffer, NewPaddingSize);
    OutStream.Write(Buffer, NewPaddingSize);

    // Updating footer infos
    with Owner.Items[Index] do begin
      fNewAbsoluteOffset := Offset;
      fNewRelativeOffset := Offset - IpacAbsoluteOffset;
      fNewSize := NewSectionSize;
      fNewPaddingSize := NewPaddingSize;
    end;

  except
    on E:Exception do begin
      E.Message := Format('%s.WriteIpacSection: %s [InStream: "%s", ' +
        'OutStream: "%s", Section Info = {"%s" "%s" A:%d R:%d S:%d}, Updated: %s ' +
        '= {A:%d R:%d S:%d}, IpacAbsoluteOffset: %d, NewPaddingSize: %d]',
        [UNIT_NAME, E.Message, InStream.FileName, OutStream.FileName,
        Name, Kind, AbsoluteOffset, RelativeOffset, Size,
        BoolToStr(Updated, True), fNewAbsoluteOffset, fNewRelativeOffset,
        fNewSize, IpacAbsoluteOffset, NewPaddingSize]
      );
      raise;
    end;
  end;
end;

function TIpacSectionListItem.GetSectionPaddingSize(DataSize: LongWord): LongWord;
var
  current_num, total_null_bytes: LongWord;

begin
  // Finding the correct number of null bytes after file data
  // Based on the original function by Manic
  current_num := 0;
  total_null_bytes := 0;
  while current_num <> DataSize do
  begin
    if total_null_bytes = 0 then begin
      total_null_bytes := 31;
    end else begin
      Dec(total_null_bytes);
    end;
    Inc(current_num);
  end;
  Result := total_null_bytes;
end;

function TIpacSectionListItem.GetSourceFileName: TFileName;
begin
  Result := Owner.Owner.InternalWorkingSourceFile;
end;

{ TIPACEditor }

procedure TIpacEditor.Clear;
begin
  (*  If the source file is compressed, the InternalWorkingSourceFile contains
      the uncompressed temp file. if the source if is already uncompressed,
      InternalWorkingSourceFile contains the source file [NOT TO BE DELETED]. *)
  if Compressed and FileExists(InternalWorkingSourceFile) then
    DeleteFile(InternalWorkingSourceFile);
  Sections.Clear;
  Content.Clear;
end;

constructor TIpacEditor.Create;
begin
  fSections := TIpacSectionList.Create(Self);
  fFileSectionsList := TFileSectionsList.Create(Self);
  GZipInitEngine(GetWorkingTempDirectory);
end;

destructor TIpacEditor.Destroy;
begin
  fSections.Free;
  fFileSectionsList.Free;
  inherited;
end;

procedure TIpacEditor.InitWorkingSelectedFile(InputFileName: TFileName);
begin
  fCompressed := GZipDecompress(InputFileName, GetWorkingTempDirectory, fInternalWorkingSourceFile);
  if not Compressed then
    InternalWorkingSourceFile := ExpandFileName(InputFileName);
end;

function TIpacEditor.LoadFromFile(const FileName: TFileName): Boolean;
var
  FS: TFileStream;
  SectionEntry: TSectionEntry;
  Offset, NextSectionOffset: LongWord;
  IpacSectionIndex: Integer;
  Done: Boolean;

begin
  Result := False;
  if not FileExists(FileName) then Exit;
  Clear; // the previous temp file is cleaned here (if needed)

  try
    fSourceFileName := FileName;

    // Ungzip if needed
    InitWorkingSelectedFile(SourceFileName);

    // Loading the decompressed IPAC file
    FS := TFileStream.Create(InternalWorkingSourceFile, fmOpenRead);
    try

{$IFDEF DEBUG}
      WriteLn(sLineBreak, '*** PARSING FILE ***');
{$ENDIF}

      // Parsing the file...
      repeat
        Offset := FS.Position;

        // Reading the header
        FS.Read(SectionEntry, SizeOf(TSectionEntry));
        IpacSectionIndex := Sections.Add(SectionEntry.Name, Offset, SectionEntry.Size);
        NextSectionOffset := Offset + SectionEntry.Size;

        // We found the IPAC section
        if SectionEntry.Name = IPAC_SIGN then begin
          Result := True;
          Content.fIpacFileSectionIndex := IpacSectionIndex;

          // Parse the IPAC section
          with Content.IpacSection do
            ParseIpacSections(FS, Offset, Size);

          // Skip IPAC footer
          Inc(NextSectionOffset, Content.Count * SizeOf(TIpacSectionEntry));
        end;

        // Skipping section
        Done := (NextSectionOffset >= FS.Size) or (SectionEntry.Size = 0);
        if not Result then
          FS.Seek(NextSectionOffset, soFromBeginning);

      until Done or (FS.Position >= FS.Size);

      // Not a valid file...
      if not Result then
        Clear;

{$IFDEF DEBUG}
      WriteLn(sLineBreak, 'LoadFromFile "', ExtractFileName(FileName), '" result: ', Result);
{$ENDIF}

    except
      on E:Exception do begin
        E.Message := Format('%s.LoadFromFile: %s [InputFile: "%s"]',
          [UNIT_NAME, E.Message, FileName]
        );
        raise;
      end;
    end;

  finally
    FS.Free;
  end;
end;

procedure TIpacEditor.ParseIpacSections(var FS: TFileStream; IpacOffset, IpacSize: LongWord);
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
  WriteLn(sLineBreak, 'Reading IPAC sections:');
{$ENDIF}

  // Scanning every IPAC footer entry
  for i := 0 to IpacSectionsCount - 1 do begin
    FS.Read(IpacSection, SizeOf(TIpacSectionEntry));
    with IpacSection do
      Content.Add(FS, Name, Kind, (IpacOffset + Offset), Offset, Size);
      // We are passing the FS parameter to the AnalyzeSection for determinate what's the section content...
  end;

{$IFDEF DEBUG}
  WriteLn('');
{$ENDIF}
end;

function TIpacEditor.Save: Boolean;
begin
  Result := SaveToFile(SourceFileName);
end;

function TIpacEditor.SaveToFile(const FileName: TFileName): Boolean;
var
  InStream, OutStream: TFileStream;
  OutTempFile, FinalEmbeddedFileName: TFileName;
  i, j: Integer;
  
begin
  Result := False;
  if not FileExists(InternalWorkingSourceFile) then Exit;

  OutTempFile := GetTempFileName;

  // Opening the file
  OutStream := TFileStream.Create(OutTempFile, fmCreate);
  InStream := TFileStream.Create(InternalWorkingSourceFile, fmOpenRead);
  try

{$IFDEF DEBUG}
    WriteLn('*** SAVING THE FILE ***');
{$ENDIF}

    // Writing each file section
    for i := 0 to Sections.Count - 1 do begin

      if Sections[i].Name = IPAC_SIGN then begin
        // Write IPAC header
        Content.WriteIpacHeader(OutStream);

        // Write IPAC sections content
        for j := 0 to Content.Count - 1 do
          Content[j].WriteIpacSection(InStream, OutStream);

        // Writing IPAC footer
        Content.WriteIpacFooter(OutStream);

      end else begin
        // Raw Copy of the section
        InStream.Seek(Sections[i].Offset, soFromBeginning);
        OutStream.CopyFrom(InStream, Sections[i].Size);
      end;

    end;

  finally
    // Destroying FileStream. The save is finished!
    OutStream.Free;
    InStream.Free;

    // Checking target
    if FileExists(FileName) then
      if (MakeBackup) and (FileName = SourceFileName) then
        RenameFile(FileName, FileName + '.BAK')
      else
        DeleteFile(FileName);

    // Compress the file if needed
    if Compressed then begin                    
      FinalEmbeddedFileName :=
        IncludeTrailingPathDelimiter(ExtractFilePath(OutTempFile))
        + ExtractFileName(InternalWorkingSourceFile);
      RenameFile(OutTempFile, FinalEmbeddedFileName); // OutTempFile is the new file
      OutTempFile := FinalEmbeddedFileName;
      GZipCompress(OutTempFile); // compressing the new temp file
    end;

    // Copying the right file
    Result := CopyFile(OutTempFile, FileName, False);

    // Deleting temp file
    if Result then
      DeleteFile(OutTempFile);

    // Updating the information if we Save the current loaded file to the same file
    if FileName = SourceFileName then begin
      Result := Result and LoadFromFile(SourceFileName);
{$IFDEF DEBUG}
      WriteLn('File was reloaded from disk.');
{$ENDIF}
    end;

{$IFDEF DEBUG}
    WriteLn('Saved to "', ExtractFileName(FileName), '", Result: ', Result);
{$ENDIF}
  end;
end;

{ TIpacSectionsList }

function TIpacSectionList.Add(var SourceFileStream: TFileStream; Name,
  Kind: string; AbsoluteOffset, RelativeOffset, Size: LongWord): Integer;
var
  NewItem: TIpacSectionListItem;

begin
  NewItem := TIpacSectionListItem.Create(Self);
  NewItem.fAbsoluteOffset := AbsoluteOffset;
  NewItem.fName := Name;
  NewItem.fKind := Kind;
  NewItem.fRelativeOffset := RelativeOffset;
  NewItem.fSize := Size;
  Result := fList.Add(NewItem);
  NewItem.fIndex := Result;

  // Searching the section extended type
  NewItem.AnalyzeSection(SourceFileStream);

{$IFDEF DEBUG}
  WriteLn('  #', Result, ': Name: ', Name, ', Kind: ', Kind,
    ', ROffset: ', RelativeOffset, ', AOffset: ', AbsoluteOffset,
    ', Size: ', Size);
{$ENDIF}
end;

procedure TIpacSectionList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TIpacSectionListItem(fList.Items[i]).Free;
  fList.Clear;
end;

constructor TIpacSectionList.Create(Owner: TIpacEditor);
begin
  fOwner := Owner;
  fList := TList.Create;
end;

destructor TIpacSectionList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TIpacSectionList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TIpacSectionList.GetIpacFileSection: TFileSectionsListItem;
begin
  Result := Owner.Sections[fIpacFileSectionIndex];
end;

function TIpacSectionList.GetItem(Index: Integer): TIpacSectionListItem;
begin
  Result := TIpacSectionListItem(fList.Items[Index]);
end;

procedure TIpacSectionList.WriteIpacFooter(var FS: TFileStream);
const
  IPAC_HEADER_SIZE = 16;

var
  i: Integer;
  Entry: TIpacSectionEntry;
  Offset: LongWord;

begin
  IpacSection.fSize := IPAC_HEADER_SIZE;
  
  // Writing each footer entry
  for i := 0 to Count - 1 do begin
    // Preparing the Entry raw string fields
    ZeroMemory(@Entry.Name, Length(Entry.Name));
    ZeroMemory(@Entry.Kind, Length(Entry.Kind));

    // Initializing members
    StrCopy(Entry.Name, PChar(Items[i].Name));
    StrCopy(Entry.Kind, PChar(Items[i].Kind));
    Entry.Offset := Items[i].fNewRelativeOffset;
    Entry.Size := Items[i].fNewSize;

    // Writing to the file
    FS.Write(Entry, SizeOf(TIpacSectionEntry));

    // Calculating Ipac Section size
    Inc(IpacSection.fSize, Items[i].fNewSize);
    Inc(IpacSection.fSize, Items[i].fNewPaddingSize);

{$IFDEF DEBUG}
    with Items[i] do
      WriteLn('  #', i, ': Name: ', Name, ', Kind: ', Kind, ', ROffset: ',
        fNewRelativeOffset, ', AOffset: ', fNewAbsoluteOffset, ', Size: ', fNewSize);
{$ENDIF}
  end;

  // saving the end of flow offset
  Offset := FS.Position;

  // Updating IPAC header
  FS.Seek(fIpacSectionSizeAbsoluteOffset1, soFromBeginning);
  FS.Write(IpacSection.Size, SizeOf(LongWord));
  FS.Seek(fIpacSectionSizeAbsoluteOffset2, soFromBeginning);
  FS.Write(IpacSection.Size, SizeOf(LongWord));

{$IFDEF DEBUG}
  WriteLn(sLineBreak, 'IPAC section size: ', IpacSection.Size, sLineBreak);
{$ENDIF}

  // Restoring the offset
  FS.Seek(Offset, soFromBeginning);
end;

procedure TIpacSectionList.WriteIpacHeader(var FS: TFileStream);
const
  IPAC_FAKE_SIZE: LongWord = $FFFFFFFF;

var
  SectionsCount: LongWord;

begin
  // Write signature
  FS.Write(IPAC_SIGN, Length(IPAC_SIGN));

  // Write IPAC size (to update after)
  fIpacSectionSizeAbsoluteOffset1 := FS.Position;
  FS.Write(IPAC_FAKE_SIZE, SizeOf(IPAC_FAKE_SIZE));

  // Write IPAC sections count
  SectionsCount := LongWord(Count);
  FS.Write(SectionsCount, SizeOf(LongWord));

  // Write IPAC size (to update after again)
  fIpacSectionSizeAbsoluteOffset2 := FS.Position;
  FS.Write(IPAC_FAKE_SIZE, SizeOf(IPAC_FAKE_SIZE));  
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

