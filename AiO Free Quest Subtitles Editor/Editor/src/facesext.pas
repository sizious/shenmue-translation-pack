unit facesext;

// Auto-select right directory for debug purpose
// {$DEFINE DEBUG_PAKF_SHENMUE1}
{$DEFINE DEBUG_PAKF_SHENMUE2}
// {$DEFINE DEBUG_PAKF_SHENMUE2_XB}
// {$DEFINE DEBUG_PAKF_WHATS_SHENMUE}  // OK

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, PAKFExec, JvBaseDlg, JvBrowseFolder;

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
    Label1: TLabel;
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
  protected
    procedure ExtractFaces;
    procedure SetFormCanceledState(CancelInProgress: Boolean);
    procedure SetFormControlsState(State: Boolean);
    procedure ProcessCompleted(Sender: TObject);
    property CanceledByButton: Boolean read fCanceledByButton
      write fCanceledByButton;
    property ExtractorThread: TPAKFExtractorThread read fPAKFExtractorThread
      write fPAKFExtractorThread;
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
  Math, ScnfUtil;
  
{ TfrmFacesExtractor }

procedure TfrmFacesExtractor.bBrowseClick(Sender: TObject);
begin
  with JvBrowseForFolderDialog do
    if Execute then eDirectory.Text := Directory;
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
var
  GameVersion: TGameVersion;

begin
  SetFormControlsState(False);
  ProcessBusy := True;
  ProcessCanceled := False;
  GameVersion := gvShenmue;
  case rgGameVersion.ItemIndex of
    1: GameVersion := gvShenmue2;
    2: GameVersion := gvWhatsShenmue;
  end;
  ExtractorThread := TPAKFExtractorThread.Create(eDirectory.Text, GameVersion);
  ExtractorThread.OnTerminate := ProcessCompleted;
  ExtractorThread.Resume;
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
  eDirectory.Text := 'G:\Shenmue\Humans\SHENMUE PAL\DISC1\PKF\';
  rgGameVersion.ItemIndex := 0;
{$ENDIF}
{$IFDEF DEBUG_PAKF_SHENMUE2}
  eDirectory.Text := 'G:\Shenmue\Humans\SHENMUE 2 PAL\DISC1\PKF\';
  rgGameVersion.ItemIndex := 1;
{$ENDIF}
{$IFDEF DEBUG_PAKF_SHENMUE2_XB}
  eDirectory.Text := 'G:\Shenmue\Humans\SHENMUE 2 PAL UK XBOX\DISC1\PKF\';
  rgGameVersion.ItemIndex := 1;
{$ENDIF}
{$IFDEF DEBUG_PAKF_WHATS_SHENMUE}
  eDirectory.Text := 'G:\Shenmue\Humans\WHATS SHENMUE JAP\PKF';
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
