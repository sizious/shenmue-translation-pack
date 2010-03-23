unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NbikEdit;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;
  SequenceEditor: TNozomiMotorcycleSequenceEditor;

implementation

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  SequenceEditor.LoadFromFile('PAL_DISC3.SCN');
  SequenceEditor.Items[1].Text := 'BLOH!';
  SequenceEditor.SaveToFile('PAL_DISC3.HAK');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  SequenceEditor := TNozomiMotorcycleSequenceEditor.Create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  SequenceEditor.Free;
end;

end.
