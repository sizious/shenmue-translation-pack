unit Preview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls; //, GraphicEx;

type
  TfrmPreview = class(TForm)
    imgScreenPreview: TImage;
    imgBkgnd: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fConfigSection: string;
    { Déclarations privées }
  protected
    { Déclarations protégées }
    procedure LoadConfig;
    procedure SaveConfig;
    property ConfigSection: string read fConfigSection;
  public
    { Déclarations publiques }
    procedure AssignBitmap(Source: TBitmap);
  end;

var
  frmPreview: TfrmPreview;

implementation

uses
  Main, Utils;

{$R *.dfm}

{ TfrmPreview }

procedure TfrmPreview.AssignBitmap(Source: TBitmap);
begin
  imgScreenPreview.Picture.Assign(Source);
end;

procedure TfrmPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.ScreenPreview := False;
end;

procedure TfrmPreview.FormCreate(Sender: TObject);
begin
  fConfigSection := LowerCase(StringReplace(Name, 'frm', '', []));
  LoadConfig;
end;

procedure TfrmPreview.FormDestroy(Sender: TObject);
begin
  SaveConfig;
end;

procedure TfrmPreview.LoadConfig;
begin
  Configuration.ReadFormAttributes(Self);
  frmMain.ScreenPreview := Configuration.ReadBool(ConfigSection, 'visible', False);
end;

procedure TfrmPreview.SaveConfig;
begin
  Configuration.WriteFormAttributes(Self);
  Configuration.WriteBool(ConfigSection, 'visible', frmMain.ScreenPreview);
end;

end.
