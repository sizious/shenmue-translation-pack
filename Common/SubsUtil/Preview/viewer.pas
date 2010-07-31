unit Viewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  ESubtitlesPreviewInterface = class(Exception);
  EInvalidCharsMapFormat = class(ESubtitlesPreviewInterface);

  TfrmSubsPreview = class;

  TSubtitlesPreviewer = class(TObject)
  private
    CharsMapLines, CharsMapCols: Integer;
    CharsMapString: string;
    fWindow: TfrmSubsPreview;
    fSourceDirectory: TFileName;
    fWindowClosed: TNotifyEvent;
    procedure WindowClosedEvent(Sender: TObject; var Action: TCloseAction);
    procedure SetWindowClosed(const Value: TNotifyEvent);
  protected
    procedure LoadDataSource;
    property Window: TfrmSubsPreview read fWindow;
  public
    constructor Create(const SourceDirectory: TFileName);
    destructor Destroy; override;
    procedure Clear;
    procedure Hide;
    function IsVisible: Boolean;
    procedure Show(Subtitle: string);
    procedure Update(Subtitle: string);
    property OnWindowClosed: TNotifyEvent read fWindowClosed write SetWindowClosed;
    property SourceDirectory: TFileName read fSourceDirectory;
  end;

  TfrmSubsPreview = class(TForm)
    iSub1: TImage;
    iSub2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

(*var
  frmSubsPreview: TfrmSubsPreview;*)

implementation

{$R *.dfm}

uses
  oldskool_font_vcl;

const
  CHARSMAP_EMPTY_TAG  = '*'; // tag a hole in the charsmap string

{ TSubtitlesPreviewWindow }

procedure TSubtitlesPreviewer.Clear;
begin
  with fWindow do begin
    iSub1.Picture.Bitmap := nil;
    iSub2.Picture.Bitmap := nil;
  end;
end;

constructor TSubtitlesPreviewer.Create(const SourceDirectory: TFileName);
begin
  fSourceDirectory := IncludeTrailingPathDelimiter(SourceDirectory);
  fWindow := TfrmSubsPreview.Create(nil);
  fWindow.OnClose := WindowClosedEvent;

  // Initialisation
  with fWindow do begin
    iSub1.Picture.Bitmap := nil;
    iSub2.Picture.Bitmap := nil;
    // Image1.Picture.Bitmap := nil;
    // Image1.Visible := False;
  end;

  // Load the charsmap
  LoadDataSource;
end;

destructor TSubtitlesPreviewer.Destroy;
begin
  fWindow.Free;
  inherited Destroy;
end;

procedure TSubtitlesPreviewer.Hide;
begin
  fWindow.OnClose := nil; // stack overflow bug resolved
  if IsVisible then
    fWindow.Close;
  fWindow.OnClose := WindowClosedEvent;    
end;

function TSubtitlesPreviewer.IsVisible: Boolean;
begin
  try
    Result := fWindow.Visible;
  except
    Result := False;
  end;
end;

procedure TSubtitlesPreviewer.LoadDataSource;
var
  SL: TStringList;
  CharsMapFile: TFileName;
  i: Integer;

begin
  CharsMapFile := SourceDirectory + 'charsmap.txt';
  SL := TStringList.Create;
  try
    SL.LoadFromFile(CharsMapFile);
    CharsMapCols := 0;
    CharsMapLines := 0;
    CharsMapString := '';    
    i := 0;
    
    while i < SL.Count do begin
      if (SL[i] <> '') and (Copy(SL[i], 1, 1) <> '#') then begin
        Inc(CharsMapLines);
        CharsMapString := CharsMapString + SL[i];

        // Setting CharsMapLines
        if CharsMapCols = 0 then
          CharsMapCols := Length(SL[i])
        else
          // Check if the length of each line is equal
          if CharsMapCols <> Length(SL[i]) then
            raise EInvalidCharsMapFormat.Create('Invalid CharsMap file format. '
              + 'Each line MUST be the same length!' + sLineBreak
              + 'You should correct this immediatly. '
              + 'Please exit the application now.' + sLineBreak
              + 'Target file: "' + CharsMapFile + '".' + sLineBreak + sLineBreak
              + 'Tips:' + sLineBreak
              + 'Please use the "*" tag to fill each hole.' + sLineBreak
              + 'If you want to add a comment, please use the "#" wildcard. '
              + 'Blank lines are allowed.'
            );
      end; // SL[i]
      Inc(i);
    end;
  finally
    SL.Free;
  end;
end;

procedure TSubtitlesPreviewer.SetWindowClosed(const Value: TNotifyEvent);
begin
  fWindowClosed := Value;
end;

procedure TSubtitlesPreviewer.Show(Subtitle: string);
begin
  fWindow.FormStyle := fsStayOnTop;
  if not IsVisible then
    fWindow.Show;
  Update(Subtitle);
end;

procedure TSubtitlesPreviewer.Update(Subtitle: string);
const
  CR = '¡õ';
  
var
  BitmapVcl: TOldskoolFontBitmapVcl;
  BmpBuf, BitmapFont: TBitmap;
  Sub1, Sub2: string;
  i: Integer;

begin
  if not IsVisible then Exit;
  
  if SubTitle = '' then begin
    Clear;
    Exit;
  end;
  
  SubTitle := StringReplace(SubTitle, #$0D#$0A, CR, [rfReplaceAll]);

  // if CR...
  i := Pos(CR, SubTitle);
  if i <> 0 then begin
    Sub1 := Copy(SubTitle, i+2, Length(SubTitle));
    Sub2 := Copy(SubTitle, 0, i-1);
  end else begin
    Sub1 := SubTitle;
    Sub2 := '';
  end;

  with fWindow do begin
    iSub1.Picture.Bitmap := nil;
    iSub2.Picture.Bitmap := nil;
  end;

  // draw bitmap font
  BitmapFont := TBitmap.Create;
  try
//    BitmapFont.Handle := LoadBitmap(hInstance, 'BMPFONT');
    BitmapFont.LoadFromFile(SourceDirectory + 'font.bmp');
    BitmapVcl := TOldskoolFontBitmapVcl.Create(CharsMapString, 0,
      CHARSMAP_EMPTY_TAG, BitmapFont, CharsMapLines, CharsMapCols, True);
    BmpBuf := TBitmap.Create;
    try
      BitmapVcl.DrawString(Sub1, BmpBuf);
      fWindow.iSub1.Picture.Assign(BmpBuf);
      if Sub2 <> '' then
      begin
        BitmapVcl.DrawString(Sub2, BmpBuf);
        fWindow.iSub2.Picture.Assign(BmpBuf);
      end;

    finally
      BitmapVcl.Free;
      BmpBuf.Free;
    end;
  finally
    BitmapFont.Free;
  end;
end;

procedure TSubtitlesPreviewer.WindowClosedEvent(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(fWindowClosed) then
    fWindowClosed(Sender);
end;

procedure TfrmSubsPreview.FormCreate(Sender: TObject);
begin
  with iSub1 do begin
    Left := 2;
    Top := 418;
    Width := 640;
    Height := 30;
  end;
  with iSub2 do begin
    Left := 2;
    Top := 385;
    Width := 640;
    Height := 30;
  end;
  
end;

procedure TfrmSubsPreview.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

end.
