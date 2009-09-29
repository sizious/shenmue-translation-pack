unit massimp;

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
//    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    fBatchSubsImporter: TSubsMassImporterThread;
    fImporting: Boolean;
    fAborted: Boolean;
    fSuccess: Boolean;
//    fFilesAmbigous: Boolean;
    procedure BatchImportSubtitles(const InputDirectory: TFileName);
    procedure FileImportedEvent(Sender: TObject;
      TargetFileName, SubsFileName: TFileName; ImportResult: TImportResult);
    procedure ImportFinishedEvent(Sender: TObject; FilesImported,
      FilesFailure: Integer);
    procedure ResetForm;
    procedure ChangeControlsState(const State: Boolean);
  protected
    property Aborted: Boolean read fAborted write fAborted;
//    property HasFilesAmbigous: Boolean read fFilesAmbigous write fFilesAmbigous;
    property Importing: Boolean read fImporting write fImporting;
  public
    { Déclarations publiques }
    function MsgBox(const Text, Caption: string; Flags: Integer): Integer;
    procedure UpdateProgressBar;
    property Success: Boolean read fSuccess;
  end;

var
  frmMassImport: TfrmMassImport;

implementation

uses
  Main, Math, FilesLst, Utils;
  
{$R *.dfm}

//------------------------------------------------------------------------------

function TfrmMassImport.MsgBox(const Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.BatchImportSubtitles(const InputDirectory: TFileName);
var
  FilesList: TFilesList;
  i: Integer;

begin
  FilesList := TFilesList.Create;
  try
    for i := 0 to frmMain.lbFilesList.Items.Count - 1 do
      FilesList.Add(frmMain.GetTargetDirectory + frmMain.lbFilesList.Items[i]);

    fBatchSubsImporter := TSubsMassImporterThread.Create(InputDirectory, FilesList);
    fBatchSubsImporter.OnFileImported := FileImportedEvent;
    fBatchSubsImporter.OnCompleted := ImportFinishedEvent;
    fBatchSubsImporter.Resume;

  finally
    FilesList.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.btnBrowseClick(Sender: TObject);
begin
  with JvBrowseForFolderDialog do
    if Execute then eDirectory.Text := Directory;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.btnImportClick(Sender: TObject);
begin
  if not DirectoryExists(eDirectory.Text) then begin
    MsgBox('Please select the subtitles directory.', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  ResetForm;
  ChangeControlsState(False);
  Importing := True;
  Aborted := False;
  BatchImportSubtitles(eDirectory.Text);
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
  btnCancel.Enabled := False;
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.FileImportedEvent(Sender: TObject;
  TargetFileName, SubsFileName: TFileName; ImportResult: TImportResult);
begin
  with Self.lvFiles.Items.Add do begin
    Caption := ExtractFileName(TargetFileName);
    case ImportResult of
      irSuccess           : SubItems.Add('OK');
      irFailed            : SubItems.Add('FAILED');
      irSubsFileNotFound  : SubItems.Add('NOT FOUND');
      irSubsFileAmbiguous : //begin
                              SubItems.Add('AMBIGUOUS');
                              //HasFilesAmbigous := True;
                            //end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmMassImport.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Importing then begin
    Aborted := True;
    if Assigned(fBatchSubsImporter) then begin
      fBatchSubsImporter.Terminate;
    end;
    ChangeControlsState(True);
    CanClose := False;
    ResetForm;
  end;
end;
  
//------------------------------------------------------------------------------

procedure TfrmMassImport.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  ResetForm;
end;

procedure TfrmMassImport.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

(*procedure TfrmMassImport.FormShow(Sender: TObject);
begin
  ResetForm;
end;*)

//------------------------------------------------------------------------------

procedure TfrmMassImport.ImportFinishedEvent(Sender: TObject; FilesImported,
  FilesFailure: Integer);
var
  Icon: Integer;
//  AmbigousMsg: string;

begin
  if Aborted then
    pBar.Position := 0;

  (*AmbigousMsg := '';
  if HasFilesAmbigous then
    AmbigousMsg :=
      WrapStr + 'You have ambigous XML files in your input folder.' + WrapStr
       + 'Ambigous is for example for the <TEST.PKS> file, you have both' + WrapStr
       + '<TEST.XML> and <TEST.PKS.XML> in your input folder.';*)
    
  Importing := False;
  ChangeControlsState(True);

  if not Aborted then begin

    if FilesImported > 0 then begin
      if FilesFailure = 0 then
        Icon := MB_ICONINFORMATION
      else
        Icon := MB_ICONWARNING;
      MsgBox(IntToStr(FilesImported) + ' file(s) successfully imported. '
        + IntToStr(FilesFailure) + ' errornous file(s).', 'Batch Import Results', Icon);
      fSuccess := True;

      if FilesFailure = 0 then
        Close;
    end else
      MsgBox('No files successfully imported. Check your input folder.',
      'Batch Import Results', MB_ICONWARNING);
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfrmMassImport.ResetForm;
begin
  // Aborted := False;
  Importing := False; // cheminement normal
  lProgBar.Caption := '...';
  pBar.Position := 0;
  lvFiles.Clear;
  ChangeControlsState(True);
  btnCancel.Enabled := True;
  if DirectoryExists(frmMain.SelectedDirectory) then begin
    eDirectory.Text := frmMain.SelectedDirectory;
    JvBrowseForFolderDialog.Directory := eDirectory.Text;
  end;
//  HasFilesAmbigous := False;
end;
  
//------------------------------------------------------------------------------

procedure TfrmMassImport.UpdateProgressBar;
begin
  pbar.Position := pbar.Position + 1;
  lProgBar.Caption := FormatFloat('0.00', SimpleRoundTo((100 * pbar.Position) / pbar.Max, -2)) + '%';
  Application.ProcessMessages;
end;
   
//------------------------------------------------------------------------------

end.
