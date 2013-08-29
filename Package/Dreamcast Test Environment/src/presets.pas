unit presets;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmPresets = class(TForm)
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    Button5: TButton;
    Button6: TButton;
    Button1: TButton;
    Button4: TButton;
    Button2: TButton;
    Button3: TButton;
    Bevel1: TBevel;
    Button7: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmPresets: TfrmPresets;

implementation

{$R *.dfm}

end.
