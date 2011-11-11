unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TfrmAbout = class(TForm)
    lAppVersion: TLabel;
    pImage: TPanel;
    iPicture: TImage;
    lProductName: TLabel;
    bvBottom: TBevel;
    bClose: TButton;
    bvMiddle: TBevel;
    lShenTrad: TLabel;
    lProductNameShadow: TLabel;
    lAppVersionTitle: TLabel;
    bvUp: TBevel;
    mCredits: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    procedure bCloseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure JvLinkLabel1LinkClick(Sender: TObject; LinkNumber: Integer;
      LinkText, LinkParam: string);
    procedure JvHTLabel1HyperLinkClick(Sender: TObject; LinkName: string);
    procedure lShenTradMouseEnter(Sender: TObject);
    procedure lShenTradMouseLeave(Sender: TObject);
    procedure lShenTradClick(Sender: TObject);
    procedure Label2DblClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

procedure InitAboutBox(const AppTitle, AppVersion: string; ShortAppTitle: string = '');
procedure RunAboutBox;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

{$R *.dfm}

uses
  UITools;
  
const
  CREDITS_RESOURCE_NAME = 'CREDITS';
                                                      
var
  frmAbout: TfrmAbout;
  sLongAppTitle,
  sShortAppTitle,
  sAppVersion: string;

//------------------------------------------------------------------------------

procedure InitAboutBox(const AppTitle, AppVersion: string; ShortAppTitle: string = '');
begin
  sLongAppTitle := AppTitle;
  if ShortAppTitle = '' then
    sShortAppTitle := GetApplicationShortTitle
  else
    sShortAppTitle := ShortAppTitle;
  sAppVersion := AppVersion;
end;

//------------------------------------------------------------------------------

procedure RunAboutBox;
var
  CreditsRes: TResourceStream;

begin
  frmAbout := TfrmAbout.Create(Application);
  CreditsRes := TResourceStream.Create(hInstance, CREDITS_RESOURCE_NAME, RT_RCDATA);
  try
    with frmAbout do begin
      Caption := 'About ' + sLongAppTitle + '...';
      lAppVersion.Caption := sAppVersion;
      lProductName.Caption := sShortAppTitle;
      lProductNameShadow.Caption := lProductName.Caption;
      mCredits.Lines.LoadFromStream(CreditsRes);
      ShowModal;
    end;
  finally
    frmAbout.Free;
    CreditsRes.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmAbout.bCloseClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmAbout.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

procedure TfrmAbout.JvHTLabel1HyperLinkClick(Sender: TObject; LinkName: string);
begin
  OpenLink('http://shenmuesubs.sourceforge.net/');
end;

procedure TfrmAbout.JvLinkLabel1LinkClick(Sender: TObject; LinkNumber: Integer;
  LinkText, LinkParam: string);
begin
  OpenLink(LinkText);
end;

procedure TfrmAbout.Label2DblClick(Sender: TObject);
begin
  MessageBoxA(Handle, 'TA DA! YOU FIND IT !!!', 'KiKOOLOL! :-D', MB_ICONINFORMATION);
  OpenLink('http://sbibuilder.shorturl.com/');
end;

procedure TfrmAbout.lShenTradClick(Sender: TObject);
begin
  OpenLink('http://shenmuesubs.sourceforge.net/');
end;

procedure TfrmAbout.lShenTradMouseEnter(Sender: TObject);
begin
  with (Sender as TLabel) do
  begin
    Font.Color := clHotLight;
    Font.Style := Font.Style + [fsUnderline];
    Cursor := crHandPoint;
  end;
end;

procedure TfrmAbout.lShenTradMouseLeave(Sender: TObject);
begin
  with (Sender as TLabel) do
  begin
    Font.Color := clWindowText;
    Font.Style := Font.Style - [fsUnderline];
    Cursor := crDefault;
  end;
end;

end.
