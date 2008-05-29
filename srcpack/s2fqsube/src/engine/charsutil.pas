//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

{
  Extracted from Shenmue II Subtitles Editor v4.2
  Modified by Manic
}

unit charsutil;

interface

uses
  Classes, SysUtils, UIntList, Windows;

function processChar(sbChar: String): Byte;
function revertChar(sbDecimal: Byte; sbChar:String): String;
function loadCharsList(FileName: TFileName): Boolean;

var
  charsList:TStringList;
  decimalList:TIntList;

implementation
uses charscnt;

function processChar(sbChar: String): Byte;
var i:Integer;
begin
  //The result will not be modified unless the character is found in 'charsList'
  Result := 0;
  for i := 0 to charsList.Count - 1 do begin
    if sbChar = charsList[i] then begin
      Result := decimalList[i];
      Break;
    end;
  end;
end;

function revertChar(sbDecimal: Byte; sbChar:String): String;
var i:Integer;
begin
  //The result will not be modified unless the character is found in 'decimalList'
  Result := '';
  for i := 0 to decimalList.Count - 1 do begin
    if sbDecimal = decimalList[i] then
    begin
      Result := charsList[i];
      Break;
    end
    else begin
      Result := sbChar;
    end;
  end;
end;

function loadCharsList(FileName: TFileName): Boolean;
var F:TextFile; mainLine, tempChar:String;
begin
  Result := False;
  charsList := TStringList.Create;
  decimalList := TIntList.Create;

  //Opening the file (probable chars_list.csv)
  if FileExists(FileName) then begin
    AssignFile(F, FileName);
    Reset(F);

    // Reading all the lines
    repeat
      ReadLn(F, mainLine);
      if (mainLine <> '') and (mainLine[1] <> '#') then begin
        decimalList.Add(StrToInt(parse_section(',', mainLine, 0)));
        tempChar := parse_section(',', mainLine, 1);
        charsList.Add(AnsiDequotedStr(tempChar, '"'));
      end;
    until EOF(F);

    CloseFile(F);

    if charsList.Count > 0 then begin
      Result := True;
    end;
  end;
end;

end.
