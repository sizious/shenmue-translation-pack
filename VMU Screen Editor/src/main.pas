unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, LCDEdit, ImgList, ComCtrls, ToolWin, JvExComCtrls, JvToolBar,
  JvListView, ExtCtrls, StdCtrls;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    miQuit: TMenuItem;
    lvIpacContent: TJvListView;
    miOpen: TMenuItem;
    odOpen: TOpenDialog;
    Panel1: TPanel;
    sbMain: TStatusBar;
    pnlScreenPreview: TPanel;
    imgScreenPreview: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;
  VmuLcdEditor: TVmuLcdEditor;

implementation

{$R *.dfm}

uses
  Themes;
  
procedure TfrmMain.Button1Click(Sender: TObject);
begin
  VmuLcdEditor.LoadFromFile('LCD.IWD');
  vmulcdeditor.Items[2].ExportToFile('test.bmp');
  imgScreenPreview.Picture.LoadFromFile('test.bmp');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  pnlScreenPreview.DoubleBuffered := True;
  VmuLcdEditor := TVmuLcdEditor.Create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  VmuLcdEditor.Free;
end;

end.
