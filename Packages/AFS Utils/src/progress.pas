unit progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmProgress = class(TForm)
    lblCurrentTask: TLabel;
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    btCancel: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

end.
