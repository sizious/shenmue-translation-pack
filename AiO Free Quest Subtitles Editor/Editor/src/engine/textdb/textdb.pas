unit textdb;

interface

uses
  Windows, SysUtils, Classes, ScnfEdit, ScnfUtil, CharsLst;

type
  TSubtitlesContainer = class(TSubList)
  public
    constructor Create; overload;
  end;

  TTextDatabaseIndex = class
  public

  end;

  TTextDatabaseCorrector = class
  private
    fGameVersion: TGameVersion;
    fLoaded: Boolean;
    fIndexFileName: TFileName;
    fCharsList: TSubsCharsList;
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
    property CharsList: TSubsCharsList read fCharsList;
    property Subtitles: TSubtitlesContainer read fSubtitles;
  end;

implementation

uses
  LzmaDec, XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX;

{ TTextDatabaseCorrector }

procedure TTextDatabaseCorrector.Clear;
begin

end;

constructor TTextDatabaseCorrector.Create;
begin
  fSubtitles := TSubtitlesContainer.Create;
  fCharsList := TSubsCharsList.Create;
end;

destructor TTextDatabaseCorrector.Destroy;
begin
  fSubtitles.Free;
  fCharsList.Free;
  inherited;
end;


function TTextDatabaseCorrector.LoadDatabase(
  GameVersion: TGameVersion): Boolean;
var
  fnIndexFileName: TFileName;

begin
  // Extracting the LZMA archive
  fnIndexFileName := GetTextDatabaseIndexFile(GameVersion);
  if FileExists(fnIndexFileName) then begin
    // archive loaded
    fLoaded := True;
    fGameVersion := GameVersion;
    fIndexFileName := fnIndexFileName;

    // parsing the XML index file
    
  end;
end;

function TTextDatabaseCorrector.LoadTableForNPC(const ShortVoiceID,
  CharID: string): Boolean;
begin

end;

{ TSubsListX }

constructor TSubtitlesContainer.Create;
begin
  inherited Create(nil);
end;

end.
