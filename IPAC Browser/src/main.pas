unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IpacMgr, Menus;

type
  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miOpen: TMenuItem;
    N1: TMenuItem;
    miQuit: TMenuItem;
    miDebugMenu: TMenuItem;
    estIPACEditor1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure estIPACEditor1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;
  IPACEditor: TIPACEditor;

implementation

{$R *.dfm}

procedure TfrmMain.estIPACEditor1Click(Sender: TObject);
begin
  IPACEditor.LoadFromFile('afs00001.PKS');
  IPACEditor.Content[0].ImportFromFile('TEST.BIN');
  IPACEditor.SaveToFile('OUT.BIN');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Creating the main IPAC Editor object
  IPACEditor := TIPACEditor.Create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Destroying the IPAC Object
  IPACEditor.Free;
end;

end.
