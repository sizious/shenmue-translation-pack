unit search;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmSearch = class(TForm)
    lblInfo: TLabel;
    editSearch: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  frmSearch: TfrmSearch;

implementation
uses main;

{$R *.dfm}

procedure TfrmSearch.Button1Click(Sender: TObject);
begin
  frmMain.SelectSearchedFile(editSearch.Text);
  Close;
end;

end.
