unit searchutil;

interface

uses
  SysUtils, Masks;

function SearchFile(const SearchString: String; const FileIndex: Integer): Boolean;

implementation
uses afsextract, charsutil;

function SearchFile(const SearchString: String; const FileIndex: Integer): Boolean;
var
  Mask: TMask;
  strBuf: String;
begin
  strBuf := afsMain.FileName[FileIndex];
  Mask := TMask.Create(SearchString);
  Result := Mask.Matches(strBuf);
  Mask.Free;
end;

end.
