unit utils;

interface

uses
  SysUtils;

function ApplyCase(StrToGenerate, StrModel : string) : string;
procedure PrintUsage;
procedure PrintWhy;
procedure PrintDescription;

implementation

procedure PrintWhy;
begin
  WriteLn(
      'So why this proggy then ?', #13#10,
      '  That''s pretty simple. *EVERY TRANSLATION MADE WITH v1.xx to v1.02 EDITORS ARE',#13#10,
      '  NON-WORKING HACKED FILES.*', #13#10,
      #13#10,
      'OMG! I''LL LOSE ALL MY TRANSLATION ??', #13#10,
      '  No. The purpose of this proggy is to retrieve subtitles from *BAD* hacked', #13#10,
      '  NPC files in order to inject these with the new version of the editor (which ', #13#10,
      '  means the coming soon v2.xx).', #13#10,
      #13#10,
      '  Yes, with this exporter, *YOU DON''T LOSE EVERY WORK MADE WITH EARLIER ',#13#10,
      '  VERSIONS OF FREE QUEST EDITOR*.'
  );
end;

procedure PrintDescription;
begin
  WriteLn(
      'Description:',#13#10,
      '  This tool was made for retrieve and export subtitles from *MESSED UP* NPC', #13#10,
      '  "PAKS" files. In fact, public releases of the FQ Editor (down to v2.0) haves', #13#10,
      '  a very *BAD* hack algorithm. The FQ Editor v2.xx+ hacks NPC "PAKS" files', #13#10,
      '  properly, but only from ORIGINAL, *NOT BAD HACKED* "PAKS" files.'
  );
end;

procedure PrintUsage;
var
  pname: string;

begin
  PrintDescription;
  
  pname := ExtractFileName(ChangeFileExt(ParamStr(0), ''));  
  WriteLn(
      #13#10,
      'Usage:',
      #13#10,
      '  ', pname, ' <command> [old_npc.pks] [subs.xml] [options]',
      #13#10, #13#10,
      'Commands:', #13#10,
      '  -e: Extract [subs.xml] from [old_npc.pks]',#13#10,
      '  -h: Print this help', #13#10,
      '  -w: Print "why this proggy ?" screen', #13#10,
      '  -v: Print used engine version', #13#10, #13#10,
      'Options:', #13#10,
      '  -o: Overwrite output file'
    );
end;

//Savoir si un caractère passé en paramètre est en minuscule.
function IsLowCase(c : Char) : Boolean;
var
  _ord_c : Byte;

begin
  _ord_c := Ord(c);

  Result := (_ord_c > Ord('a')) and (_ord_c < Ord('z'));
end;

{	Fonction qui permet de changer la case d'une chaine source en fonction d'un modèle.
	Exemple : ApplyCase('hello', 'SaLuT') renvoit HeLlo. }
function ApplyCase(StrToGenerate, StrModel : string) : string;
var
  i : Integer;
  
begin
  Result := '';
  
  for i := 1 to Length(StrModel) do
    if IsLowCase(StrModel[i]) then
      Result := Result + LowerCase(StrToGenerate[i])
    else Result := Result + UpperCase(StrToGenerate[i]);
end;

function Left(SubStr : string ; S : string): string;
begin
  result:=copy(s, 1, pos(substr, s)-1);
end;

end.