//    This file is part of Shenmue AiO Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit common;

interface

type
  // gvUndef..........: (Undefined)
  // gvWhatsShenmue...: What's Shenmue (Demo)
  // gvShenmue........: Shenmue I / US Shenmue
  // gvShenmue2.......: Shenmue II (DC)
  // gvShenmue2X......: Shenmue II (XBOX)
  TGameVersion = (gvUndef, gvWhatsShenmue, gvShenmue, gvShenmue2, gvShenmue2X);

const
  // TABLE_CHAR_CODE: Char = #$A1;   // special char: this's a code used by the game
  // TABLE_STR_ENTRY_BEGIN: Char = #$D6; // start string
  // TABLE_STR_ENTRY_END: Char = #$D7;   // end string

  TABLE_STR_ENTRY_BEGIN = #$A1#$D6; // start string
  TABLE_STR_ENTRY_END   = #$A1#$D7; // end string
  TABLE_STR_CR          = #$A1#$F5; // carriage return

  GAME_INTEGER_SIZE = 4;

  PAKS_SIGN = 'PAKS'; // Global "PKS" file sign
  SCNF_SIGN = 'SCNF';
  SCNF_FOOTER_SIGN = 'BIN ';

  // Game detection strings
  VOICE_STR_WHATS_SHENMUE     = '/prj16sc/MSG/voice/';
  VOICE_STR_WHATS_SHENMUE_B2  = '/prj16sc2/MSG/voice/';
  VOICE_STR_SHENMUE           = '/p38/prj38sc/Msg/voice/';
  VOICE_STR_SHENMUE2          = '/p48/prj48sc/Voice/';
  VOICE_STR_SHENMUE2X         = '/usr1/people/muramatsu/yoshizawa/humans/data/voice/';

implementation

end.
