(*
  Shenmue Notebook Editor

  Memo Editor Engine
*)
unit MemoEdit;

interface

uses
  Windows, SysUtils, Classes, FSParser, StrDeps, SysTools;

type
  EDiaryEditor = class(Exception);
  EMessageTextNotEditable = class(EDiaryEditor);

  TPagePosition = (ppLeft, ppRight);
    
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
    fFlagCode: Word;
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
    property FlagCode: Word read fFlagCode write fFlagCode;
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
    function ExportToFile(const FileName: TFileName): Boolean;
    function ImportFromFile(const FileName: TFileName): Boolean;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TDiaryEditorPagesListItem
      read GetItem; default;
    property Owner: TDiaryEditor read fOwner;
  end;

  // Manage the MEMOFLG.BIN for the Xbox version
  TXboxExecutableVersion = (xevNotApplicable, xevTrial, xevRetailPalUk,
    xevRetailUsa);
  
  TXboxMemoFlagInfo = class(TObject)
  private
    fFlagOffset: LongWord;
    fExecutableVersion: TXboxExecutableVersion;
    fExecutableFileName: TFileName;
    fOwner: TDiaryEditor;
  protected
    procedure Clear;
    procedure ExecuteDetection;
    function IsXboxExecutable(var InFlagStream: TFileStream;
      var ExecutableVersionResult: TXboxExecutableVersion;
      var FlagOffsetResult: LongWord): Boolean;
  public
    constructor Create(AOwner: TDiaryEditor);
    destructor Destroy; override;
    property ExecutableFileName: TFileName read fExecutableFileName;
    property ExecutableVersion: TXboxExecutableVersion read fExecutableVersion;
    property FlagOffset: LongWord read fFlagOffset;
    property Owner: TDiaryEditor read fOwner;
  end;

  // Main class
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
    fDataSourceFileName: TFileName;
    fMakeBackup: Boolean;
    fFlagSourceFileName: TFileName;
    fXboxMemoFlagInfo: TXboxMemoFlagInfo;
    fPlatformVersion: TPlatformVersion;
  protected
    procedure AddEntry(var Input: TFileStream; const StrPointerOffset,
      StrOffset: LongWord; const PageNumber: Integer; const FlagCode: Word);
    procedure WriteTempUpdatedSections(var InStream: TFileStream;
      const MEMOFileName, RUBIFileName, MSTRFileName, FlagFileName: TFileName);
    property Dependances: TDiaryEditorStringsDependances read fDependancesList;
    property MSTRStringsStartOffset: LongWord read fMSTRStringsStartOffset;    
    property RUBIStringsStartOffset: LongWord read fRUBIStringStartOffset;
    property SectionIndexMEMO: Integer read fSectionIndexMEMO;
    property SectionIndexMSTR: Integer read fSectionIndexMSTR;
    property SectionIndexRUBI: Integer read fSectionIndexRUBI;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;    
{$IFDEF DEBUG}
    procedure DumpStringDependancies(const FileName: TFileName);
{$ENDIF}
    function LoadFromFile(const DataFileName, FlagFileName: TFileName): Boolean;
    function Reload: Boolean;
    function Save: Boolean;
    function SaveToFile(const DataFileName, FlagFileName: TFileName): Boolean;
    property DataSourceFileName: TFileName read fDataSourceFileName;
    property FlagSourceFileName: TFileName read fFlagSourceFileName;
    property MakeBackup: Boolean read fMakeBackup write fMakeBackup;
    property Loaded: Boolean read fFileLoaded;
    property Pages: TDiaryEditorPagesList read fPages;
    property PlatformVersion: TPlatformVersion read fPlatformVersion;
    property Sections: TFileSectionsList read fSections;
    property XboxMemoFlagInfo: TXboxMemoFlagInfo read fXboxMemoFlagInfo;
  end;

function ExecutableVersionToString(EV: TXboxExecutableVersion): string;
function PagePositionToString(PagePosition: TPagePosition): string;

implementation

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants
{$IFDEF DEBUG}
  , TypInfo
{$ENDIF};

const
  MSTR_SIGN = 'MSTR';
  MEMO_SIGN = 'MEMO';
  RUBI_SIGN = 'RUBI';

  EMPTY_STRING_OFFSET_VALUE = $FFFFFFFF;

  MSTR_PADDING_SIZE = 8;
  MEMO_PADDING_SIZE = 4;

  MEMOFLG_SIZE = 2700;

function ExecutableVersionToString(EV: TXboxExecutableVersion): string;
begin
  case EV of
    xevNotApplicable:
      Result := '(Not applicable)';
    xevTrial:
      Result := 'Trial';
    xevRetailPalUk:
      Result := 'Retail (PAL UK)';
    xevRetailUsa:
      Result := 'Retail (USA)';
  end;
end;

function PagePositionToString(PagePosition: TPagePosition): string;
begin
  Result := '';
  case PagePosition of
    ppLeft  : Result := 'Left';
    ppRight : Result := 'Right';
  end;
end;

{ TDiaryEditor }

procedure TDiaryEditor.AddEntry(var Input: TFileStream; const StrPointerOffset,
  StrOffset: LongWord; const PageNumber: Integer; const FlagCode: Word);
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
  NewMsgItem.fEditable := (PageNumber > 0); // (StrOffset <> EMPTY_STRING_OFFSET_VALUE);
  NewMsgItem.fText := '';
  NewMsgItem.fPageIndex := PageNumber;
  NewMsgItem.fAllowStringWrite := True;
  NewMsgItem.fNewStringOffset := EMPTY_STRING_OFFSET_VALUE; // updated when SaveToFile is called
  NewMsgItem.fFlagCode := FlagCode;

{$IFDEF DEBUG}
  StringAbsoluteOffset := 0;
{$ENDIF}

  // Adding to the list
  NewMsgItem.fIndex := Messages.Add(NewMsgItem);

  // Reading the text if possible
  if NewMsgItem.fStringOffset <> EMPTY_STRING_OFFSET_VALUE then begin
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
  if NewMsgItem.fStringOffset <> EMPTY_STRING_OFFSET_VALUE then
    WriteLn('#P:', NewMsgItem.PageIndex, ';L:', NewMsgItem.Index, ', StrAbsoluteOffset=',
      StringAbsoluteOffset, ', Ptr=', NewMsgItem.StringPointerOffset, ', Str=',
      NewMsgItem.StringOffset, sLineBreak, '  "', NewMsgItem.Text, '"');
{$ENDIF}
end;

procedure TDiaryEditor.Clear;
begin
  // Cleaning temp MEMOFLG.BIN file
  if (PlatformVersion = pvXbox) and FileExists(FlagSourceFileName) then
    DeleteFile(FlagSourceFileName);

  fFileLoaded := False;
  Pages.Clear;
  Dependances.Clear;
  XboxMemoFlagInfo.Clear;
  fPlatformVersion := pvUndef;
end;

constructor TDiaryEditor.Create;
begin
  fMakeBackup := False;
  fPages := TDiaryEditorPagesList.Create(Self);
  fSections := TFileSectionsList.Create(Self);
  fDependancesList := TDiaryEditorStringsDependances.Create;
  fXboxMemoFlagInfo := TXboxMemoFlagInfo.Create(Self);
end;

destructor TDiaryEditor.Destroy;
begin
  Clear;
  fXboxMemoFlagInfo.Free;
  fPages.Free;
  fSections.Free;
  fDependancesList.Free;
  inherited;
end;

{$IFDEF DEBUG}
procedure TDiaryEditor.DumpStringDependancies(const FileName: TFileName);
begin
  Dependances.ExportToCSV(FileName);
end;
{$ENDIF}

function TDiaryEditor.LoadFromFile(const DataFileName,
  FlagFileName: TFileName): Boolean;
const
  MAX_LINE_PER_PAGE = 5;

var
  DataInput, FlagInput: TFileStream;
//  MaxPosition,
  PageNumber, EntryCount: Integer;
  StrPointerOffset, StrOffset: LongWord;
  Section: TFileSectionsListItem;
  TimeCode: Word;
  ValidFile: Boolean;

begin
  Result := False;
  if (not FileExists(DataFileName)) or (not FileExists(FlagFileName)) then Exit;

  // Try to parse the MEMODATA.BIN file
  DataInput := TFileStream.Create(DataFileName, fmOpenRead);
  try
{$IFDEF DEBUG}
    WriteLn('*** LOADING MEMO DATA FILE ***');
{$ENDIF}
    // Parsing the file
    ParseFileSections(DataInput, fSections);

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
    ValidFile := (SectionIndexMEMO <> -1) and (SectionIndexRUBI <> -1)
      and (SectionIndexMSTR <> -1);
    EntryCount := 0;

    // Analyzing MEMO and MSTR sections
    if ValidFile then begin
{$IFDEF DEBUG}
      WriteLn('*** PARSING FILE ***');
{$ENDIF}
      // Clearing the object
      Clear;

      // Setting file names
      fDataSourceFileName := DataFileName;
      fFlagSourceFileName := FlagFileName;
      fPlatformVersion := pvDreamcast;

      (*
        Handling Xbox MEMOFLG.BIN special case:
        Extract MEMOFLG.BIN from Xbox XBE if needed.
      *)
      XboxMemoFlagInfo.ExecuteDetection;

      // Opening Flag File
      FlagInput := TFileStream.Create(FlagSourceFileName, fmOpenRead);
      try
        // Getting the RUBI starting address in the MSTR section
        Section := Sections[SectionIndexRUBI];
        DataInput.Seek(Section.Offset + SizeOf(TSectionEntry), soFromBeginning);
        repeat
          DataInput.Read(fRUBIStringStartOffset, UINT32_SIZE);
        until fRUBIStringStartOffset <> EMPTY_STRING_OFFSET_VALUE;

        // Getting the max position
  //      Section := Sections[SectionIndexMEMO];
  //      MaxPosition := Section.Offset + Section.Size;

        // Seek 'MEMO' header
        DataInput.Seek(SizeOf(TSectionEntry), soFromBeginning);

        // Read each string list
        PageNumber := 0;
        repeat
          // Read the String Offset value from MEMODATA.BIN
          StrPointerOffset := DataInput.Position;
          DataInput.Read(StrOffset, 4);

          // Read the Time Code value from MEMOFLG.BIN
          FlagInput.Read(TimeCode, UINT16_SIZE);

          // Adding the entry
          AddEntry(DataInput, StrPointerOffset, StrOffset, PageNumber, TimeCode);

          Inc(EntryCount);
          if (EntryCount mod MAX_LINE_PER_PAGE) = 0 then
            Inc(PageNumber);

  //      until DataInput.Position >= MaxPosition;
        until FlagInput.Position >= FlagInput.Size;

        // Setting Loaded value to true
        fFileLoaded := ValidFile;
        Result := Loaded;
      finally
        FlagInput.Free;
      end; // try FlagInput

    end; // Loaded

{$IFDEF DEBUG}
    WriteLn(sLineBreak, '*** END ***', sLineBreak,
      'Pages Count: ', Pages.Count, ', Messages Count: ', EntryCount,
      sLineBreak);
{$ENDIF}

  finally
    DataInput.Free;
  end;
end;

function TDiaryEditor.Reload: Boolean;
var
  FlagFile: TFileName;

begin
  FlagFile := FlagSourceFileName;
  if PlatformVersion = pvXbox then
    FlagFile := XboxMemoFlagInfo.ExecutableFileName;
  Result := LoadFromFile(DataSourceFileName, FlagFile);
end;

function TDiaryEditor.Save: Boolean;
begin
  Result := SaveToFile(DataSourceFileName, FlagSourceFileName) and Reload;
end;

function TDiaryEditor.SaveToFile(const DataFileName,
  FlagFileName: TFileName): Boolean;
var
  DataTemp, OutFlagTemp, OutFlagFinal, MEMOSectionTemp, RUBISectionTemp,
  MSTRSectionTemp, XBETemp: TFileName;
  i: Integer;
  XBEStream, OriginalDataStream, OutTempDataStream,
  OutTempFlagStream: TFileStream;

  // WriteUpdatedSection
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
      FName := MEMOSectionTemp
    else if SectionName = RUBI_SIGN then
      FName := RUBISectionTemp
    else if SectionName = MSTR_SIGN then
      FName := MSTRSectionTemp;

    // Write the updated section if possible
    Result := FileExists(FName);
    if Result then begin
      UpdatedStream := TFileStream.Create(FName, fmOpenRead);
      try
        // Write the section header
        StrCopy(Header.Name, PChar(SectionName));
        Header.Size := UpdatedStream.Size + SizeOf(TSectionEntry);
        OutTempDataStream.Write(Header, SizeOf(TSectionEntry));

        // Write the updated section content
        OutTempDataStream.CopyFrom(UpdatedStream, UpdatedStream.Size);

        // Write MSTR Padding
        if SectionName = MSTR_SIGN then
          WriteNullBlock(OutTempDataStream, MSTR_PADDING_SIZE);
      finally
        UpdatedStream.Free;
        DeleteFile(FName); // clean the temp file
      end; // try
    end; // Result
  end; // function

// SaveToFile Main
begin
  Result := False;
  if not Loaded then Exit;

{$IFDEF DEBUG}
    WriteLn('*** SAVING MEMO DATA FILE ***');
{$ENDIF}

  DataTemp := GetTempFileName;

  OutTempDataStream := TFileStream.Create(DataTemp, fmCreate);
  OriginalDataStream := TFileStream.Create(DataSourceFileName, fmOpenRead);
  try
    // Update the MEMO, RUBI and MSTR sections.
    MEMOSectionTemp := GetTempFileName;
    RUBISectionTemp := GetTempFileName;
    MSTRSectionTemp := GetTempFileName;
    OutFlagTemp := GetTempFileName;
    WriteTempUpdatedSections(OriginalDataStream, MEMOSectionTemp, 
      RUBISectionTemp, MSTRSectionTemp, OutFlagTemp);

    // Update all sections
    for i := 0 to Sections.Count - 1 do

      // Write the updated section, and if not, write the raw section from the source
      if not WriteUpdatedSection(Sections[i].Name) then begin
        // Write the raw section from the InStream
        OriginalDataStream.Seek(Sections[i].Offset, soFromBeginning);
        OutTempDataStream.Write(OriginalDataStream, Sections[i].Size);
      end;

  finally
    OriginalDataStream.Free;
    OutTempDataStream.Free;

    // Writing the requested updated MEMODATA.BIN file
    Result := MoveTempFile(DataTemp, DataFileName, MakeBackup);

    // Saving the MEMOFLG.BIN
    OutFlagFinal := FlagFileName;
    if PlatformVersion = pvXbox then begin
      // Preparing temporary XBE
      XBETemp := GetTempFileName;
      CopyFile(XboxMemoFlagInfo.ExecutableFileName, XBETemp, False);
            
      // Patching the XBE with the updated MEMOFLG.BIN
      OutTempFlagStream := TFileStream.Create(OutFlagTemp, fmOpenRead);
      XBEStream := TFileStream.Create(XBETemp, fmOpenWrite);
      try
        XBEStream.Seek(XboxMemoFlagInfo.FlagOffset, soFromBeginning);
        XBEStream.CopyFrom(OutTempDataStream, OutTempDataStream.Size);
      finally
        OutTempFlagStream.Free;
        XBEStream.Free;
      end;

      // Deleting Old Temp FlagFileName
      MoveTempFile(OutFlagTemp, FlagSourceFileName, False);
      OutFlagTemp := XBETemp;

      // If the parameter FlagFileName = TempFlagFile, then we will assign the XBE
      if SameText(FlagFileName, FlagSourceFileName) then      
        OutFlagFinal := XboxMemoFlagInfo.ExecutableFileName;
    end;

    // Writing the requested updated MEMOFLG.BIN file
    Result := Result and MoveTempFile(OutFlagTemp, OutFlagFinal, MakeBackup);
    
  end; // finally
end;

procedure TDiaryEditor.WriteTempUpdatedSections(var InStream: TFileStream;
  const MEMOFileName, RUBIFileName, MSTRFileName, FlagFileName: TFileName);
var
  p, m, RUBI_PatchValue: Integer;
  Messages: TDiaryEditorMessagesList;
  MEMO_FStream, RUBI_FStream, MSTR_FStream, FLAG_FStream: TFileStream;
  Item: TDiaryEditorMessagesListItem;
  StrOffset, Temp: LongWord;

begin
  MEMO_FStream := TFileStream.Create(MEMOFileName, fmCreate);
  MSTR_FStream := TFileStream.Create(MSTRFileName, fmCreate);
  RUBI_FStream := TFileStream.Create(RUBIFileName, fmCreate);
  FLAG_FStream := TFileStream.Create(FlagFileName, fmCreate);
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
        if Item.Text <> '' then begin

          // AllowStringWrite is set to true if we can write the string in the file.
          if Item.AllowStringWrite then begin
            Item.NewStringOffset := MSTR_FStream.Position;
            WriteNullTerminatedString(MSTR_FStream, Item.Text);
          end;
          (* else the string was already written, and we'll write only the MEMO
            String offset (NewStringOffset). *)

        end else
          // The text = '' so we don't need to write a string.
          Item.NewStringOffset := EMPTY_STRING_OFFSET_VALUE;

        // Write the Text Flag
        FLAG_FStream.Write(Item.FlagCode, UINT16_SIZE);

        // Write the MEMO offset
        StrOffset := Item.NewStringOffset;
        MEMO_FStream.Write(StrOffset, UINT32_SIZE);

      end; // m

    end; // p

    // Write MSTR Padding
    WriteNullBlock(MEMO_FStream, MEMO_PADDING_SIZE);

    //**************************************************************************
    // UPDATING RUBI SECTION
    //**************************************************************************

    // Calculating the new RUBI string start offset (with a "patch value")
    RUBI_PatchValue := MSTR_FStream.Size - RUBIStringsStartOffset;
{$IFDEF DEBUG}
    WriteLn('RUBI PatchValue: ', RUBI_PatchValue);
{$ENDIF}

    // Dump the RUBI "MSTR" file content from the original file
{$IFDEF DEBUG}
    WriteLn('MSTR StringsStartOffset: ', MSTRStringsStartOffset);
    WriteLn('RUBI StringsStartOffset: ', RUBIStringsStartOffset);
{$ENDIF}    
    MSTR_FStream.Seek(0, soFromEnd);
    InStream.Seek(MSTRStringsStartOffset
      + RUBIStringsStartOffset, soFromBeginning);
    Temp := Sections[SectionIndexMSTR].Size - RUBIStringsStartOffset - MSTR_PADDING_SIZE;
{$IFDEF DEBUG}
    WriteLn('RUBI Dump / Offset: ', (MSTRStringsStartOffset + RUBIStringsStartOffset),
      ', Size: ', Temp);
{$ENDIF}
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
    FLAG_FStream.Free;
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
  // This value is used in WriteTempUpdatedSections
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
  StrCode, StrText, StrROffset, StrAOffset: string;

begin
  Buffer := TStringList.Create;
  try
    Buffer.Add('Page Number;Line Number;String Pointer Offset (MEMO Section);'
      + 'String Relative Offset (MSTR Section);String Absolute Offset (Calculated)'
      + ';Code;Text');
    for i := 0 to Count - 1 do begin
      Page := Items[i];
      for j := 0 to Page.Messages.Count - 1 do begin
        Msg := Page.Messages[j];

        StrROffset := '-';
        StrAOffset := '-';
        StrCode := '-';
        StrText := '(undef)';
        if Msg.Editable then begin
          StrROffset := IntToStr(Msg.StringOffset);
          StrAOffset := IntToStr(Owner.MSTRStringsStartOffset + Msg.StringOffset);
          StrText := Msg.Text;
          StrCode := IntToStr(Msg.FlagCode);
        end;

        Buffer.Add(Format('%d;%d;%d;%s;%s;%s;"%s"',
          [i, j, Msg.StringPointerOffset, StrROffset, StrAOffset, StrCode, StrText]));
          
      end;
    end;

    Buffer.SaveToFile(FileName);
  finally
    Buffer.Free;
  end;
end;

function TDiaryEditorPagesList.ExportToFile(const FileName: TFileName): Boolean;
var
  XMLDocument: IXMLDocument;
  p, m: Integer;
  PageNode, MessageNode: IXMLNode;
  MessageEntry: TDiaryEditorMessagesListItem;

begin
  Result := False;
  if not Owner.Loaded then Exit;

  XMLDocument := TXMLDocument.Create(nil);
  try
    // Setting XMLDocument properties
    with XMLDocument do begin
      Options := [doNodeAutoCreate];
      ParseOptions:= [];
      NodeIndentStr:= '  ';
      Active := True;
      Version := '1.0';
      Encoding := 'utf-8';
    end;

    // Creating root
    XMLDocument.DocumentElement := XMLDocument.CreateNode('DiaryExport');

    // Navigating in the list...
    for p := 0 to Count - 1 do begin

      // Initializing the PageNode
      PageNode := XMLDocument.CreateNode('Page');
      PageNode.Attributes['Index'] := p;

      // Get all Messages for this Page
      for m := 0 to Items[p].Messages.Count - 1 do begin
        MessageEntry := Items[p].Messages[m];

        // Creating the new item
        MessageNode := XMLDocument.CreateNode('Message');
        MessageNode.Attributes['Index'] := m;
        MessageNode.Attributes['Code'] := MessageEntry.FlagCode;

        // If editable, then add the MessageText to the XML file
        if Items[p].Messages[m].Editable then begin
          MessageNode.NodeValue := MessageEntry.Text;

          // Adding to the tree
          PageNode.ChildNodes.Add(MessageNode);
        end;
      end;

      // Adding the Page node
      if PageNode.ChildNodes.Count > 0 then
        XMLDocument.DocumentElement.ChildNodes.Add(PageNode);

    end;

    // Saving the file
    XMLDocument.SaveToFile(FileName);
  finally
    XMLDocument.Active := False;
    XMLDocument := nil;
    Result := FileExists(FileName);    
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

function TDiaryEditorPagesList.ImportFromFile(
  const FileName: TFileName): Boolean;
var
  XMLDocument: IXMLDocument;
  i, p, m: Integer;
  PageNode, MessageNode: IXMLNode;
  MessageText: string;
  
begin
  Result := False;
  if (not FileExists(FileName)) or (not Owner.Loaded) then Exit;

  XMLDocument := TXMLDocument.Create(nil);
  try
    try
      // Setting XMLDocument properties
      with XMLDocument do begin
        Options := [doNodeAutoCreate];
        ParseOptions:= [];
        NodeIndentStr:= '  ';
        Active := True;
        Version := '1.0';
        Encoding := 'utf-8';
      end;

      // Loading file
      XMLDocument.LoadFromFile(FileName);
      
      // Checking root
      if XMLDocument.DocumentElement.NodeName <> 'DiaryExport' then Exit;

      // Navigating in the XML Tree...
      PageNode := XMLDocument.DocumentElement.ChildNodes.First;
      repeat

        // Read the Messages from this Page
        for i := 0 to PageNode.ChildNodes.Count - 1 do begin
          MessageNode := PageNode.ChildNodes[i];

          // Setting PageIndex (p) and MessageIndex (m)
          p := PageNode.Attributes['Index'];
          m := MessageNode.Attributes['Index'];

          // Retrieving the Message.Text
          MessageText := '';
          if not VarIsNull(MessageNode.NodeValue) then
            MessageText := MessageNode.NodeValue;

          // Setting the read message text
          Items[p].Messages[m].Text := MessageText;
          Items[p].Messages[m].FlagCode := MessageNode.Attributes['Code'];
        end;

        // Go the next page
        PageNode := PageNode.NextSibling;
      until not Assigned(PageNode);

      Result := True;
    except
      Result := False;
    end;
  finally
    XMLDocument.Active := False;
    XMLDocument := nil;
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

{ TXboxMemoFlagInfo }

procedure TXboxMemoFlagInfo.Clear;
begin
  if (ExecutableVersion <> xevNotApplicable) then
    if FileExists(Owner.FlagSourceFileName) then
      DeleteFile(Owner.FlagSourceFileName);
  fFlagOffset := 0;
  fExecutableVersion := xevNotApplicable;
  fExecutableFileName := '';
end;

constructor TXboxMemoFlagInfo.Create(AOwner: TDiaryEditor);
begin
  fOwner := AOwner;
  fExecutableVersion := xevNotApplicable;
  fFlagOffset := 0;
  fExecutableFileName := '';
end;

destructor TXboxMemoFlagInfo.Destroy;
begin
  Clear;
  inherited;
end;

procedure TXboxMemoFlagInfo.ExecuteDetection;
var
  InFlagStream, OutStream: TFileStream;
  
begin
  InFlagStream := TFileStream.Create(Owner.FlagSourceFileName, fmOpenRead);
  try

    if IsXboxExecutable(InFlagStream, fExecutableVersion, fFlagOffset) then begin
      // Setting Xbox File Version
      Owner.fPlatformVersion := pvXbox;
      fExecutableFileName := InFlagStream.FileName;

      // Extract the MEMOFLG.BIN
      Owner.fFlagSourceFileName := GetTempFileName;
      OutStream := TFileStream.Create(Owner.FlagSourceFileName, fmCreate);
      try
        InFlagStream.Seek(FlagOffset, soFromBeginning);
        OutStream.CopyFrom(InFlagStream, MEMOFLG_SIZE);
      finally
        OutStream.Free;
      end; // try

{$IFDEF DEBUG}
      WriteLn('MEMOFLG XBE: ExecutableVersion: ',
        GetEnumName(TypeInfo(TXboxExecutableVersion), Ord(ExecutableVersion)),
        ', FlagOffset: ', FlagOffset
      );
{$ENDIF}
    end; // IsXboxExecutable

  finally
    InFlagStream.Free;
  end;
end;

function TXboxMemoFlagInfo.IsXboxExecutable(var InFlagStream: TFileStream;
  var ExecutableVersionResult: TXboxExecutableVersion;
  var FlagOffsetResult: LongWord): Boolean;
type
  TXbeDetectorEntry = record
    Version: TXboxExecutableVersion;
    Offset: LongWord;
    Signature: PChar;
  end;
  
const
  XBE_SIGN                = 'XBEH';
  XBE_CHECK_OFFSET        = $182;

  XBE_DETECTION: array[0..2] of TXbeDetectorEntry = (
    (Version: xevRetailPalUk; Offset: $4EE128; Signature: #$00#$00#$3C#$65#$DB#$3D#$32#$00#$53#$4D),
    (Version: xevRetailUsa;   Offset: $4E5124; Signature: #$53#$4D#$53#$00#$68#$00#$65#$00#$6E#$00),
    (Version: xevTrial;       Offset: $4E5138; Signature: #$4D#$49#$53#$00#$68#$00#$65#$00#$6E#$00)
  );

var
  FileHeader: array[0..3] of Char;
  Buffer: array[0..9] of Char;
  SavedPos: Int64;
  i: Integer;

begin
  Result := False;
  FlagOffsetResult := 0;
  ExecutableVersionResult := xevNotApplicable;
  SavedPos := InFlagStream.Position;

  // Checking Flag Signature
  InFlagStream.Seek(0, soFromBeginning);
  InFlagStream.Read(FileHeader, SizeOf(FileHeader));

  // The file is a Xbox Executable (XBE)
  if FileHeader = XBE_SIGN then begin

    // Detect the XBE version
    InFlagStream.Seek(XBE_CHECK_OFFSET, soFromBeginning);
    InFlagStream.Read(Buffer, SizeOf(Buffer));

    // Check the XBE type
    Result := False;
    for i := Low(XBE_DETECTION) to High(XBE_DETECTION) do begin
      if StrComp(Buffer, XBE_DETECTION[i].Signature) = 0 then begin
        ExecutableVersionResult := XBE_DETECTION[i].Version;
        FlagOffsetResult := XBE_DETECTION[i].Offset;
        Result := True;
      end; // StrComp
    end; // for

  end; // FileHeader

  InFlagStream.Seek(SavedPos, soFromBeginning);
end;

end.
