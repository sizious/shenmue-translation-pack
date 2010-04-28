unit ChrUtils;

interface

uses
  Windows, SysUtils, Classes;

function ReadNullTerminatedString(var F: TFileStream): string;
procedure WriteNullTerminatedString(var F: TFileStream; const S: string);

//------------------------------------------------------------------------------
implementation
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

procedure WriteNullTerminatedString(var F: TFileStream; const S: string);
var
  pStr: PChar;
  wStr: Word;

begin
  wStr := Length(S);
  if wStr = 0 then Exit; // nothing to write  

  pStr := StrAlloc(wStr + 1);
  StrPLCopy(pStr, S, wStr);

  F.Write(pStr^, wStr + 1);

  StrDispose(pStr);
end;

//------------------------------------------------------------------------------

end.