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
    lShenmueUS: TLabel;
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
    fTotalFacesExtracted_SM1: Integer;
    fTotalFacesExtracted_SM2: Integer;    
    fTotalFacesExtracted_WSM: Integer;
    procedure ExtractionFinished(Sender: TObject; ProcessCanceled: Boolean;
      ExistsFiles, SuccessFiles, ErrornousFiles, TotalFiles: Integer);
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
    property TotalFacesExtracted_SM1: Integer
      read fTotalFacesExtracted_SM1 write fTotalFacesExtracted_SM1;
    property TotalFacesExtracted_SM2: Integer
      read fTotalFacesExtracted_SM2 write fTotalFacesExtracted_SM2;
    property TotalFacesExtracted_WSM: Integer
      read fTotalFacesExtracted_WSM write fTotalFacesExtracted_WSM;
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
  Math, NPCList;
  
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
  ProcessCanceled: Boolean; ExistsFiles, SuccessFiles, ErrornousFiles,
  TotalFiles: Integer);
var
  Errors, MsgTitle,
  MissingFaceText: string;
  Icon, FacesCount,
  MissingFacesCount,
  TotalFacesExtracted: Integer;

begin
  if not ProcessCanceled then begin

    FacesCount := GetNPCAutoExtractedCount(SelectedGameVersion);
    
    // Display the missing faces count
    TotalFacesExtracted := 0;
    case SelectedGameVersion of
      gvShenmue: // Shenmue
        begin
          TotalFacesExtracted_SM1 := TotalFacesExtracted_SM1 + SuccessFiles;
          TotalFacesExtracted := TotalFacesExtracted_SM1;          
        end;
      gvShenmue2: // Shenmue II
        begin
          TotalFacesExtracted_SM2 := TotalFacesExtracted_SM2 + SuccessFiles;
          TotalFacesExtracted := TotalFacesExtracted_SM2;
        end;
      gvWhatsShenmue: // What's Shenmue
        begin
          TotalFacesExtracted_WSM := TotalFacesExtracted_WSM + SuccessFiles;
          TotalFacesExtracted := TotalFacesExtracted_WSM;
        end;
    end;
    MissingFacesCount := FacesCount - TotalFacesExtracted;

    if MissingFacesCount > 0 then
      MissingFaceText := 'You are missing ' + IntToStr(MissingFacesCount) +
        ' of ' + IntToStr(FacesCount) + ' face(s) files.' + sLineBreak
        + 'Extract the missing faces from the others discs set!'
    else
      MissingFaceText := 'You have every NPC faces files for '
        + GetSelectedGameTitle + ' !';

    // The rest of the message box: displaying errornous files count
    MsgTitle := 'Extraction finished';
    if (SuccessFiles > 0) and (ErrornousFiles > 0) then begin
      Errors := ' ' + IntToStr(ErrornousFiles) + ' error(s).';
      Icon := MB_ICONWARNING;
      MsgTitle := ' with errors';
    end else begin
      Errors := ' no errors.';
      Icon := MB_ICONINFORMATION;
    end;

    // Displaying the message box
    if MissingFacesCount = 0 then
      MsgBox(MissingFaceText, 'Faces extraction complete!', MB_ICONINFORMATION + MB_OK)
    else
      if SuccessFiles > 0 then
        MsgBox(IntToStr(SuccessFiles) + ' file(s) successfully extracted with' + Errors
          + sLineBreak + MissingFaceText,
          MsgTitle,
          Icon + MB_OK)
      else
        MsgBox('Every NPC for '
          + GetSelectedGameTitle + ' were already extracted '
          + 'from the selected folder.',
          MsgTitle,
          Icon + MB_OK
        );
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
  TotalFacesExtracted_SM1 := 0;
  TotalFacesExtracted_SM2 := 0;
  TotalFacesExtracted_WSM := 0;      
end;

function TfrmFacesExtractor.GetSelectedGameTitle: string;
begin
  Result := rgGameVersion.Items[rgGameVersion.ItemIndex];
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
begin
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
