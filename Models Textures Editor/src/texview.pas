unit texview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Img2Png, Menus;

const
  DEFAULT_PREVIEW_HEIGHT = 128;
  DEFAULT_PREVIEW_WIDTH = 128;

type
  TfrmTexPreview = class(TForm)
    iTexture: TImage;
    iBkgnd: TImage;
    sdTexture: TSaveDialog;
    pmTexture: TPopupMenu;
    miSaveTex: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure miSaveTexClick(Sender: TObject);
    procedure iTextureContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    fLoadedFileName: TFileName;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property LoadedFileName: TFileName read fLoadedFileName write fLoadedFileName;
  end;

var
  frmTexPreview: TfrmTexPreview;

implementation

{$R *.dfm}

uses
  Common, Utils;

function InitializeWindow: TFileName;
begin
  Result := GetWorkingDirectory + 'bkgnd.png';
  ExtractFile('BKGND', Result);
end;

procedure TfrmTexPreview.FormCreate(Sender: TObject);
begin
  iBkgnd.Picture.LoadFromFile(InitializeWindow);
  ClientHeight := DEFAULT_PREVIEW_HEIGHT;
  ClientWidth := DEFAULT_PREVIEW_WIDTH;
end;

procedure TfrmTexPreview.iTextureContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  miSaveTex.Enabled := FileExists(LoadedFileName);
end;

procedure TfrmTexPreview.miSaveTexClick(Sender: TObject);
begin
  with sdTexture do begin
    FileName := ExtractFileName(LoadedFileName);
    if Execute then begin
        CopyFile(PChar(LoadedFileName), PChar(FileName), False);
    end;
  end;
end;

end.
