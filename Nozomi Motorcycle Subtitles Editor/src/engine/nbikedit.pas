unit NBIKEdit;

interface

uses
  Windows, SysUtils, Classes, DataDefs, FSParser, ChrCodec;
  
type
  TNozomiMotorcycleSequenceEditor = class;
  TNozomiMotorcycleSequenceSubtitleList = class;

  TNozomiMotorcycleSequenceSubtitleItem = class(TObject)
  private
    fText: string;
    fIndex: Integer;
    fOwner: TNozomiMotorcycleSequenceSubtitleList;
    fStringOffset: Integer;
    fStringPointerOffset: Integer;
    fOriginalTextLength: Integer;
    fNewStringOffset: Integer;
    function GetPatchValue: Integer;
    function GetEditor: TNozomiMotorcycleSequenceEditor;
    function GetRawText: string;
  protected
    function DecodeText(const S: string): string;
    function EncodeText(const S: string): string;
    procedure WriteSubtitle(var Output: TFileStream);
    property Editor: TNozomiMotorcycleSequenceEditor read GetEditor;
    property NewStringOffset: Integer read fNewStringOffset;
    property OriginalTextLength: Integer read fOriginalTextLength;
    property PatchValue: Integer read GetPatchValue;
  public
    property Index: Integer read fIndex;
    property RawText: string read GetRawText;
    property StringPointerOffset: Integer read fStringPointerOffset;
    property StringOffset: Integer read fStringOffset;
    property Text: string read fText write fText;
    property Owner: TNozomiMotorcycleSequenceSubtitleList read fOwner;
  end;

  TNozomiMotorcycleSequenceSubtitleList = class(TObject)
  private
    fSubtitleList: TList;
    fOwner: TNozomiMotorcycleSequenceEditor;
    function GetCount: Integer;
    function GetSubtitleItem(Index: Integer): TNozomiMotorcycleSequenceSubtitleItem;
  protected
    procedure Add(const StrPointerOffset: Integer; var Input: TFileStream);
    procedure Clear;
  public
    constructor Create(AOwner: TNozomiMotorcycleSequenceEditor);
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TNozomiMotorcycleSequenceSubtitleItem
      read GetSubtitleItem; default;
    property Owner: TNozomiMotorcycleSequenceEditor read fOwner;
  end;

  TNozomiMotorcycleSequenceEditor = class(TObject)
  private
    fStringPointersList: TList;
    fValuesToUpdateList: TList;

    fSourceFileName: TFileName;
    fStringTableOffset: Integer;
    fFileVersion: TNozomiMotorcycleSequenceGameVersion;
    fLoaded: Boolean;
    fFileSectionsList: TFileSectionsList;
    fDumpedSceneInputFileName: TFileName;
    fSubtitles: TNozomiMotorcycleSequenceSubtitleList;
    fCharset: TShenmueCharsetCodec;
  protected
    procedure UpdateDumpedSceneFile;
    function RetrieveGameVersion(var F: TFileStream): Boolean;
    property DumpedSceneInputFileName: TFileName read fDumpedSceneInputFileName;
    property StringPointersList: TList read fStringPointersList;
    property ValuesToUpdateList: TList read fValuesToUpdateList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function LoadFromFile(const FileName: TFileName): Boolean;
    function Save: Boolean;
    function SaveToFile(const FileName: TFileName): Boolean;
    property FileVersion: TNozomiMotorcycleSequenceGameVersion read fFileVersion;
    property Charset: TShenmueCharsetCodec read fCharset;
    property Loaded: Boolean read fLoaded;
    property Sections: TFileSectionsList read fFileSectionsList;
    property Subtitles: TNozomiMotorcycleSequenceSubtitleList read fSubtitles;
    property SourceFileName: TFileName read fSourceFileName;
    property StringTableOffset: Integer read fStringTableOffset;
  end;

implementation

uses
  SysTools;

{ TNozomiMotorcycleSequenceEditor }

procedure TNozomiMotorcycleSequenceEditor.Clear;
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

constructor TNozomiMotorcycleSequenceEditor.Create;
begin
  fCharset := TShenmueCharsetCodec.Create;
  fSubtitles := TNozomiMotorcycleSequenceSubtitleList.Create(Self);
  fStringPointersList := TList.Create;
  fValuesToUpdateList := TList.Create;
  fFileSectionsList := TFileSectionsList.Create(Self);
  Clear;
end;

destructor TNozomiMotorcycleSequenceEditor.Destroy;
begin
  Clear;
  fSubtitles.Free;
  fStringPointersList.Free;
  fValuesToUpdateList.Free;
  fFileSectionsList.Free;
  fCharset.Free;
  inherited;
end;

function TNozomiMotorcycleSequenceEditor.LoadFromFile(
  const FileName: TFileName): Boolean;
var
  Input: TFileStream;
  DumpedSceneInput: TFileStream;
  i: Integer;
  
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
      Result := RetrieveGameVersion(DumpedSceneInput);
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

function TNozomiMotorcycleSequenceEditor.RetrieveGameVersion(var F: TFileStream): Boolean;
var
  i: Integer;
  Value: Byte;
  SavedPosition: LongWord;

begin
  SavedPosition := F.Position;

  // Identifying the file version
  i := 0;
  repeat
    F.Seek(GAME_VERSION_DETECTION[i].Offset, soFromBeginning);
    F.Read(Value, SizeOf(Value));
    Result := GAME_VERSION_DETECTION[i].Value = Value;
    if Result then
      fFileVersion := GAME_VERSION_DETECTION[i].Result;
    Inc(i);
  until (Result) or (i > High(GAME_VERSION_DETECTION));

  // The file version was detected
  if Result then begin
    IntegerArrayToList(DISC3_ALL_POINTERS_SUBTITLES, fStringPointersList);
    case FileVersion of
      // DISC3 USA
      gvUsaDisc3:
        IntegerArrayToList(DISC3_USA_POINTERS_UPDATE, fValuesToUpdateList);
      // DISC3 PAL
      gvPalDisc3:
        IntegerArrayToList(DISC3_PAL_POINTERS_UPDATE, fValuesToUpdateList);
      // DISC4 USA/PAL
      gvUsaPalDisc4:
        begin
          IntegerArrayToList(DISC4_ALL_POINTERS_SUBTITLES, fStringPointersList);
          IntegerArrayToList(DISC4_ALL_POINTERS_UPDATE, fValuesToUpdateList);
        end;
    end; // case FileVersion
  end; // if Result

  F.Seek(SavedPosition, soFromBeginning);
end;

function TNozomiMotorcycleSequenceEditor.Save: Boolean;
begin
  Result := SaveToFile(SourceFileName);
end;

function TNozomiMotorcycleSequenceEditor.SaveToFile(const FileName: TFileName): Boolean;
var
  i: Integer;
  Input, Output, UpdatedSceneFile: TFileStream;
  OutputTempFileName: TFileName;

begin
  Result := False;
  if not Loaded then Exit;
  
  // Patch the extracted Scene info file
  UpdateDumpedSceneFile;

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
end;

procedure TNozomiMotorcycleSequenceEditor.UpdateDumpedSceneFile;
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
    TotalPatchValue := 0; // don't know but it works...
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

{ TNozomiMotorcycleSubtitleItem }

function TNozomiMotorcycleSequenceSubtitleItem.DecodeText(const S: string): string;
begin
  Result := StringReplace(S, SUBTITLE_DELIMITER, '', []);
  Result := Editor.Charset.Decode(Result);
end;

function TNozomiMotorcycleSequenceSubtitleItem.EncodeText(const S: string): string;
begin
  Result := SUBTITLE_DELIMITER + Editor.Charset.Encode(S);
end;

function TNozomiMotorcycleSequenceSubtitleItem.GetEditor: TNozomiMotorcycleSequenceEditor;
begin
  Result := Owner.Owner;
end;

function TNozomiMotorcycleSequenceSubtitleItem.GetPatchValue: Integer;
begin
  Result := Length(EncodeText(Text)) - OriginalTextLength;
end;

function TNozomiMotorcycleSequenceSubtitleItem.GetRawText: string;
begin
  Result := Editor.Charset.Encode(Text);
end;

procedure TNozomiMotorcycleSequenceSubtitleItem.WriteSubtitle(
  var Output: TFileStream);
var
  TempSubtitle: string;
  NullByte: Byte;

begin
  fNewStringOffset := Output.Position;

  // Writing subtitle header
  TempSubtitle := EncodeText(Text);

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

{ TNozomiMotorcycleSequenceSubtitleList }

procedure TNozomiMotorcycleSequenceSubtitleList.Add(
  const StrPointerOffset: Integer; var Input: TFileStream);
var
  NewItem: TNozomiMotorcycleSequenceSubtitleItem;
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
  NewItem := TNozomiMotorcycleSequenceSubtitleItem.Create;
  ItemIndex := fSubtitleList.Add(NewItem);
  with NewItem do begin
    fOwner := Self;
    fStringPointerOffset := StrPointerOffset;
    fText := DecodeText(Subtitle);
    fIndex := ItemIndex;
    fOriginalTextLength := Length(Subtitle);
    fStringOffset := StrOffset;
  end;

{$IFDEF DEBUG}
  WriteLn('  #', Format('%2.2d', [NewItem.Index]), ', Ptr=0x',
    IntToHex(NewItem.StringPointerOffset, 4), ', Str=0x',
    IntToHex(NewItem.StringOffset, 4), sLineBreak,
    '    "', NewItem.Text, '"'
  );
{$ENDIF}
end;

procedure TNozomiMotorcycleSequenceSubtitleList.Clear;
var
  i: Integer;
  
begin
  for i := 0 to Count - 1 do
    TNozomiMotorcycleSequenceSubtitleItem(fSubtitleList[i]).Free;
  fSubtitleList.Clear;
end;

constructor TNozomiMotorcycleSequenceSubtitleList.Create(
  AOwner: TNozomiMotorcycleSequenceEditor);
begin
  fSubtitleList := TList.Create;
  fOwner := AOwner;
end;

destructor TNozomiMotorcycleSequenceSubtitleList.Destroy;
begin
  Clear;
  fSubtitleList.Free;
  inherited;
end;

function TNozomiMotorcycleSequenceSubtitleList.GetCount: Integer;
begin
  Result := fSubtitleList.Count;
end;

function TNozomiMotorcycleSequenceSubtitleList.GetSubtitleItem(
  Index: Integer): TNozomiMotorcycleSequenceSubtitleItem;
begin
  Result := TNozomiMotorcycleSequenceSubtitleItem(fSubtitleList[Index]);
end;

end.
