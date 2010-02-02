unit systools;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, SysUtils, Classes, PNGImage;

procedure CopyFileBlock(var FromF, ToF: file; StartOffset, BlockSize: Integer);
procedure DeleteDirectory(DirectoryToRemove: TFileName);
function ExtractFile(ResourceName: string; OutputFileName: TFileName): Boolean;
function ExtractStr(LeftSubStr, RightSubStr, S: string): string;
function GetFileSize(const FileName: TFileName): Int64;
function GetTempDir: TFileName;
function HexToInt(Hex: string): Integer;
function HexToInt64(Hex: string): Int64;
function Left(SubStr: string; S: string): string;
function Right(SubStr: string; S: string): string;
function RunAndWait(const TargetFileName: TFileName) : Boolean;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

const
  HexValues = '0123456789ABCDEF';

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

end.
