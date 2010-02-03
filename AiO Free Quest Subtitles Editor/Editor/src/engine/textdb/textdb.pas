(*
  T E X T D B  M O D U L E
  This file is part of the TextDB Module, the Text Correction Database.

  The Text Correction Database is a module made to store EVERY original subtitles
  in order for you to correct the subtitles.

  This file is the main unit using every files in the textdb directory.
*)
unit textdb;

interface

uses
  Windows, SysUtils, Classes, ScnfUtil, DBIndex, DBInlay;

type
  TTextDatabaseCorrector = class
  private
    fDatabaseIndex: TTextDatabaseIndex;
    fGameVersion: TGameVersion;
    fLoaded: Boolean;
    fIndexFileName: TFileName;
    fSubtitles: TSubtitlesContainer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    function LoadDatabase(GameVersion: TGameVersion): Boolean;
    function LoadTableForNPC(const ShortVoiceID, CharID: string): Boolean;
    
    property IndexFileName: TFileName read fIndexFileName;
    property GameVersion: TGameVersion read fGameVersion;
    property Loaded: Boolean read fLoaded;
    property Subtitles: TSubtitlesContainer read fSubtitles;
  end;

implementation

uses
  DBLzma, Common;

{ TTextDatabaseCorrector }

procedure TTextDatabaseCorrector.Clear;
begin
  fLoaded := False;
  fGameVersion := gvUndef;
  fIndexFileName := '';
end;

constructor TTextDatabaseCorrector.Create;
begin
  fSubtitles := TSubtitlesContainer.Create;
  fDatabaseIndex := TTextDatabaseIndex.Create;
end;

destructor TTextDatabaseCorrector.Destroy;
begin
  fDatabaseIndex.Free;
  fSubtitles.Free;
  inherited;
end;


function TTextDatabaseCorrector.LoadDatabase(
  GameVersion: TGameVersion): Boolean;
var
  fnIndexFileName: TFileName;

  
begin
  Result := False;
  Clear;
  
  // Extracting the LZMA archive
  fnIndexFileName := GetTextDatabaseIndexFile(GameVersion);
  if FileExists(fnIndexFileName) then begin
    // archive loaded
    fLoaded := True;
    fGameVersion := GameVersion;
    fIndexFileName := fnIndexFileName;
    fSubtitles.CharsList.Active :=
      fSubtitles.CharsList.LoadFromFile(GetCorrectCharsList(GameVersion));
    Result := fDatabaseIndex.LoadDatabaseIndex(fnIndexFileName);
  end;
end;

function TTextDatabaseCorrector.LoadTableForNPC(const ShortVoiceID,
  CharID: string): Boolean;
var
  NPCIndex: TTextDatabaseIndexItem;
  SubtitlesFile: TFileName;
  
begin
  Result := False;
  NPCIndex := fDatabaseIndex.FindNPC(ShortVoiceID, CharID);
  if Assigned(NPCIndex) then begin
    SubtitlesFile := NPCIndex.TextDatabaseFileName;
    if FileExists(SubtitlesFile) then
      Result := fSubtitles.LoadNPCSubtitlesFile(ShortVoiceID, CharID, SubtitlesFile);
  end;
end;

end.
