unit cryptutl;

interface

uses
  SysUtils;

function ROT13(const S: string): string;

implementation

uses
  StrUtils;

function ROT13(const S: string): string;
const
  a1 : string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  a2 : string = 'nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM';

var
  i : integer;
begin
  for i := 1 to length(S) do
    if AnsiContainsStr(a1, S[i]) then
      result := result + a2[pos(S[i], a1)]
    else
      result := result + S[i];
end;

end.
