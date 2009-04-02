unit substrad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmMultiTranslate = class(TForm)
    lInfos: TLabel;
    Bevel1: TBevel;
    lProgBar: TLabel;
    pbar: TProgressBar;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    fAborted: Boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Reset;
    procedure MultiTranslatorEndEvent(Sender: TObject);
    property Aborted: Boolean read fAborted write fAborted;
  end;

var
  frmMultiTranslate: TfrmMultiTranslate;

implementation

{$R *.dfm}

uses main;

procedure TfrmMultiTranslate.btnCancelClick(Sender: TObject);
begin
  btnCancel.Enabled := False;
  Aborted := True;
  Close;
end;

procedure TfrmMultiTranslate.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Aborted then begin
    SubsRetriever.Terminate;
    CanClose := False;
    fAborted := False;
  end;
  Reset;
end;

procedure TfrmMultiTranslate.FormCreate(Sender: TObject);
begin
  Reset;
  DoubleBuffered := True;
  Aborted := False;
end;

procedure TfrmMultiTranslate.MultiTranslatorEndEvent(Sender: TObject);
begin
  Close;
  // frmMain.eFilesCount.Text := IntToStr(frmMain.lbFilesList.Count);
  // if frmMain.lbFilesList.CanFocus then frmMain.lbFilesList.SetFocus;
  frmMain.SetStatus('Ready');
  // frmMain.AddDebug('Selected directory: "' + frmMain.TargetDirectory + '"');
end;

procedure TfrmMultiTranslate.Reset;
begin
  Self.lInfos.Caption := '';
  pbar.Position := 0;
  lProgBar.Caption := '0%';
  btnCancel.Enabled := True;
end;

end.
