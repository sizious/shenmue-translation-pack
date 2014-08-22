unit Config;

interface

uses
  Windows, SysUtils, Messages, Forms, Variants, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmConfig = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    GroupBox3: TGroupBox;
    Edit2: TEdit;
    Button2: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    GroupBox2: TGroupBox;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Button1: TButton;
    GroupBox4: TGroupBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.dfm}

end.
