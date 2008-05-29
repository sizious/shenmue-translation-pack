//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit scnfutil;

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
  Buf: array[0..4] of Char;
  currOffset, intBuf, ftrOffset: Integer;
  subFound:Boolean;
begin
  subFound := False;

  Seek(F, 28);
  BlockRead(F, ftrOffset, SizeOf(ftrOffset));
  Inc(ftrOffset, 16);
  
  currOffset := 32;
  Seek(F, currOffset);

  while (subFound <> True) and (currOffset <> ftrOffset) do begin
    // Reading section header, if present
    BlockRead(F, Buf, SizeOf(Buf));
    Buf[4] := #0;

    // Trimming null byte and verifying length
    if Length(Trim(PChar(@Buf))) = 4 then begin
      // Verifying section header
      if SCNF_SIGN = PChar(@Buf) then begin
        subFound := True;
      end
      else begin
        // Reading section size & seeking to next section
        Seek(F, currOffset+4);
        BlockRead(F, intBuf, SizeOf(intBuf));
        Inc(currOffset, intBuf);
        Seek(F, currOffset);
      end;
    end
    else begin
      // Seeking over null bytes
      Inc(currOffset, 1);
      Seek(F, currOffset);
      end;
  end;

  Result := currOffset;
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
