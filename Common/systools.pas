unit systools;

interface

uses
  Windows, SysUtils, Classes;

function CopyFile(SourceFileName, DestFileName: TFileName; FailIfExists: Boolean): Boolean;
procedure CopyFileBlock(var FromF, ToF: file; StartOffset, BlockSize: Integer);
procedure DeleteDirectory(DirectoryToRemove: TFileName);
function ExtractFile(ResourceName: string; OutputFileName: TFileName): Boolean;
function ExtractStr(LeftSubStr, RightSubStr, S: string): string;
function GetApplicationInstancesCount: Integer;
function GetFileSize(const FileName: TFileName): Int64;
function GetTempDir: TFileName;
function GetTempFileName: TFileName;
function HexToInt(Hex: string): Integer;
function HexToInt64(Hex: string): Int64;
procedure IntegerArrayToList(Source: array of Integer; var Destination: TList);
function MoveFile(const ExistingFileName, NewFileName: TFileName): Boolean;
function ParseStr(SubStr, S: string; n: Integer): string;
function StringArrayBinarySearch(SortedSource: array of string;
  SearchValue: string): Integer;
function StringArraySequentialSearch(Source: array of string;
  SearchValue: string): Integer;
function Left(SubStr: string; S: string): string;
function Right(SubStr: string; S: string): string;
function RunAndWait(const TargetFileName: TFileName) : Boolean;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

{$WARN SYMBOL_PLATFORM OFF}

uses
  TlHelp32;
  
const
  HexValues = '0123456789ABCDEF';

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
      Result := 16*Result + Pos(Upcase(Hex[i]), HexValues)-1;
    else for i:=1 to 8 do
      Result := 16*Result + Pos(Upcase(Hex[i]), HexValues)-1;
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
      Result := 16*Result + Pos(Upcase(Hex[i]), HexValues)-1;
    else for i:=1 to 16 do
      Result := 16*Result + Pos(Upcase(Hex[i]), HexValues)-1;
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
  Result := GetTempDir + IntToHex(Random($FFFFFFF), 8) + '.SiZ';
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

function GetFileSize(const FileName: TFileName): Int64;
var
  Stream: TFileStream;
  
begin
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

initialization
  Randomize;

//------------------------------------------------------------------------------

end.
