unit nbikedit;

interface

uses
  Windows, SysUtils, Classes, DataDefs;
  
type
  TNozomiMotorcycleSequenceEditor = class;

  TNozomiMotorcycleSequenceSubtitleItem = class(TObject)
  private
    fText: string;
    fIndex: Integer;
    fOwner: TNozomiMotorcycleSequenceEditor;
    fStringOffset: Integer;
    fStringPointerOffset: Integer;
    fOriginalTextLength: Integer;
    fNewStringOffset: Integer;
    function GetPatchValue: Integer;
  protected
    function DecodeText(const S: string): string;
    function EncodeText(const S: string): string;
    procedure WriteSubtitle(var Output: TFileStream);
    property NewStringOffset: Integer read fNewStringOffset;
    property OriginalTextLength: Integer read fOriginalTextLength;
    property PatchValue: Integer read GetPatchValue;
  public
    property Index: Integer read fIndex;
    property StringPointerOffset: Integer read fStringPointerOffset;
    property StringOffset: Integer read fStringOffset;
    property Text: string read fText write fText;        
    property Owner: TNozomiMotorcycleSequenceEditor read fOwner;
  end;

  TNozomiMotorcycleSequenceEditor = class(TObject)
  private
    fStringPointersList: TList;
    fValuesToUpdateList: TList;
    fSubtitleList: TList;
    fSourceFileName: TFileName;
    fStringTableOffset: Integer;
    fFileVersion: TNozomiMotorcycleSequenceGameVersion;
    fLoaded: Boolean;
    function GetCount: Integer;
    function GetSubtitleItem(Index: Integer): TNozomiMotorcycleSequenceSubtitleItem;
  protected
    procedure Add(const StrPointerOffset: Integer; var Input: TFileStream);
    function RetrieveGameVersion(var F: TFileStream): Boolean;
    property StringPointersList: TList read fStringPointersList;
    property ValuesToUpdateList: TList read fValuesToUpdateList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function LoadFromFile(const FileName: TFileName): Boolean;
    procedure SaveToFile(const FileName: TFileName);
    property Count: Integer read GetCount;
    property FileVersion: TNozomiMotorcycleSequenceGameVersion read fFileVersion;
    property Items[Index: Integer]: TNozomiMotorcycleSequenceSubtitleItem
      read GetSubtitleItem; default;
    property Loaded: Boolean read fLoaded;
    property SourceFileName: TFileName read fSourceFileName;
    property StringTableOffset: Integer read fStringTableOffset;
  end;

implementation

uses
  SysTools;

{ TNozomiMotorcycleSequenceEditor }

procedure TNozomiMotorcycleSequenceEditor.Add(const StrPointerOffset: Integer;
  var Input: TFileStream);
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
  WriteLn('#', Format('%2.2d', [NewItem.Index]), ', Ptr=0x',
    IntToHex(NewItem.StringPointerOffset, 4), ', Str=0x',
    IntToHex(NewItem.StringOffset, 4), sLineBreak,
    '  "', NewItem.Text, '"'
  );
{$ENDIF}
end;

procedure TNozomiMotorcycleSequenceEditor.Clear;
var
  i: Integer;

begin
  fSourceFileName := '';
  fLoaded := False;
  for i := 0 to Count - 1 do
    TNozomiMotorcycleSequenceSubtitleItem(fSubtitleList[i]).Free;
  fSubtitleList.Clear;
  fStringPointersList.Clear;
  fValuesToUpdateList.Clear;
end;

constructor TNozomiMotorcycleSequenceEditor.Create;
begin
  fSubtitleList := TList.Create;
  fStringPointersList := TList.Create;
  fValuesToUpdateList := TList.Create;
  Clear;
end;

destructor TNozomiMotorcycleSequenceEditor.Destroy;
begin
  Clear;
  fSubtitleList.Free;
  fStringPointersList.Free;
  fValuesToUpdateList.Free;
  inherited;
end;

function TNozomiMotorcycleSequenceEditor.GetCount: Integer;
begin
  Result := fSubtitleList.Count;
end;

function TNozomiMotorcycleSequenceEditor.GetSubtitleItem(
  Index: Integer): TNozomiMotorcycleSequenceSubtitleItem;
begin
  Result := TNozomiMotorcycleSequenceSubtitleItem(fSubtitleList[Index]);
end;

function TNozomiMotorcycleSequenceEditor.LoadFromFile(
  const FileName: TFileName): Boolean;
var
  Input: TFileStream;
  i: Integer;
  
begin
{$IFDEF DEBUG}
  WriteLn(sLineBreak, '*** READING FILE ***', sLineBreak);
{$ENDIF}

  Input := TFileStream.Create(FileName, fmOpenRead);
  try
    Clear;

    // Detect the file version
    Result := RetrieveGameVersion(Input);
    if Result then begin

      // The file was successfully opened
      fSourceFileName := FileName;
      fLoaded := True;

      // Calculating the beginning of the subtitles table
      Input.Seek(Integer(StringPointersList[0]), soFromBeginning);
      Input.Read(fStringTableOffset, 4);

      // Reading the subtitle table
      for i := 0 to StringPointersList.Count - 1 do
        Add(Integer(StringPointersList[i]), Input);

    end;
    
  finally
    Input.Free;
  end;  
end;

function TNozomiMotorcycleSequenceEditor.RetrieveGameVersion(var F: TFileStream): Boolean;
var
  i: Integer;
  Value: Byte;

begin
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
end;

procedure TNozomiMotorcycleSequenceEditor.SaveToFile(const FileName: TFileName);
var
  Input, Output: TFileStream;
  OutputFileName: TFileName;
  Value, i, TotalPatchValue: Integer;
  Header: TSequenceDataHeader;
  
begin
{$IFDEF DEBUG}
  WriteLn(sLineBreak, '*** SAVING FILE ***', sLineBreak);
{$ENDIF}

  OutputFileName := FileName; //GetTempFileName;

  Input := TFileStream.Create(SourceFileName, fmOpenRead);
  Output := TFileStream.Create(OutputFileName, fmCreate);
  try

    // Positionning on the SCN3 section
    Input.Seek(0, soFromBeginning);

    // Copy everything without original subtitle table
    Output.CopyFrom(Input, StringTableOffset);

    // Writing the subtitles table
    TotalPatchValue := 0; // don't know but it works...
    for i := 0 to Count - 1 do begin
      // Writing the subtitle
      Items[i].WriteSubtitle(Output);

      // Updating the string pointer value
      Output.Seek(Items[i].StringPointerOffset, soFromBeginning);
      Output.Write(Items[i].NewStringOffset, 4);
      Output.Seek(0, soFromEnd);

      // Calculating the TotalPatchValue
      Inc(TotalPatchValue, Items[i].PatchValue);
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
  end;
end;

{ TNozomiMotorcycleSubtitleItem }

function TNozomiMotorcycleSequenceSubtitleItem.DecodeText(const S: string): string;
begin
  Result := StringReplace(S, SUBTITLE_DELIMITER, '', [rfReplaceAll]);
  Result := StringReplace(Result, SUBTITLE_LINEBREAK, '<br>', [rfReplaceAll]);
end;

function TNozomiMotorcycleSequenceSubtitleItem.EncodeText(const S: string): string;
begin
  Result := SUBTITLE_DELIMITER
    + StringReplace(S, '<br>', SUBTITLE_LINEBREAK, [rfReplaceAll]);
end;

function TNozomiMotorcycleSequenceSubtitleItem.GetPatchValue: Integer;
begin
  Result := Length(EncodeText(Text)) - OriginalTextLength;
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

end.
