unit SysTools;

interface

uses
  Windows, SysUtils, Classes;

const
  UINT16_SIZE = 2;
  UINT32_SIZE = 4;

type
  ESystemTools = class(Exception);
  EDataDirectoryNotFound = class(ESystemTools);

  TPlatformVersion = (pvUnknow, pvDreamcast, pvXbox);

  // Batch thread events
  TBatchThreadInitializeEvent = procedure(Sender: TObject; MaxValue: Integer)
    of object;
  TBatchThreadFileProceed = procedure(Sender: TObject; FileName: TFileName;
    Result: Boolean) of object;
  TBatchThreadCompletedEvent = procedure(Sender: TObject;
    ErrornousFiles, TotalFiles: Integer; Canceled: Boolean) of object;

// Functions
function CopyFile(SourceFileName, DestFileName: TFileName;
  FailIfExists: Boolean): Boolean;
procedure CopyFileBlock(var FromF, ToF: file; StartOffset, BlockSize: Integer);
procedure Delay(Milliseconds: Double);
procedure DeleteDirectory(DirectoryToRemove: TFileName);
function ExtractFile(ResourceName: string; OutputFileName: TFileName): Boolean;
function ExtractStr(LeftSubStr, RightSubStr, S: string): string;
function ExtremeRight(SubStr: string; S: string): string;
function FindStr(const SubStr, S: string): Boolean;
function GetApplicationDirectory: TFileName;
function GetApplicationInstancesCount: Integer;
function GetApplicationDataDirectory: TFileName;
function GetFileSize(const FileName: TFileName): Int64;
function GetRandomString(const StringMaxLength: Integer): string;
function GetTempDir: TFileName;
function GetTempFileName: TFileName;
function HexToInt(Hex: string): Integer;
function HexToInt64(Hex: string): Int64;
procedure IntegerArrayToList(Source: array of Integer; var Destination: TList);
procedure IntegerToArray(var Destination: array of Char; const Value: Integer);
function MoveFile(const ExistingFileName, NewFileName: TFileName): Boolean;
function MoveTempFile(const TempFileName, DestFileName: TFileName;
  MakeBackup: Boolean): Boolean;
function ParseStr(SubStr, S: string; n: Integer): string;
function PlateformVersionToString(PlateformVersion: TPlatformVersion): string;
function StringArrayBinarySearch(SortedSource: array of string;
  SearchValue: string): Integer;
function StringArraySequentialSearch(Source: array of string;
  SearchValue: string): Integer;
function Left(SubStr: string; S: string): string;
function Right(SubStr: string; S: string): string;
function RunAndWait(const TargetFileName: TFileName) : Boolean;
procedure WriteNullBlock(var F: TFileStream; const Size: LongWord);

//==============================================================================
implementation
//==============================================================================

{$WARN SYMBOL_PLATFORM OFF}

uses
  TlHelp32, Forms, Math;
  
const
  HEXADECIMAL_VALUES  = '0123456789ABCDEF';
  DATA_BASEDIR        = 'data';

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

function FindStr(const SubStr, S: string): Boolean;
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

function GetTempFileName: TFileName;
begin
  repeat
    Result := GetTempDir + IntToHex(Random($FFFFFFF), 8) + '.SiZ';
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

function ExtractStr(LeftSubStr, RightSubStr, S: string): string;
begin
  Result := Left(RightSubStr, Right(LeftSubStr, S));
end;

//------------------------------------------------------------------------------

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

procedure WriteNullBlock(var F: TFileStream; const Size: LongWord);
const
  MAX_BUFFER_SIZE = 32;

var
  Buffer: array[0..MAX_BUFFER_SIZE - 1] of Byte;
  MissingBlocks, BlockSize: LongWord;

begin
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

function PlateformVersionToString(PlateformVersion: TPlatformVersion): string;
begin
  case PlateformVersion of
    pvUnknow:
      Result := '(Unknow)';
    pvDreamcast:
      Result := 'Dreamcast';
    pvXbox:
      Result := 'Xbox';
  end;
end;

//------------------------------------------------------------------------------

initialization
  Randomize;

//------------------------------------------------------------------------------

end.
