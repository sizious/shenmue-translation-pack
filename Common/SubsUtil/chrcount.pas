//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

{
  Extracted from Chars Count v3.0 by Manic (Manic Corp.)
}

unit ChrCount;

interface

uses
  Windows, SysUtils, StdCtrls;
  
procedure CalculateCharsCount(Subtitle: string; var Line1Count, Line2Count: Integer);
procedure UpdateSubtitleLengthControls(SubtitleText: string;
  FirstLengthEditControl, SecondLengthEditControl: TEdit);

implementation

uses
  Graphics, SysTools;

const
  SUBTITLE_LINE_MAXLENGTH = 44;
  
//------------------------------------------------------------------------------

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

//------------------------------------------------------------------------------

procedure CalculateCharsCount(Subtitle: string; var Line1Count, Line2Count: Integer);
var
  line1, line2:String;
  num_substr:Integer;

begin
  Subtitle := StringReplace(Subtitle, '<br>', '¡õ', [rfReplaceAll]);
  Subtitle := StringReplace(Subtitle, #13#10, '¡õ', [rfReplaceAll]);
  Subtitle := StringReplace(Subtitle, #$81#$95, '¡õ', [rfReplaceAll]);
  Subtitle := StringReplace(Subtitle, '...', '=@', [rfReplaceAll]);

        if StrPos(PChar(Subtitle), PChar('¡õ')) <> nil then
        begin
                line1 := ParseStr('¡õ', Subtitle, 0);
                line2 := ParseStr('¡õ', Subtitle, 1);
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

//------------------------------------------------------------------------------

procedure CheckIfSubLengthIsCorrect(const Value: Integer;
  Field: TEdit);
begin
  if Value > SUBTITLE_LINE_MAXLENGTH then begin
    Field.Font.Color := clRed;
    Field.Font.Style := [fsBold];
  end else begin
    Field.Font.Color := clWindowText;
    Field.Font.Style := [];
  end;
end;

//------------------------------------------------------------------------------

procedure UpdateSubtitleLengthControls(SubtitleText: string;
  FirstLengthEditControl, SecondLengthEditControl: TEdit);
var
  Line1, Line2: Integer;

begin
  CalculateCharsCount(SubtitleText, Line1, Line2);
  FirstLengthEditControl.Text := IntToStr(Line1);
  CheckIfSubLengthIsCorrect(Line1, FirstLengthEditControl);
  SecondLengthEditControl.Text := IntToStr(Line2);
  CheckIfSubLengthIsCorrect(Line2, SecondLengthEditControl);
end;

//------------------------------------------------------------------------------

end.
