//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit scnfutil;

interface

uses
  Windows, SysUtils, Common;

// scnf utilities
function FindPaksFooterOffset(var F: file; var SectionsCount: Integer): Integer; overload;
function FindPaksFooterOffset(var F: file): Integer; overload;
function IsFileValidScnf(const FileName: TFileName): Boolean;

// misc utilities
function Right(SubStr, S: string): string;
function ExtremeRight(SubStr: string; S: string): string;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  ScnfEdit;

function Right(SubStr: string ; S : string): string;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;

//------------------------------------------------------------------------------

function ExtremeRight(SubStr: string ; S: string): string;
begin
  Repeat
    S:= Right(substr,s);
  until pos(substr,s)=0;
  result:=S;
end;

//------------------------------------------------------------------------------

function FindPaksFooterOffset(var F: file): Integer;
var
  Dummy: Integer;

begin
  Result := FindPaksFooterOffset(F, Dummy);
end;

//------------------------------------------------------------------------------

function FindPaksFooterOffset(var F: file; var SectionsCount: Integer): Integer;
begin
  // Reading how many sections this file has in IPAC section (FIRST SECTION ALWAYS)
  Seek(F, 24);
  BlockRead(F, SectionsCount, GAME_INTEGER_SIZE);

  // Calculating PAKS file footer
  Result := FileSize(F) - SectionsCount * SizeOf(TSectionRawBinaryEntry);
end;

//------------------------------------------------------------------------------

function IsFileValidScnf(const FileName: TFileName): Boolean;
var
  F: File;
  Buf: array[0..4] of Char;
  SectionEntry: TSectionRawBinaryEntry;
  i, SectionsCount: Integer;

begin
  Result := False;

  AssignFile(F, FileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F, 1);{$I+}
  if IOResult <> 0 then Exit;
  
  // Scanning the current file to see if it is a valid SCNF file
  try
    try
      Seek(F, 0);
      BlockRead(F, Buf, SizeOf(Buf)); // Reading file header
      Buf[4] := #0;

      //Verifying if it's a valid PAKS file
      if PAKS_SIGN = PChar(@Buf) then begin
        // Reading how many sections this file has
        {Seek(F, 24);
        BlockRead(F, SectionsCount, GAME_INTEGER_SIZE);

        // Reading footer
        Seek(F, FileSize(F) - SectionsCount * SizeOf(SectionEntry)); }
        Seek(F, FindPaksFooterOffset(F, SectionsCount));
        i := 0;
        while (i < SectionsCount) and (not Result) do begin
          BlockRead(F, SectionEntry, SizeOf(SectionEntry));
          Result := (SectionEntry.Name = SCNF_FOOTER_SIGN);
          // WriteLn(SectionEntry.Name);
          Inc(i);
        end;

        // If we have found the "BIN " section we'll check if it contains a subtitle table
        if Result then begin
          Seek(F, SectionEntry.Offset + 16);  // 16 for IPAC
          BlockRead(F, Buf, SizeOf(Buf)); // Reading file header
          Buf[4] := #0;
          Result := PChar(@Buf) = SCNF_SIGN;
        end;

      end;

    except
      Result := False;
    end;

  finally
    CloseFile(F);
  end;
end;

//------------------------------------------------------------------------------

end.
