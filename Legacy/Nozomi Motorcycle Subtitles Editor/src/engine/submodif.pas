unit SubModif;

interface

uses
  Windows, SysUtils, Classes, NBIKEdit;
  
type
  TSubtitlesTextManagerListItem = class(TObject)
  private
    fInitialText: string;  
    fOriginalText: string;
  public
    // Original AM2 subtitle (Text never modified)
    property InitialText: string read fInitialText;
    // Subtitle before any modification on this NBIKEdit instance
    property OriginalText: string read fOriginalText;
  end;

  TSubtitlesTextManagerList = class(TObject)
  private
    fSubtitlesList: TList;
    procedure Clear;    
    function GetCount: Integer;
    function GetItem(Index: Integer): TSubtitlesTextManagerListItem;
  protected
    procedure Add(const AInitialText, AOriginalText: string);
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSubtitlesTextManagerListItem
      read GetItem; default;
  end;

  TSubtitlesTextManager = class(TObject)
  private
    fSubtitles: TSubtitlesTextManagerList;
    fDefaultTextCorrectorDBFile: TFileName;
  protected
    property DefaultTextCorrectorDBFile: TFileName
      read fDefaultTextCorrectorDBFile;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Initialize(var NBIKEditor: TNozomiMotorcycleSequenceEditor;
      const InitialTextDatabase: TFileName); overload;
    procedure Initialize(var NBIKEditor: TNozomiMotorcycleSequenceEditor); overload;
    property Subtitles: TSubtitlesTextManagerList read fSubtitles;
  end;

implementation

uses
  SysTools;

const
  DEFAULT_TEXTDB = 'nbiktext.db';

{ TSubtitlesModifiedStateItemsList }

procedure TSubtitlesTextManagerList.Add(const AInitialText,
  AOriginalText: string);
var
  NewItem: TSubtitlesTextManagerListItem;

begin
  NewItem := TSubtitlesTextManagerListItem.Create;
  NewItem.fInitialText := AInitialText;
  NewItem.fOriginalText := AOriginalText;
  fSubtitlesList.Add(NewItem);
end;

procedure TSubtitlesTextManagerList.Clear;
var
  i: Integer;

begin
  for i := 0 to Count - 1 do
    TSubtitlesTextManagerListItem(fSubtitlesList[i]).Free;
  fSubtitlesList.Clear;
end;

constructor TSubtitlesTextManagerList.Create;
begin
  fSubtitlesList := TList.Create;
end;

destructor TSubtitlesTextManagerList.Destroy;
begin
  Clear;
  fSubtitlesList.Free;
  inherited;
end;

function TSubtitlesTextManagerList.GetCount: Integer;
begin
  Result:= fSubtitlesList.Count;
end;

function TSubtitlesTextManagerList.GetItem(
  Index: Integer): TSubtitlesTextManagerListItem;
begin
  Result := TSubtitlesTextManagerListItem(fSubtitlesList[Index]);
end;

{ TSubtitlesModifiedStateChecker }

procedure TSubtitlesTextManager.Clear;
begin
  Subtitles.Clear;
end;

constructor TSubtitlesTextManager.Create;
begin
  fSubtitles := TSubtitlesTextManagerList.Create;
  fDefaultTextCorrectorDBFile := GetApplicationDataDirectory + DEFAULT_TEXTDB;
end;

destructor TSubtitlesTextManager.Destroy;
begin
  fSubtitles.Free;
  inherited;
end;

procedure TSubtitlesTextManager.Initialize(
  var NBIKEditor: TNozomiMotorcycleSequenceEditor);
begin
  Initialize(NBIKEditor, DefaultTextCorrectorDBFile);
end;

procedure TSubtitlesTextManager.Initialize(
  var NBIKEditor: TNozomiMotorcycleSequenceEditor;
  const InitialTextDatabase: TFileName);
var
  TextDB: TStringList;
  i: Integer;

begin
  Clear;

  TextDB := TStringList.Create;
  try
    TextDB.LoadFromFile(InitialTextDatabase);

    for i := 0 to NBIKEditor.Subtitles.Count - 1 do
      Subtitles.Add(TextDB[i], NBIKEditor.Subtitles[i].RawText);

  finally
    TextDB.Free;
  end;
end;

end.
