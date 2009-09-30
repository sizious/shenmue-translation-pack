unit texview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Img2Png;

type
  TfrmTexPreview = class(TForm)
    iTexture: TImage;
    iBkgnd: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
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
end;

end.
