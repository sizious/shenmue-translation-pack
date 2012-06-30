//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit old_scnfutil;

interface

uses
  Windows, SysUtils;

// scnf utilities
function IsFileValidScnf(const FileName: TFileName): Boolean;
function FindScnfOffset(var F: File): Integer;

// misc utilities
function Right(SubStr: string ; S : string): string;
function ExtremeRight(SubStr: string ; S: string): string;

implementation

function Right(SubStr: string ; S : string): string;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;

function ExtremeRight(SubStr: string ; S: string): string;
begin
  Repeat
    S:= Right(substr,s);
  until pos(substr,s)=0;
  result:=S;
end;

function FindScnfOffset(var F: File): Integer;
const
  SCNF_SIGN = 'SCNF'; // SCNF signature = Free Quest character subtitles table
var
  strBuf: String;
  intBuf: Integer;
begin
  //Seeking to footer & reading offset
  Seek(F, FileSize(F)-8);
  BlockRead(F, intBuf, SizeOf(intBuf));
  Inc(intBuf, 16);

  //Seeking to offset & reading section name
  Seek(F, intBuf);
  SetLength(strBuf, 4);
  BlockRead(F, Pointer(strBuf)^, Length(strBuf));

  //Verifying section name
  if strBuf = SCNF_SIGN then begin
    Result := intBuf;
  end
  else begin
    Result := 32;                       // SiZ V2.0 : may be another case ???
  end;
end;

function IsFileValidScnf(const FileName: TFileName): Boolean;
const
  PAKS_SIGN = 'PAKS'; // Global "PKS" file sign
var
  F: File;
  Buf: array[0..4] of Char;
  intBuf: Integer;
begin
  Result := False;

  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;
  
  // Scanning the current file to see if it is a valid SCNF file
  try
    Seek(F, 0);
    BlockRead(F, Buf, SizeOf(Buf)); // Reading file header
    Buf[4] := #0;

    //Verifying if it's a valid PAKS file
    if PAKS_SIGN = PChar(@Buf) then begin
      Seek(F, 24);
      BlockRead(F, intBuf, SizeOf(intBuf));
      // Verifying subtitle presence
      if intBuf > 1 then begin
        Result := True;
      end;
    end;
  finally
    CloseFile(F);
  end;
end;


end.
