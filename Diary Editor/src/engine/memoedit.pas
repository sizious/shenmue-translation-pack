unit MemoEdit;

interface

uses
  Windows, SysUtils, Classes, FSParser;
  
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
    function GetEditor: TDiaryEditor;
  protected
    property Editor: TDiaryEditor read GetEditor;
  public
    property Editable: Boolean read fEditable;
    property Index: Integer read fIndex;
    property StringPointerOffset: LongWord read fStringPointerOffset;
    property StringOffset: LongWord read fStringOffset;
    property Text: string read fText write fText;    
    property Owner: TDiaryEditorMessagesList read fOwner;
  end;

  TDiaryEditorMessagesList = class(TObject)
  private
    fItemsList: TList;
    fOwner: TDiaryEditor;
    fStartMessagesOffset: LongWord;
    function GetCount: Integer;
    function GetItem(Index: Integer): TDiaryEditorMessagesListItem;
  protected
    procedure Add(const StrPointerOffset, StrOffset: LongWord;
      var Input: TFileStream);
    procedure Clear;
    property StartMessagesOffset: LongWord read fStartMessagesOffset;
  public
    constructor Create(AOwner: TDiaryEditor);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TDiaryEditorMessagesListItem
      read GetItem; default;
    property Owner: TDiaryEditor read fOwner;
  end;

  TDiaryEditor = class(TObject)
  private
    fMessages: TDiaryEditorMessagesList;
    fSections: TFileSectionsList;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromFile(const FileName: TFileName): Boolean;
    property Messages: TDiaryEditorMessagesList read fMessages;
    property Sections: TFileSectionsList read fSections;
  end;

implementation

uses
  ChrParse;
  
{ TDiaryEditor }

constructor TDiaryEditor.Create;
begin
  fMessages := TDiaryEditorMessagesList.Create(Self);
  fSections := TFileSectionsList.Create(Self);
end;

destructor TDiaryEditor.Destroy;
begin
  fMessages.Free;
  fSections.Free;
  inherited;
end;

function TDiaryEditor.LoadFromFile(const FileName: TFileName): Boolean;
var
  Input: TFileStream;
  i, MemoOffset, MessagesCount: Integer;
  StrPointerOffset, StrOffset: LongWord;
  Section: TFileSectionsListItem;

begin
  Result := False;

  Input := TFileStream.Create(FileName, fmOpenRead);
  try
    // Parsing the file
    ParseFileSections(Input, fSections);

    Messages.fStartMessagesOffset := Sections[Sections.IndexOf('MSTR')].Offset + SizeOf(TSectionEntry);

    // Getting the max position
    Section := Sections[Sections.IndexOf('MEMO')];
    MessagesCount := Section.Offset + Section.Size;

    i := 0;

    // Seek 'MEMO' header
    Input.Seek(SizeOf(TSectionEntry), soFromBeginning);

    // Read each string list
    repeat
      StrPointerOffset := Input.Position;
      Input.Read(StrOffset, 4);
      Messages.Add(StrPointerOffset, StrOffset, Input);
    until Input.Position >= MessagesCount;

  finally
    Input.Free;
  end;
end;

{ TDiaryEditorMessagesListItem }

function TDiaryEditorMessagesListItem.GetEditor: TDiaryEditor;
begin

end;

{ TDiaryEditorMessagesList }

procedure TDiaryEditorMessagesList.Add(const StrPointerOffset,
  StrOffset: LongWord; var Input: TFileStream);
var
  SavedPosition: Int64;
  NewItem: TDiaryEditorMessagesListItem;
  StringAbsoluteOffset: LongWord;
  
begin
  // Saving the current position
  SavedPosition := Input.Position;

  // Creating the new object
  NewItem := TDiaryEditorMessagesListItem.Create;

  // Initializing the new entry
  NewItem.fOwner := Self;
  NewItem.fStringPointerOffset := StrPointerOffset;
  NewItem.fStringOffset := StrOffset;
  NewItem.fEditable := (StrOffset <> $FFFFFFFF);
  NewItem.fText := '';

{$IFDEF DEBUG}
  StringAbsoluteOffset := 0;
{$ENDIF}

  // Reading the text if possible
  if NewItem.Editable then begin
    StringAbsoluteOffset := StartMessagesOffset + NewItem.StringOffset;
    Input.Seek(StringAbsoluteOffset, soFromBeginning);
    NewItem.fText := ReadNullTerminatedString(Input);
  end;

  // Adding to the list
  NewItem.fIndex := fItemsList.Add(NewItem);

  // Restore saved position
  Input.Seek(SavedPosition, soFromBeginning);

{$IFDEF DEBUG}
  if NewItem.Editable then
    WriteLn('#', NewItem.Index, ', offset=', StringAbsoluteOffset, ': "', NewItem.Text, '"');
{$ENDIF}
end;

procedure TDiaryEditorMessagesList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fItemsList.Clear;
end;

constructor TDiaryEditorMessagesList.Create(AOwner: TDiaryEditor);
begin
  fOwner := AOwner;
  fItemsList := TList.Create;
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

end.
