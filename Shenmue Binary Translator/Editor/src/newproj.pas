unit newproj;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmNewProject = class(TForm)
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    GroupBox3: TGroupBox;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmNewProject: TfrmNewProject;

implementation

{$R *.dfm}

end.
