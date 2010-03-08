unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, LCDEdit, ImgList, ComCtrls, ToolWin, JvExComCtrls, JvToolBar,
  JvListView, ExtCtrls, StdCtrls;

type
  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miQuit: TMenuItem;
    lvIwadContent: TJvListView;
    miOpen: TMenuItem;
    odOpen: TOpenDialog;
    pnlRightCommands: TPanel;
    sbMain: TStatusBar;
    pnlScreenPreview: TPanel;
    imgScreenPreview: TImage;
    btnImport: TButton;
    btnExport: TButton;
    btnExportAll: TButton;
    btnUndo: TButton;
    N1: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    N2: TMenuItem;
    miClose: TMenuItem;
    N3: TMenuItem;
    miEdit: TMenuItem;
    miUndo: TMenuItem;
    N4: TMenuItem;
    miImport: TMenuItem;
    miExport: TMenuItem;
    N5: TMenuItem;
    miExportAll: TMenuItem;
    miHelp: TMenuItem;
    miProjectHome: TMenuItem;
    miCheckForUpdate: TMenuItem;
    N6: TMenuItem;
    miAbout: TMenuItem;
    pmIwadContent: TPopupMenu;
    miUndo2: TMenuItem;
    N7: TMenuItem;
    miImport2: TMenuItem;
    miExport2: TMenuItem;
    N8: TMenuItem;
    miExportAll2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure miQuitClick(Sender: TObject);
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
  
procedure TfrmMain.btnImportClick(Sender: TObject);
begin
  VmuLcdEditor.LoadFromFile('LCD.IWD');
  vmulcdeditor.Items[2].ExportToFile('test.bmp');
  imgScreenPreview.Picture.LoadFromFile('test.bmp');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  pnlScreenPreview.DoubleBuffered := True;
  VmuLcdEditor := TVmuLcdEditor.Create;

  // Setting the Form
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  VmuLcdEditor.Free;
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

end.
