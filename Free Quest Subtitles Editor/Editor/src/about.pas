unit about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TfrmAbout = class(TForm)
    lAppVersion: TLabel;
    lEngineVersion: TLabel;
    pImage: TPanel;
    iPicture: TImage;
    Label1: TLabel;
    Bevel1: TBevel;
    bClose: TButton;
    Bevel2: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Bevel3: TBevel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

uses
  Main, ScnfEdit;

procedure TfrmAbout.bCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  Caption := Caption + ' ' + Application.Title + '...';
  lAppVersion.Caption := APP_VERSION + ' (' + COMPIL_DATE_TIME + ')';
  lEngineVersion.Caption := SCNF_EDITOR_ENGINE_VERSION + ' (' + SCNF_EDITOR_ENGINE_COMPIL_DATE_TIME + ')';
end;

end.
