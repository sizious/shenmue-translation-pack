unit MemoEdit;

interface

uses
  Windows, SysUtils, Classes, FSParser, StrDeps;

type
  EDiaryEditor = class(Exception);
  EMessageTextNotEditable = class(EDiaryEditor);

  TDiaryEditor = class;

  TDiaryEditorMessagesList = class;

  TDiaryEditorMessagesListItem = class(TObject)
  private
    fOwner: TDiaryEditorMessagesList;
    fIndex: Integer;
    fText: string;
    fEditable: Boolean;
    fStringPointerOffset: LongWord;
    fStringOffset: LongWord;
    fPageIndex: Integer;
    fAllowStringWrite: Boolean;
    fNewStringOffset: LongWord;
    function GetEditor: TDiaryEditor;
    procedure SetText(const Value: string);
    procedure SetNewStringOffset(const Value: LongWord);
  protected
    property AllowStringWrite: Boolean read fAllowStringWrite;
    property Editor: TDiaryEditor read GetEditor;
    property NewStringOffset: LongWord read fNewStringOffset
      write SetNewStringOffset;
  public
    constructor Create(AOwner: TDiaryEditorMessagesList);
    property Editable: Boolean read fEditable;
    property Index: Integer read fIndex;
    property PageIndex: Integer read fPageIndex;
    property StringPointerOffset: LongWord read fStringPointerOffset;
    property StringOffset: LongWord read fStringOffset;
    property Text: string read fText write SetText;    
    property Owner: TDiaryEditorMessagesList read fOwner;
  end;

  TDiaryEditorPagesListItem = class;

  TDiaryEditorMessagesList = class(TObject)
  private
    fItemsList: TList;
    fOwner: TDiaryEditorPagesListItem;
    function GetItem(Index: Integer): TDiaryEditorMessagesListItem;
    function GetCount: Integer;
  protected
    function Add(Item: TDiaryEditorMessagesListItem): Integer;
    procedure Clear;
  public
    constructor Create(AOwner: TDiaryEditorPagesListItem);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TDiaryEditorMessagesListItem
      read GetItem; default;
    property Owner: TDiaryEditorPagesListItem read fOwner;
  end;

  TDiaryEditorPagesList = class;

  TDiaryEditorPagesListItem = class(TObject)
  private
    fMessages: TDiaryEditorMessagesList;
    fOwner: TDiaryEditorPagesList;
  public
    constructor Create(AOwner: TDiaryEditorPagesList);
    destructor Destroy; override;
    property Messages: TDiaryEditorMessagesList read fMessages;
    property Owner: TDiaryEditorPagesList read fOwner;
  end;

  TDiaryEditorPagesList = class(TObject)
  private
    fItemsList: TList;
    fOwner: TDiaryEditor;
    function GetCount: Integer;
    function GetItem(Index: Integer): TDiaryEditorPagesListItem;
  protected
    procedure Clear;
    function GetRequestedPage(const Index: Integer): TDiaryEditorPagesListItem;
  public
    constructor Create(AOwner: TDiaryEditor);
    destructor Destroy; override;
    procedure ExportToCSV(const FileName: TFileName);
    procedure ExportToFile(const FileName: TFileName);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TDiaryEditorPagesListItem
      read GetItem; default;
    property Owner: TDiaryEditor read fOwner;
  end;

  TDiaryEditor = class(TObject)
  private
    fPages: TDiaryEditorPagesList;
    fSections: TFileSectionsList;
    fMSTRStringsStartOffset: LongWord;
    fDependancesList: TDiaryEditorStringsDependances;
    fFileLoaded: Boolean;
    fSectionIndexRUBI: Integer;
    fSectionIndexMEMO: Integer;
    fSectionIndexMSTR: Integer;
    fRUBIStringStartOffset: LongWord;
    fSourceFileName: TFileName;
    fMakeBackup: Boolean;
  protected
    procedure AddEntry(var Input: TFileStream; const StrPointerOffset,
      StrOffset: LongWord; const PageNumber: Integer);
    procedure Clear;
    procedure WriteTempUpdatedSections(var InStream: TFileStream;
      const MEMOFileName, RUBIFileName, MSTRFileName: TFileName);
    property Dependances: TDiaryEditorStringsDependances read fDependancesList;
    property MSTRStringsStartOffset: LongWord read fMSTRStringsStartOffset;    
    property RUBIStringsStartOffset: LongWord read fRUBIStringStartOffset;
    property SectionIndexMEMO: Integer read fSectionIndexMEMO;
    property SectionIndexMSTR: Integer read fSectionIndexMSTR;
    property SectionIndexRUBI: Integer read fSectionIndexRUBI;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromFile(const FileName: TFileName): Boolean;
    function SaveToFile(const FileName: TFileName): Boolean;
    property MakeBackup: Boolean read fMakeBackup write fMakeBackup;
    property Loaded: Boolean read fFileLoaded;
    property Pages: TDiaryEditorPagesList read fPages;
    property Sections: TFileSectionsList read fSections;
    property SourceFileName: TFileName read fSourceFileName;
  end;

implementation

uses
  Common, SysTools, ChrUtils, XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX;

const
  MSTR_SIGN = 'MSTR';
  MEMO_SIGN = 'MEMO';
  RUBI_SIGN = 'RUBI';
  EMPTY_STRING_OFFSET_VALUE = $FFFFFFFF;
  MSTR_PADDING_SIZE = 8;
  
{ TDiaryEditor }

procedure TDiaryEditor.AddEntry(var Input: TFileStream; const StrPointerOffset,
  StrOffset: LongWord; const PageNumber: Integer);
var
  SavedPosition: Int64;
  NewMsgItem: TDiaryEditorMessagesListItem;
  StringAbsoluteOffset: LongWord;
  Messages: TDiaryEditorMessagesList;

begin
  // Saving the current position
  SavedPosition := Input.Position;

  // Retrieving the page object. If doesn't exists, create it.
  Messages := Pages.GetRequestedPage(PageNumber).Messages;

  // Creating the new object
  NewMsgItem := TDiaryEditorMessagesListItem.Create(Messages);

  // Initializing the new entry
  NewMsgItem.fStringPointerOffset := StrPointerOffset;
  NewMsgItem.fStringOffset := StrOffset;
  NewMsgItem.fEditable := (StrOffset <> EMPTY_STRING_OFFSET_VALUE);
  NewMsgItem.fText := '';
  NewMsgItem.fPageIndex := PageNumber;
  NewMsgItem.fAllowStringWrite := NewMsgItem.fEditable;
  NewMsgItem.fNewStringOffset := EMPTY_STRING_OFFSET_VALUE; // updated when SaveToFile is called

{$IFDEF DEBUG}
  StringAbsoluteOffset := 0;
{$ENDIF}

  // Adding to the list
  NewMsgItem.fIndex := Messages.Add(NewMsgItem);

  // Reading the text if possible
  if NewMsgItem.Editable then begin
    // Retrieve the string
    StringAbsoluteOffset := MSTRStringsStartOffset + NewMsgItem.StringOffset;
    Input.Seek(StringAbsoluteOffset, soFromBeginning);
    NewMsgItem.fText := ReadNullTerminatedString(Input);

    // Adding a string depandence reference
    Dependances.Add(StrOffset, NewMsgItem, NewMsgItem.fAllowStringWrite);
  end;

  // Restore saved position
  Input.Seek(SavedPosition, soFromBeginning);

{$IFDEF DEBUG}
  if NewMsgItem.Editable then
    WriteLn('#P:', NewMsgItem.PageIndex, ';L:', NewMsgItem.Index, ', StrAbsoluteOffset=',
      StringAbsoluteOffset, ', Ptr=', NewMsgItem.StringPointerOffset, ', Str=',
      NewMsgItem.StringOffset, sLineBreak, '  "', NewMsgItem.Text, '"');
{$ENDIF}
end;

procedure TDiaryEditor.Clear;
begin
  Pages.Clear;
  Dependances.Clear;
//  fStartMessagesOffset := 0;
end;

constructor TDiaryEditor.Create;
begin
  fPages := TDiaryEditorPagesList.Create(Self);
  fSections := TFileSectionsList.Create(Self);
  fDependancesList := TDiaryEditorStringsDependances.Create;
end;

destructor TDiaryEditor.Destroy;
begin
  fPages.Free;
  fSections.Free;
  fDependancesList.Free;
  inherited;
end;

function TDiaryEditor.LoadFromFile(const FileName: TFileName): Boolean;
const
  MAX_LINE_PER_PAGE = 5;

var
  Input: TFileStream;
  MaxPosition, PageNumber, EntryCount: Integer;
  StrPointerOffset, StrOffset: LongWord;
  Section: TFileSectionsListItem;

begin
  Result := False;
  if not FileExists(FileName) then Exit;

  // Try to parse the MEMODATA.BIN file
  Input := TFileStream.Create(FileName, fmOpenRead);
  try
    // Parsing the file
    ParseFileSections(Input, fSections);

    // Initializing StartMessagesOffset
    fSectionIndexMSTR := Sections.IndexOf(MSTR_SIGN); // MSTR is the section containing the strings
    if SectionIndexMSTR <> -1 then
      fMSTRStringsStartOffset := Sections[SectionIndexMSTR].Offset
        + SizeOf(TSectionEntry);

    // Search the Memo section, contains the MSTR strings pointers
    fSectionIndexMEMO := Sections.IndexOf(MEMO_SIGN);

    // Search the RUBI section, contains "japanese" strings...
    fSectionIndexRUBI := Sections.IndexOf(RUBI_SIGN);

    // The file to be valid must be contains MEMO, RUBI and MSTR sections
    fFileLoaded := (SectionIndexMEMO <> -1) and (SectionIndexRUBI <> -1)
      and (SectionIndexMSTR <> -1);

    // Analyzing MEMO and MSTR sections
    if Loaded then begin
      // Clearing the object
      Clear;
      fSourceFileName := FileName;

      // Getting the RUBI starting address in the MSTR section
      Section := Sections[SectionIndexRUBI];
      Input.Seek(Section.Offset + SizeOf(TSectionEntry), soFromBeginning);
      repeat
        Input.Read(fRUBIStringStartOffset, UINT32_SIZE);
      until fRUBIStringStartOffset <> EMPTY_STRING_OFFSET_VALUE;

      // Getting the max position
      Section := Sections[SectionIndexMEMO];
      MaxPosition := Section.Offset + Section.Size;

      // Seek 'MEMO' header
      Input.Seek(SizeOf(TSectionEntry), soFromBeginning);

      // Read each string list
      PageNumber := 0;
      EntryCount := 0;
      repeat

        StrPointerOffset := Input.Position;
        Input.Read(StrOffset, 4);

        AddEntry(Input, StrPointerOffset, StrOffset, PageNumber);

        Inc(EntryCount);
        if (EntryCount mod MAX_LINE_PER_PAGE) = 0 then
          Inc(PageNumber);

      until Input.Position >= MaxPosition;
    end; // Loaded

  finally
    Input.Free;
  end;
end;

function TDiaryEditor.SaveToFile(const FileName: TFileName): Boolean;
var
  OutFileName, fnMEMO, fnRUBI, fnMSTR: TFileName;
  i: Integer;
  InStream, OutStream: TFileStream;

  function WriteUpdatedSection(const SectionName: TFileName): Boolean;
  var
    FName: TFileName;
    UpdatedStream: TFileStream;
    Header: TSectionEntry;

  begin
    FName := '';

    (* Determinates if the requested section was updated before by
       WriteTempUpdatedSections. *)
    if SectionName = MEMO_SIGN then
      FName := fnMEMO
    else if SectionName = RUBI_SIGN then
      FName := fnRUBI
    else if SectionName = MSTR_SIGN then
      FName := fnMSTR;

    // Write the updated section if possible
    Result := FileExists(FName);
    if Result then begin
      UpdatedStream := TFileStream.Create(FName, fmOpenRead);
      try
        // Write the section header
        StrCopy(Header.Name, PChar(SectionName));
        Header.Size := UpdatedStream.Size + SizeOf(TSectionEntry);
        OutStream.Write(Header, SizeOf(TSectionEntry));

        // Write the updated section content
        OutStream.CopyFrom(UpdatedStream, UpdatedStream.Size);

        // Write MSTR Padding if needed
        if SectionName = MSTR_SIGN then
          WriteNullBlock(OutStream, MSTR_PADDING_SIZE);
      finally
        UpdatedStream.Free;
        DeleteFile(FName); // clean the temp file
      end; // try
    end; // Result
  end; // function

begin
  Result := False;
  if not Loaded then Exit;


  OutFileName := GetTempFileName;

  OutStream := TFileStream.Create(OutFileName, fmCreate);
  InStream := TFileStream.Create(SourceFileName, fmOpenRead);
  try
    // Update the MEMO, RUBI and MSTR sections.
    fnMEMO := GetTempFileName;
    fnRUBI := GetTempFileName;
    fnMSTR := GetTempFileName;
    WriteTempUpdatedSections(InStream, fnMEMO, fnRUBI, fnMSTR);

    // Update all sections
    for i := 0 to Sections.Count - 1 do

      // Write the updated section, and if not, write the raw section from the source
      if not WriteUpdatedSection(Sections[i].Name) then begin
        // Write the raw section from the InStream
        InStream.Seek(Sections[i].Offset, soFromBeginning);
        OutStream.Write(InStream, Sections[i].Size);
      end;
    
  finally
    InStream.Free;
    OutStream.Free;

    // Writing the requested updated file
    if FileExists(FileName) and (not MakeBackup) then
      DeleteFile(FileName)
    else
      RenameFile(FileName, ChangeFileExt(FileName, '.BAK'));
    MoveFile(OutFileName, FileName);
  end;
end;

procedure TDiaryEditor.WriteTempUpdatedSections(var InStream: TFileStream;
  const MEMOFileName, RUBIFileName, MSTRFileName: TFileName);
var
  p, m, RUBI_PatchValue: Integer;
  Messages: TDiaryEditorMessagesList;
  MEMO_FStream, RUBI_FStream, MSTR_FStream: TFileStream;
  Item: TDiaryEditorMessagesListItem;
  StrOffset, Temp: LongWord;

begin
  MEMO_FStream := TFileStream.Create(MEMOFileName, fmCreate);
  MSTR_FStream := TFileStream.Create(MSTRFileName, fmCreate);
  RUBI_FStream := TFileStream.Create(RUBIFileName, fmCreate);
  try
    //**************************************************************************
    // UPDATING MEMO AND MSTR SECTIONS
    //**************************************************************************

    // Write update MEMO and MSTR sections
    for p := 0 to Pages.Count - 1 do begin
      Messages := Pages[p].Messages;

      for m := 0 to Messages.Count - 1 do begin
        Item := Messages[m];

        // Write the string in the MSTR section
        if Item.AllowStringWrite then begin
          Item.NewStringOffset := MSTR_FStream.Position;
          WriteNullTerminatedString(MSTR_FStream, Item.Text);
          StrOffset := Item.NewStringOffset;
        end else
          StrOffset := Item.NewStringOffset;

        // Write the MEMO offset
        MEMO_FStream.Write(StrOffset, UINT32_SIZE);

      end; // m

    end; // p

    //**************************************************************************
    // UPDATING RUBI SECTION
    //**************************************************************************

    // Calculating the new RUBI string start offset (with a "patch value")
    RUBI_PatchValue := MSTR_FStream.Size - RUBIStringsStartOffset;
{$IFDEF DEBUG}
    WriteLn('RUBI_PatchValue: ', RUBI_PatchValue);
{$ENDIF}

    // Dump the RUBI "MSTR" file content from the original file
    MSTR_FStream.Seek(0, soFromEnd);
    InStream.Seek(MSTRStringsStartOffset
      + RUBIStringsStartOffset, soFromBeginning);
    Temp := Sections[SectionIndexMSTR].Size - RUBIStringsStartOffset - MSTR_PADDING_SIZE;
    MSTR_FStream.CopyFrom(InStream, Temp);
    
    // Writing the updated RUBI section
    InStream.Seek(Sections[SectionIndexRUBI].Offset
      + SizeOf(TSectionEntry), soFromBeginning);
    Temp := Sections[SectionIndexRUBI].Offset + Sections[SectionIndexRUBI].Size;
    repeat
      InStream.Read(StrOffset, UINT32_SIZE);
      if StrOffset <> EMPTY_STRING_OFFSET_VALUE then
        Inc(StrOffset, RUBI_PatchValue);
      RUBI_FStream.Write(StrOffset, UINT32_SIZE);
    until InStream.Position >= Temp;

  finally
    MEMO_FStream.Free;
    MSTR_FStream.Free;
    RUBI_FStream.Free;
  end;

end;

{ TDiaryEditorMessagesListItem }

constructor TDiaryEditorMessagesListItem.Create(
  AOwner: TDiaryEditorMessagesList);
begin
  fOwner := AOwner;
end;

function TDiaryEditorMessagesListItem.GetEditor: TDiaryEditor;
begin
  Result := (Owner.Owner.Owner.Owner); // Funny !!! But it's correct.
end;

procedure TDiaryEditorMessagesListItem.SetNewStringOffset(
  const Value: LongWord);
var
  i, DependancesIndex: Integer;
  CurrentDependance: TPointerOffsetsList;

begin
  fNewStringOffset := Value;

  // Update every dependances NewStringOffset
  if Editor.Dependances.IndexOf(StringOffset, DependancesIndex) then begin
    CurrentDependance := Editor.Dependances[DependancesIndex];
    for i := 0 to CurrentDependance.Count - 1 do
      TDiaryEditorMessagesListItem(CurrentDependance[i]).fNewStringOffset := Value;
  end;
end;

procedure TDiaryEditorMessagesListItem.SetText(const Value: string);
var
  i, DependancesIndex: Integer;
  Item: TDiaryEditorMessagesListItem;

begin
  if not Editable then
    raise EMessageTextNotEditable.Create(
      Format('This item [Page:%d, Message:%d] is NOT editable!', [PageIndex, Index])
    );

  fText := Value;

  // Update string dependancies
  if Editor.Dependances.IndexOf(fStringOffset, DependancesIndex) then
    for i := 0 to Editor.Dependances[DependancesIndex].Count - 1 do begin
      Item := TDiaryEditorMessagesListItem(Editor.Dependances[DependancesIndex][i]);
      Item.fText := Value;
    end;
end;

{ TDiaryEditorMessagesList }

procedure TDiaryEditorPagesList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fItemsList.Clear;
end;

constructor TDiaryEditorPagesList.Create(AOwner: TDiaryEditor);
begin
  fOwner := AOwner;
  fItemsList := TList.Create;
end;

destructor TDiaryEditorPagesList.Destroy;
begin
  Clear;
  fItemsList.Free;
  inherited;
end;

procedure TDiaryEditorPagesList.ExportToCSV(const FileName: TFileName);
var
  Buffer: TStringList;
  i, j: Integer;
  Page: TDiaryEditorPagesListItem;
  Msg: TDiaryEditorMessagesListItem;
  StrText, StrROffset, StrAOffset: string;

begin
  Buffer := TStringList.Create;
  try
    Buffer.Add('Page Number;Line Number;String Pointer Offset;' +
      'String Relative Offset;String Absolute Offset;Text');
    for i := 0 to Count - 1 do begin
      Page := Items[i];
      for j := 0 to Page.Messages.Count - 1 do begin
        Msg := Page.Messages[j];

        StrROffset := '-';
        StrAOffset := '-';
        StrText := '(undef)';
        if Msg.Editable then begin
          StrROffset := IntToStr(Msg.StringOffset);
          StrAOffset := IntToStr(Owner.MSTRStringsStartOffset + Msg.StringOffset);
          StrText := Msg.Text;
        end;

        Buffer.Add(Format('%d;%d;%d;%s;%s;"%s"',
          [i, j, Msg.StringPointerOffset, StrROffset, StrAOffset, StrText]));
          
      end;
    end;

    Buffer.SaveToFile(FileName);
  finally
    Buffer.Free;
  end;
end;

procedure TDiaryEditorPagesList.ExportToFile(const FileName: TFileName);
var
  XMLDoc: IXMLDocument;
  p, m: Integer;

begin
  XMLDoc := TXMLDocument.Create(nil);

  // Setting XMLDocument properties
  with XMLDoc do begin
    Options := [doNodeAutoCreate];
    ParseOptions:= [];
    NodeIndentStr:= '  ';
    Active := True;
    Version := '1.0';
    Encoding := 'ISO-8859-1';
  end;

  // Navigating in the list...
  for p := 0 to Count - 1 do
    for m := 0 to Items[p].Messages.Count - 1 do begin
      Items[p].Messages[m].Text  ___ 
    end;
end;

function TDiaryEditorPagesList.GetCount: Integer;
begin
  Result := fItemsList.Count;
end;

function TDiaryEditorPagesList.GetItem(
  Index: Integer): TDiaryEditorPagesListItem;
begin
  Result := TDiaryEditorPagesListItem(fItemsList[Index]);
end;

function TDiaryEditorPagesList.GetRequestedPage(
  const Index: Integer): TDiaryEditorPagesListItem;
var
  i: Integer;

begin
  Result := nil;
  if Index < 0 then Exit;

  if (Index >= 0) and (Index < Count) then
    // Retrieve the page
    Result := Items[Index]
  else begin
    // Create the page(s)
    for i := Count to Index do begin
      Result := TDiaryEditorPagesListItem.Create(Self);
      fItemsList.Add(Result);
    end;
  end;
end;

{ TDiaryEditorMessagesList }

function TDiaryEditorMessagesList.Add(Item: TDiaryEditorMessagesListItem): Integer;
begin
  Result := fItemsList.Add(Item);
end;

procedure TDiaryEditorMessagesList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fItemsList.Clear;
end;

constructor TDiaryEditorMessagesList.Create(AOwner: TDiaryEditorPagesListItem);
begin
  fItemsList := TList.Create;
  fOwner := AOwner;
end;

destructor TDiaryEditorMessagesList.Destroy;
begin
  Clear;
  fItemsList.Free;
  inherited;
end;

function TDiaryEditorMessagesList.GetCount: Integer;
begin
  Result := fItemsList.Count;
end;

function TDiaryEditorMessagesList.GetItem(
  Index: Integer): TDiaryEditorMessagesListItem;
begin
  Result := TDiaryEditorMessagesListItem(fItemsList[Index]);
end;

{ TDiaryEditorPagesListItem }

constructor TDiaryEditorPagesListItem.Create(AOwner: TDiaryEditorPagesList);
begin
  fMessages := TDiaryEditorMessagesList.Create(Self);
  fOwner := AOwner;
end;

destructor TDiaryEditorPagesListItem.Destroy;
begin
  fMessages.Free;
  inherited;
end;

end.
