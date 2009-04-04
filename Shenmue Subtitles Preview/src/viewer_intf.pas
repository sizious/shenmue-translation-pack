unit viewer_intf;

interface

uses
  Windows, SysUtils, Classes, Forms, Graphics, Viewer;

//------------------------------------------------------------------------------
// SUBTITLES VIEWER API
//------------------------------------------------------------------------------

type
  TSubtitlesPreviewWindow = class(TObject)
  private
    fWindowClosed: TNotifyEvent;
    procedure WindowClosedEvent(Sender: TObject; var Action: TCloseAction);
    procedure SetWindowClosed(const Value: TNotifyEvent);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Hide;
    function IsVisible: Boolean;
    procedure Show(Subtitle: string);
    procedure Update(Subtitle: string);
    property OnWindowClosed: TNotifyEvent read fWindowClosed write SetWindowClosed;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  oldskool_font_vcl;

const
  CHARSMAP_EMPTY_TAG  = '*'; // tag a hole in the charsmap string

  CHARSMAP_LINES = 5;
  CHARSMAP_COLS = 27;

  CHARSMAP_STRING = '*ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
                    '1234567890È,‰¡ÕÎ»ˆ”¸—ﬂø°''.*' +
                    'abcdefghijklmnopqrstuvwxyzÒ' +
                    'ƒ‚¬·¿‡ÔœÓŒÌÀÍ È…Ë÷Ù‘‹˚€˘ŸÁ«' +
                    '´ª?!:@=;()-****************';

{ TSubtitlesPreviewWindow }

procedure TSubtitlesPreviewWindow.Clear;
begin
  frmSubsPreview.iSub1.Picture.Bitmap := nil;
  frmSubsPreview.iSub2.Picture.Bitmap := nil;
end;

constructor TSubtitlesPreviewWindow.Create;
begin
  frmSubsPreview := TfrmSubsPreview.Create(Application);  
  frmSubsPreview.OnClose := WindowClosedEvent;

  // Initialisation
  with frmSubsPreview do begin
    iSub1.Picture.Bitmap := nil;
    iSub2.Picture.Bitmap := nil;
    // Image1.Picture.Bitmap := nil;
    // Image1.Visible := False;
  end;
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
    BitmapFont.Handle := LoadBitmap(hInstance, 'BMPFONT');
    BitmapVcl := TOldskoolFontBitmapVcl.Create(CHARSMAP_STRING, 0,
      CHARSMAP_EMPTY_TAG, BitmapFont, CHARSMAP_LINES, CHARSMAP_COLS, True);
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
