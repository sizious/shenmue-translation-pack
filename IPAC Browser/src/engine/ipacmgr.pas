unit ipacmgr;

interface

uses
  Windows, SysUtils, Classes, IpacUtil;

type
  TIpacEditor = class;
  TIpacSectionsList = class;
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
  TIpacSectionsListItem = class
  private
    fOwner: TIpacSectionsList;
    fName: string;
    fKind: string;
    fSize: LongWord;
    fRelativeOffset: LongWord;
    fAbsoluteOffset: LongWord;
    fImportedFileName: TFileName;
    fUpdated: Boolean;
    fIndex: Integer;
    fFileSectionDetails: TIpacSectionKind;
    fExpandedFileSectionDetails: Boolean;
    function GetSourceFileName: TFileName;
  protected
    procedure AnalyzeSection(var SourceFileStream: TFileStream);
    function GetSectionPaddingSize: LongWord;
    procedure WriteIpacSection(var InStream, OutStream: TFileStream);
    property SourceFileName: TFileName read GetSourceFileName;
  public
    constructor Create(Owner: TIpacSectionsList);

    procedure CancelImport;
    procedure ExportToFile(const FileName: TFileName);
    function ExportToFolder(const Folder: TFileName): TFileName;
    function GetOutputFileName: TFileName;
    function ImportFromFile(const FileName: TFileName): Boolean;

    property AbsoluteOffset: LongWord read fAbsoluteOffset;
    property ExpandedFileSectionDetails: Boolean read fExpandedFileSectionDetails;
    property FileSectionDetails: TIpacSectionKind read fFileSectionDetails;
    property Index: Integer read fIndex;
    property ImportedFileName: TFileName read fImportedFileName;
    property Name: string read fName;
    property Kind: string read fKind;
    property PaddingSize: LongWord read GetSectionPaddingSize;
    property RelativeOffset: LongWord read fRelativeOffset;
    property Size: LongWord read fSize;
    property Owner: TIpacSectionsList read fOwner;
    property Updated: Boolean read fUpdated;    
  end;

  // IPAC sections manager
  TIpacSectionsList = class
  private
    fIpacSectionSizeAbsoluteOffset1: LongWord;
    fIpacSectionSizeAbsoluteOffset2: LongWord;
    fOwner: TIpacEditor;
    fList: TList;
    fIpacFileSectionIndex: Integer;
    function GetCount: Integer;
    function GetItem(Index: Integer): TIpacSectionsListItem;
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
    property Items[Index: Integer]: TIpacSectionsListItem read GetItem; default;
    property IpacSection: TFileSectionsListItem read GetIpacFileSection;
    property Owner: TIpacEditor read fOwner;
  end;

  // Main class
  TIpacEditor = class
  private
    fSections: TIpacSectionsList;
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
    property Content: TIpacSectionsList read fSections;

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

{ TIpacSectionsListItem }

procedure TIpacSectionsListItem.CancelImport;
begin
  fImportedFileName := '';
  fUpdated := False;
end;

constructor TIpacSectionsListItem.Create(Owner: TIpacSectionsList);
begin
  fOwner := Owner;
end;

procedure TIpacSectionsListItem.ExportToFile(const FileName: TFileName);
var
  InStream, OutStream: TFileStream;

begin
  OutStream := TFileStream.Create(FileName, fmCreate);
  InStream := TFileStream.Create(GetSourceFileName, fmOpenRead);
  try
    InStream.Seek(AbsoluteOffset, soFromBeginning);
    OutStream.CopyFrom(InStream, Size);
  finally
    OutStream.Free;
    InStream.Free;
  end;
end;

function TIpacSectionsListItem.ExportToFolder(const Folder: TFileName): TFileName;
begin
  Result := IncludeTrailingPathDelimiter(Folder) + GetOutputFileName;
  ExportToFile(Result);
end;

procedure TIpacSectionsListItem.AnalyzeSection(var SourceFileStream: TFileStream);
begin
  fFileSectionDetails := AnalyzeIpacSection(Kind, SourceFileStream,
    AbsoluteOffset, Size, fExpandedFileSectionDetails);
end;

function TIpacSectionsListItem.GetOutputFileName: TFileName;
(*var
  RadicalName: TFileName;

begin
  RadicalName := ChangeFileExt(ExtractFileName(Owner.Owner.SourceFileName));
  Result := RadicalName + '_' + Name + '_#' + IntToStr(Index) + '.BIN';*)
begin
  Result := Name + '.' + FileSectionDetails.Extension;
end;

function TIpacSectionsListItem.ImportFromFile(
  const FileName: TFileName): Boolean;
begin
  Result := FileExists(FileName);
  if not Result then Exit;

  fImportedFileName := FileName;
  fUpdated := True;
end;

procedure TIpacSectionsListItem.WriteIpacSection(var InStream, OutStream: TFileStream);
var
  Offset, IpacAbsoluteOffset,
  NewSectionSize: LongWord;
  ImportedFileStream: TFileStream;
  Buffer: array[0..31] of Char;

begin
  Offset := OutStream.Position;
  IpacAbsoluteOffset := Owner.IpacSection.Offset;
  
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

  // Updating footer infos
  Owner.Items[Index].fAbsoluteOffset := Offset;
  Owner.Items[Index].fRelativeOffset := Offset - IpacAbsoluteOffset;
  Owner.Items[Index].fSize := NewSectionSize; // important because PaddingSize is set after!

  // Writing section padding
  ZeroMemory(@Buffer, PaddingSize);
  OutStream.Write(Buffer, PaddingSize);
end;

function TIpacSectionsListItem.GetSectionPaddingSize: LongWord;
var
  current_num, total_null_bytes: LongWord;

begin
  // Finding the correct number of null bytes after file data
  // Based on the original function by Manic
  current_num := 0;
  total_null_bytes := 0;
  while current_num <> Size do
  begin
    if total_null_bytes = 0 then begin
      total_null_bytes := 31;
    end
    else begin
      Dec(total_null_bytes);
    end;
    Inc(current_num);
  end;
  Result := total_null_bytes;
end;

function TIpacSectionsListItem.GetSourceFileName: TFileName;
begin
  Result := Owner.Owner.InternalWorkingSourceFile;
end;

{ TIPACEditor }

procedure TIpacEditor.Clear;
begin
  Sections.Clear;
  Content.Clear;
end;

constructor TIpacEditor.Create;
begin
  fSections := TIpacSectionsList.Create(Self);
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
    InternalWorkingSourceFile := InputFileName;
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

  fSourceFileName := FileName;
  Clear;

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
  OutTempFile: TFileName;
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
      DeleteFile(InternalWorkingSourceFile); // the uncompressed original temp file
      RenameFile(OutTempFile, InternalWorkingSourceFile); // OutTempFile is the new file
      OutTempFile := InternalWorkingSourceFile; // The new temp saved file is renamed as the original temp file
      GZipCompress(OutTempFile); // compressing the new temp file
    end;

    // Copying the right file
    Result := CopyFile(OutTempFile, FileName, False);

    // Deleting temp file
    if Result then
      DeleteFile(OutTempFile);

    (*  Reloading the file from the disk because every structure must be reloaded
        cleared datas. Every infos has been modified in order to build the output
        file. It's crap, but doing so uses less variables, so less source code. *)
    Result := Result and LoadFromFile(SourceFileName);

{$IFDEF DEBUG}
    WriteLn('Saved to "', ExtractFileName(FileName), '", Result: ', Result);
{$ENDIF}
  end;
end;

{ TIpacSectionsList }

function TIpacSectionsList.Add(var SourceFileStream: TFileStream; Name,
  Kind: string; AbsoluteOffset, RelativeOffset, Size: LongWord): Integer;
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
  NewItem.fIndex := Result;

  // Searching the section extended type
  NewItem.AnalyzeSection(SourceFileStream);

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

constructor TIpacSectionsList.Create(Owner: TIpacEditor);
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

function TIpacSectionsList.GetIpacFileSection: TFileSectionsListItem;
begin
  Result := Owner.Sections[fIpacFileSectionIndex];
end;

function TIpacSectionsList.GetItem(Index: Integer): TIpacSectionsListItem;
begin
  Result := TIpacSectionsListItem(fList.Items[Index]);
end;

procedure TIpacSectionsList.WriteIpacFooter(var FS: TFileStream);
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
    Entry.Offset := Items[i].RelativeOffset;
    Entry.Size := Items[i].Size;

    // Writing to the file
    FS.Write(Entry, SizeOf(TIpacSectionEntry));

    // Calculating Ipac Section size
    Inc(IpacSection.fSize, Items[i].Size);
    Inc(IpacSection.fSize, Items[i].PaddingSize);

{$IFDEF DEBUG}
    with Items[i] do
      WriteLn('  #', i, ': Name: ', Name, ', Kind: ', Kind, ', ROffset: ',
        RelativeOffset, ', AOffset: ', AbsoluteOffset, ', Size: ', Size);
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

procedure TIpacSectionsList.WriteIpacHeader(var FS: TFileStream);
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

