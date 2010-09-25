(*
  T E X T D B  M O D U L E
  This file is part of the TextDB Module, the Text Correction Database.

  The Text Correction Database is a module made to store EVERY original subtitles
  in order for you to correct the subtitles.

  This file is the main unit using every files in the textdb directory.

  - DBInlay: TCD files parser
  - DBIndex: DBI file parser
*)
unit TextDB;

interface

uses
  Windows, SysUtils, Classes, DBInlay, DBIndex;

type
  TTextCorrectorDatabase = class(TObject)
  private
    fDatabaseIndex: TTextDatabaseIndex;
    fLoaded: Boolean;
    fIndexFileName: TFileName;
    fSubtitles: TTextDatabaseSubtitlesContainer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function OpenDatabase(FileName: TFileName): Boolean;
    procedure CloseDatabase;
    function LoadTable(const HashKey: string): Boolean;
    property IndexFileName: TFileName read fIndexFileName;
    property Loaded: Boolean read fLoaded;
    property Subtitles: TTextDatabaseSubtitlesContainer read fSubtitles;
  end;

implementation

uses
  ActiveX;

{ TTextCorrectorDatabase }

procedure TTextCorrectorDatabase.Clear;
begin
  fLoaded := False;
  fIndexFileName := '';
end;

procedure TTextCorrectorDatabase.CloseDatabase;
begin
  Clear;
end;

constructor TTextCorrectorDatabase.Create;
begin
  fSubtitles := TTextDatabaseSubtitlesContainer.Create;
  fDatabaseIndex := TTextDatabaseIndex.Create;
end;

destructor TTextCorrectorDatabase.Destroy;
begin
  fDatabaseIndex.Free;
  fSubtitles.Free;
  inherited;
end;

function TTextCorrectorDatabase.OpenDatabase(FileName: TFileName): Boolean;
begin
  Clear;

  FileName := ExpandFileName(FileName);
  if FileExists(FileName) then begin
    fIndexFileName := FileName;
    fLoaded := fDatabaseIndex.LoadDatabaseIndex(IndexFileName);
  end;
  
  Result := Loaded;
end;

function TTextCorrectorDatabase.LoadTable(
  const HashKey: string): Boolean;
var
  IndexItem: TTextDatabaseIndexItem;
  SubtitlesFile: TFileName;

begin
  Result := False;
  IndexItem := fDatabaseIndex.FindByHashKey(HashKey);
  if Assigned(IndexItem) then begin
    SubtitlesFile := IndexItem.TextDatabaseFileName;
    if FileExists(SubtitlesFile) then
      Result := Subtitles.LoadSubtitlesFile(HashKey, SubtitlesFile);
  end;
end;

initialization
  CoInitialize(nil);

end.
