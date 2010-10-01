unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, JvExComCtrls, JvToolBar, Menus;

type
  TfrmMain = class(TForm)
    tbMain: TJvToolBar;
    ToolButton1: TToolButton;
    tbOpen: TToolButton;
    tbReload: TToolButton;
    tbSave: TToolButton;
    ToolButton4: TToolButton;
    tbImportSubtitles: TToolButton;
    tbExportSubtitles: TToolButton;
    ToolButton9: TToolButton;
    tbDebugLog: TToolButton;
    tbPreview: TToolButton;
    tbOriginalTextField: TToolButton;
    tbCharset: TToolButton;
    ToolButton5: TToolButton;
    tbBatchImportSubtitles: TToolButton;
    tbBatchExportSubtitles: TToolButton;
    ToolButton6: TToolButton;
    tbAutoSave: TToolButton;
    tbMakeBackup: TToolButton;
    ToolButton2: TToolButton;
    tbAbout: TToolButton;
    ilToolBar: TImageList;
    ilToolBarDisabled: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    View1: TMenuItem;
    Help1: TMenuItem;
    DEBUG1: TMenuItem;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

end.
