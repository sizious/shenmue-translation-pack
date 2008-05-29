unit scandir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

type
  TfrmDirScan = class(TForm)
    lInfos: TLabel;
    pbar: TProgressBar;
    Button1: TButton;
    Bevel1: TBevel;
    lProgBar: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Déclarations privées }
    fAborted: Boolean;
  public
    { Déclarations publiques }
    procedure Reset;
    procedure DirectoryScanningEndEvent(Sender: TObject);
  end;

var
  frmDirScan: TfrmDirScan;

implementation

{$R *.dfm}

uses
  Main;
  
procedure TfrmDirScan.Button1Click(Sender: TObject);
begin
  fAborted := True;
  Close;
end;

procedure TfrmDirScan.DirectoryScanningEndEvent(Sender: TObject);
begin
  Close;
  frmMain.eFilesCount.Text := IntToStr(frmMain.lbFilesList.Count);
  if frmMain.lbFilesList.CanFocus then frmMain.lbFilesList.SetFocus;
  frmMain.SetStatus('Ready');
  frmMain.AddDebug('Selected directory: "' + frmMain.TargetDirectory + '"');
  frmMain.ActiveMultifilesOptions;
end;

procedure TfrmDirScan.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if fAborted then begin
    SCNFScanner.Terminate;
    CanClose := False;
    fAborted := False;
  end;
  Reset;
end;

procedure TfrmDirScan.FormCreate(Sender: TObject);
begin
  Reset;
  DoubleBuffered := True;
  fAborted := False;
end;

procedure TfrmDirScan.Reset;
begin
  pbar.Position := 0;
  lProgBar.Caption := '0%';
end;

end.
