(*
  This file is part of Shenmue Free Quest Subtitles Editor.

  Shenmue Free Quest Subtitles Editor is free software: you can redistribute it
  and/or modify it under the terms of the GNU General Public License as
  published by the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Shenmue AiO Free Quest Subtitles Editor is distributed in the hope that it
  will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Shenmue AiO Free Quest Subtitles Editor.  If not, see
  <http://www.gnu.org/licenses/>.
*)

unit Progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

type
  TProgressMode = (
    pmSCNFScanner,        // SCNF directory scanner
    pmGlobalScan,         // Global-Translation subtitles list builder
//    pmMultiScan,          // Multi-Translation subtitles list builder
    pmBatchSubsExport,    // Batch exporter
    pmGlobalViewUpdater  // Global-Translation View Updater
//    pmMultiExec           // Multi-Translation execution
  );

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
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
    fCurrentThread: TThread;
    fAbortQuery: Boolean;
    fTerminated: Boolean;
    fProgressMode: TProgressMode;
    fAborted: Boolean;
    procedure SetProgressMode(const Value: TProgressMode);
  protected
    procedure EventEndCommon;
    
    procedure EventEndBatchSubsExporter(Sender: TObject);
    procedure EventEndDirectoryScanning(Sender: TObject);
    procedure EventEndGlobalTranslationViewUpdater(Sender: TObject);
    procedure EventEndMultiTranslationExecution(Sender: TObject);
    procedure EventEndSubsRetrieverGlobalTranslation(Sender: TObject);
(*    procedure EventEndSubsRetrieverMultiTranslation(Sender: TObject);
    procedure EventMultiTranslationCompleted(Sender: TObject;
      SubsUpdatedCount, SubsUpdatedOccurencesCount: Integer);*)

    procedure EventSubsMassExporterErrornousFile(Sender: TObject;
      ErrornousFileName: TFileName; ReasonMessage: string);
    procedure EventSubsMassExporterCompleted(Sender: TObject; FileExportedCount,
      FileErrornousCount: Integer);
  public
    { Déclarations publiques }
    procedure Reset;
    procedure UpdateProgressBar;
    function MsgBox(const Text, Title: string; Flags: Integer): Integer;
    property Aborted: Boolean read fAborted write fAborted;
    property AbortQueryByCancelButton: Boolean read fAbortQuery write fAbortQuery;
    property Terminated: Boolean read fTerminated write fTerminated;
    property Mode: TProgressMode read fProgressMode write SetProgressMode;
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

uses
  Main, Math, SubsExp, MultiScan;
  
procedure TfrmProgress.btnCancelClick(Sender: TObject);
begin
  btnCancel.Enabled := False;
  AbortQueryByCancelButton := True;
  Close;
end;

procedure TfrmProgress.EventEndDirectoryScanning(Sender: TObject);
begin
  Terminated := True;
  
  frmMain.eFilesCount.Text := IntToStr(frmMain.lbFilesList.Count);
  if frmMain.lbFilesList.CanFocus then frmMain.lbFilesList.SetFocus;

  frmMain.SetStatusReady;
  frmMain.AddDebug('Selected directory: "' + frmMain.SelectedDirectory + '"');
  frmMain.UpdateDirectoryControlsState;
  
  // Multi-Translate if needed
  (*if frmMain.MultiTranslation.Active then begin

    if not Aborted then // if aborted when scanning files
      frmMain.MultiTranslation.Prepare(False)
    else begin
      // We don't have the time to update the Multi-Translation list, so we must clear it
      frmMain.MultiTranslation.Active := False;
      frmMain.AddDebug('You have cancelled the file scan process. '
        + 'The Multi-Translation retriever has been cancelled too.');
      Close;      
    end;
          
  end else*)
    Close; // the job is finished
end;

procedure TfrmProgress.EventEndMultiTranslationExecution(Sender: TObject);
begin
  EventEndCommon;
end;

procedure TfrmProgress.EventEndGlobalTranslationViewUpdater(Sender: TObject);
begin
  EventEndCommon;
end;

procedure TfrmProgress.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Screen.Cursor := crDefault;
end;

procedure TfrmProgress.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  CanDo: Integer;

begin
  // if canceled by button or window closed when the processus isn't terminated
  if (AbortQueryByCancelButton) or (not Terminated) then begin
  
    AbortQueryByCancelButton := False;
    CanClose := False; // don't close window now, only when the thread is finished
    
    if Assigned(fCurrentThread) then begin
      fCurrentThread.Suspend;
      CanDo := MsgBox('Are you sure to cancel the current operation ?', 'Aborting heavy process', MB_ICONWARNING + MB_OKCANCEL + MB_DEFBUTTON2);
      fCurrentThread.Resume; // resume the thread to continue or to stop the thread
      btnCancel.Enabled := True;
      if CanDo = IDCANCEL then Exit;
      fCurrentThread.Terminate; // the thread must be running to get terminate working properly
    end;

    Aborted := True;
  end;
//  Reset;
end;

procedure TfrmProgress.FormCreate(Sender: TObject);
begin
  Reset;
  DoubleBuffered := True;
  lProgBar.DoubleBuffered := True;
end;

procedure TfrmProgress.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then Close;
end;

procedure TfrmProgress.FormShow(Sender: TObject);
begin
  Screen.Cursor := crAppStart;
//  Reset;
end;

procedure TfrmProgress.Reset;
begin
  Terminated := False;
  AbortQueryByCancelButton := False;
  pbar.Position := 0;
  lProgBar.Caption := '0%';
  Self.lInfos.Caption := '';
  btnCancel.Enabled := True;
  Aborted := False;
end;

procedure TfrmProgress.SetProgressMode(const Value: TProgressMode);
begin
  Reset;
  fProgressMode := Value;

  case fProgressMode of
    pmSCNFScanner:
                    begin
                      frmMain.SetStatus('Scanning directory... Please wait.');
                      Self.Caption := 'Scanning directory...';
                      fCurrentThread := SCNFScanner;
                      fCurrentThread.OnTerminate := EventEndDirectoryScanning;
                    end;

    pmGlobalScan:
                    begin
                      frmMain.SetStatus('Retrieving subtitles from files list... Please wait.');
                      Self.Caption := 'Retrieving subtitles...';
                      fCurrentThread := MultiTranslationSubsRetriever;
                      fCurrentThread.OnTerminate := EventEndSubsRetrieverGlobalTranslation;
                    end;

    (*pmMultiScan:
                    begin
                      frmMain.SetStatus('Preparing Multi-Translation... Please wait.');
                      Self.Caption := 'Preparing Multi-Translation...';
                      fCurrentThread := MultiTranslationSubsRetriever;
                      fCurrentThread.OnTerminate := EventEndSubsRetrieverMultiTranslation;
                    end;*)

    pmBatchSubsExport:
                      begin
                        frmMain.SetStatus('Batch exporting... Please wait.');
                        Self.Caption := 'Batch exporting...';
                        fCurrentThread := BatchSubsExporter;
                        fCurrentThread.OnTerminate := EventEndBatchSubsExporter;
                        (fCurrentThread as TSubsMassExporterThread).OnErrornousFile := EventSubsMassExporterErrornousFile;
                        (fCurrentThread as TSubsMassExporterThread).OnCompleted := EventSubsMassExporterCompleted;
                      end;

    pmGlobalViewUpdater:
                      begin
                        frmMain.SetStatus('Updating Global-translation view...');
                        Caption := 'Updating Global-translation view...';
                        fCurrentThread := MultiTranslationViewUpdater;
                        fCurrentThread.OnTerminate := EventEndGlobalTranslationViewUpdater;
                      end;

    (*pmMultiExec:
                      begin
                        Caption := 'Multi-Translating...';
                        frmMain.SetStatus(Caption + ' Please wait.');
                        fCurrentThread := MultiTranslationUpdater;
                        fCurrentThread.OnTerminate := EventEndMultiTranslationExecution;
                        (fCurrentThread as TMultiTranslationExecThread).OnCompleted :=
                          EventMultiTranslationCompleted;
                      end;*)
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

function TfrmProgress.MsgBox(const Text, Title: string;
  Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Title), Flags);
end;

(*procedure TfrmProgress.MultiTranslatorEndEvent(Sender: TObject);
begin
  Terminated := True;
  Close;
  frmMain.SetStatus('Ready');
end;*)

procedure TfrmProgress.EventSubsMassExporterCompleted(Sender: TObject;
  FileExportedCount, FileErrornousCount: Integer);
begin
  frmMain.AddDebug(IntToStr(FileExportedCount) + ' file(s) exported successfully with '
    + IntToStr(FileErrornousCount) + ' error(s).');
end;

procedure TfrmProgress.EventSubsMassExporterErrornousFile(Sender: TObject;
  ErrornousFileName: TFileName; ReasonMessage: string);
begin
  frmMain.AddDebug('Error when exporting subs from the file "'
    + ErrornousFileName + '". Reason: ' + ReasonMessage + '.');
end;

procedure TfrmProgress.EventEndSubsRetrieverGlobalTranslation(Sender: TObject);
begin
  EventEndCommon;

  if not Aborted then
    frmMain.AddDebug('Files list scanned successfully. '
      + IntToStr(frmMain.GlobalTranslation.TextDataList.Count)
      + ' subtitle(s) retrieved.')
  else
    frmMain.AddDebug('Files list scanning aborted.'
    + ' If some datas are in the window you can work on it anyway...');

  try
    if frmMain.tvMultiSubs.Items.Count > 0 then begin
      frmMain.GlobalTranslation.InUse := True;
      frmMain.tvMultiSubs.Items[0].Selected := True;
      frmMain.tvMultiSubsClick(Self);
    end;
  except
  end;
end;

(*procedure TfrmProgress.EventEndSubsRetrieverMultiTranslation(Sender: TObject);
var
  RefreshRequested: Boolean;

begin
  EventEndCommon;

  RefreshRequested :=
    (fCurrentThread as TMultiTranslationSubtitlesRetriever).RefreshRequested;

  if not Aborted then begin

    if RefreshRequested then
      frmMain.AddDebug('Since you are using Multi-Translation, datas has been '
        + 'updated. '
        + IntToStr(frmMain.MultiTranslation.TextDataList.Count)
        + ' subtitle(s) retrieved.')
    else
      frmMain.AddDebug('The Multi-Translation function is now ready. '
        + IntToStr(frmMain.MultiTranslation.TextDataList.Count)
        + ' subtitle(s) retrieved.');
        
  end else begin
    frmMain.AddDebug('The Multi-Translation function will not be available if you abort the process. It has been disabled.');
    frmMain.MultiTranslation.Active := False;
  end;
end;

procedure TfrmProgress.EventMultiTranslationCompleted(Sender: TObject;
  SubsUpdatedCount, SubsUpdatedOccurencesCount: Integer);
var
  S: string;

begin
  S := 'Multi-Translation done. ';
  if (SubsUpdatedCount = 0) and (SubsUpdatedOccurencesCount = 0) then
    frmMain.AddDebug(S + ' No subtitle was needed to be updated with this feature.')
  else
    frmMain.AddDebug(S + IntToStr(SubsUpdatedCount)
      + ' subtitle(s) updated in ' + IntToStr(SubsUpdatedOccurencesCount)
      + ' occurence(s).');
end;*)

procedure TfrmProgress.EventEndBatchSubsExporter(Sender: TObject);
begin
  EventEndCommon;
end;

procedure TfrmProgress.EventEndCommon;
begin
  Terminated := True;
  Close;
  frmMain.SetStatusReady;
end;

end.
