//    This file is part of SPR Utils.
//
//    You should have received a copy of the GNU General Public License
//    along with SPR Utils.  If not, see <http://www.gnu.org/licenses/>.

unit sprcheck;

interface

uses
  Classes, SysUtils;

function IsValidSpr(const FileName: TFileName): Boolean;

implementation

function IsValidSpr(const FileName: TFileName): Boolean;
var
  F: File;
  strBuf: String;
begin
  Result := False;

  //Verifying file validity
  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;

  //Reading header
  SetLength(strBuf, 4);
  BlockRead(F, Pointer(strBuf)^, Length(strBuf));
  if strBuf = 'TEXN' then begin
    Result := True;
  end;

  // Closing file (Fix by SiZiOUS)
  CloseFile(F);
end;

end.
