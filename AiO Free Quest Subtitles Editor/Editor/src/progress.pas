//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

type
  TProgressMode = (pmSCNFScanner, pmMultiScan, pmBatchSubsExport);

  TfrmProgress = class(TForm)
    lInfos: TLabel;
    pbar: TProgressBar;
    btnCancel: TButton;
    Bevel1: TBevel;
    lProgBar: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    fCurrentThread: TThread;
    fAborted: Boolean;
    fTerminated: Boolean;
    fProgressMode: TProgressMode;
    procedure MultiTranslatorEndEvent(Sender: TObject);
    procedure SetProgressMode(const Value: TProgressMode);
    procedure SubsRetrieverEndEvent(Sender: TObject);
    procedure BatchSubsExporterEndEvent(Sender: TObject);
    procedure SubsMassExporterErrornousFileEvent(Sender: TObject;
      ErrornousFileName: TFileName; ReasonMessage: string);
    procedure SubsMassExporterCompletedEvent(Sender: TObject; FileExportedCount,
      FileErrornousCount: Integer);
  public
    { Déclarations publiques }
    procedure Reset;
    procedure UpdateProgressBar;
    procedure DirectoryScanningEndEvent(Sender: TObject);
    property Aborted: Boolean read fAborted write fAborted;
    property Terminated: Boolean read fTerminated write fTerminated;
    property Mode: TProgressMode read fProgressMode write SetProgressMode;
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

uses
  Main, Math, SubsExp;
  
procedure TfrmProgress.btnCancelClick(Sender: TObject);
begin
  btnCancel.Enabled := False;
  Aborted := True;
  Close;
end;

procedure TfrmProgress.DirectoryScanningEndEvent(Sender: TObject);
begin
  Terminated := True;
  Close;
  frmMain.eFilesCount.Text := IntToStr(frmMain.lbFilesList.Count);
  if frmMain.lbFilesList.CanFocus then frmMain.lbFilesList.SetFocus;
  frmMain.SetStatus('Ready');
  frmMain.AddDebug('Selected directory: "' + frmMain.SelectedDirectory + '"');
  frmMain.ActiveMultifilesOptions;
end;

procedure TfrmProgress.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (Aborted) or (not Terminated) then begin
    // SCNFScanner.Terminate;  //SubsRetriever.Terminate; fCurrentThread
    if Assigned(fCurrentThread) then fCurrentThread.Terminate;
    CanClose := False;
    Aborted := False;
  end;
  Reset;
end;

procedure TfrmProgress.FormCreate(Sender: TObject);
begin
  Reset;
  DoubleBuffered := True;
end;

procedure TfrmProgress.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then Close;
end;

procedure TfrmProgress.Reset;
begin
  Terminated := False;
  Aborted := False;
  pbar.Position := 0;
  lProgBar.Caption := '0%';
  Self.lInfos.Caption := '';
  btnCancel.Enabled := True;
end;

procedure TfrmProgress.SetProgressMode(const Value: TProgressMode);
begin
  fProgressMode := Value;

  case fProgressMode of
    pmSCNFScanner:
                    begin
                      frmMain.SetStatus('Scanning directory ... Please wait.');
                      Self.Caption := 'Scanning directory...';
                      fCurrentThread := SCNFScanner;
                      fCurrentThread.OnTerminate := DirectoryScanningEndEvent;
                    end;
    pmMultiScan:
                    begin
                      frmMain.SetStatus('Retrieving subtitles from files list... Please wait.');
                      Self.Caption := 'Retrieving subtitles...';
                      fCurrentThread := SubsRetriever;
                      fCurrentThread.OnTerminate := SubsRetrieverEndEvent;
                    end;
    pmBatchSubsExport:
                      begin
                        frmMain.SetStatus('Batch exporting... Please wait.');
                        Self.Caption := 'Batch exporting...';
                        fCurrentThread := BatchSubsExporter;
                        fCurrentThread.OnTerminate := BatchSubsExporterEndEvent;
                        (fCurrentThread as TSubsMassExporterThread).OnErrornousFile := SubsMassExporterErrornousFileEvent;
                        (fCurrentThread as TSubsMassExporterThread).OnCompleted := SubsMassExporterCompletedEvent;
                      end;
  end;

  if not Assigned(fCurrentThread) then
    raise Exception.Create('SetProgressMode: CurrentThread is nil...');
end;

procedure TfrmProgress.UpdateProgressBar;
begin
  pbar.Position := frmProgress.pbar.Position + 1;
  lProgBar.Caption := FormatFloat('0.00', SimpleRoundTo((100 * pbar.Position) / pbar.Max, -2)) + '%';
  Application.ProcessMessages;
end;

procedure TfrmProgress.MultiTranslatorEndEvent(Sender: TObject);
begin
  Terminated := True;
  Close;
  frmMain.SetStatus('Ready');
end;

procedure TfrmProgress.SubsMassExporterCompletedEvent(Sender: TObject;
  FileExportedCount, FileErrornousCount: Integer);
begin
  frmMain.AddDebug(IntToStr(FileExportedCount) + ' file(s) exported successfully with '
    + IntToStr(FileErrornousCount) + ' error(s).');
end;

procedure TfrmProgress.SubsMassExporterErrornousFileEvent(Sender: TObject;
  ErrornousFileName: TFileName; ReasonMessage: string);
begin
  frmMain.AddDebug('Error when exporting subs from the file "'
    + ErrornousFileName + '". Reason: ' + ReasonMessage + '.');
end;

procedure TfrmProgress.SubsRetrieverEndEvent(Sender: TObject);
begin
  Terminated := True;
  Close;
  frmMain.SetStatus('Ready');
  frmMain.MultiTranslationFillControls;
end;

procedure TfrmProgress.BatchSubsExporterEndEvent(Sender: TObject);
begin
  Terminated := True;
  Close;
  frmMain.SetStatus('Ready');
end;

end.
