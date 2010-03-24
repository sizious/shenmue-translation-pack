//    This file is part of Shenmue AiO Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue AiO Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit charsutils;

interface

uses
  Classes, SysUtils;

//function ParseSection(substr:String; s:String; n:Integer): string;
function CountPos(const subtext: string; Text: string): Integer;
procedure CharsCount(const Text: String);

var
  lineCharsCnt: array of Integer;

implementation

uses
  SysTools;
  
//This function retrieve the text between the defined substring
(*function ParseSection(substr:String; s:String; n:Integer): string;
var i: Integer;
begin
        S := S + substr;

        for i:=1 to n do
        begin
                S := copy(s, Pos(substr, s) + Length(substr), Length(s) - Pos(substr, s) + Length(substr));
        end;

        Result := Copy(s, 1, pos(substr, s)-1);
end;*)

//This function count the number of occurence of the defined substring
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

//Main Chars Count function
procedure CharsCount(const Text: String);
var
  i, lineNum, subStrNum, lineCnt: Integer;
  lineText: String;
begin
  lineNum := countPos(sLineBreak, Text);
  Finalize(lineCharsCnt);
  SetLength(lineCharsCnt, lineNum+1);
  for i := 0 to lineNum do begin
    lineText := Trim(ParseStr(sLineBreak, Text, i));
    lineCnt := Length(lineText);
    if lineCnt = 0 then begin
      lineCharsCnt[i] := lineCnt;
    end
    else begin
      subStrNum := countPos('=@', lineText);
      lineCnt := lineCnt - (subStrNum*2) + (subStrNum*3);
      lineCharsCnt[i] := lineCnt;
    end;
  end;
end;

end.
