unit SRFScript;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, JvBaseDlg, JvBrowseFolder, BatchSRF;

type
  TCinematicsMode = (cmSingle, cmBatch);
  
  TfrmCinematicsScript = class(TForm)
    gbTarget: TGroupBox;
    eTarget: TEdit;
    bBrowse: TButton;
    rgDiscNumber: TRadioGroup;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    bGenerate: TButton;
    bCancel: TButton;
    gbBatchResult: TGroupBox;
    lvFiles: TListView;
    pBar: TProgressBar;
    lProgBar: TPanel;
    sdSRF: TSaveDialog;
    bfdSRF: TJvBrowseForFolderDialog;
    procedure FormShow(Sender: TObject);
    procedure rgDiscNumberClick(Sender: TObject);
    procedure bGenerateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bBrowseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    fMode: TCinematicsMode;
    procedure SetMode(const Value: TCinematicsMode);
    procedure SetFileName(const Value: TFileName);
    function GetDiscNumber: Integer;
    function GetFileName: TFileName;
    procedure BatchInitialize(Sender: TObject; MaxValue: Integer);
    procedure BatchFileProceed(Sender: TObject; FileName: TFileName;
      Result: Boolean);
    procedure BatchCompleted(Sender: TObject; ErrornousFiles,
      TotalFiles: Integer; Canceled: Boolean);
    procedure Clear;
    procedure ChangeControlsState(State: Boolean);
  protected
    BatchThread: TCinematicsBatchThread;
  public
    { Déclarations publiques }
    function Execute: Boolean;
    function GetDefaultFileName: TFileName;
    function MsgBox(Text: string; Title: TCaption; Flags: Integer): Integer;
    property DiscNumber: Integer read GetDiscNumber;
    property FileName: TFileName read GetFileName write SetFileName;
    property Mode: TCinematicsMode read fMode write SetMode;
  end;

var
  frmCinematicsScript: TfrmCinematicsScript;

implementation

{$R *.dfm}

uses
  UITools, Main, Math;

{ TfrmCinematicsScript }

procedure TfrmCinematicsScript.BatchCompleted(Sender: TObject; ErrornousFiles,
  TotalFiles: Integer; Canceled: Boolean);
begin
  if not Canceled then
    MsgBox(
      'Batch SRF script generation done. ' + IntToStr(ErrornousFiles)
        + ' error(s) on ' + IntToStr(TotalFiles) + ' file(s).',
      'Batch SRF script result',
      MB_ICONINFORMATION
    );
  ChangeControlsState(True);
end;

procedure TfrmCinematicsScript.BatchFileProceed(Sender: TObject;
  FileName: TFileName; Result: Boolean);
begin
  // Updating progress bar
  pbar.Position := pbar.Position + 1;
  lProgBar.Caption :=
    FormatFloat('0.00', SimpleRoundTo((100 * pbar.Position) / pbar.Max, -2)) + '%';
  Application.ProcessMessages;

  // add the file to the list
  with lvFiles.Items.Add do begin
    Caption := ExtractFileName(FileName);
    if Result then
      SubItems.Add('OK')
    else
      SubItems.Add('FAILED');
  end;

  // select the lastest item
  ListViewSelectItem(lvFiles, lvFiles.Items.Count - 1);
end;

procedure TfrmCinematicsScript.BatchInitialize(Sender: TObject;
  MaxValue: Integer);
begin
  Clear;
  pBar.Max := MaxValue;
end;

procedure TfrmCinematicsScript.bBrowseClick(Sender: TObject);
begin
  case Mode of
    cmSingle:
      begin
        sdSRF.FileName := ExtractFileName(FileName);
        if sdSRF.Execute then
          FileName := sdSRF.FileName;
      end;
    cmBatch:
      if bfdSRF.Execute then
        FileName := bfdSRF.Directory;
  end;
end;

procedure TfrmCinematicsScript.bGenerateClick(Sender: TObject);
begin
  if Mode = cmBatch then begin
    // Init the UI
    ChangeControlsState(False);

    // Do the batch export
    BatchThread := TCinematicsBatchThread.Create;
    with BatchThread do begin
      FreeOnTerminate := True;
      FilesList.Assign(frmMain.SelectedDirectory, frmMain.lbFilesList.Items);
      TargetDirectory := IncludeTrailingPathDelimiter(FileName);
      TargetDiscNumber := DiscNumber;
      OnInitialize := BatchInitialize;
      OnFileProceed := BatchFileProceed;
      OnCompleted := BatchCompleted;
      Resume;
    end;
  end;
end;

procedure TfrmCinematicsScript.ChangeControlsState(State: Boolean);
begin
  bGenerate.Enabled := State;
  rgDiscNumber.Enabled := State;
  eTarget.Enabled := State;
  bBrowse.Enabled := State;
end;

procedure TfrmCinematicsScript.Clear;
begin
  lProgBar.Caption := '-';
  lvFiles.Clear;
  pBar.Position := 0;
end;

function TfrmCinematicsScript.Execute: Boolean;
begin
  Result := ShowModal = mrOK;
end;

procedure TfrmCinematicsScript.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  CanDo: Integer;

begin
  if Assigned(BatchThread) then
    if not bGenerate.Enabled then begin
      Action := caNone;
      BatchThread.Suspend;
      CanDo := MsgBox('Are you sure to cancel ?', 'Cancel ?', MB_ICONWARNING + MB_OKCANCEL);
      if CanDo = IDOK then
        BatchThread.Terminate;
      BatchThread.Resume;
    end;
end;

procedure TfrmCinematicsScript.FormCreate(Sender: TObject);
begin
  FileName := EmptyStr;
end;

procedure TfrmCinematicsScript.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

procedure TfrmCinematicsScript.FormShow(Sender: TObject);
begin
  Clear;
  eTarget.SelectAll;
  eTarget.SetFocus;
end;

function TfrmCinematicsScript.GetDefaultFileName: TFileName;
begin
  Result := IncludeTrailingPathDelimiter(GetCurrentDir)
      + SCNFEditor.VoiceShortID + '_srf_disc' + IntToStr(DiscNumber) + '.xml';
end;

function TfrmCinematicsScript.GetDiscNumber: Integer;
begin
  Result := (rgDiscNumber.ItemIndex + 1);
end;

function TfrmCinematicsScript.GetFileName: TFileName;
begin
  Result := eTarget.Text;
end;

function TfrmCinematicsScript.MsgBox(Text: string; Title: TCaption;
  Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Title), Flags);
end;

procedure TfrmCinematicsScript.rgDiscNumberClick(Sender: TObject);
begin
  if Mode = cmSingle then begin
    FileName := GetDefaultFileName;
    eTarget.SelectAll;
  end;
end;

procedure TfrmCinematicsScript.SetFileName(const Value: TFileName);
begin
  eTarget.Text := Value;
end;

procedure TfrmCinematicsScript.SetMode(const Value: TCinematicsMode);
begin
  fMode := Value;
  case fMode of
    cmSingle:
      begin
        gbBatchResult.Visible := False;
        gbTarget.Caption := ' Select the target filename : ';
        Height := 245;
        bGenerate.ModalResult := mrOK;
      end;
    cmBatch:
      begin
        gbBatchResult.Visible := True;
        gbTarget.Caption := ' Select the target directory : ';
        Height := 390;
        bGenerate.ModalResult := mrNone;
        if FileName = EmptyStr then
          FileName := IncludeTrailingPathDelimiter(GetCurrentDir);       
      end;
  end;
end;

end.
