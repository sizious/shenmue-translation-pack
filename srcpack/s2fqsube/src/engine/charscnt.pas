{
  Extracted from Chars Count v3.0 by Manic (Manic Corp.)
}
unit charscnt;

interface

uses
  Windows, SysUtils;
  
procedure CalculateCharsCount(const Subtitle: string; var Line1Count, Line2Count: Integer);
function parse_section(substr:String; s:String; n:Integer): string;
function CountPos(const subtext: string; Text: string): Integer;

implementation

//This function retrieve the text between the defined substring
function parse_section(substr:String; s:String; n:Integer): string;
var i:integer;
begin
  S := S + substr;

  for i:=1 to n do
  begin
          S := copy(s, Pos(substr, s) + Length(substr), Length(s) - Pos(substr, s) + Length(substr));
  end;

  Result := Copy(s, 1, pos(substr, s)-1);
end;

//This function ('CountPos') come from this site:
//http://www.delphitricks.com/source-code/strings/count_the_number_of_occurrences_of_a_substring_within_a_string.html
function CountPos(const subtext: string; Text: string): Integer;
begin
        if (Length(subtext) = 0) or (Length(Text) = 0) or (Pos(subtext, Text) = 0) then
        begin
                Result := 0;
        end
        else
        begin
                Result := (Length(Text) - Length(StringReplace(Text, subtext, '', [rfReplaceAll]))) div Length(subtext);
        end;
end;

procedure CalculateCharsCount(const Subtitle: string; var Line1Count, Line2Count: Integer);
var
  line1, line2:String;
  num_substr:Integer;
  
begin
        if StrPos(PChar(Subtitle), PChar('¡õ')) <> nil then
        begin
                line1 := parse_section('¡õ', Subtitle, 0);
                line2 := parse_section('¡õ', Subtitle, 1);
        end
        else
        begin
                line1 := Subtitle;
                line2 := '';
        end;

        //Finding original length for the first line
        Line1Count := Length(line1);
        
        //Calculating the correct length for the first line
        num_substr := CountPos('=@', line1);
        Line1Count := Line1Count - (num_substr*2) + (num_substr*3);

        //Verifying if the second line contain text
        if line2 <> '' then
        begin
                //Finding original length for the second line
                Line2Count := Length(line2);

                //Calculating the correct length for the second line
                num_substr := CountPos('=@', line2);
                Line2Count := Line2Count - (num_substr*2) + (num_substr*3);

        end
        else
        begin
               Line2Count := 0;
        end;
end;

end.
