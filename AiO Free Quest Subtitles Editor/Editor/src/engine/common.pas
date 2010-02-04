//    This file is part of Shenmue AiO Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit common;

{$DEFINE DEBUG_FACES_DIR}

interface

uses
  SysUtils, ScnfUtil;

type
  // Identify what's the type of each MultiTranslation Node
  TMultiTranslationNodeViewType = (
    nvtUndef,          // Undefined
    nvtSubtitleKey,    // This is a subtitle key node
    nvtSourceFile,     // This is the source file node
    nvtSubCode,        // This is a subcode node
    nvtSubTranslated   // This is the subtitle translated node
  );

  // Structure attached at TTreeNode.Data in MultiTranslation TreeView
  PMultiTranslationNodeType = ^TMultiTranslationNodeType;
  TMultiTranslationNodeType = record
    NodeViewType: TMultiTranslationNodeViewType;
    GameVersion: TGameVersion;
  end;

const
  // Default text when not translated...
  MT_NOT_TRANSLATED_YET       = '# Not translated yet... #';
  FACE_WIDTH                  = 96; // used in pakfutil
  FACE_HEIGHT                 = 96;
  ORIGINAL_TEXT_NOT_AVAILABLE = '~~ Not available... ~~';

function GetCorrectCharsList(const GameVersion: TGameVersion): TFileName;
function GetDatasDirectory: TFileName;
function GetFacesDirectory(GameVersion: TGameVersion): TFileName;
function GetNPCInfoFile: TFileName;
function GetTextCorrectorDatabasesDirectory: TFileName;
function IsCharsModAvailable(GameVersion: TGameVersion): Boolean;
function IsTheSameCharsList(GameVersion1, GameVersion2: TGameVersion): Boolean;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

const
  DATA_BASE_DIR           = 'data';

  NPC_INFO_FILE           = 'npc_info.csv';
  CHR_LIST_1              = 'chrlist1.csv'; // for Shenmue, US Shenmue, What's Shenmue
  CHR_LIST_2              = 'chrlist2.csv'; // for Shenmue II

  FACES_BASE_DIR          = 'faces';
  FACES_WHATS_DIR         = 'whats';
  FACES_SHENMUE_DIR       = 'shenmue';
  FACES_SHENMUE2_DIR      = 'shenmue2';

  TEXT_DATABASE_ROOT_DIR  = 'textdb';       // directory where are stored subtitles correction DB

{$IFDEF DEBUG}{$IFDEF DEBUG_FACES_DIR}
  FACES_DEBUG_DIR         = 'G:\Shenmue\~pakf\';
{$ENDIF}{$ENDIF}
  
var
  DatasDirectory: TFileName;

//------------------------------------------------------------------------------

function GetTextCorrectorDatabasesDirectory: TFileName;
begin
  Result := GetDatasDirectory + TEXT_DATABASE_ROOT_DIR + '\';
end;

//------------------------------------------------------------------------------

function GetFacesDirectory(GameVersion: TGameVersion): TFileName;
begin
{$IFDEF DEBUG}{$IFDEF DEBUG_FACES_DIR}
  Result := FACES_DEBUG_DIR + FACES_BASE_DIR + '\';
{$ENDIF}{$ELSE}
  Result := GetDatasDirectory + FACES_BASE_DIR + '\';
{$ENDIF}
  case GameVersion of
    gvWhatsShenmue  : Result := Result + FACES_WHATS_DIR    + '\';
    gvShenmue       : Result := Result + FACES_SHENMUE_DIR  + '\';
    gvShenmue2J     : Result := Result + FACES_SHENMUE2_DIR + '\';
    gvShenmue2      : Result := Result + FACES_SHENMUE2_DIR + '\';
    gvShenmue2X     : Result := Result + FACES_SHENMUE2_DIR + '\';
  end;
end;

//------------------------------------------------------------------------------

function GetNPCInfoFile: TFileName;
begin
  Result := DatasDirectory + NPC_INFO_FILE;
end;

//------------------------------------------------------------------------------

function IsTheSameCharsList(GameVersion1, GameVersion2: TGameVersion): Boolean;
begin
  if (GameVersion1 = gvShenmue2J) or (GameVersion1 = gvShenmue2X) then
    GameVersion1 := gvShenmue2;
  if (GameVersion2 = gvShenmue2J) or (GameVersion2 = gvShenmue2X) then
    GameVersion2 := gvShenmue2;
  Result := GameVersion1 = GameVersion2;
end;

//------------------------------------------------------------------------------

function GetDatasDirectory: TFileName;
begin
  Result := DatasDirectory;
end;

//------------------------------------------------------------------------------

function GetCorrectCharsList(const GameVersion: TGameVersion): TFileName;
begin
  Result := GetDatasDirectory;
  case GameVersion of
    gvUndef:        Result := '';
    gvWhatsShenmue: Result := Result + CHR_LIST_1;
    gvShenmue:      Result := Result + CHR_LIST_1;
    gvShenmue2J:    Result := Result + CHR_LIST_2;
    gvShenmue2:     Result := Result + CHR_LIST_2;
    gvShenmue2X:    Result := Result + CHR_LIST_2;
  end;
end;

//------------------------------------------------------------------------------

function IsCharsModAvailable(GameVersion: TGameVersion): Boolean;
begin
  Result := FileExists(GetCorrectCharsList(GameVersion));
end;

//------------------------------------------------------------------------------

initialization
  DatasDirectory :=
    IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + DATA_BASE_DIR + '\';

//------------------------------------------------------------------------------

end.
