unit SeqEdit;

interface

uses
  Windows, SysUtils, Classes, SeqDB, FSParser, ChrCodec, BinHack;
  
type
  TSequenceDataHeader = record
    NameID: array[0..3] of Char;  // SCN3
    Size: Integer;                // SCN3 section size
    Unknow: Integer;
    UnknowPtr1: Integer;
    UnknowPtr2: Integer;
    DataSize1: Integer;           // Size - 8
    Unknow2: Integer;
    Unknow3: Integer;
    HeaderSize: Integer;          // Header size, I guess...
    DataSize2: Integer;           // Size - 8
    Unknow4: Integer;
    Unknow5: Integer;
  end;
  
  TSpecialSequenceEditor = class;
  TSpecialSequenceSubtitlesList = class;

  TSpecialSequenceBackupSubtitleItem = class
  private
    fInitialText: string;
    fOriginalText: string;
    fOwner: TSpecialSequenceSubtitlesList;
    function GetInitialText: string;
    function GetOriginalText: string;
  public
    constructor Create(AOwner: TSpecialSequenceSubtitlesList);
    // Original AM2 subtitle (Text never modified)
    property InitialText: string read GetInitialText;
    // Subtitle before any modification
    property OriginalText: string read GetOriginalText;
    property RawOriginalText: string read fOriginalText;
  end;

  TSpecialSequenceSubtitleItem = class(TObject)
  private
    fText: string;
    fIndex: Integer;
    fOwner: TSpecialSequenceSubtitlesList;
    fStringOffset: Integer;
    fStringPointerOffset: Integer;
    fOriginalTextLength: Integer;
    fNewStringOffset: Integer;
    fBackupText: TSpecialSequenceBackupSubtitleItem;
    function GetPatchValue: Integer;
    function GetEditor: TSpecialSequenceEditor;
    function GetText: string;
    procedure SetText(const Value: string);
  protected
    procedure WriteSubtitle(var Output: TFileStream);
    property Editor: TSpecialSequenceEditor read GetEditor;
    property NewStringOffset: Integer read fNewStringOffset;
    property OriginalTextLength: Integer read fOriginalTextLength;
    property PatchValue: Integer read GetPatchValue;
  public
    constructor Create(AOwner: TSpecialSequenceSubtitlesList);
    destructor Destroy; override;
    property BackupText: TSpecialSequenceBackupSubtitleItem
      read fBackupText;
    property Index: Integer read fIndex;
    property RawText: string read fText;
    property StringPointerOffset: Integer read fStringPointerOffset;
    property StringOffset: Integer read fStringOffset;
    property Text: string read GetText write SetText;
    property Owner: TSpecialSequenceSubtitlesList read fOwner;
  end;

  TSpecialSequenceSubtitlesList = class(TObject)
  private
    fSubtitleList: TList;
    fOwner: TSpecialSequenceEditor;
    fDecodeText: Boolean;
    function GetCount: Integer;
    function GetSubtitleItem(Index: Integer): TSpecialSequenceSubtitleItem;
  protected
    function Add(const StrPointerOffset: Integer;
      var Input: TFileStream): Integer;
    procedure Clear;
  public
    constructor Create(AOwner: TSpecialSequenceEditor);
    destructor Destroy; override;
    function TransformText(const Subtitle: string): string;
    property Count: Integer read GetCount;
    property DecodeText: Boolean read fDecodeText write fDecodeText;
    property Items[Index: Integer]: TSpecialSequenceSubtitleItem
      read GetSubtitleItem; default;
    property Owner: TSpecialSequenceEditor read fOwner;
  end;

  TSpecialSequenceEditor = class(TObject)
  private
    fOriginalHeaderSize: LongWord;
    fOriginalHeaderDataSize1: LongWord;
    fOriginalHeaderDataSize2: LongWord;
    fBinaryHacker: TBinaryHacker;
    fStringPointersList: TList;
    fValuesToUpdateList: TList;
    fSequenceDatabase: TSequenceDatabase;
    fSourceFileName: TFileName;
    fStringTableOffset: Integer;
    fLoaded: Boolean;
    fFileSectionsList: TFileSectionsList;
    fDumpedSceneInputFileName: TFileName;
    fSubtitles: TSpecialSequenceSubtitlesList;
    fCharset: TShenmueCharsetCodec;
    fSequenceDatabaseIndex: Integer;
  protected
    procedure UpdateDumpedSceneFile;
    property BinaryHacker: TBinaryHacker read fBinaryHacker;
    property DumpedSceneInputFileName: TFileName read fDumpedSceneInputFileName;
    property SequenceDatabase: TSequenceDatabase read fSequenceDatabase;
    property StringPointersList: TList read fStringPointersList;
    property ValuesToUpdateList: TList read fValuesToUpdateList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function LoadFromFile(const FileName: TFileName): Boolean;
    function Save: Boolean;
    function SaveToFile(const FileName: TFileName): Boolean;
    property Charset: TShenmueCharsetCodec read fCharset;
    property Loaded: Boolean read fLoaded;
    property Sections: TFileSectionsList read fFileSectionsList;
    property Subtitles: TSpecialSequenceSubtitlesList read fSubtitles;
    property SourceFileName: TFileName read fSourceFileName;
    property StringTableOffset: Integer read fStringTableOffset;
  end;

implementation

uses
  {$IFDEF DEBUG} TypInfo, {$ENDIF}
  SysTools, LZMADec, WorkDir;

const
  SCENE_SECTION_ID = 'SCN3';
  SEQINFO_DB  = 'seqinfo.db';
  SEQINFO_XML = 'seqinfo.xml';
  SUBTITLE_DELIMITER = #$81#$9C#$90#$C2;
  
{ TSpecialSequenceEditor }

procedure TSpecialSequenceEditor.Clear;
begin
  fSourceFileName := '';
  fLoaded := False;

  fStringPointersList.Clear;
  fValuesToUpdateList.Clear;

//  Sections.Clear;
  Subtitles.Clear;

  // clean the dumped scene file
  if FileExists(DumpedSceneInputFileName) then
    DeleteFile(DumpedSceneInputFileName);
end;

constructor TSpecialSequenceEditor.Create;
begin
  fBinaryHacker := TBinaryHacker.Create;
  BinaryHacker.MakeBackup := False;
  fSequenceDatabase := TSequenceDatabase.Create;
  SevenZipExtract(GetApplicationDataDirectory + SEQINFO_DB,
    GetWorkingTempDirectory);
  SequenceDatabase.LoadDatabase(GetWorkingTempDirectory + SEQINFO_XML);
  fCharset := TShenmueCharsetCodec.Create;
  fSubtitles := TSpecialSequenceSubtitlesList.Create(Self);
  fStringPointersList := TList.Create;
  fValuesToUpdateList := TList.Create;
  fFileSectionsList := TFileSectionsList.Create(Self);
  Clear;
end;

destructor TSpecialSequenceEditor.Destroy;
begin
  Clear;
  fSubtitles.Free;
  fStringPointersList.Free;
  fValuesToUpdateList.Free;
  fFileSectionsList.Free;
  fCharset.Free;
  fSequenceDatabase.Free;
  fBinaryHacker.Free;
  inherited;
end;

function TSpecialSequenceEditor.LoadFromFile(
  const FileName: TFileName): Boolean;
var
  Input: TFileStream;
  DumpedSceneInput: TFileStream;
  i, j: Integer;
  SeqDbItem: TSequenceDatabaseItem;

begin
{$IFDEF DEBUG}
  WriteLn('*** READING FILE ***');
{$ENDIF}

  Input := TFileStream.Create(FileName, fmOpenRead);
  try
    Clear;

    // Parsing the file
    ParseFileSections(Input, fFileSectionsList);
    i := Sections.IndexOf(SCENE_SECTION_ID);
    Result := i <> -1;

    // We found a SCN3 section
    if Result then begin

      // Initializing the SCN3 FileStream receiver
      fDumpedSceneInputFileName := GetWorkingTempFileName;
      DumpedSceneInput := TFileStream.Create(DumpedSceneInputFileName, fmCreate);

      // Dumping the SCN3 section
      Input.Seek(Sections[i].Offset, soFromBeginning);
      DumpedSceneInput.CopyFrom(Input, Sections[i].Size);
      DumpedSceneInput.Seek(0, soFromBeginning);

      // Detect the file version
      fSequenceDatabaseIndex := SequenceDatabase.IdentifyFile(DumpedSceneInput);
      Result := fSequenceDatabaseIndex <> -1;
      if Result then begin
        SeqDbItem := SequenceDatabase[fSequenceDatabaseIndex];

        // The file was successfully opened
        fSourceFileName := FileName;
        fLoaded := True;

        // Loading string pointers...
        for i := 0 to SeqDbItem.StringPointers.Count - 1 do
          StringPointersList.Add(Pointer(SeqDbItem.StringPointers[i].StringPointer));

        // Loading the Binary Hacker engine : place holders
        BinaryHacker.PlaceHolders.Clear;
        for i := 0 to SeqDbItem.PlaceHolders.Count - 1 do
          BinaryHacker.PlaceHolders.Add(
            SeqDbItem.PlaceHolders[i].Offset,
            SeqDbItem.PlaceHolders[i].Size
          );

        // Setting original header values
        fOriginalHeaderSize := SeqDbItem.OriginalHeaderValues.Size;
        fOriginalHeaderDataSize1 := SeqDbItem.OriginalHeaderValues.DataSize1;
        fOriginalHeaderDataSize2 := SeqDbItem.OriginalHeaderValues.DataSize2;

        // Calculating the beginning of the subtitles table
        DumpedSceneInput.Seek(Integer(StringPointersList[0]), soFromBeginning);
        DumpedSceneInput.Read(fStringTableOffset, 4);

        // Reading the subtitle table
{$IFDEF DEBUG}
        WriteLn(sLineBreak, 'Reading subtitle table:');
{$ENDIF}
        for i := 0 to StringPointersList.Count - 1 do
        begin
          j := Subtitles.Add(Integer(StringPointersList[i]), DumpedSceneInput);
          Subtitles[j].BackupText.fInitialText :=
            SeqDbItem.StringPointers[i].StringValue;
        end;
      end; // Result

    end; // Result

  finally
    Input.Free;
    DumpedSceneInput.Free;
  end;
end;

function TSpecialSequenceEditor.Save: Boolean;
begin
  Result := SaveToFile(SourceFileName);
end;

function TSpecialSequenceEditor.SaveToFile(const FileName: TFileName): Boolean;
var
  i: Integer;
  Input, Output, UpdatedSceneFile: TFileStream;
  OutputTempFileName: TFileName;

begin
  Result := False;
  if not Loaded then Exit;

{$IFDEF DEBUG}
  WriteLn(sLineBreak, '*** SAVING FILE ***', sLineBreak);
{$ENDIF}

  // Patch the extracted Scene info file
  UpdateDumpedSceneFile;

  try

    // Write the new MAPINFO.BIN file
    OutputTempFileName := GetWorkingTempFileName;
    Input := TFileStream.Create(SourceFileName, fmOpenRead);
    Output := TFileStream.Create(OutputTempFileName, fmCreate);
    try

      for i := 0 to Sections.Count - 1 do begin

        // Writing patched section
        if Sections[i].Name = SCENE_SECTION_ID then begin

          UpdatedSceneFile := TFileStream.Create(DumpedSceneInputFileName, fmOpenRead);
          try
            Output.CopyFrom(UpdatedSceneFile, UpdatedSceneFile.Size);
          finally
            UpdatedSceneFile.Free;
          end;

        end else begin
          // Writing normal section
          Input.Seek(Sections[i].Offset, soFromBeginning);
          Output.CopyFrom(Input, Sections[i].Size);
        end;

      end;

    finally
      Input.Free;
      Output.Free;

      // Updating target
      if FileExists(OutputTempFileName) then begin
        Result := CopyFile(OutputTempFileName, FileName, False);
        DeleteFile(OutputTempFileName);
      end;

      // Load the new updated file if needed
      if SourceFileName = FileName then
        LoadFromFile(SourceFileName);

    end;

  except    
    on E:Exception do begin
      E.Message := 'SaveToFile: ' + E.Message;
      raise;
    end;
  end;
end;

procedure TSpecialSequenceEditor.UpdateDumpedSceneFile;
var
  OutputStream: TFileStream;
  i: Integer;
  ExtraValue: LongWord;
  Header: TSequenceDataHeader;
  
begin
  // Writing the new strings...
  BinaryHacker.Strings.Clear;
  for i := 0 to Subtitles.Count - 1 do
  begin
    BinaryHacker.Strings.Add(
      Integer(StringPointersList[i]),
      SUBTITLE_DELIMITER + Subtitles[i].RawText
    );
  end;
  ExtraValue := BinaryHacker.Execute(DumpedSceneInputFileName);

  // Updating the Section Header
  OutputStream := TFileStream.Create(DumpedSceneInputFileName, fmOpenReadWrite);
  try
    OutputStream.Seek(0, soFromBeginning);
    OutputStream.Read(Header, SizeOf(TSequenceDataHeader));
    OutputStream.Seek(0, soFromBeginning);
    Header.Size := fOriginalHeaderSize + ExtraValue;
//    Header.DataSize1 := fOriginalHeaderDataSize1 + ExtraValue;
//    Header.DataSize2 := fOriginalHeaderDataSize2 + ExtraValue;
    OutputStream.Write(Header, SizeOf(TSequenceDataHeader));
  finally
    OutputStream.Free;
  end;
end;

{ TSpecialSequenceSubtitleItem }

constructor TSpecialSequenceSubtitleItem.Create(
  AOwner: TSpecialSequenceSubtitlesList);
begin
  fOwner := AOwner;
  fBackupText := TSpecialSequenceBackupSubtitleItem.Create(fOwner);
end;

destructor TSpecialSequenceSubtitleItem.Destroy;
begin
  fBackupText.Free;
  inherited;
end;

function TSpecialSequenceSubtitleItem.GetEditor: TSpecialSequenceEditor;
begin
  Result := Owner.Owner;
end;

function TSpecialSequenceSubtitleItem.GetPatchValue: Integer;
begin
  Result := Length(RawText) - OriginalTextLength;
end;

function TSpecialSequenceSubtitleItem.GetText: string;
begin
  if Owner.DecodeText then
    Result := Owner.TransformText(fText)
  else
    Result := fText;
end;

procedure TSpecialSequenceSubtitleItem.SetText(const Value: string);
begin
  if Owner.DecodeText then
    fText := Editor.Charset.Encode(Value)
  else
    fText := Value;
end;

procedure TSpecialSequenceSubtitleItem.WriteSubtitle(
  var Output: TFileStream);
var
  TempSubtitle: string;
  NullByte: Byte;

begin
  fNewStringOffset := Output.Position;

  // Writing subtitle header
  TempSubtitle := SUBTITLE_DELIMITER + RawText;

  // Writing subtitle text
  Output.Write(TempSubtitle[1], Length(TempSubtitle));

  // Writing one null byte
  NullByte := $00;
  Output.Write(NullByte, 1);

{$IFDEF DEBUG}
  WriteLn(
    'Ptr=0x', IntToHex(StringPointerOffset, 4), ', OldValue=0x',
    IntToHex(StringOffset, 4), ', NewValue=0x', IntToHex(NewStringOffset, 4),
    sLineBreak, '  "', Text, '"'
  );
{$ENDIF}
end;

{ TSpecialSequenceSubtitlesList }

function TSpecialSequenceSubtitlesList.Add(
  const StrPointerOffset: Integer; var Input: TFileStream): Integer;
var
  NewItem: TSpecialSequenceSubtitleItem;
  Subtitle: string;
  StrOffset: Integer;
  c: Char;
  Done: Boolean;                                   
  
begin
  // Initializing the Subtitle decoder
  Done := False;
  Subtitle := '';
  Input.Seek(StrPointerOffset, soFromBeginning);
  Input.Read(StrOffset, 4);
  Input.Seek(StrOffset, soFromBeginning);

  // Reading the subtitle
  while not Done do begin  
    Input.Read(c, 1);
    if c <> #0 then
      Subtitle := Subtitle + c
    else
      Done := True;
  end;

  // Adding the new item to the internal list
  NewItem := TSpecialSequenceSubtitleItem.Create(Self);
  Result := fSubtitleList.Add(NewItem);
  with NewItem do
  begin
    fStringPointerOffset := StrPointerOffset;
    fText := StringReplace(Subtitle, SUBTITLE_DELIMITER, '', []);
    fIndex := Result;
    fOriginalTextLength := Length(fText); // Length(Subtitle);
    fStringOffset := StrOffset;
    BackupText.fOriginalText := fText;
  end;

{$IFDEF DEBUG}
  WriteLn('  #', Format('%2.2d', [NewItem.Index]), ', Ptr=0x',
    IntToHex(NewItem.StringPointerOffset, 4), ', Str=0x',
    IntToHex(NewItem.StringOffset, 4), sLineBreak,
    '    "', NewItem.RawText, '"'
  );
{$ENDIF}
end;

procedure TSpecialSequenceSubtitlesList.Clear;
var
  i: Integer;
  
begin
  for i := 0 to Count - 1 do
    TSpecialSequenceSubtitleItem(fSubtitleList[i]).Free;
  fSubtitleList.Clear;
end;

constructor TSpecialSequenceSubtitlesList.Create(
  AOwner: TSpecialSequenceEditor);
begin
  fSubtitleList := TList.Create;
  fOwner := AOwner;
end;

destructor TSpecialSequenceSubtitlesList.Destroy;
begin
  Clear;
  fSubtitleList.Free;
  inherited;
end;

function TSpecialSequenceSubtitlesList.GetCount: Integer;
begin
  Result := fSubtitleList.Count;
end;

function TSpecialSequenceSubtitlesList.GetSubtitleItem(
  Index: Integer): TSpecialSequenceSubtitleItem;
begin
  Result := TSpecialSequenceSubtitleItem(fSubtitleList[Index]);
end;

function TSpecialSequenceSubtitlesList.TransformText(
  const Subtitle: string): string;
type
  TCharsetFunc = function(S: string): string of object;

var
  CharsetFunc: TCharsetFunc;
  
begin
  if DecodeText then
    CharsetFunc := Owner.Charset.Decode
  else
    CharsetFunc := Owner.Charset.Encode;
  Result := CharsetFunc(Subtitle);
end;

{ TSpecialSequenceBackupSubtitleItem }

constructor TSpecialSequenceBackupSubtitleItem.Create(
  AOwner: TSpecialSequenceSubtitlesList);
begin
  fOwner := AOwner;
end;

function TSpecialSequenceBackupSubtitleItem.GetInitialText: string;
begin
  Result := fOwner.TransformText(fInitialText);
end;

function TSpecialSequenceBackupSubtitleItem.GetOriginalText: string;
begin
  Result := fOwner.TransformText(fOriginalText);
end;

initialization
  SevenZipInitEngine(GetWorkingTempDirectory);

end.
