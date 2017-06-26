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
    fStringStartTag: string;
    function GetPatchValue: Integer;
    function GetEditor: TSpecialSequenceEditor;
    function GetText: string;
    procedure SetText(const Value: string);
    function GetBinaryText: string;
  protected
    property Editor: TSpecialSequenceEditor read GetEditor;
    property NewStringOffset: Integer read fNewStringOffset;
    property OriginalTextLength: Integer read fOriginalTextLength;
    property PatchValue: Integer read GetPatchValue;
  public
    constructor Create(AOwner: TSpecialSequenceSubtitlesList);
    destructor Destroy; override;
    property BackupText: TSpecialSequenceBackupSubtitleItem
      read fBackupText;
    property BinaryText: string read GetBinaryText;
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
    function GetSequenceItem: TSequenceDatabaseItem;
  protected
    function Add(const StrPointerOffset: Integer; const StrStartTag: string;
      var InputStream: TFileStream): Integer;
    procedure Clear;
    property SequenceItem: TSequenceDatabaseItem read GetSequenceItem;
  public
    constructor Create(AOwner: TSpecialSequenceEditor);
    destructor Destroy; override;
    function TransformText(const Subtitle: string): string;
    function ExportToFile(FileName: TFileName): Boolean;
    function ImportFromFile(FileName: TFileName): Boolean;
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
    fStringPointersList: TList;
    fSequenceDatabase: TSequenceDatabase;
    fSourceFileName: TFileName;
    fStringTableOffset: Integer;
    fLoaded: Boolean;
    fFileSectionsList: TFileSectionsList;
    fDumpedSceneInputFileName: TFileName;
    fSubtitles: TSpecialSequenceSubtitlesList;
    fCharset: TShenmueCharsetCodec;
    fSequenceDatabaseIndex: Integer;
    fExpandableFileSectionSizeFromStartOffset: LongWord;
    fExpandableFileSectionSizeFromStartSize: LongWord;
    fExpandableFileSectionSizeFromEnd: LongWord;
    function GetSequenceItem: TSequenceDatabaseItem;
  protected
    procedure UpdateDumpedSceneFile;
    property DumpedSceneInputFileName: TFileName read fDumpedSceneInputFileName;
    property SequenceDatabase: TSequenceDatabase read fSequenceDatabase;
    property SequenceItem: TSequenceDatabaseItem read GetSequenceItem;
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
  SysTools, LZMADec, WorkDir, FileSpec, BinHack,
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX;

const
  SCENE_SECTION_ID = 'SCN3';
  SEQINFO_DB  = 'seqinfo.db';
  SEQINFO_XML = 'seqinfo.xml';
  SEQINFO_XML_ROOT_NODE = 'sequenceeditor';
  
{ TSpecialSequenceEditor }

procedure TSpecialSequenceEditor.Clear;
begin
  fSourceFileName := '';
  fLoaded := False;
  
  fStringPointersList.Clear;

//  Sections.Clear;
  Subtitles.Clear;

  // clean the dumped scene file
  if FileExists(DumpedSceneInputFileName) then
    DeleteFile(DumpedSceneInputFileName);
end;

constructor TSpecialSequenceEditor.Create;
begin
  fSequenceDatabase := TSequenceDatabase.Create;
  SevenZipExtract(GetApplicationDataDirectory + SEQINFO_DB,
    GetWorkingTempDirectory);
  SequenceDatabase.LoadDatabase(GetWorkingTempDirectory + SEQINFO_XML);
  fCharset := TShenmueCharsetCodec.Create;
  fSubtitles := TSpecialSequenceSubtitlesList.Create(Self);
  fStringPointersList := TList.Create;
  fFileSectionsList := TFileSectionsList.Create(Self);
  Clear;
end;

destructor TSpecialSequenceEditor.Destroy;
begin
  Clear;
  fSubtitles.Free;
  fStringPointersList.Free;
  fFileSectionsList.Free;
  fCharset.Free;
  fSequenceDatabase.Free;
  inherited;
end;

function TSpecialSequenceEditor.GetSequenceItem: TSequenceDatabaseItem;
begin
  Result := nil;
  if fSequenceDatabaseIndex <> -1 then
    Result := SequenceDatabase[fSequenceDatabaseIndex];
end;

function TSpecialSequenceEditor.LoadFromFile(
  const FileName: TFileName): Boolean;
var
  Input: TFileStream;
  DumpedSceneInput: TFileStream;
  i, j: Integer;

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
        // The file was successfully opened
        fSourceFileName := FileName;

        // Setting original header values
        fOriginalHeaderSize := SequenceItem.OriginalHeaderValues.Size;
        fOriginalHeaderDataSize1 := SequenceItem.OriginalHeaderValues.DataSize1;
        fOriginalHeaderDataSize2 := SequenceItem.OriginalHeaderValues.DataSize2;

        // Compute position that take into account Expandable section
        // This will help us to re-update/modify hacked files with this method
        if SequenceItem.MemoryInformation.Expandable then begin
          // Compute the 0 -> From Start Offset
          with SequenceItem.MemoryInformation.ExpandablePlaceHolder do begin
            fExpandableFileSectionSizeFromStartOffset := Offset;
            fExpandableFileSectionSizeFromStartSize := Size;
          end;
          // Compute From End <- End of Expandable Section without modification
          fExpandableFileSectionSizeFromEnd := fOriginalHeaderSize -
            (fExpandableFileSectionSizeFromStartOffset +
            fExpandableFileSectionSizeFromStartSize);
        end;

        // Calculating the beginning of the subtitles table
        DumpedSceneInput.Seek(SequenceItem.StringPointers[0].StringPointer, soFromBeginning);
        DumpedSceneInput.Read(fStringTableOffset, 4);

        // Reading the subtitle table
{$IFDEF DEBUG}
        WriteLn(sLineBreak, 'Reading subtitle table:');
{$ENDIF}
        for i := 0 to SequenceItem.StringPointers.Count - 1 do begin
          j := Subtitles.Add(
            SequenceItem.StringPointers[i].StringPointer,
            SequenceItem.StringPointers[i].StringStartTag,
            DumpedSceneInput
          );
          Subtitles[j].BackupText.fInitialText :=
            SequenceItem.StringPointers[i].StringValue;
        end;

        // Mark as loaded if we have some subtitles to translate.
        fLoaded := Subtitles.Count > 0;
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
  WorkingFileName: TFileName;
  InputStream, OutputStream: TFileStream;
  i: Integer;
  CurrentFileOffset, ExtraFileSize, ExtraPointerValue, BytesWritten,
  PaddingSize: LongWord;
  Header: TSequenceDataHeader;
  BinaryHacker: TBinaryHacker;

begin
  // Initializing the result file
  WorkingFileName := GetWorkingTempFileName;

  // Create an empty file for our the output program
  // Note: We use fmOpenReadWrite for OutputStream because of BinaryHacker requirements.
  InitializeFile(WorkingFileName, True);

  InputStream := TFileStream.Create(DumpedSceneInputFileName, fmOpenRead);
  OutputStream := TFileStream.Create(WorkingFileName, fmOpenReadWrite);
  try
    if not SequenceItem.MemoryInformation.Expandable then begin
      // Place Holder = Not Expandable
      // The FileSize is fixed. We'll use the BinaryHacker class (for string
      // allocation optimization).

      // Copy all Input to Output.
      OutputStream.CopyFrom(InputStream, 0);

      BinaryHacker := TBinaryHacker.Create;
      try
        // Define the subtitles
        for i := 0 to Subtitles.Count - 1 do
        BinaryHacker.Strings.Add(SequenceItem.StringPointers[i].StringPointer, Subtitles[i].BinaryText);

        // Define the available Place Holders
        for i := 0 to SequenceItem.MemoryInformation.PlaceHolders.Count - 1 do
          with SequenceItem.MemoryInformation.PlaceHolders[i] do
            BinaryHacker.PlaceHolders.Add(Offset, Size);

        // Execute the Binary Hacker!
        BinaryHacker.Execute(OutputStream);
      finally
        BinaryHacker.Free;
      end;

      // Checking if the BinaryHacker doesn't have increased the file
      // ... TODO

    end else begin
      // Place Holder = Expandable
      // The FileSize is variable, only on ONE Place Holder section.
      // We don't need to use the optimized BinaryHacker class.

      // Copy File Header
      OutputStream.CopyFrom(InputStream, fExpandableFileSectionSizeFromStartOffset);

      // Writing the new strings...
      BytesWritten := 0;
      for i := 0 to Subtitles.Count - 1 do
      begin
        OutputStream.Seek(0, soFromEnd);
        CurrentFileOffset := OutputStream.Position;
        WriteNullTerminatedString(OutputStream, Subtitles[i].BinaryText);
        OutputStream.Seek(SequenceItem.StringPointers[i].StringPointer, soFromBeginning);
        OutputStream.Write(CurrentFileOffset, UINT32_SIZE);
        Inc(BytesWritten, Length(Subtitles[i].BinaryText) + 1);
      end;
      OutputStream.Seek(0, soFromEnd);

      // Manage the extra space
      if (fExpandableFileSectionSizeFromStartSize > BytesWritten) then begin
        // New strings are less long than original file
        // We pad to the original size
        // So the file size can be bigger than the original but NOT lesser
        PaddingSize := fExpandableFileSectionSizeFromStartSize - BytesWritten;
        WriteNullBlock(OutputStream, PaddingSize)
      end else if (BytesWritten > fExpandableFileSectionSizeFromStartSize) then
        // If we have new extra bytes, then add the proper padding.
        WritePaddingSection(OutputStream, BytesWritten, pm4b);

      // Copy file footer
      InputStream.Seek(-fExpandableFileSectionSizeFromEnd, soFromEnd);
      OutputStream.CopyFrom(InputStream, fExpandableFileSectionSizeFromEnd);
    end;

  finally
    InputStream.Free;
    OutputStream.Free;
  end;

  // Updating Headers/Additional Pointers
  OutputStream := TFileStream.Create(WorkingFileName, fmOpenReadWrite);
  try
    // Updating Section Header
    OutputStream.Seek(0, soFromBeginning);
    OutputStream.Read(Header, SizeOf(TSequenceDataHeader));
    OutputStream.Seek(0, soFromBeginning);
    ExtraFileSize := OutputStream.Size - fOriginalHeaderSize; // only positive (i.e. check 'extra space' section)
    Header.Size := fOriginalHeaderSize + ExtraFileSize;
    Header.DataSize1 := fOriginalHeaderDataSize1 + ExtraFileSize;
    Header.DataSize2 := fOriginalHeaderDataSize2 + ExtraFileSize;
    OutputStream.Write(Header, SizeOf(TSequenceDataHeader));

    // Updating additional extra pointers if needed
    if SequenceItem.MemoryInformation.Expandable then    
      for i := 0 to SequenceItem.MemoryInformation.ExtraPointers.Count - 1 do begin
        ExtraPointerValue := SequenceItem.MemoryInformation.ExtraPointers[i].Value;
        Inc(ExtraPointerValue, ExtraFileSize);
        OutputStream.Seek(SequenceItem.MemoryInformation.ExtraPointers[i].Offset, soFromBeginning);
        OutputStream.Write(ExtraPointerValue, UINT32_SIZE);
      end;
  finally
    OutputStream.Free;
  end;

  // Replacing the old hacked file by the new one.
  KillFile(DumpedSceneInputFileName);
  RenameFile(WorkingFileName, DumpedSceneInputFileName);
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

function TSpecialSequenceSubtitleItem.GetBinaryText: string;
begin
  Result := fStringStartTag + RawText;
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

{ TSpecialSequenceSubtitlesList }

function TSpecialSequenceSubtitlesList.Add(
  const StrPointerOffset: Integer; const StrStartTag: string;
  var InputStream: TFileStream): Integer;
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
  InputStream.Seek(StrPointerOffset, soFromBeginning);
  InputStream.Read(StrOffset, 4);
  InputStream.Seek(StrOffset, soFromBeginning);

  // Reading the subtitle
  while not Done do begin  
    InputStream.Read(c, 1);
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
    fStringStartTag := StrStartTag;
    fStringPointerOffset := StrPointerOffset;
    fText := StringReplace(Subtitle, fStringStartTag, '', []);
    fIndex := Result;
    fOriginalTextLength := Length(fText);
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

function TSpecialSequenceSubtitlesList.ExportToFile;
var
  XMLRoot: IXMLDocument;
  RootNode, Node: IXMLNode;
  i: Integer;

begin
  XMLRoot := TXMLDocument.Create(nil);
  try
    with XMLRoot do begin
      Options := [doNodeAutoCreate, doAttrNull];
      ParseOptions := [poPreserveWhiteSpace];
      Active := True;
      Version := '1.0';
      Encoding := 'utf-8';
    end;

    // Creating the root
    XMLRoot.DocumentElement := XMLRoot.CreateNode(SEQINFO_XML_ROOT_NODE);


    // File attributes
    Node := XMLRoot.CreateNode('fileid');
    Node.Attributes['game'] := SequenceItem.Game;
    Node.Attributes['platform'] := SequenceItem.Platform;
    Node.NodeValue := SequenceItem.SequenceID;
    XMLRoot.DocumentElement.ChildNodes.Add(Node);

    // Subtitle list
    RootNode := XMLRoot.CreateNode('subtitles');
    RootNode.Attributes['count'] := Count;
    XMLRoot.DocumentElement.ChildNodes.Add(RootNode);
    for i := 0 to Count - 1 do begin
      Node := XMLRoot.CreateNode('subtitle');
      with Items[i] do begin
        Node.NodeValue := RawText;
      end;
      RootNode.ChildNodes.Add(Node);
    end;

    // Saving the result
    XMLRoot.SaveToFile(FileName);
    Result := FileExists(FileName);
  finally
    // Destroying the XML file
    XMLRoot.Active := False;
    XMLRoot := nil;
  end;
end;

function TSpecialSequenceSubtitlesList.GetCount: Integer;
begin
  Result := fSubtitleList.Count;
end;

function TSpecialSequenceSubtitlesList.GetSequenceItem: TSequenceDatabaseItem;
begin
  Result := Owner.SequenceItem;
end;

function TSpecialSequenceSubtitlesList.GetSubtitleItem(
  Index: Integer): TSpecialSequenceSubtitleItem;
begin
  Result := TSpecialSequenceSubtitleItem(fSubtitleList[Index]);
end;

function TSpecialSequenceSubtitlesList.ImportFromFile(
  FileName: TFileName): Boolean;
var
  XMLRoot: IXMLDocument;
  RootNode, Node: IXMLNode;
  i: Integer;
  ValidImportFile: Boolean;

begin
  Result := False;
  if not FileExists(FileName) then Exit;

  // Loading the imported file
  XMLRoot := TXMLDocument.Create(nil);
  try
    try

      with XMLRoot do begin
        Options := [doNodeAutoCreate, doAttrNull];
        ParseOptions := [poPreserveWhiteSpace];
        Active := True;
        Version := '1.0';
        Encoding := 'utf-8';
      end;

      // Loading the file
      XMLRoot.LoadFromFile(FileName);

      // Reading the root
      ValidImportFile := (XMLRoot.DocumentElement.NodeName = SEQINFO_XML_ROOT_NODE);

      // Reading XML tree
      if ValidImportFile then begin
        // Check if the loaded file is for the same scene
        Node := XMLRoot.DocumentElement.ChildNodes.FindNode('fileid');
        if Assigned(Node) then
        begin
          ValidImportFile :=
                (Node.Attributes['game'] = SequenceItem.Game)
            and (Node.Attributes['platform'] = SequenceItem.Platform)
            and (Node.NodeValue = SequenceItem.SequenceID);
        end;

        // Load subtitle list
        if ValidImportFile then begin
          RootNode := XMLRoot.DocumentElement.ChildNodes.FindNode('subtitles');
          Result := RootNode.Attributes['count'] = Count; // Check count
          if Result then
            for i := 0 to Count - 1 do begin
              Node := RootNode.ChildNodes.Nodes[i];
              Owner.Subtitles[i].fText := VariantToString(Node.NodeValue);
              RootNode.ChildNodes.Add(Node);
            end; // for
        end;
      end;

    except
{$IFDEF DEBUG}
      on E:Exception do
        WriteLn('ImportFromFile / Exception: ', E.Message);
{$ENDIF}
    end;

  finally
    // Destroying the XML file
    XMLRoot.Active := False;
    XMLRoot := nil;
  end;
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
