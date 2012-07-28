program MapInfo;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  Classes,
  fsparser in '..\..\..\Common\fsparser.pas',
  systools in '..\..\..\Common\systools.pas';

var
  Stream: TFileStream;
  i: Integer;
  CurrentOffset, MaxPos, AddrBase, StrPtr: LongWord;
  Sections: TFileSectionsList;
  SCN3: TFileSectionsListItem;
  S: string;
  CSV: TextFile;
  
// IsValidString
// Caractères permettant de reconnaitre une string valide
function IsValidChar(C: Char): Boolean;
begin
  Result := C in [#$20..#$7C, #$A5, #$AE, #$BB, #$C2..#$C6, #$CA, #$CD, #$DE,
    #$DF, #$E1, #$E2];
end;

// IsNumeric
function IsNumeric(S: string): Boolean;
const DEF = -1;
begin
  Result := not StrToIntDef(Trim(S), DEF) = DEF;
end;

// RetrieveString
function RetrieveString(Offset: LongWord): string;
var
  C: Char;
  Done: Boolean;
  i, NbChars: Integer;
  Tmp: string;

begin
  Result := '';
  Stream.Seek(Offset, soFromBeginning);
  NbChars := 0;
  repeat
    Stream.Read(C, 1);
    Done := not IsValidChar(C);

    // on double les '"' pour éviter des erreurs de séparateur
    if C = '"' then
      Result := Result + '"';

    if not Done then begin
      Result := Result + C;
      Inc(NbChars);
    end;
  until Done;

  // Test si la chaine en vaut la peine

  // Pas les chaines trop courtes
  if (NbChars < 4) then
    Result := '';

  // Pas de chaine uniquement numériques
  if IsNumeric(Result) then
    Result := '';

  // pas de chaine sans lettres
  Tmp := UpperCase(Result);
  Done := False;
  for i := 1 to Length(Tmp) do
  begin
    C := Tmp[i];
    Done := Done or (C in ['A'..'Z']);
  end;
  if not Done then Result := '';
end;

begin
  if ParamCount < 1 then
  begin
    WriteLn('usage: mapinfo <mapinfo.bin>');
    Exit;
  end;

  ReportMemoryLeaksOnShutdown := True;
  Sections := TFileSectionsList.Create;
  Stream := TFileStream.Create(ParamStr(1), fmOpenRead);
  try
    try
      ParseFileSections(Stream, Sections);
      i := Sections.IndexOf('SCN3');
      if i = -1 then Exit;
      SCN3 := Sections[i];

      AssignFile(CSV, ChangeFileExt(ParamStr(1), '.csv'));
      ReWrite(CSV);
      WriteLn(CSV, '"StringPointer";"String"');

      Stream.Seek(SCN3.Offset + 16, soFromBeginning);
      Stream.Read(AddrBase, 4);

      MaxPos := SCN3.Offset + SCN3.Size;

      for i := 0 to 3 do
      begin

        while Stream.Position < MaxPos do
        begin
          Stream.Read(StrPtr, 4);
          CurrentOffset := Stream.Position;
          S := RetrieveString(StrPtr + AddrBase + SCN3.Offset);
          if S <> '' then WriteLn(CSV, '"', CurrentOffset - SCN3.Offset - 4, '";"', S, '"');
          Stream.Seek(CurrentOffset, soFromBeginning);
        end;

        Stream.Seek(SCN3.Offset + 16 + i, soFromBeginning);
      end;

    { TODO -oUtilisateur -cCode du point d'entrée : Placez le code ici }
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;
  finally
    Sections.Free;
    Stream.Free;
    CloseFile(CSV);
  end;
end.
