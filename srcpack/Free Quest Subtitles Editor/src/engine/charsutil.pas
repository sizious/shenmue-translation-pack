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

type
  TCharsList = Record
    strList:TStringList;
    decList:TIntList;
  end;

function processChar(sbChar: String): Byte;
function revertChar(sbDecimal: Byte; sbChar:String): String;
function loadCharsList(FileName: TFileName): Boolean;
procedure freeCharsList;

var
  globalList: TCharsList;

implementation
uses charscnt;

function processChar(sbChar: String): Byte;
var i:Integer;
begin
  //The result will not be modified unless the character is found in 'charsList'
  Result := 0;
  for i := 0 to globalList.strList.Count - 1 do begin
    if sbChar = globalList.strList[i] then begin
      Result := globalList.decList[i];
      Break;
    end;
  end;
end;

function revertChar(sbDecimal: Byte; sbChar:String): String;
var i:Integer;
begin
  //The result will not be modified unless the character is found in 'decimalList'
  Result := '';
  for i := 0 to globalList.decList.Count - 1 do begin
    if sbDecimal = globalList.decList[i] then
    begin
      Result := globalList.strList[i];
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
  globalList.strList := TStringList.Create;
  globalList.decList := TIntList.Create;

  //Opening the file (probable chars_list.csv)
  if FileExists(FileName) then begin
    AssignFile(F, FileName);
    Reset(F);

    // Reading all the lines
    repeat
      ReadLn(F, mainLine);
      if (mainLine <> '') and (mainLine[1] <> '#') then begin
        globalList.decList.Add(StrToInt(parse_section(',', mainLine, 0)));
        tempChar := parse_section(',', mainLine, 1);
        globalList.strList.Add(AnsiDequotedStr(tempChar, '"'));
      end;
    until EOF(F);

    CloseFile(F);

    if globalList.strList.Count > 0 then begin
      Result := True;
    end;
  end;
end;

procedure freeCharsList;
begin
  globalList.strList.Free;
  globalList.decList.Free;
end;

end.
