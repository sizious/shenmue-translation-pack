unit about;

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
    procedure bCloseClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmAbout: TfrmAbout;

procedure InitAboutBox(const AppTitle, AppVersion: string);
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
  sLongAppTitle,
  sShortAppTitle,
  sAppVersion: string;

//------------------------------------------------------------------------------

procedure InitAboutBox(const AppTitle, AppVersion: string);
begin
  sLongAppTitle := AppTitle;
  sShortAppTitle := GetShortApplicationTitle;
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

end.
