//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit scnfutil;

interface

uses
  Windows, SysUtils;

type
  TGameVersion = (
    gvUndef,          // (Undefined)
    gvWhatsShenmue,   // What's Shenmue [Demo] (NTSC-J) (DC)
    gvShenmueJ,       // Shenmue I (NTSC-J) (DC)
    gvShenmue,        // Shenmue I (PAL) (DC) / US Shenmue (NTSC-J) (DC)
    gvShenmue2J,      // Shenmue II (NTSC-J) (DC)
    gvShenmue2,       // Shenmue II (PAL) (DC)
    gvShenmue2X       // Shenmue II (PAL) (XBOX)
  );

const
  TABLE_STR_ENTRY_BEGIN = #$A1#$D6; // start string
  TABLE_STR_ENTRY_END   = #$A1#$D7; // end string
  GAME_BR          = #$A1#$F5; // carriage return

  GAME_INTEGER_SIZE = 4;

  PAKS_SIGN = 'PAKS'; // Global "PKS" file sign
  SCNF_SIGN = 'SCNF';
  SCNF_FOOTER_SIGN = 'BIN '; // To identify SCNF section, "BIN " is used in the PAKS footer

  // Game detection strings
  VOICE_STR_WHATS_SHENMUE       = '/prj16sc/MSG/voice/';                                  // What's Shenmue (DC) (NTSC-J)
  VOICE_STR_SHENMUEJ            = '/prj16sc2/MSG/voice/';                                 // Shenmue I (DC) (NTSC-J)
  VOICE_STR_SHENMUE             = '/p38/prj38sc/Msg/voice/';                              // Shenmue I (DC) (PAL) / US Shenmue (DC) (NTSC-J)
  VOICE_STR_SHENMUE2J           = '/p39/prj39sc/Msg/voice/';                              // Shenmue II (DC)  (NTSC-J)
  VOICE_STR_SHENMUE2            = '/p48/prj48sc/Voice/';                                  // Shenmue II (DC) (PAL)
  VOICE_STR_SHENMUE2X           = '/usr1/people/muramatsu/yoshizawa/humans/data/voice/';  // Shenmue II (XBOX) (PAL)

// SCNF Utilities
function FindPaksFooterOffset(var F: file; var SectionsCount: Integer): Integer; overload;
function FindPaksFooterOffset(var F: file): Integer; overload;
function IsFileValidScnf(const FileName: TFileName): Boolean;

// Misc Utilities
function Right(SubStr, S: string): string;
function ExtremeRight(SubStr: string; S: string): string;
function GameVersionToStr(GameVersion: TGameVersion): string;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  ScnfEdit;

//------------------------------------------------------------------------------

function GameVersionToStr(GameVersion: TGameVersion): string;
begin
  Result := '(Undefined)';
  case GameVersion of
    gvWhatsShenmue  : Result := 'What''s Shenmue (NTSC-J) (DC)';
    gvShenmueJ      : Result := 'Shenmue I (NTSC-J) (DC)';
    gvShenmue       : Result := 'Shenmue I (PAL) (DC)';
    gvShenmue2J     : Result := 'Shenmue II (NTSC-J) (DC)';
    gvShenmue2      : Result := 'Shenmue II (PAL) (DC)';
    gvShenmue2X     : Result := 'Shenmue II (PAL) (XBOX)';
  end;
end;

//------------------------------------------------------------------------------

function Right(SubStr: string ; S: string): string;
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
