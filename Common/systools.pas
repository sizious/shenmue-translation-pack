unit SysTools;

interface

uses
  Windows, SysUtils, Classes, XMLIntf;

const
  UINT16_SIZE       = 2;
  UINT32_SIZE       = 4;
  GAME_BLOCK_SIZE   = 2048;
  MAX_DWORD         = $FFFFFFFF;
  
type
  ESystemTools = class(Exception);
  EDataDirectoryNotFound = class(ESystemTools);
  EFourCCNotSameLengthAsString = class(ESystemTools);

  // Standard section header (used by many units, like FSParser)
  TSectionEntry = record
    Name: array[0..3] of Char;
    Size: LongWord;
  end;

  // Padding modes
  TPaddingMode = (pm32b, pm4b, pm2b);

  // Unit sizes
  TSizeUnit = (suByte, suKiloByte, suMegaByte, suGigaByte);

// Functions
function CopyFile(SourceFileName, DestFileName: TFileName;
  FailIfExists: Boolean = False): Boolean;
procedure CopyFileBlock(var FromF, ToF: file; StartOffset, BlockSize: Integer);
procedure Delay(Milliseconds: Double);
procedure DeleteDirectory(DirectoryToRemove: TFileName);
function DriveCharToInteger(Drive: Char): Integer;
function ExtractDirectoryName(const FullDirectoryPath: TFileName): TFileName;
function ExtractFile(ResourceName: string; OutputFileName: TFileName): Boolean;
function ExtractRadicalFileName(const FullPathFileName: TFileName): TFileName;
function ExtractStr(LeftSubStr, RightSubStr, S: string): string;
function ExtremeRight(SubStr: string; S: string): string;
function EOS(Stream: TStream): Boolean;
function EOFS(FileStream: TFileStream): Boolean; // y'avais "var" avant... et "overload"???
function FormatByteSize(Bytes: Int64; var SizeUnit: TSizeUnit): string;
function GetApplicationDirectory: TFileName;
function GetApplicationRadicalName: string;
function GetApplicationInstancesCount: Integer;
function GetApplicationDataDirectory: TFileName;
function GetDirectorySize(Directory: TFileName): Int64;
function GetFileSize(const FileName: TFileName): Int64;
function GetRandomString(const StringMaxLength: Integer): string;
function GetSubStrCount(SubStr, S: string): Integer;
function GetStreamBlockReadSize(Stream: TStream;
  const WishedBlockSize: Int64): Int64;
function GetTempDir: TFileName;
function GetTempFileName(FullPath: Boolean = True): TFileName;
function GetXMLDocType(const XMLBuffer: string): string;
function HexToInt(Hex: string): Integer;
function HexToInt64(Hex: string): Int64;
procedure IntegerArrayToList(Source: array of Integer; var Destination: TList);
procedure IntegerToArray(var Destination: array of Char; const Value: Integer);
function IsInArray(Source: array of string; S: string): Boolean;
function IsInString(const SubStr, S: string): Boolean;
function IsJapaneseString(const S: string): Boolean;
procedure LoadUnicodeTextFile(SL: TStringList; const FileName: TFileName);
function MoveFile(const ExistingFileName, NewFileName: TFileName): Boolean;
function MoveTempFile(const TempFileName, DestFileName: TFileName;
  MakeBackup: Boolean): Boolean;
function ParseStr(SubStr, S: string; n: Integer): string;
procedure ParseTextToByteArray(const EncodedString: string;
  var Dest: TBytes);
function ParseTextToString(const EncodedString: string): string;
function ParseTextToValue(const EncodedString: string;
  DefaultValue: Integer): Integer;
function ReadNullTerminatedString(var F: TFileStream): string; overload;
function ReadNullTerminatedString(var F: TFileStream;
  const StrSize: LongWord): string; overload;
procedure SetXMLDocType(XMLDocument: IXMLDocument; const DocType: string);
function StrEquals(S1, S2: string): Boolean;
procedure StrToFourCC(var FourCC: array of Char; S: string);
function StringArrayBinarySearch(SortedSource: array of string;
  SearchValue: string): Integer;
function StringArraySequentialSearch(Source: array of string;
  SearchValue: string): Integer;
function Left(SubStr: string; S: string): string;
function LeftNRight(SubStr, S: string; N: Integer): string;
function Right(SubStr: string; S: string): string;
function RunNoWait(const TargetFileName: TFileName): Boolean;
function RunAndWait(const TargetFileName: TFileName) : Boolean;
function VariantToString(V: Variant): string;
procedure WriteNullBlock(F: TFileStream; const Size: LongWord);
procedure WriteNullTerminatedString(var F: TFileStream; const S: string;
  const WriteNullEndChar: Boolean = True);
{$IFDEF DEBUG}
procedure WriteMemoryStreamToConsole(MS: TMemoryStream);
{$ENDIF}
function WritePaddingSection(F: TFileStream; DataSize: LongWord;
  PaddingMode: TPaddingMode = pm32b): LongWord;

const
  SECTIONENTRY_SIZE = SizeOf(TSectionEntry);
  
//==============================================================================
implementation
//==============================================================================

{$WARN SYMBOL_PLATFORM OFF}

uses
  TlHelp32, Forms, Math, Variants, XMLDom, MSXMLDom, XMLDoc, ActiveX,
  ShellApi;

const
  HEXADECIMAL_VALUES  = '0123456789ABCDEF';
  DATA_BASEDIR        = 'data';
  NULL_BUFFER_SIZE    = 512;

//------------------------------------------------------------------------------

function ParseTextToValue(const EncodedString: string;
  DefaultValue: Integer): Integer;
begin
  if Copy(EncodedString, 1, 1) = '$' then
    // This's a hexadecimal value
    Result := HexToInt(Copy(EncodedString, 2, Length(EncodedString) - 1))
  else
    // This is a decimal value
    Result := StrToIntDef(EncodedString, DefaultValue);
end;

//------------------------------------------------------------------------------

function ParseTextToString(const EncodedString: string): string;
var
  StringList: TStringList;
  Value, i: Integer;

begin
  // This'll convert a encoded string (like '#$65#$66') to a real string.
  // Extracted from ChrCodec on 2013-01-02.
  Result := EncodedString;
  if (Pos('#', EncodedString) = 0) or (EncodedString = '#') then Exit;

  Result := '';
  StringList := TStringList.Create;
  try
    StringList.Delimiter := '#';
    StringList.DelimitedText := EncodedString;

    // For each value in the string
    for i := 0 to StringList.Count - 1 do
    begin

      // Parsing the value
      Value := ParseTextToValue(StringList[i], -1);

      // Converting the value
      if (Value > -1) and (Value < 256) then
        Result := Result + Chr(Value);

    end; // for

  finally
    StringList.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure ParseTextToByteArray(const EncodedString: string;
  var Dest: TBytes);
var
  Buf: string;
  i, j: Integer;

begin
  Buf := ParseTextToString(EncodedString);
  j :=  Length(Buf);
  SetLength(Dest, j);
  for i := 1 to j do
    Dest[i - 1] := Ord(Buf[i]);   
end;

//------------------------------------------------------------------------------

function IsInArray(Source: array of string; S: string): Boolean;
var
  i: Integer;

begin
  Result := False;
  i := Low(Source);
  while (not Result) and (i <= High(Source)) do
  begin
    Result := SameText(Source[i], S);
    Inc(i);
  end;
end;

//------------------------------------------------------------------------------

function DriveCharToInteger(Drive: Char): Integer;
begin
  Result := -1;
  Drive := UpCase(Drive);
  if Drive in ['A'..'Z'] then
    Result := (Ord(Drive) - Ord('A')) + 1;
end;

//------------------------------------------------------------------------------

// Format file byte size
function FormatByteSize(Bytes: Int64; var SizeUnit: TSizeUnit): string;
const
  B   = 1;          // byte
  KB  = 1024 * B;   // kilobyte
  MB  = 1024 * KB;  // megabyte
  GB  = 1024 * MB;  // gigabyte

begin
  Bytes := Abs(Bytes);
  if Bytes > GB then begin
    Result := FormatFloat('0.00', Bytes / GB);
    SizeUnit := suGigaByte;
  end else if Bytes > MB then begin
    Result := FormatFloat('0.00', Bytes / MB);
    SizeUnit := suMegaByte;
  end else if Bytes > KB then begin
    Result := FormatFloat('0.00', Bytes / KB);
    SizeUnit := suKiloByte;
  end else begin
    Result := FormatFloat('0.00', Bytes);
    SizeUnit := suByte;
  end;
end;

//------------------------------------------------------------------------------

{$IFDEF DEBUG}
procedure WriteMemoryStreamToConsole(MS: TMemoryStream);
var
  i: Integer;
  C: Char;

begin
  MS.Seek(0, soFromBeginning);
  for i := 0 to MS.Size - 1 do
  begin
    MS.Read(C, 1);
    Write(C);
  end;
end;
{$ENDIF}

//------------------------------------------------------------------------------

function ExtractRadicalFileName(const FullPathFileName: TFileName): TFileName;
begin
  Result := ExtractFileName(ChangeFileExt(FullPathFileName, ''));
end;

//------------------------------------------------------------------------------

// http://delphi.about.com/od/adptips2006/qt/doctype_txmldoc.htm
function GetXMLDocType(const XMLBuffer: string): string;
var
  SL: TStringList;
  Found: Boolean;
  i: Integer;

begin
  Result := '';
  SL := TStringList.Create;
  try
    SL.Text := XMLBuffer;
//    SL.LoadFromFile(XMLFileName);
    Found := False;
    i := 0;
    while (i < SL.Count) and (not Found) do begin
      Found := IsInString('DOCTYPE', UpperCase(SL[i]));
      if Found then
        Result := SL[i];
      Inc(i);
    end;
  finally
    SL.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure SetXMLDocType(XMLDocument: IXMLDocument; const DocType: string);
var
  SL: TStringList;

begin
  if (DocType = '') or (XMLDocument.XML.Count = 0) then Exit;
  SL := TStringList.Create;
  try
    SL.Assign(XMLDocument.XML);
    SL.Insert(1, DocType);
    XMLDocument.XML.Assign(SL);
    XMLDocument.Active := True;
  finally
    SL.Free;
  end;
end;

//------------------------------------------------------------------------------

// This replace the StrCopy function because it's big shit (it hang the app)
procedure StrToFourCC(var FourCC: array of Char; S: string);
var
  i: Integer;

begin
  if S = '' then
    // Only a empty zone
    ZeroMemory(@FourCC, SizeOf(FourCC))
  else begin
    // Check entry parameter
    if (Length(S) - 1) <> High(FourCC) then
      raise EFourCCNotSameLengthAsString.Create('StrToFourCC: Check the Length ' +
        'of your FourCC and S string!');

    // Filling the FourCC
    for i := 1 to Length(S) do
      FourCC[i - 1] := S[i];  // it sucks but the StrCopy don't works properly!
  end;
end;

//------------------------------------------------------------------------------

function VariantToString(V: Variant): string;
begin
  Result := '';
  if not VarIsNull(V) then
    Result := V;
end;

//------------------------------------------------------------------------------

function EOFS(FileStream: TFileStream): Boolean;
begin
//  Result := F.Position >= F.Size
  Result := EOS(FileStream);
end;

//------------------------------------------------------------------------------

function StrEquals(S1, S2: string): Boolean;
begin
  Result := StrComp(PChar(S1), PChar(S2)) = 0; 
end;

//------------------------------------------------------------------------------

function ReadNullTerminatedString(var F: TFileStream): string;
var
  Done: Boolean;
  c: Char;

begin
  Result := '';
  Done := False;

  // Reading the string
  while not Done do begin  
    F.Read(c, 1);
    if c <> #0 then
      Result := Result + c
    else
      Done := True;
  end;
end;

//------------------------------------------------------------------------------

function ReadNullTerminatedString(var F: TFileStream;
  const StrSize: LongWord): string;
var
  Buf: array[0..NULL_BUFFER_SIZE - 1] of Char;

begin
  ZeroMemory(@Buf, SizeOf(Buf));
  F.Read(Buf, StrSize);
  Result := StrPas(Buf);
end;

//------------------------------------------------------------------------------

procedure WriteNullTerminatedString(var F: TFileStream; const S: string;
  const WriteNullEndChar: Boolean);
var
  pStr: PChar;
  wStr: Word;
  _NullCharLength: LongWord;

begin
  wStr := Length(S);
  if wStr = 0 then Exit; // nothing to write

  _NullCharLength := 0;
  if WriteNullEndChar then
    _NullCharLength := 1;

  pStr := StrAlloc(wStr + 1);
  StrPLCopy(pStr, S, wStr);

  F.Write(pStr^, wStr + _NullCharLength);

  StrDispose(pStr);
end;

//------------------------------------------------------------------------------

procedure IntegerToArray(var Destination: array of Char; const Value: Integer);
var
  i, Shift: Integer;
  
begin
  Shift := 0;
  for i := Low(Destination) to High(Destination) do begin
    Destination[i] := Chr(Value shr Shift);
    Inc(Shift, 8);
  end;
end;

//------------------------------------------------------------------------------

function IsInString(const SubStr, S: string): Boolean;
begin
  Result := Pos(LowerCase(SubStr), LowerCase(S)) > 0;
end;

//------------------------------------------------------------------------------

// Thanks Michel Bardou
procedure Delay(Milliseconds: Double);
var
  StartTime: TDateTime;

begin
  StartTime := Now;
  // Transforme les millisecondes en fractions de jours
  Milliseconds := Milliseconds / 24 / 60 / 60 / 1000;
  repeat
    Sleep(1);
    Application.ProcessMessages;
  until Now > (StartTime + Milliseconds);
end;

//------------------------------------------------------------------------------

function MoveTempFile(const TempFileName, DestFileName: TFileName;
  MakeBackup: Boolean): Boolean;
var
  BackupFile: TFileName;

begin
  if FileExists(DestFileName) and (not MakeBackup) then
    DeleteFile(DestFileName)
  else begin
    BackupFile := ChangeFileExt(DestFileName, '.BAK');
    if FileExists(BackupFile) then
      DeleteFile(BackupFile); // delete old backup    
    RenameFile(DestFileName, BackupFile);
  end;
  Result := MoveFile(TempFileName, DestFileName);
end;

//------------------------------------------------------------------------------

// This function retrieve the text between the defined substring
function ParseStr(SubStr, S: string; n: Integer): string;
var
  i: Integer;

begin
  S := S + SubStr;

  for i := 1 to n do
    S :=
      Copy(
        S,
        Pos(SubStr, S) + Length(SubStr),
        Length(S) - Pos(SubStr, S) + Length(SubStr)
      );

  Result := Copy(S, 1, Pos(SubStr, S) - 1);
end;

//------------------------------------------------------------------------------

function GetApplicationDirectory: TFileName;
begin
  Result :=
    IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;

//------------------------------------------------------------------------------

function GetApplicationRadicalName: string;
begin
  Result := ExtractRadicalFileName(ParamStr(0));
end;

//------------------------------------------------------------------------------

procedure IntegerArrayToList(Source: array of Integer; var Destination: TList);
var
  i: Integer;

begin
  Destination.Clear;
  for i := Low(Source) to High(Source) do
    Destination.Add(Pointer(Source[i]));
end;

//------------------------------------------------------------------------------

// Thanks Marc Collin
// http://www.laboiteaprog.com/article-30-1-delphi_recherche_binaire
// This function is here to search in an array. ONLY IF THE ARRAY IS SORTED!!!
function StringArrayBinarySearch(SortedSource: array of string;
  SearchValue: string): Integer;
var
  Middle, Top, Bottom: Integer;
  Found: Boolean;

begin
  SearchValue := UpperCase(SearchValue);
  
  Bottom := Low(SortedSource);
  Top := High(SortedSource);
  Found := False;
  Result := 1;

  while(Bottom <= Top) and (not Found) do
  begin
    Middle := (Bottom + Top) div 2;
    if SortedSource[Middle] = SearchValue then begin
      Found := True;
      Result := Middle;
    end else
      if SortedSource[Middle] < SearchValue then
        Bottom := Middle + 1
      else
        Top := Middle - 1;
  end; // while

  if not Found then
    Result := Low(SortedSource) - 1;
end;

//------------------------------------------------------------------------------

// By CodePedia
// http://www.codepedia.com/1/HexToInt
function HexToInt(Hex: string): Integer;
var
  i: integer;
begin
  Result := 0;
  case Length(Hex) of
    0: Result := 0;
    1..8: for i:=1 to Length(Hex) do
      Result := 16*Result + Pos(Upcase(Hex[i]), HEXADECIMAL_VALUES)-1;
    else for i:=1 to 8 do
      Result := 16*Result + Pos(Upcase(Hex[i]), HEXADECIMAL_VALUES)-1;
  end;
end;

//------------------------------------------------------------------------------

// By CodePedia
// http://www.codepedia.com/1/HexToInt
function HexToInt64(Hex: string): Int64;
var
  i: integer;
begin
  Result := 0;
  case Length(Hex) of
    0: Result := 0;
    1..16: for i:=1 to Length(Hex) do
      Result := 16*Result + Pos(Upcase(Hex[i]), HEXADECIMAL_VALUES)-1;
    else for i:=1 to 16 do
      Result := 16*Result + Pos(Upcase(Hex[i]), HEXADECIMAL_VALUES)-1;
  end;
end;

//------------------------------------------------------------------------------

function CopyFile(SourceFileName, DestFileName: TFileName; FailIfExists: Boolean): Boolean;
begin
  Result := Windows.CopyFile(PChar(SourceFileName), PChar(DestFileName), FailIfExists);
end;

//------------------------------------------------------------------------------

procedure CopyFileBlock(var FromF, ToF: file; StartOffset, BlockSize: Integer);
const
  MAX_BUF_SIZE = 512;

var
  Buf: array[0..MAX_BUF_SIZE-1] of Char;
  i, j, BufSize, _Last_BufEntry_Size: Integer;

begin
  Seek(FromF, StartOffset);

  BufSize := SizeOf(Buf);
  _Last_BufEntry_Size := (BlockSize mod BufSize);

  j := BlockSize div BufSize;
  for i := 0 to j - 1 do begin
    BlockRead(FromF, Buf, SizeOf(Buf), BufSize);
    BlockWrite(ToF, Buf, BufSize);
  end;

  BlockRead(FromF, Buf, _Last_BufEntry_Size, BufSize);
  BlockWrite(ToF, Buf, BufSize);
end;

//------------------------------------------------------------------------------

// Thanks Michel
function GetTempDir: TFileName;
var
  Dir: array[0..MAX_PATH] of Char;

begin
  Result := '';
  if GetTempPath(SizeOf(Dir), Dir) <> 0 then
    Result := IncludeTrailingPathDelimiter(StrPas(Dir));
end;

//------------------------------------------------------------------------------

function GetTempFileName(FullPath: Boolean = True): TFileName;
var
  Dir: TFileName;

begin
  Dir := '';
  if FullPath then
    Dir := GetTempDir;
    
  repeat
    Result := Dir + IntToHex(Random($FFFFFFF), 8) + '.SiZ';
  until not FileExists(Result);
end;

//------------------------------------------------------------------------------

// Thanks Michel
function ExtractFile(ResourceName: string; OutputFileName: TFileName): Boolean;
var
 ResourceStream : TResourceStream;
 FileStream  : TFileStream;

begin
  ResourceStream := TResourceStream.Create(hInstance, ResourceName, RT_RCDATA);
  try
    try
      FileStream := TFileStream.Create(OutputFileName, fmCreate);
      try
        FileStream.CopyFrom(ResourceStream, 0);
      finally
        FileStream.Free;
      end;
    finally
      ResourceStream.Free;
    end;
  except
    Result := False;
    Exit;
  end;
  Result := FileExists(OutputFileName)
end;

//------------------------------------------------------------------------------

function RunNoWait(const TargetFileName: TFileName): Boolean;
begin
  Result := FileExists(TargetFileName);
  if Result then
    ShellExecute(Application.Handle, 'open', PChar(TargetFileName), '', '',
      SW_SHOWNORMAL);
end;

//------------------------------------------------------------------------------

// Thanks Michel
function RunAndWait(const TargetFileName: TFileName) : Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInformation: TProcessInformation;

begin
  Result := True;
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE;
  if CreateProcess(
    nil, PChar(TargetFileName), nil, nil, True, 0, nil, nil, StartupInfo,
    ProcessInformation
  ) then
    WaitForSingleObject(ProcessInformation.hProcess, INFINITE)
  else
    Result := False;
end;

//------------------------------------------------------------------------------

// Thanks (?)
procedure DeleteDirectory(DirectoryToRemove: TFileName);
var
  aResult : Integer;
  aSearchRec : TSearchRec;

begin
  if DirectoryToRemove = '' then Exit;
  if DirectoryToRemove[Length(DirectoryToRemove)] <> '\' then DirectoryToRemove := DirectoryToRemove + '\';
  aResult := FindFirst(DirectoryToRemove + '*.*', faAnyFile, aSearchRec);
  while aResult=0 do
  begin
    if ((aSearchRec.Attr and faDirectory)<=0) then
    begin
      try
        if (FileGetAttr(DirectoryToRemove+aSearchRec.Name) and faReadOnly) > 0 then 
			FileSetAttr(DirectoryToRemove+aSearchRec.Name, FileGetAttr(DirectoryToRemove+aSearchRec.Name) xor faReadOnly);
        //if FileGetAttr(TheFolder) > 0 then FileSetAttr(TheFolder, faAnyFile);
        DeleteFile(DirectoryToRemove+aSearchRec.Name)
      except
      end;
    end
    else
    begin
      try
        if aSearchRec.Name[1]<>'.' then   // pas le repertoire '.' et '..'sinon on tourne en rond
        begin
          DeleteDirectory(DirectoryToRemove+aSearchRec.Name); // vide les sous-repertoires de facon recursive
          RemoveDir(DirectoryToRemove+aSearchRec.Name);
        end;
      except // exception silencieuse si ne peut détrure le fichier car il est en cours d'utilisation : sera détruit la fois prochaine....
      end;
    end;
    aResult:=FindNext(aSearchRec);
  end;
  FindClose(aSearchRec); // libération de aSearchRec
  if DirectoryExists(DirectoryToRemove) = True then RemoveDir(DirectoryToRemove);
end;

//------------------------------------------------------------------------------

// Thanks Michel (Phidels.com)
function Right(SubStr: string; S: string): string;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;

//------------------------------------------------------------------------------

// Thanks Michel (Phidels.com)
function Left(SubStr: string; S: string): string;
begin
  result:=copy(s, 1, pos(substr, s)-1);
end;

//------------------------------------------------------------------------------

// Thanks Michel (Phidels.com)
function ExtractStr(LeftSubStr, RightSubStr, S: string): string;
begin
  Result := Left(RightSubStr, Right(LeftSubStr, S));
end;

//------------------------------------------------------------------------------

// Thanks Michel (Phidels.com)
function ExtremeRight(SubStr: string ; S: string): string;
begin
  Repeat
    S:= Right(substr,s);
  until pos(substr,s)=0;
  result:=S;
end;

//------------------------------------------------------------------------------

function GetFileSize(const FileName: TFileName): Int64;
var
  Stream: TFileStream;
  
begin
  Result := -1;
  if not FileExists(FileName) then Exit;
  
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    Result := Stream.Size;
  finally
    Stream.Free;
  end;
end;

//------------------------------------------------------------------------------

function StringArraySequentialSearch(Source: array of string;
  SearchValue: string): Integer;
var
  i: Integer;
  Found: Boolean;

begin
  Result := Low(Source) - 1;
  Found := False;
  
  i := Low(Source);
  while (not Found) and (i <= High(Source)) do begin
    if Pos(Source[i], SearchValue) > 0 then begin
      Result := i;
      Found := True;
    end;
    Inc(i);
  end;
end;

//------------------------------------------------------------------------------

function MoveFile(const ExistingFileName, NewFileName: TFileName): Boolean;
begin
  Result := Windows.MoveFile(PChar(ExistingFileName), PChar(NewFileName));
end;

//------------------------------------------------------------------------------

// Thanks to phidels.com and Zeus^SFX
function GetApplicationInstancesCount: Integer;
var
  Snapshot: THandle;
  Module: TModuleEntry32;
  Process: TProcessEntry32;
  ExeFile: TFileName;

  // This function checks if the process found is the same as ParamStr(0)
  function SameProcessFound: Boolean;
  begin
    Result := False;
    if SameText(Process.szExeFile, ExeFile) then
      if Module32First(Snapshot, Module) then // get the first module for this process...
        Result := SameText(Module.szExePath, ParamStr(0)); // the first module is the full path ExeFile
      // after, with Module32Next, we get every DLL loaded by the process.
  end;
  
begin
  Result := 0;

  Snapshot := CreateToolHelp32SnapShot(TH32CS_SNAPMODULE or TH32CS_SNAPPROCESS, 0);
  try
    Module.dwSize := SizeOf(TModuleEntry32);
    Process.dwSize := SizeOf(TProcessEntry32);
    ExeFile := ExtractFileName(ParamStr(0));
    
    // Retrieving each process information
    Process32First(Snapshot, Process);
    repeat

      // Check if we found the same process running...
      if SameProcessFound then
        Inc(Result);

    until not Process32Next(Snapshot, Process);

  finally
    CloseHandle(Snapshot);
  end;
end;

//------------------------------------------------------------------------------

function GetApplicationDataDirectory: TFileName;
begin
  Result := GetApplicationDirectory + DATA_BASEDIR + '\';
  if not DirectoryExists(Result) then
    raise EDataDirectoryNotFound.Create('GetApplicationDataDirectory: '
      + 'Sorry, the data directory wasn''t found ("' + Result + '") !');
end;

//------------------------------------------------------------------------------

procedure WriteNullBlock(F: TFileStream; const Size: LongWord);
const
  MAX_BUFFER_SIZE = 32;

var
  Buffer: array[0..MAX_BUFFER_SIZE - 1] of Byte;
  MissingBlocks, BlockSize: LongWord;

begin
  if Size = 0 then Exit; // nothing to write
  
  MissingBlocks := Size;
  ZeroMemory(@Buffer, SizeOf(Buffer));

  while MissingBlocks <> 0 do begin
    // Calculating BlockSize
    BlockSize := (MissingBlocks mod SizeOf(Buffer));
    if BlockSize = 0 then
      BlockSize := SizeOf(Buffer);
    Dec(MissingBlocks, BlockSize);

    // Writing the Block
    F.Write(Buffer, BlockSize);
  end;
end;

//------------------------------------------------------------------------------

function GetRandomString(const StringMaxLength: Integer): string;
const
  ALPHA_CHARS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

var
  x: Integer;

begin
  Result := '';
  for x := 0 to Random(StringMaxLength) do begin
    Result := Result + ALPHA_CHARS[Random(Length(ALPHA_CHARS)) + 1];
  end;
end;

//------------------------------------------------------------------------------

function ExtractDirectoryName(const FullDirectoryPath: TFileName): TFileName;
begin
  Result := ExtremeRight('\', Copy(FullDirectoryPath, 1, Length(FullDirectoryPath)-1))
end;

//------------------------------------------------------------------------------

// Found at http://www.eksperten.dk/spm/775112
// Author unknow

procedure LoadUnicodeTextFile(SL: TStringList; const FileName: TFileName);
var
  F: TStream;
  UnicodeString: WideString;
  UnicodeSign: Word;
  FileSize: Cardinal;
  Unicode: Boolean;

begin
  Unicode := True;
  F := TFileStream.Create(FileName, fmOpenRead);
  try

    FileSize := F.Size;
    if FileSize >= SizeOf(UnicodeSign) then begin
      F.ReadBuffer(UnicodeSign, SizeOf(UnicodeSign));

      if UnicodeSign = $FEFF then begin
        Dec(FileSize, SizeOf(UnicodeSign));
        SetLength(UnicodeString, FileSize div SizeOf(WideChar));
        F.ReadBuffer(UnicodeString[1], FileSize);
        // now UnicodeString contains Unicode string read from stream
        SL.Text := UnicodeString;
      end else
        Unicode := False;

    end;

  finally
    F.Free;
    if not Unicode then
      SL.LoadFromFile(FileName);
  end;
end;

//------------------------------------------------------------------------------

// Thanks Primoz Gabrijelcic
// http://www.swissdelphicenter.ch/torry/showcode.php?id=1692

{:Converts Unicode string to Ansi string using specified code page.
  @param   ws       Unicode string.
  @param   codePage Code page to be used in conversion.
  @returns Converted ansi string.
}

(*function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
var
  l: integer;
begin
  if ws = '' then
    Result := ''
  else
  begin
    l := WideCharToMultiByte(codePage,
      WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
      @ws[1], - 1, nil, 0, nil, nil);
    SetLength(Result, l - 1);
    if l > 1 then
      WideCharToMultiByte(codePage,
        WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
        @ws[1], - 1, @Result[1], l - 1, nil, nil);
  end;
end; { WideStringToString }

function MakeJapaneseString(const WS: WideString): AnsiString;
begin
  Result := WideStringToString(WS, 20932);
end; *)

//------------------------------------------------------------------------------

// to be fixed
function IsJapaneseString(const S: string): Boolean;
var
  i: Integer;
  
begin
  Result := False;
  if S <> '' then
    for i := 1 to Length(S) do
      Result := Result or (S[i] in [#$A4, #$B6, #$A5, #$BB]);
end;

//------------------------------------------------------------------------------

function WritePaddingSection(F: TFileStream; DataSize: LongWord;
  PaddingMode: TPaddingMode = pm32b): LongWord;
const
  PADDING_MAX_SIZE  = 32;
  
var
  Padding: array[0..PADDING_MAX_SIZE - 1] of Byte;
  PaddingOperator: LongWord;
  
begin
  PaddingOperator := PADDING_MAX_SIZE; // dummy value
  case PaddingMode of
    pm32b: PaddingOperator := 32;
    pm4b:  PaddingOperator := 4;
    pm2b:  PaddingOperator := 2;
  end;

  // Compute padding size (= Result)
  Result := DataSize mod PaddingOperator;
  if Result <> 0 then  
    Result := PaddingOperator - Result;

  // Writing padding in the file
  if Result <> 0 then begin
    ZeroMemory(@Padding, Result);
    F.Write(Padding, Result);
  end;
end;

//------------------------------------------------------------------------------

function EOS(Stream: TStream): Boolean;
begin
  Result := Stream.Position >= Stream.Size;
end;

//------------------------------------------------------------------------------

function GetStreamBlockReadSize(Stream: TStream;
  const WishedBlockSize: Int64): Int64;
var
  RemainingBytes: Int64;

begin
  Result := WishedBlockSize;

  // If the Wished BlockSize is more than the Stream Size...
  if WishedBlockSize > Stream.Size then
    Result := Stream.Size; // ... return the stream size

  // If the Wished BlockSize is more larger than the bytes remaining to read...
  RemainingBytes := Stream.Size - Stream.Position;
  if WishedBlockSize > RemainingBytes then
    Result := RemainingBytes; // ... return the remaining bytes count.
end;

//------------------------------------------------------------------------------

// Author unknow
function GetDirectorySize(Directory: TFileName): Int64;
var
  aResult : Integer;
  aSearchRec : TSearchRec;

begin
  Result := 0;
  if Directory = '' then Exit;
  Directory := IncludeTrailingPathDelimiter(Directory);
  aResult := FindFirst(Directory + '*.*', faAnyFile, aSearchRec);
  while aResult = 0 do
  begin
    if ((aSearchRec.Attr and faDirectory) <= 0) then
      Result := Result + aSearchRec.Size //GetFileSize(Directory + aSearchRec.Name)
    else
      if aSearchRec.Name[1] <> '.' then   // pas le repertoire '.' et '..'sinon on tourne en rond
        Result := Result + GetDirectorySize(Directory + aSearchRec.Name);
    aResult := FindNext(aSearchRec);
  end;
  FindClose(aSearchRec); // libération de aSearchRec
end;

//------------------------------------------------------------------------------

// Thanks Michel (Phidels.com)
function GetSubStrCount(SubStr, S: string): Integer;
{==================================================================================}
{ renvoie le nombre de fois que la sous chaine substr est présente dans la chaine S}
{==================================================================================}
begin
  result:=0;
  while pos(substr,s)<>0 do
  begin
    S:=Right(substr,s);
    inc(result);
  end;
end;

//------------------------------------------------------------------------------

// Thanks Michel (Phidels.com)
function LeftNRight(SubStr, S: string; N: Integer): string;
{==============================================================================}
{ renvoie ce qui est à gauche de la droite de la n ieme sous chaine substr     }
{ de la chaine S                                                               }
{ ex : GaucheNDroite('/','c:machin\truc\essai.exe',1) renvoie 'truc'           }
{ Permet d'extraire un à un les éléments d'une chaine séparés par un séparateur}
{==============================================================================}
var i:integer;
begin
  S:=S+substr;
  for i:=1 to n do
  begin
    S:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
  end;
  result:=copy(s, 1, pos(substr, s)-1);
end;

//------------------------------------------------------------------------------

initialization
  Randomize;

//------------------------------------------------------------------------------

end.
