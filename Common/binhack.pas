(*
  BinHack Class

  This class was designed to patch a binary files with strings.
  It handles the string pointers and the file growth too (if needed).
*)
unit BinHack;

interface

uses
  Windows, SysUtils, Classes;

type
  EBinaryHacker = class(Exception);
  EIncorrectFileStream = class(EBinaryHacker);


////////////////////////////////////////////////////////////////////////////////
// Place Holders                                                              //
////////////////////////////////////////////////////////////////////////////////

(*
   There is 2 kinds of place holders:
   - Specified place holders, which is file area that can be used to write
     our strings.
   - Extra place holders, which is file area that doesn't exists and must be
     created by the engine.

   How the extra place holder must be handled by the engine?
   emEOF = The extra place holder is written at the end of file
   emDesigned = The extra place holder is written at the specified offset.
*)

  TPlaceHolderGrowMethod = (gmEOF, gmDesigned);

  // Place Holder Context
  // Give information on the area for the requested string...
  TPlaceHolderContext = packed record
  private
    _PlaceHolderIndex: Integer;
    _StringSize: LongWord;
  public
    StringOffset: LongWord; // the string will be written at this offset!
  end;

  // Place Holder Item
  TBHPlaceHolderItem = class
  private
    fSize: LongWord;
    fSizeSpaceRemaining: LongWord;
    fStartOffset: LongWord;
    fWorkingOffset: LongWord;
  public
    property Offset: LongWord read fStartOffset;
    property Size: LongWord read fSize;
  end;

  // Place Holders Main Class
  TBHPlaceHolders = class
  private
    fCurrentPlaceHolderIndex: Integer;
    fGrowMethod: TPlaceHolderGrowMethod;
    fGrowOffset: LongWord;
    fItemsList: TList;
    fWorkingGrowOffset: LongWord;
    fExtraBlocksSizeWritten: LongWord;
    procedure Initialize(OutputFileStream: TFileStream);
    procedure CloseStringWriteContext(Context: TPlaceHolderContext);
    function GetCount: Integer;
    function GetExtraBlocksSizeWritten: LongWord;
    function GetItem(Index: Integer): TBHPlaceHolderItem;
    function OpenStringWriteContext(StringSize: LongWord): TPlaceHolderContext;
    procedure Reset;
    procedure Sort;
    procedure SetGrowOffsetValue(const Value: LongWord);
    procedure SetGrowOffset(const Value: LongWord);
    procedure Finalize(OutputFileStream: TFileStream);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Offset, Size: LongWord): Integer;
    procedure Assign(Source: TBHPlaceHolders);
{$IFDEF DEBUG}
    procedure DebugPrint;
{$ENDIF}
    procedure Clear;
    property Count: Integer read GetCount;
    property GrowMethod: TPlaceHolderGrowMethod
      read fGrowMethod write fGrowMethod;
    property GrowOffset: LongWord
      read fGrowOffset write SetGrowOffset;
    property Items[Index: Integer]: TBHPlaceHolderItem
      read GetItem; default;
  end;


////////////////////////////////////////////////////////////////////////////////
// Strings                                                                    //
////////////////////////////////////////////////////////////////////////////////

(*
   Determines how to handle the base address on the pointer
    - Default : The Pointer Offset will be updated with the real string offset
                in the file
    - Add     : Add the PointerOffsetBaseAddress to the string offset before
                writing in the pointer offset
    - Sub     : Sub the PointerOffsetBaseAddress ...
*)

  TBHStringPointerOffsetMode = (pomDefault, pomAdd, pomSub);

  TBHStringItem = class
  private
    fPointerOffset: LongWord;
    fPointerOffsetBaseAddress: LongWord;
    fPointerOffsetMode: TBHStringPointerOffsetMode;
    fValue: string;
    function GetSize: LongWord;
  public
    constructor Create;
    property PointerOffset: LongWord read fPointerOffset;
    property PointerOffsetMode: TBHStringPointerOffsetMode
      read fPointerOffsetMode write fPointerOffsetMode;
    property PointerOffsetBaseAddress: LongWord
      read fPointerOffsetBaseAddress write fPointerOffsetBaseAddress;
    property StringValue: string read fValue;
    property Size: LongWord read GetSize;
  end;

  TBHStrings = class
  private
    fList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TBHStringItem;
    procedure Sort;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(PointerOffset: LongWord; StringValue: string): Integer; overload;
    function Add(PointerOffset: LongWord; StringValue: string;
      PointerOffsetMode: TBHStringPointerOffsetMode;
      PointerOffsetAddressBase: LongWord): Integer; overload;
    procedure Assign(Source: TBHStrings);
{$IFDEF DEBUG}
    procedure DebugPrint;
{$ENDIF}
    procedure Clear;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TBHStringItem
      read GetItem; default;
  end;


////////////////////////////////////////////////////////////////////////////////
// Binary Hacker Main Class                                                   //
////////////////////////////////////////////////////////////////////////////////


  TBinaryHacker = class
  private
    fPlaceHolders: TBHPlaceHolders;
    fStrings: TBHStrings;
    fMakeBackup: Boolean;
    procedure Initialize(OutputFileStream: TFileStream);
    procedure Finalize(OutputFileStream: TFileStream);
  protected
    function DoExecute(FileStream: TFileStream): LongWord;
  public
    // Constructor... (of course you know that)
    constructor Create;

    // Destructor... (you understood, well ?)
    destructor Destroy; override;

    // Apply the patch on the 'FileName' file.
    // This is the main method of this class.
    // Returns the extra bytes written (if the file has grown, 0 if not)
    function Execute(const FileName: TFileName): LongWord; overload;

    // Apply the patch directly on the TFileStream class.
    function Execute(FileStream: TFileStream): LongWord; overload;

    // Set this to 'True' (default) if you wanna make a backup before patching
    // with the 'Execute' method.
    property MakeBackup: Boolean
      read fMakeBackup write fMakeBackup;

    // Contains the Strings to be translated, with the pointer offsets.
    property Strings: TBHStrings
      read fStrings;

    // Contains the file areas that can be used to write our strings.
    property PlaceHolders: TBHPlaceHolders
      read fPlaceHolders;
  end;


////////////////////////////////////////////////////////////////////////////////
implementation
////////////////////////////////////////////////////////////////////////////////

uses
  SysTools;

const
  SBACKUP_EXT       = '.BAK';
  PLACEHOLDER_SIGN  = 'SiZ!';

{ TBinaryHacker }

constructor TBinaryHacker.Create;
begin
  fMakeBackup := True;
  fPlaceHolders := TBHPlaceHolders.Create;
  fStrings := TBHStrings.Create;
end;

destructor TBinaryHacker.Destroy;
begin
  fPlaceHolders.Free;
  fStrings.Free;
  inherited;
end;

function TBinaryHacker.DoExecute(FileStream: TFileStream): LongWord;
var
  i: Integer;
  Context: TPlaceHolderContext;
  StrOffset: LongWord;
  CurrentItem: TBHStringItem;
  
begin
  try
    // Initializing Engine
    Initialize(FileStream);

    // Writing each String... (starting with the biggest)
    for i := Strings.Count - 1 downto 0 do
    begin
    
{$IFDEF DEBUG}
      Write('#', i, ': ');
{$ENDIF}

      // Request the place holder object to get a necessary place to write our string
      CurrentItem := Strings[i];
      Context := PlaceHolders.OpenStringWriteContext(CurrentItem.Size);
      try
        // Updating the string pointer
        FileStream.Seek(CurrentItem.PointerOffset, soFromBeginning);
        StrOffset := Context.StringOffset;
        case CurrentItem.PointerOffsetMode of
          pomAdd: Inc(StrOffset, CurrentItem.PointerOffsetBaseAddress);
          pomSub: Dec(StrOffset, CurrentItem.PointerOffsetBaseAddress);
        end;
        FileStream.Write(StrOffset, UINT32_SIZE);

{$IFDEF DEBUG}
        WriteLn('PtrOffset=', CurrentItem.PointerOffset, ', StrOffset=', StrOffset); 
{$ENDIF}

        // Positioning the file pointer at the correct location
        FileStream.Seek(Context.StringOffset, soFromBeginning);

        // If the GrowMethod is Designed and no PlaceHolder was found, this means
        // that we need to increaze the file size at the specified location, to hold
        // our new string.
        // Note: If GrowMethod is gmEOF, no need to insert data, the data will be
        //       directly appened to the file's end.
        if (Context._PlaceHolderIndex = -1) and (PlaceHolders.GrowMethod = gmDesigned) then
          InsertNullBlock(FileStream, Length(CurrentItem.StringValue) + 1);

        // Write the string
        WriteNullTerminatedString(FileStream, CurrentItem.StringValue);

{$IFDEF DEBUG}
        WriteLn(' "', CurrentItem.StringValue, '"');
{$ENDIF}

      finally
        // Updating the place holder context...
        PlaceHolders.CloseStringWriteContext(Context);
      end;

    end;

    // Finalizing Engine
    Finalize(FileStream);
  finally
    // Return the number of bytes written in extra
      Result := PlaceHolders.GetExtraBlocksSizeWritten;
  end;
end;

function TBinaryHacker.Execute(FileStream: TFileStream): LongWord;
var
  BackupFileName: TFileName;
  BackupFileStream: TFileStream;

begin
  // Making backup as requested
  if MakeBackup then begin
    BackupFileName := ChangeFileExt(FileStream.FileName, SBACKUP_EXT);
    BackupFileStream := TFileStream.Create(BackupFileName, fmCreate);
    try
      BackupFileStream.CopyFrom(FileStream, 0);
    finally
      BackupFileStream.Free;
    end;
  end;

  // Patching the file
  try
    Result := DoExecute(FileStream);
  except
    on Exception do
      raise EIncorrectFileStream.Create('Unable to work with the supplied TFileStream. '
        + 'Please check if the TFileStream Mode is set to fmOpenReadWrite');
  end;
end;

function TBinaryHacker.Execute(const FileName: TFileName): LongWord;
var
  FileStream: TFileStream;
  
begin
  // Making backup as requested
  if MakeBackup then
    CopyFile(FileName, ChangeFileExt(FileName, SBACKUP_EXT));

  // Opening target file
  FileStream := TFileStream.Create(FileName, fmOpenReadWrite);
  try
    // Patching the file
    Result := DoExecute(FileStream);
  finally
    // Close the target file
    FileStream.Free;
  end;
end;

procedure TBinaryHacker.Finalize(OutputFileStream: TFileStream);
begin
  PlaceHolders.Finalize(OutputFileStream);
end;

procedure TBinaryHacker.Initialize(OutputFileStream: TFileStream);
begin
  // Sorting lists before working
  Strings.Sort;

  // Initializing Place Holders...
  PlaceHolders.Initialize(OutputFileStream);
end;

{ TBHStrings }

function TBHStrings.Add(PointerOffset: LongWord; StringValue: string): Integer;
begin
  Result := Add(PointerOffset, StringValue, pomDefault, 0);
end;

function TBHStrings.Add(PointerOffset: LongWord; StringValue: string;
  PointerOffsetMode: TBHStringPointerOffsetMode;
  PointerOffsetAddressBase: LongWord): Integer;
var
  Item: TBHStringItem;

begin
  Item := TBHStringItem.Create;
  Item.fValue := StringValue;
  Item.fPointerOffset := PointerOffset;
  Item.fPointerOffsetMode := PointerOffsetMode;
  Item.fPointerOffsetBaseAddress := PointerOffsetAddressBase;
  Result := fList.Add(Item);
end;

procedure TBHStrings.Assign(Source: TBHStrings);
var
  i: Integer;
  
begin
  Clear;
  for i := 0 to Source.Count - 1 do
    Add(Source[i].PointerOffset, Source[i].StringValue);
end;

procedure TBHStrings.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fList.Clear;
end;

constructor TBHStrings.Create;
begin
  fList := TList.Create;
end;

{$IFDEF DEBUG}
procedure TBHStrings.DebugPrint;
var
  i: Integer;

begin
  WriteLn('*** Strings Start ***');
  for i := Count - 1 downto 0 do
    WriteLn('  ptr_offset=', Items[i].PointerOffset, ', size=', Items[i].Size,
      sLineBreak, '     "', Items[i].StringValue,'"');
  WriteLn('*** Strings End ***');
end;
{$ENDIF}

destructor TBHStrings.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

function TBHStrings.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TBHStrings.GetItem(Index: Integer): TBHStringItem;
begin
  Result := TBHStringItem(fList[Index]);
end;

procedure TBHStrings.Sort;
  
  function _Compare(Item1, Item2: Pointer): Integer;
  begin
    Result := TBHStringItem(Item1).Size - TBHStringItem(Item2).Size;
  end;

begin
  fList.Sort(@_Compare);
end;

{ TBHStringItem }

constructor TBHStringItem.Create;
begin
  fPointerOffsetMode := pomDefault;
  fValue := '';
  fPointerOffset := 0;
  fPointerOffsetBaseAddress := 0;
end;

function TBHStringItem.GetSize: LongWord;
begin
  Result := Length(StringValue) + 1; // + 1 for $00
end;

{ TBHPlaceHolders }

function TBHPlaceHolders.Add(Offset, Size: LongWord): Integer;
var
  Item: TBHPlaceHolderItem;

begin
  Item := TBHPlaceHolderItem.Create;
  Item.fStartOffset := Offset;
  Item.fSize := Size;
  Item.fSizeSpaceRemaining := Size;
  Item.fWorkingOffset := Offset;
  Result := fItemsList.Add(Item);
end;

procedure TBHPlaceHolders.Assign(Source: TBHPlaceHolders);
var
  i: Integer;
  
begin
  Clear;
  for i := 0 to Source.Count - 1 do
    Add(Source[i].Offset, Source[i].Size);
end;

procedure TBHPlaceHolders.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  fItemsList.Clear;
end;

procedure TBHPlaceHolders.CloseStringWriteContext(Context: TPlaceHolderContext);
begin
  if Context._PlaceHolderIndex = -1 then
  begin
    // update the extra place holder
    Inc(fWorkingGrowOffset, Context._StringSize);
  end else begin
    // update the designed place holder
    Dec(Items[Context._PlaceHolderIndex].fSizeSpaceRemaining, Context._StringSize);
    Inc(Items[Context._PlaceHolderIndex].fWorkingOffset, Context._StringSize);
  end;
end;

constructor TBHPlaceHolders.Create;
begin
  fItemsList := TList.Create;
  // this was done to exploit the chosen place holder at the maximum...
  fCurrentPlaceHolderIndex := -1;

  // this define how to manage the extra space to add to the file
  fGrowMethod := gmEOF;
  SetGrowOffsetValue(0); // will be calculated under the EOF flag
end;

{$IFDEF DEBUG}
procedure TBHPlaceHolders.DebugPrint;
var
  i: Integer;

begin
  WriteLn('*** Place Holders Start ***');
  for i := Count - 1 downto 0 do
    WriteLn('  offset=', Items[i].Offset, ', size=', Items[i].Size);
  WriteLn('*** Place Holders End ***');
end;
{$ENDIF}

destructor TBHPlaceHolders.Destroy;
begin
  Clear;
  fItemsList.Free;
  inherited;
end;

procedure TBHPlaceHolders.Finalize(OutputFileStream: TFileStream);
var
  Buf: TSectionEntry;

begin
  // Calculate the extra size added to the file
  fExtraBlocksSizeWritten := fWorkingGrowOffset - fGrowOffset;

  // Write the section footer for the binary hacker if needed...
  if (GrowMethod = gmEOF) and (GetExtraBlocksSizeWritten > 0) then
  begin
    OutputFileStream.Seek(0, soFromEnd);
    Buf.Name := PLACEHOLDER_SIGN;
    Buf.Size := fGrowOffset;
    OutputFileStream.Write(Buf, SECTIONENTRY_SIZE);
    Inc(fExtraBlocksSizeWritten, SECTIONENTRY_SIZE);
  end;

  // Reset the temporary vars used by the engine...
  Reset;
end;

function TBHPlaceHolders.OpenStringWriteContext(StringSize: LongWord): TPlaceHolderContext;
var
  FoundArea: Boolean;

  function _FindNewPlaceHolder: Integer;
  var
    Found: Boolean;
    i: Integer;

  begin
    Result := -1;
    Found := False;
    i := Count - 1; // starting with the biggest space
    while (not Found) and (i >= 0) do
    begin
      Found := Items[i].fSizeSpaceRemaining >= StringSize; // we found a better place holder!
      Dec(i);
    end;
    if Found then
      Result := i + 1;
  end;

begin
  Result._StringSize := StringSize;

  // Initializing...
  // ...or Search another better place holder that can be great for writing our string
  FoundArea := (fCurrentPlaceHolderIndex <> -1) and
    (Items[fCurrentPlaceHolderIndex].fSizeSpaceRemaining >= StringSize);

  if not FoundArea then
  begin
    Sort;
    fCurrentPlaceHolderIndex := _FindNewPlaceHolder;
  end;

  
  with Result do
    if fCurrentPlaceHolderIndex <> -1 then
    begin
      // Using the cached PlaceHolderIndex or the new found just before
      _PlaceHolderIndex := fCurrentPlaceHolderIndex;
      StringOffset := Items[fCurrentPlaceHolderIndex].fWorkingOffset;
    end else begin
      // the extra place holder will be used.
      StringOffset := fWorkingGrowOffset;
      _PlaceHolderIndex := -1;
    end;
end;

function TBHPlaceHolders.GetCount: Integer;
begin
  Result := fItemsList.Count;
end;

function TBHPlaceHolders.GetExtraBlocksSizeWritten: LongWord;
begin
  Result := fExtraBlocksSizeWritten;
end;

function TBHPlaceHolders.GetItem(Index: Integer): TBHPlaceHolderItem;
begin
  Result := TBHPlaceHolderItem(fItemsList[Index]);
end;

procedure TBHPlaceHolders.Initialize(OutputFileStream: TFileStream);
var
  i: Integer;
  Offset: Int64;
  Buf: TSectionEntry;

begin
  Offset := OutputFileStream.Position;

  // Initializing the Extra PlaceHolder
  fExtraBlocksSizeWritten := 0;
  if GrowMethod = gmEOF then
  begin
    // By default, this's the file end.
    SetGrowOffsetValue(OutputFileStream.Size);

    // We'll determinate if the binhacker has been used on this file before.
    // if yes, we'll use the real 'end' of the file, not the extra place holder
    // added by this binhacker.
    OutputFileStream.Seek(-SECTIONENTRY_SIZE, soFromEnd);
    OutputFileStream.Read(Buf, SECTIONENTRY_SIZE);
    if SameText(Buf.Name, PLACEHOLDER_SIGN) then
    begin
      // Getting the real end of the file
      SetGrowOffsetValue(Buf.Size);
      // Truncate the file
      OutputFileStream.Size := Buf.Size;
    end;
  end;
  // ... else, the GrowOffset was designed!
  
  // Cleaning the place holders...
  for i := 0 to Count - 1 do
  begin
    OutputFileStream.Seek(Items[i].Offset, soFromBeginning);
    WriteNullBlock(OutputFileStream, Items[i].Size);
  end;
  OutputFileStream.Seek(Offset, soFromBeginning);
end;

procedure TBHPlaceHolders.SetGrowOffsetValue(const Value: LongWord);
begin
  fGrowOffset := Value;
  fWorkingGrowOffset := Value;
end;

procedure TBHPlaceHolders.Reset;
var
  i: Integer;

begin
  fWorkingGrowOffset := GrowOffset;
  for i := 0 to Count - 1 do
    with Items[i] do
    begin
      fSizeSpaceRemaining := Size;
      fWorkingOffset := Offset;
    end;
end;

procedure TBHPlaceHolders.SetGrowOffset(const Value: LongWord);
begin
  if GrowMethod = gmEOF then
    raise EBinaryHacker.Create('GrowOffset: Unable to set the GrowOffset' +
      ' because the GrowMethod is set to gmEOF!');
  SetGrowOffsetValue(Value);
end;

procedure TBHPlaceHolders.Sort;
  
  function _Compare(Item1, Item2: Pointer): Integer;
  begin
    Result :=
      TBHPlaceHolderItem(Item1).fSizeSpaceRemaining -
      TBHPlaceHolderItem(Item2).fSizeSpaceRemaining;
  end;

begin
  fItemsList.Sort(@_Compare);
end;

end.
