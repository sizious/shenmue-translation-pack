unit SeqEdit;

interface

uses
  Windows, SysUtils, Classes, SeqDB, FSParser, ChrCodec;
  
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

  TSpecialSequenceSubtitleItem = class(TObject)
  private
    fText: string;
    fIndex: Integer;
    fOwner: TSpecialSequenceSubtitlesList;
    fStringOffset: Integer;
    fStringPointerOffset: Integer;
    fOriginalTextLength: Integer;
    fNewStringOffset: Integer;
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
    procedure Add(const StrPointerOffset: Integer; var Input: TFileStream);
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
  protected
    procedure UpdateDumpedSceneFile;
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
  fSequenceDatabase := TSequenceDatabase.Create;
  SevenZipExtract(GetApplicationDataDirectory + SEQINFO_DB, GetWorkingTempDirectory);
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
  inherited;
end;

function TSpecialSequenceEditor.LoadFromFile(
  const FileName: TFileName): Boolean;
var
  Input: TFileStream;
  DumpedSceneInput: TFileStream;
  i: Integer;
  FileInfo: Integer;
  
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
      fDumpedSceneInputFileName := GetTempFileName;
      DumpedSceneInput := TFileStream.Create(DumpedSceneInputFileName, fmCreate);

      // Dumping the SCN3 section
      Input.Seek(Sections[i].Offset, soFromBeginning);
      DumpedSceneInput.CopyFrom(Input, Sections[i].Size);
      DumpedSceneInput.Seek(0, soFromBeginning);

      // Detect the file version
      FileInfo := SequenceDatabase.IdentifyFile(DumpedSceneInput);
      Result := FileInfo <> -1;
      if Result then begin

        // The file was successfully opened
        fSourceFileName := FileName;
        fLoaded := True;

        // Calculating the beginning of the subtitles table
        DumpedSceneInput.Seek(Integer(StringPointersList[0]), soFromBeginning);
        DumpedSceneInput.Read(fStringTableOffset, 4);

        // Reading the subtitle table
{$IFDEF DEBUG}
        WriteLn(sLineBreak, 'Reading subtitle table:');
{$ENDIF}
        for i := 0 to StringPointersList.Count - 1 do
          Subtitles.Add(Integer(StringPointersList[i]), DumpedSceneInput);
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

  // Patch the extracted Scene info file
  UpdateDumpedSceneFile;

  try

    // Write the new MAPINFO.BIN file
    OutputTempFileName := GetTempFileName;
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
  Input, Output: TFileStream;
  OutputTempFileName: TFileName;
  Value, i, TotalPatchValue: Integer;
  Header: TSequenceDataHeader;
  
begin
{$IFDEF DEBUG}
  WriteLn(sLineBreak, '*** SAVING FILE ***', sLineBreak);
{$ENDIF}

  OutputTempFileName := GetTempFileName;

  Input := TFileStream.Create(DumpedSceneInputFileName, fmOpenRead);
  Output := TFileStream.Create(OutputTempFileName, fmCreate);
  try

    // Copy everything without original subtitle table
    Output.CopyFrom(Input, StringTableOffset);

    // Writing the subtitles table
    TotalPatchValue := 0;
    for i := 0 to Subtitles.Count - 1 do begin
      // Writing the subtitle
      Subtitles[i].WriteSubtitle(Output);

      // Updating the string pointer value
      Output.Seek(Subtitles[i].StringPointerOffset, soFromBeginning);
      Output.Write(Subtitles[i].NewStringOffset, 4);
      Output.Seek(0, soFromEnd);

      // Calculating the TotalPatchValue
      Inc(TotalPatchValue, Subtitles[i].PatchValue);
    end;

    // Writing the lastest dummy subtitle (which is 1 byte length)
    Value := $0;
    Output.Write(Value, 1);

(*
    // Updating misc pointer values
{$IFDEF DEBUG}
    WriteLn(sLineBreak, 'Updating pointers:');
{$ENDIF}
    for i := 0 to ValuesToUpdateList.Count - 1 do begin
      Output.Seek(Integer(ValuesToUpdateList[i]), soFromBeginning);
{$IFDEF DEBUG}
      Write('  #', Format('%2.2d', [i]),
        ': Ptr=0x', IntToHex(Integer(ValuesToUpdateList[i]), 4));
{$ENDIF}
      Output.Read(Value, 4);
{$IFDEF DEBUG}
      Write(', OldValue=0x', IntToHex(Value, 4));
{$ENDIF}
      Output.Seek(-4, soCurrent);
      Inc(Value, TotalPatchValue);
{$IFDEF DEBUG}
      WriteLn(', NewValue=0x', IntToHex(Value, 4));
{$ENDIF}
      Output.Write(Value, 4);
    end;
*)

    // Writing the file footer
    Input.Seek(Integer(ValuesToUpdateList[0]), soFromBeginning);
    Input.Read(Value, 4);
    Input.Seek(Value, soFromBeginning);    
{$IFDEF DEBUG}
    Write('Writing footer: offset=0x', IntToHex(Value, 4));
{$ENDIF}
    Value := Input.Size - Value;
{$IFDEF DEBUG}
    WriteLn(', size=', Value);
{$ENDIF}
    Output.Seek(0, soFromEnd);
    Output.CopyFrom(Input, Value);

    // Updating the section header
    Output.Seek(0, soFromBeginning);
    Output.Read(Header, SizeOf(TSequenceDataHeader));
    Output.Seek(0, soFromBeginning);
    Inc(Header.Size, TotalPatchValue);
    Inc(Header.DataSize1, TotalPatchValue);
    Inc(Header.DataSize2, TotalPatchValue);
    Output.Write(Header, SizeOf(TSequenceDataHeader));
    
  finally
    Input.Free;
    Output.Free;

    // Deleting old DumpedSceneFile
    if FileExists(OutputTempFileName) then begin
      CopyFile(OutputTempFileName, DumpedSceneInputFileName, False);
      DeleteFile(OutputTempFileName);
    end;
  end;
end;

{ TSpecialSequenceSubtitleItem }

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

procedure TSpecialSequenceSubtitlesList.Add(
  const StrPointerOffset: Integer; var Input: TFileStream);
var
  NewItem: TSpecialSequenceSubtitleItem;
  Subtitle: string;
  ItemIndex, StrOffset: Integer;
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
  NewItem := TSpecialSequenceSubtitleItem.Create;
  ItemIndex := fSubtitleList.Add(NewItem);
  with NewItem do begin
    fOwner := Self;
    fStringPointerOffset := StrPointerOffset;
    fText := StringReplace(Subtitle, SUBTITLE_DELIMITER, '', []);
    fIndex := ItemIndex;
    fOriginalTextLength := Length(fText); // Length(Subtitle);
    fStringOffset := StrOffset;
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

initialization
  SevenZipInitEngine(GetWorkingTempDirectory);

end.
