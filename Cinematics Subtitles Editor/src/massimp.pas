unit MassImp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, JvBaseDlg, JvBrowseFolder, StdCtrls, ComCtrls, SubsImp;

type
  TfrmMassImport = class(TForm)
    GroupBox1: TGroupBox;
    eDirectory: TEdit;
    btnBrowse: TButton;
    JvBrowseForFolderDialog: TJvBrowseForFolderDialog;
    btnImport: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
    GroupBox2: TGroupBox;
    Bevel2: TBevel;
    lvFiles: TListView;
    pBar: TProgressBar;
    Label1: TLabel;
    lProgBar: TPanel;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
    fActive: Boolean;
    fBatchThread: TBatchSubtitlesImporterThread;
    procedure ResetForm;
    procedure ResetProgress;
    procedure ChangeControlsState(const State: Boolean);
    procedure ChangeCancelState(const State: Boolean);
    procedure ThreadCompleted(Sender: TObject; ErrornousFiles,
      TotalFiles: Integer; Canceled: Boolean);
    procedure ThreadFileProceed(Sender: TObject; FileName: TFileName;
      Result: TBatchThreadImportedResult);
    procedure UpdateProgressBar;
    procedure SetSourceDirectory(const Value: TFileName);
    function GetSourceDirectory: TFileName;
    property Active: Boolean read fActive write fActive;
    property BatchThread: TBatchSubtitlesImporterThread read fBatchThread
      write fBatchThread;
  public
    { Déclarations publiques }
    function MsgBox(const Text, Caption: string; Flags: Integer): Integer;
    property SourceDirectory: TFileName read GetSourceDirectory
      write SetSourceDirectory;
  end;

//==============================================================================
implementation
//==============================================================================

{$R *.dfm}

uses
  Main, Math, FilesLst, UITools, DebugLog;
  
//------------------------------------------------------------------------------

function TfrmMassImport.MsgBox(const Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.btnBrowseClick(Sender: TObject);
begin
  with JvBrowseForFolderDialog do begin
    Directory := SourceDirectory;
    if Execute then
      SourceDirectory := Directory;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.btnImportClick(Sender: TObject);
begin
  // Initialize UI
  ResetForm;
  btnImport.Enabled := False;
  Active := True;
  pBar.Max := frmMain.WorkingFilesList.Count;
  lvFiles.SetFocus;

  // Adding an entry to the Debug Log
  Debug.AddLine(ltInformation, 'Starting batch importation for '
    + IntToStr(pBar.Max) + ' file(s)...');
  frmMain.StatusText := 'Batch importing...';
  
  // Running the thread
  BatchThread := TBatchSubtitlesImporterThread.Create;
  with BatchThread do begin
    // Properties
    FreeOnTerminate := True;
    TargetDirectory := SourceDirectory;
    SourceFilesList.Assign(frmMain.WorkingFilesList);

    // Events
    OnFileProceed := ThreadFileProceed;
    OnCompleted := ThreadCompleted;

    // Run !
    Resume;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.ChangeCancelState(const State: Boolean);
begin
  btnCancel.Enabled := State;
  SetCloseWindowButtonState(Self, State);
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.ChangeControlsState(const State: Boolean);
begin
  btnImport.Enabled := State;
  btnBrowse.Enabled := State;
  eDirectory.Enabled := State;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.btnCancelClick(Sender: TObject);
begin
  ChangeCancelState(False);
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Refresh the view
  frmMain.ReloadFile;
end;

procedure TfrmMassImport.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  CanDo: Integer;

begin
  if Active then begin
    BatchThread.Suspend;
    CanClose := False;

    CanDo := MsgBox('Cancel the import operation ?', 'Question', MB_ICONQUESTION
      + MB_OKCANCEL + MB_DEFBUTTON2);

    ChangeCancelState(True);
    BatchThread.Resume;
    
    if CanDo = IDOK then
      BatchThread.Terminate;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  ResetForm;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

//------------------------------------------------------------------------------

function TfrmMassImport.GetSourceDirectory: TFileName;
begin
  Result := eDirectory.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.ResetForm;
begin
  ResetProgress;
  lvFiles.Clear;
  ChangeControlsState(True);
  ChangeCancelState(True);
  Active := False;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.ResetProgress;
begin
  lProgBar.Caption := '...';
  pBar.Position := 0;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.SetSourceDirectory(const Value: TFileName);
begin
  eDirectory.Text := IncludeTrailingPathDelimiter(Value);
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.ThreadCompleted(Sender: TObject; ErrornousFiles,
  TotalFiles: Integer; Canceled: Boolean);
var
  FilesImported, Icon: Integer;
  S: string;
  DebugType: TDebugLineType;
  
begin
  Active := False;
  ChangeControlsState(True);

  frmMain.StatusText := 'Batch importing done!';

  if not Canceled then begin
    FilesImported := TotalFiles - ErrornousFiles;

    if FilesImported > 0 then begin

      if (ErrornousFiles = 0) then begin
        Icon := MB_ICONINFORMATION;
        DebugType := ltInformation;
      end else begin
        Icon := MB_ICONWARNING;
        DebugType := ltWarning;
      end;

      S := IntToStr(FilesImported) + ' file(s) successfully imported. '
        + IntToStr(ErrornousFiles) + ' errornous file(s).';
      MsgBox(S, 'Batch Import Results', Icon);
      Debug.AddLine(DebugType, S);

      if (ErrornousFiles = 0) then
        Close;

    end else
      Debug.Report(ltWarning,
        'No files successfully imported. Check your input folder.', '');

  end else
    ResetProgress;

  frmMain.StatusText := '';
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.ThreadFileProceed(Sender: TObject; FileName: TFileName;
  Result: TBatchThreadImportedResult);
begin
  with lvFiles.Items.Add do begin
    Caption := ExtractFileName(FileName);
    SubItems.Add(ImportResultToString(Result));
  end;
  ListViewSelectItem(lvFiles, lvFiles.Items.Count - 1);
  UpdateProgressBar;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.UpdateProgressBar;
begin
  pbar.Position := pbar.Position + 1;
  lProgBar.Caption := FormatFloat('0.00',
    SimpleRoundTo((100 * pbar.Position) / pbar.Max, -2)) + '%';
  Application.ProcessMessages;
end;
   
//------------------------------------------------------------------------------

end.
