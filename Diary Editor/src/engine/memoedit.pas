unit MemoEdit;

interface

uses
  Windows, SysUtils, Classes, FSParser, StrDeps;

type
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
    function GetEditor: TDiaryEditor;
    procedure SetText(const Value: string);
  protected
    property Editor: TDiaryEditor read GetEditor;
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
    procedure Add(Item: TDiaryEditorMessagesListItem);
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
  protected
    procedure AddEntry(var Input: TFileStream; const StrPointerOffset,
      StrOffset: LongWord; const PageNumber: Integer);
    property Dependances: TDiaryEditorStringsDependances read fDependancesList;         
    property StartMessagesOffset: LongWord read fStartMessagesOffset;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromFile(const FileName: TFileName): Boolean;
    property Pages: TDiaryEditorPagesList read fPages;
    property Sections: TFileSectionsList read fSections;
  end;

implementation

uses
  ChrParse;
  
{ TDiaryEditor }

procedure TDiaryEditor.AddEntry(var Input: TFileStream; const StrPointerOffset,
  StrOffset: LongWord; const PageNumber: Integer);
var
  SavedPosition: Int64;
  NewItem: TDiaryEditorMessagesListItem;
  StringAbsoluteOffset: LongWord;
  Messages: TDiaryEditorMessagesList;

begin
  // Saving the current position
  SavedPosition := Input.Position;

  // Retrieving the page object. If doesn't exists, create it.
  Messages := Pages.GetRequestedPage(PageNumber).Messages;

  // Creating the new object
  NewItem := TDiaryEditorMessagesListItem.Create(Messages);

  // Initializing the new entry
  NewItem.fStringPointerOffset := StrPointerOffset;
  NewItem.fStringOffset := StrOffset;
  NewItem.fEditable := (StrOffset <> $FFFFFFFF);
  NewItem.fText := '';
  NewItem.fPageIndex := PageNumber;

{$IFDEF DEBUG}
  StringAbsoluteOffset := 0;
{$ENDIF}

  // Adding to the list
  Messages.Add(NewItem);

  // Reading the text if possible
  if NewItem.Editable then begin
    // Retrieve the string
    StringAbsoluteOffset := StartMessagesOffset + NewItem.StringOffset;
    Input.Seek(StringAbsoluteOffset, soFromBeginning);
    NewItem.fText := ReadNullTerminatedString(Input);

    // Adding a string depandence reference
    Dependances.Add(StrOffset, NewItem);
  end;

  // Restore saved position
  Input.Seek(SavedPosition, soFromBeginning);

{$IFDEF DEBUG}
  if NewItem.Editable then
    WriteLn('#P:', NewItem.PageIndex, ';L:', NewItem.Index, ', StrAbsoluteOffset=',
      StringAbsoluteOffset, ', Ptr=', NewItem.StringPointerOffset, ', Str=',
      NewItem.StringOffset, sLineBreak, '  "', NewItem.Text, '"');
{$ENDIF}
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
  MemoSection: TFileSectionsListItem;

begin
  Result := False;

  Input := TFileStream.Create(FileName, fmOpenRead);
  try
    // Parsing the file
    ParseFileSections(Input, fSections);

    fStartMessagesOffset := Sections[Sections.IndexOf('MSTR')].Offset + SizeOf(TSectionEntry);

    // Getting the max position
    MemoSection := Sections[Sections.IndexOf('MEMO')];
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

  finally
    Input.Free;
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
  i, Index: Integer;
  Item: TDiaryEditorMessagesListItem;

begin
  fText := Value;

  // Update string dependancies
  if Editor.Dependances.IndexOf(fStringOffset, Index) then
    for i := 0 to Editor.Dependances[Index].Count - 1 do begin
      Item := TDiaryEditorMessagesListItem(Editor.Dependances[Index][i]);
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

procedure TDiaryEditorMessagesList.Add(Item: TDiaryEditorMessagesListItem);
begin
  Item.fIndex := fItemsList.Add(Item);
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
