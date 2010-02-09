unit viewer_intf;

interface

uses
  Windows, SysUtils, Classes, Forms, Graphics, Viewer;

// Thanks to IlDucci for the patch
  
//------------------------------------------------------------------------------
// SUBTITLES VIEWER API
//------------------------------------------------------------------------------

type
  ESubtitlesPreviewInterface = class(Exception);
  EInvalidCharsMapFormat = class(ESubtitlesPreviewInterface);
  
  TSubtitlesPreviewWindow = class(TObject)
  private
    fSourceDirectory: TFileName;
    fWindowClosed: TNotifyEvent;
    procedure WindowClosedEvent(Sender: TObject; var Action: TCloseAction);
    procedure SetWindowClosed(const Value: TNotifyEvent);
  protected
    procedure LoadDataSource;
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

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  oldskool_font_vcl;

const
  CHARSMAP_EMPTY_TAG  = '*'; // tag a hole in the charsmap string
(*
  CHARSMAP_LINES = 5;
  CHARSMAP_COLS = 27;

  CHARSMAP_STRING = '*ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
                    '1234567890È,‰¡ÕÎ»ˆ”¸—ﬂø°''.*' +
                    'abcdefghijklmnopqrstuvwxyzÒ' +
                    'ƒ‚¬·¿‡ÔœÓŒÌÀÍ È…Ë÷Ù‘‹˚€˘ŸÁ«' +
                    '´ª?!:@=;()-*”Û˙⁄***********';
*)

var
  CharsMapLines, CharsMapCols: Integer;
  CharsMapString: string;
  
{ TSubtitlesPreviewWindow }

procedure TSubtitlesPreviewWindow.Clear;
begin
  frmSubsPreview.iSub1.Picture.Bitmap := nil;
  frmSubsPreview.iSub2.Picture.Bitmap := nil;
end;

constructor TSubtitlesPreviewWindow.Create(const SourceDirectory: TFileName);
begin
  fSourceDirectory := IncludeTrailingPathDelimiter(SourceDirectory);
  frmSubsPreview := TfrmSubsPreview.Create(Application);
  frmSubsPreview.OnClose := WindowClosedEvent;

  // Initialisation
  with frmSubsPreview do begin
    iSub1.Picture.Bitmap := nil;
    iSub2.Picture.Bitmap := nil;
    // Image1.Picture.Bitmap := nil;
    // Image1.Visible := False;
  end;

  // Load the charsmap
  LoadDataSource;
end;

destructor TSubtitlesPreviewWindow.Destroy;
begin
  frmSubsPreview.Free;
  inherited Destroy;
end;

procedure TSubtitlesPreviewWindow.Hide;
begin
  if IsVisible then frmSubsPreview.Close;
end;

function TSubtitlesPreviewWindow.IsVisible: Boolean;
begin
  try
    Result := frmSubsPreview.Visible;
  except
    Result := False;
  end;
end;

procedure TSubtitlesPreviewWindow.LoadDataSource;
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

procedure TSubtitlesPreviewWindow.SetWindowClosed(const Value: TNotifyEvent);
begin
  fWindowClosed := Value;
end;

procedure TSubtitlesPreviewWindow.Show(Subtitle: string);
begin
  frmSubsPreview.FormStyle := fsStayOnTop;
  frmSubsPreview.Show;
  Update(Subtitle);
end;

procedure TSubtitlesPreviewWindow.Update(Subtitle: string);
const
  CR = '°ı';
  
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

  with frmSubsPreview do begin
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
      frmSubsPreview.iSub1.Picture.Assign(BmpBuf);
      if Sub2 <> '' then
      begin
        BitmapVcl.DrawString(Sub2, BmpBuf);
        frmSubsPreview.iSub2.Picture.Assign(BmpBuf);
      end;

    finally
      BitmapVcl.Free;
      BmpBuf.Free;
    end;
  finally
    BitmapFont.Free;
  end;
end;

procedure TSubtitlesPreviewWindow.WindowClosedEvent(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(fWindowClosed) then fWindowClosed(Sender);
end;

end.
