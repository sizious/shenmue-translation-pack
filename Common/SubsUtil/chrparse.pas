unit ChrParse;

interface

uses
  Windows, SysUtils, Classes;

function ReadNullTerminatedString(var F: TFileStream): string;

implementation

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

end.