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
  protected
    property AllowStringWrite: Boolean read fAllowStringWrite;
    property Editor: TDiaryEditor read GetEditor;
    property NewStringOffset: LongWord read fNewStringOffset;
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
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TDiaryEditorPagesListItem
      read GetItem; default;
    property Owner: TDiaryEditor read fOwner;
  end;

  TDiaryEditor = class(TObject)
  private
    fPages: TDiaryEditorPagesList;
    fSections: TFileSectionsList;
    fStartMessagesOffset: LongWord;
    fDependancesList: TDiaryEditorStringsDependances;
    fFileLoaded: Boolean;
  protected
    procedure AddEntry(var Input: TFileStream; const StrPointerOffset,
      StrOffset: LongWord; const PageNumber: Integer);
    procedure Clear;
    procedure WriteUpdatedSections(const fnMEMO, fnMSTR: TFileName);
    property Dependances: TDiaryEditorStringsDependances read fDependancesList;         
    property StartMessagesOffset: LongWord read fStartMessagesOffset;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromFile(const FileName: TFileName): Boolean;
    function SaveToFile(const FileName: TFileName): Boolean;
    property Loaded: Boolean read fFileLoaded;
    property Pages: TDiaryEditorPagesList read fPages;
    property Sections: TFileSectionsList read fSections;
  end;

implementation

uses
  Common, SysTools, ChrUtils;

const
  UNEDITABLE_OFFSET_VALUE = $FFFFFFFF;
  
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
  NewMsgItem.fEditable := (StrOffset <> UNEDITABLE_OFFSET_VALUE);
  NewMsgItem.fText := '';
  NewMsgItem.fPageIndex := PageNumber;
  NewMsgItem.fAllowStringWrite := NewMsgItem.fEditable;

{$IFDEF DEBUG}
  StringAbsoluteOffset := 0;
{$ENDIF}

  // Adding to the list
  NewMsgItem.fIndex := Messages.Add(NewMsgItem);

  // Reading the text if possible
  if NewMsgItem.Editable then begin
    // Retrieve the string
    StringAbsoluteOffset := StartMessagesOffset + NewMsgItem.StringOffset;
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
  i, MaxPosition, PageNumber, EntryCount: Integer;
  StrPointerOffset, StrOffset: LongWord;
  MemoSection: TFileSectionsListItem;

begin
  Result := False;

  Input := TFileStream.Create(FileName, fmOpenRead);
  try
    // Parsing the file
    ParseFileSections(Input, fSections);

    // Initializing StartMessagesOffset
    i := Sections.IndexOf(MSTR_SIGN); // MSTR is the section containing the strings
    if i <> -1 then
      fStartMessagesOffset := Sections[i].Offset + SizeOf(TSectionEntry);

    // Search the Memo section, contains the MSTR strings pointers
    i := Sections.IndexOf(MEMO_SIGN);
    fFileLoaded := i <> -1;

    // Analyzing MEMO and MSTR sections
    if Loaded then begin
      // Clearing the object
      Clear;
      
      // Getting the max position
      MemoSection := Sections[i];
      MaxPosition := MemoSection.Offset + MemoSection.Size;

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
  fnMEMO, fnMSTR: TFileName;
  
begin
  Result := False;
  if not Loaded then Exit;

  // Update the MEMO and MSTR sections.
  fnMEMO := GetTempFileName;
  fnMSTR := GetTempFileName;
  WriteUpdatedSections(fnMEMO, fnMSTR);

  Reconstruire le fichier MEMODATA.BIN, mise à jour de la section RUBI également...
end;

procedure TDiaryEditor.WriteUpdatedSections(const fnMEMO, fnMSTR: TFileName);
var
  p: Integer;
  m: Integer;
  Messages: TDiaryEditorMessagesList;
  MEMO_FStream, MSTR_FStream: TFileStream;
  Item: TDiaryEditorMessagesListItem;
  StrOffset: LongWord;
  
begin
  MEMO_FStream := TFileStream.Create(fnMEMO, fmCreate);
  MSTR_FStream := TFileStream.Create(fnMSTR, fmCreate);
  try

    for p := 0 to Pages.Count - 1 do begin
      Messages := Pages[p].Messages;

      for m := 0 to Messages.Count - 1 do begin
        Item := Messages[m];

        StrOffset := UNEDITABLE_OFFSET_VALUE;

        // Write the string in the MSTR section
        if Item.AllowStringWrite then begin
          Item.fNewStringOffset := MSTR_FStream.Position;
          WriteNullTerminatedString(MSTR_FStream, Item.Text);
          StrOffset := Item.fNewStringOffset;
        end;

        // Write the MEMO offset
        MEMO_FStream.Write(StrOffset, UINT32_SIZE);

      end; // m

    end; // p

    
  finally
    MEMO_FStream.Free;
    MSTR_FStream.Free;
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
          StrAOffset := IntToStr(Owner.StartMessagesOffset + Msg.StringOffset);
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
