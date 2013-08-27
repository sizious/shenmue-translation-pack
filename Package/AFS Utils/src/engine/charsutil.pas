//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

{
  Extracted from Chars Count v3.0 by Manic
}

unit charsutil;

interface

uses
  Windows, SysUtils;

function ParseSection(substr:String; s:String; n:Integer): string;
function CountPos(const subtext: string; Text: string): Integer;

implementation

//This function retrieve the text between the defined substring
function ParseSection(substr:String; s:String; n:Integer): string;
var i:integer;
begin
  S := S + substr;

  for i:=1 to n do
  begin
          S := copy(s, Pos(substr, s) + Length(substr), Length(s) - Pos(substr, s) + Length(substr));
  end;

  Result := Copy(s, 1, pos(substr, s)-1);
end;

//Count the number of occurence of a substr within a string
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

end.
