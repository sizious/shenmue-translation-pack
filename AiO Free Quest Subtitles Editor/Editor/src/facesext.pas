unit facesext;

// Auto-select right directory for debug purpose

// 249 faces extracted (+7 from shenmue.ptc)
// {$DEFINE DEBUG_PAKF_SHENMUE1}

// 592 faces extracted (everything extracted)
{$DEFINE DEBUG_PAKF_SHENMUE2}

// 592 faces extracted (everything extracted)
// {$DEFINE DEBUG_PAKF_SHENMUE2_XB}

// 68 faces extracted (everything extracted)
// {$DEFINE DEBUG_PAKF_WHATS_SHENMUE}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, PAKFExec, JvBaseDlg, JvBrowseFolder,
  ScnfUtil;

type
  TfrmFacesExtractor = class(TForm)
    GroupBox1: TGroupBox;
    eDirectory: TEdit;
    bBrowse: TButton;
    rgGameVersion: TRadioGroup;
    GroupBox2: TGroupBox;
    lvFiles: TListView;
    pBar: TProgressBar;
    lProgBar: TPanel;
    Bevel1: TBevel;
    bExtract: TButton;
    bCancel: TButton;
    JvBrowseForFolderDialog: TJvBrowseForFolderDialog;
    lHelp: TLabel;
    lrg0: TLabel;
    lrg1: TLabel;
    lrg2: TLabel;
    procedure bExtractClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    fProcessBusy: Boolean;
    fPAKFExtractorThread: TPAKFExtractorThread;
    fProcessCanceled: Boolean;
    fCanceledByButton: Boolean;
    fSelectedGameVersion: TGameVersion;
    procedure ExtractionFinished(Sender: TObject; ProcessCanceled: Boolean;
      SuccessExtractCount, ErrorExtractCount, TotalExtractedCount,
      TotalExtractedMaxCount: Integer);
  protected
    procedure ExtractFaces;
    function GetSelectedGameVersion: TGameVersion;
    function GetSelectedGameTitle: string;
    procedure SetFormCanceledState(CancelInProgress: Boolean);
    procedure SetFormControlsState(State: Boolean);
    procedure ProcessCompleted(Sender: TObject);
    property CanceledByButton: Boolean read fCanceledByButton
      write fCanceledByButton;
    property ExtractorThread: TPAKFExtractorThread read fPAKFExtractorThread
      write fPAKFExtractorThread;
    property SelectedGameVersion: TGameVersion
      read fSelectedGameVersion write fSelectedGameVersion;
    property ProcessBusy: Boolean read fProcessBusy write fProcessBusy;
    property ProcessCanceled: Boolean read fProcessCanceled write fProcessCanceled;
  public
    { Déclarations publiques }
    function MsgBox(const Text, Caption: string; Flags: Integer): Integer;
    procedure Reset(SetMaxValue: Integer);
    procedure UpdateProgressBar;
  end;

var
  frmFacesExtractor: TfrmFacesExtractor;

  
implementation

{$R *.dfm}

uses
  Math, PakfMgr;
  
{ TfrmFacesExtractor }

procedure TfrmFacesExtractor.bBrowseClick(Sender: TObject);
begin
  with JvBrowseForFolderDialog do begin
    if DirectoryExists(eDirectory.Text) then
      Directory := eDirectory.Text;
    if Execute then eDirectory.Text := Directory;
  end;
end;

procedure TfrmFacesExtractor.bCancelClick(Sender: TObject);
begin
  CanceledByButton := ProcessBusy;
  Close;
end;

procedure TfrmFacesExtractor.bExtractClick(Sender: TObject);
begin
  if not DirectoryExists(eDirectory.Text) then begin
    MsgBox('The specified directory doesn''t exists.', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  ExtractFaces;
end;

procedure TfrmFacesExtractor.ExtractFaces;
begin
  SetFormControlsState(False);
  ProcessBusy := True;
  ProcessCanceled := False;
  SelectedGameVersion := GetSelectedGameVersion;

  // Create and execute the thread
  ExtractorThread := TPAKFExtractorThread.Create(eDirectory.Text, SelectedGameVersion);
  ExtractorThread.OnTerminate := ProcessCompleted;
  ExtractorThread.OnExtractionFinished := ExtractionFinished;
  ExtractorThread.Resume;
end;

procedure TfrmFacesExtractor.ExtractionFinished(Sender: TObject;
  ProcessCanceled: Boolean; SuccessExtractCount, ErrorExtractCount,
  TotalExtractedCount, TotalExtractedMaxCount: Integer);
var
  Errors, MsgTitle, SuccessText,
  MissingFaceText: string;
  Icon,
  MissingFacesCount: Integer;

begin
  if not ProcessCanceled then begin

    MissingFacesCount := TotalExtractedMaxCount - TotalExtractedCount;
    Icon := MB_ICONINFORMATION;
    MsgTitle := 'Extraction finished';
    Errors := ' no errors.';

    if MissingFacesCount > 0 then begin
      MissingFaceText := 'You are missing ' + IntToStr(MissingFacesCount) +
        ' of ' + IntToStr(TotalExtractedMaxCount) + ' face(s) files.' + sLineBreak
        + 'Extract the missing faces from the others discs!';

      // The rest of the message box: displaying errornous files count
      if ErrorExtractCount > 0 then begin
        Errors := ' ' + IntToStr(ErrorExtractCount) + ' error(s).';
        MsgTitle := ' with errors';
        Icon := MB_ICONWARNING;
      end;

    end else
      MissingFaceText := 'You have every NPC faces files for '
        + GetSelectedGameTitle + ' !';

    // Displaying the message box
    if SuccessExtractCount > 0 then begin
      SuccessText := IntToStr(SuccessExtractCount) + ' file(s) successfully '
        + 'extracted with' + Errors + sLineBreak;
    end;

    MsgBox(SuccessText + MissingFaceText, MsgTitle, Icon + MB_OK);
        
  end; // ProcessCanceled
end;

procedure TfrmFacesExtractor.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  CanDo: Integer;

begin
  if ProcessBusy then begin
    Action := caNone; // if busy, we can't close the window
    if not ProcessCanceled then begin
      // Asking if we are sure to exit
      ExtractorThread.Suspend;
      CanDo := MsgBox('Are you sure to cancel the extraction?', 'Aborting process', MB_OKCANCEL + MB_DEFBUTTON2 + MB_ICONEXCLAMATION);
      ExtractorThread.Resume;

      if CanDo = IDCANCEL then Exit; // cancel process aborted..
      ExtractorThread.Terminate; // Terminate if OK pressed
      ProcessCanceled := True;
      SetFormCanceledState(True);
    end; // ProcessCanceled
  end; // ProcessBusy
end;

procedure TfrmFacesExtractor.FormCreate(Sender: TObject);
begin
{$IFDEF DEBUG}
{$IFDEF DEBUG_PAKF_SHENMUE1}
  eDirectory.Text := 'G:\Shenmue\Humans\04-Shenmue (PAL)\DISC1\PKF\';
  rgGameVersion.ItemIndex := 0;
{$ENDIF}
{$IFDEF DEBUG_PAKF_SHENMUE2}
  eDirectory.Text := 'G:\Shenmue\Humans\06-Shenmue II (PAL)\DISC1\PKF\';
  rgGameVersion.ItemIndex := 1;
{$ENDIF}
{$IFDEF DEBUG_PAKF_SHENMUE2_XB}
  eDirectory.Text := 'G:\Shenmue\Humans\08-Shenmue 2x (PAL) (UK)\DISC1\PKF\';
  rgGameVersion.ItemIndex := 1;
{$ENDIF}
{$IFDEF DEBUG_PAKF_WHATS_SHENMUE}
  eDirectory.Text := 'G:\Shenmue\Humans\01-What''s Shenmue (JAP)\PKF\';
  rgGameVersion.ItemIndex := 2;
{$ENDIF}
{$ENDIF}
end;

procedure TfrmFacesExtractor.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    bCancel.Click;
  end;
end;

procedure TfrmFacesExtractor.FormShow(Sender: TObject);
begin
  Reset(0);
end;

function TfrmFacesExtractor.GetSelectedGameTitle: string;
const
  SPACE_SLASH = '      ';

begin
  Result :=
    (FindComponent('lrg' + IntToStr(rgGameVersion.ItemIndex)) as TLabel).Caption;
  Result := StringReplace(Result, SPACE_SLASH, ' / ', [rfReplaceAll]);
end;

function TfrmFacesExtractor.GetSelectedGameVersion: TGameVersion;
begin
  Result := gvUndef;
  case rgGameVersion.ItemIndex of
    0: Result := gvShenmue;
    1: Result := gvShenmue2;
    2: Result := gvWhatsShenmue;
  end;
end;

function TfrmFacesExtractor.MsgBox(const Text, Caption: string;
  Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmFacesExtractor.ProcessCompleted(Sender: TObject);
begin
  ProcessBusy := False;
  if (ProcessCanceled) and (not CanceledByButton) then begin
    Close;
    Exit;
  end;
  SetFormCanceledState(False);
  SetFormControlsState(True);
  // Reset the flag if it was canceled by button
  CanceledByButton := False;  
end;

procedure TfrmFacesExtractor.Reset(SetMaxValue: Integer);
begin
  pBar.Position := 0;
  pBar.Max := SetMaxValue;
  lProgBar.Caption := '...';
  Self.lvFiles.Clear;
end;

procedure TfrmFacesExtractor.SetFormCanceledState(CancelInProgress: Boolean);
var
  HandleMenu: THandle;
  Flag: Integer;

begin
  bCancel.Enabled := not CancelInProgress;
  HandleMenu := GetSystemMenu(Handle, False);
  if CancelInProgress then
    Flag := MF_DISABLED
  else
    Flag := MF_ENABLED;
  EnableMenuItem(HandleMenu, SC_CLOSE, Flag);
end;

procedure TfrmFacesExtractor.SetFormControlsState(State: Boolean);
var
  i: Integer;

begin
  for i := 0 to rgGameVersion.Items.Count - 1 do
    (FindComponent('lrg' + IntToStr(i)) as TLabel).Enabled := State;    
  bBrowse.Enabled := State;
  eDirectory.Enabled := State;
  rgGameVersion.Enabled := State;
  bExtract.Enabled := State;
  if State then begin
    lProgBar.Caption := '...';
    pBar.Position := 0;
  end;
end;

procedure TfrmFacesExtractor.UpdateProgressBar;
begin
  pBar.Position := pBar.Position + 1;
  lProgBar.Caption :=
    FormatFloat('0.00', SimpleRoundTo((100 * pbar.Position) / pbar.Max, -2)) + '%';
  Application.ProcessMessages;
end;

end.
