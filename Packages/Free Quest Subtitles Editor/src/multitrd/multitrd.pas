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

unit MultiTrd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, JvExComCtrls, JvListView, ScnfEdit,
  FilesLst, MTExec;

type
  TfrmMultiTranslation = class(TForm)
    Bevel1: TBevel;
    bGo: TButton;
    bClose: TButton;
    gbProgress: TGroupBox;
    lblProgress: TLabel;
    pbPAKS: TProgressBar;
    pbTotal: TProgressBar;
    pcMulti: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lvSubsSelect: TJvListView;
    cbFiles: TComboBox;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lOriginalSub: TLabel;
    eNewFirstLineLength: TEdit;
    eNewSecondLineLength: TEdit;
    mNewSub: TMemo;
    mOldSub: TMemo;
    cbSameSex: TCheckBox;
    mDebugLog: TMemo;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure bGoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lvSubsSelectSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure mNewSubChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mOldSubChange(Sender: TObject);
    procedure cbFilesSelect(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
  private
    fFilesList: TFilesList;
    fMultiExec: TMultiTranslationExecute;
    fSelectedIndex: Integer;
    fAborted: Boolean;
    fTerminated: Boolean;
    fOldSelectedSubtitleText: string;
    fOriginalSelectedSubtitleText: string;
    procedure LoadSubsListView(const FileName: TFileName);
    procedure MultiTranslate;
    function GetSelectedSubtitle: TSubEntry;
//    function GetSelectedSubtitleUI: string;
//    procedure SetSelectedSubtitleUI(const Value: string);
    procedure UpdateOldSubtitleField;
  protected
    procedure AddDebug(m: string);
    procedure InitMultiView(const FileName: TFileName);
    procedure EndEventCompleted(Sender: TObject; SubsTranslated: Integer);
    procedure EventFileTranslated(Sender: TObject; TargetFileName: TFileName;
      TargetSubtitleCode: string);
    procedure EventTranslatingSubtitle(Sender: TObject; OldSubtitle,
      NewSubtitle: string);
    property SelectedSubtitle: TSubEntry read GetSelectedSubtitle;
(*    property SelectedSubtitleUI: string read GetSelectedSubtitleUI write
      SetSelectedSubtitleUI; *)
    property SelectedIndex: Integer read fSelectedIndex write fSelectedIndex;
    property FilesList: TFilesList read fFilesList;
    property MultiExec: TMultiTranslationExecute read fMultiExec write fMultiExec;
    property Aborted: Boolean read fAborted write fAborted;
    property Terminated: Boolean read fTerminated write fTerminated;
    property OriginalSelectedSubtitleText: string
      read fOriginalSelectedSubtitleText write fOriginalSelectedSubtitleText; // ORIGINAL text from AM2 developers
    property OldSelectedSubtitleText: string
      read fOldSelectedSubtitleText write fOldSelectedSubtitleText; // PREVIOUS text from the user (the translator)...    
  public
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
  end;

var
  frmMultiTranslation: TfrmMultiTranslation;

implementation

uses
  Main, CharsCnt;
  
{$R *.dfm}

procedure Delay(Milliseconds: Double);
var
  StartTime: TDateTime;

begin
  StartTime := Now;
  Milliseconds := Milliseconds / 24 / 60 / 60 / 1000;
  repeat
    Application.ProcessMessages;
  until Now > StartTime + Milliseconds;
end;

procedure TfrmMultiTranslation.AddDebug(m: string);
begin
  mDebugLog.Lines.Add(m);
end;

procedure TfrmMultiTranslation.bCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMultiTranslation.bGoClick(Sender: TObject);
begin
  if mNewSub.Text = '' then begin
    MsgBox('Please input the new subtitle.', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  MultiTranslate;
end;

procedure TfrmMultiTranslation.cbFilesSelect(Sender: TObject);
begin
  if cbFiles.ItemIndex = -1 then Exit;
  InitMultiView(FilesList[cbFiles.ItemIndex].FileName);
end;

procedure TfrmMultiTranslation.EndEventCompleted(Sender: TObject;
  SubsTranslated: Integer);
var
  i: Integer;

begin
  Terminated := True;
  
  lblProgress.Caption := IntToStr(SubsTranslated) + ' subtitle(s) updated.';

  SCNFEditor.ReloadFile;
  for i := 0 to SCNFEditor.Subtitles.Count - 1 do
    lvSubsSelect.Items[i].SubItems[1] := SCNFEditor.Subtitles[i].Text;

  OldSelectedSubtitleText := mNewSub.Text;
  UpdateOldSubtitleField;

  Delay(1000);
  pbPAKS.Position := 0;
  pbTotal.Position := 0;
  bGo.Enabled := True;

  MultiExec := nil;
end;

procedure TfrmMultiTranslation.EventFileTranslated(Sender: TObject;
  TargetFileName: TFileName; TargetSubtitleCode: string);
begin
  AddDebug('     ' + ExtractFileName(TargetFileName) + ': ' +  TargetSubtitleCode);
end;

procedure TfrmMultiTranslation.EventTranslatingSubtitle(Sender: TObject;
  OldSubtitle, NewSubtitle: string);
begin
  AddDebug('Translating "' + OldSubtitle + '" -> "' + NewSubtitle + '"...');
end;

procedure TfrmMultiTranslation.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  CanDo: Integer;

begin
  if Assigned(MultiExec) and (not Terminated) then
    if not Aborted then begin
      MultiExec.Suspend;
      CanDo := MsgBox('Cancel the Multi-Translation process?', 'Warning', MB_ICONWARNING + MB_OKCANCEL);
      MultiExec.Resume;
      Action := caNone;
      if CanDo = IDCANCEL then Exit;

      Aborted := True;
      MultiExec.Terminate;
      Exit;
    end else begin
      // (not Terminated) and (Aborted)
      // We are waiting the end of the process
      Action := caNone;
      Exit;
    end;

  frmMain.ReloadFileEditor;
end;

procedure TfrmMultiTranslation.FormCreate(Sender: TObject);
begin
  gbProgress.DoubleBuffered := True;
  DoubleBuffered := True;
  fFilesList := TFilesList.Create;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
end;

procedure TfrmMultiTranslation.FormDestroy(Sender: TObject);
begin
  fFilesList.Free;
end;

procedure TfrmMultiTranslation.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

procedure TfrmMultiTranslation.FormShow(Sender: TObject);
var
  i: Integer;

begin
  pcMulti.TabIndex := 0;
  mDebugLog.Clear;
  MultiExec := nil;
  FilesList.Clear;
  cbFiles.Clear;
  Aborted := False;
  Terminated := False;
  
  for i := 0 to frmMain.lbFilesList.Count - 1 do begin
    FilesList.Add(frmMain.SelectedDirectory + frmMain.lbFilesList.Items[i]);
    cbFiles.Items.Add(frmMain.lbFilesList.Items[i]);
  end;
  
  InitMultiView(SCNFEditor.SourceFileName);
end;

function TfrmMultiTranslation.GetSelectedSubtitle: TSubEntry;
var
  Index: Integer;

begin
  Result := nil;
  if not Assigned(lvSubsSelect.Selected) then Exit;
  Index := lvSubsSelect.Selected.Index;
  Result := SCNFEditor.Subtitles[Index];

  // Loading subtitle from database
  OriginalSelectedSubtitleText :=
    TextDatabaseCorrector.Subtitles[Index].Text;
  OldSelectedSubtitleText := Result.Text;
end;

(*function TfrmMultiTranslation.GetSelectedSubtitleUI: string;
begin
  Result := '';
  if SelectedIndex = -1 then Exit;
  Result := lvSubsSelect.Items[SelectedIndex].SubItems[1];
end; *)

procedure TfrmMultiTranslation.InitMultiView(const FileName: TFileName);
begin
  if frmMain.EnableOriginalSubtitlesFieldView then
    lOriginalSub.Caption := 'Original text:'
  else
    lOriginalSub.Caption := 'Old text:';

  mNewSub.Clear;
  mOldSub.Clear;
  lblProgress.Caption := 'Idle...';

  bGo.Enabled := FileExists(FileName);
  if bGo.Enabled then
    LoadSubsListView(FileName);
end;

procedure TfrmMultiTranslation.LoadSubsListView(const FileName: TFileName);
var
  i: Integer;
  Entry: TSubEntry;

begin
  frmMain.LoadSubtitleFile(FileName);
  frmMain.lbFilesList.OnClick := nil;
  frmMain.lbFilesList.ItemIndex := frmMain.lbFilesList.Items.IndexOf(ExtractFileName(FileName));
  frmMain.lbFilesList.OnClick := frmMain.lbFilesListClick;

  lvSubsSelect.Clear;
  for i := 0 to SCNFEditor.Subtitles.Count - 1 do
    with lvSubsSelect.Items.Add do begin
      Entry := SCNFEditor.Subtitles[i];
      Caption := Entry.CharID;
      SubItems.Add(Entry.Code);
      SubItems.Add(Entry.Text);
    end;
    
  if lvSubsSelect.Items.Count > 0 then
    lvSubsSelect.ItemIndex := 0;

  i := cbFiles.Items.IndexOf(ExtractFileName(FileName));
  if i <> -1 then
    cbFiles.ItemIndex := i;
end;

procedure TfrmMultiTranslation.lvSubsSelectSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected then
    SelectedIndex := Item.Index;

  if Assigned(SelectedSubtitle) then begin
    UpdateOldSubtitleField;
    mNewSub.Text := SelectedSubtitle.Text;
  end;
end;

procedure TfrmMultiTranslation.mNewSubChange(Sender: TObject);
begin
  frmMain.UpdateSubtitleLengthControls(mNewSub.Text, eNewFirstLineLength, eNewSecondLineLength);
  mNewSub.Text := StringReplace(mNewSub.Text, '<br>', sLineBreak, [rfReplaceAll]);
end;

procedure TfrmMultiTranslation.mOldSubChange(Sender: TObject);
begin
  mOldSub.Text := StringReplace(mOldSub.Text, '<br>', sLineBreak, [rfReplaceAll]);
end;

function TfrmMultiTranslation.MsgBox(Text, Caption: string;
  Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMultiTranslation.MultiTranslate;
begin
  Terminated := False;
  bGo.Enabled := False;
  MultiExec := TMultiTranslationExecute.Create(FilesList, OldSelectedSubtitleText,
    mNewSub.Text, cbSameSex.Checked);
  MultiExec.OnCompleted := EndEventCompleted;
  MultiExec.OnFileTranslated := EventFileTranslated;
  MultiExec.OnTranslatingSubtitle := EventTranslatingSubtitle;
  MultiExec.Resume;
end;

procedure TfrmMultiTranslation.UpdateOldSubtitleField;
begin
  if frmMain.EnableOriginalSubtitlesFieldView then
    mOldSub.Text := OriginalSelectedSubtitleText
  else
    mOldSub.Text := OldSelectedSubtitleText;
end;

(*procedure TfrmMultiTranslation.SetSelectedSubtitleUI(const Value: string);
begin
  if SelectedIndex = -1 then Exit;
  lvSubsSelect.Items[SelectedIndex].SubItems[1] := Value;
end;*)

end.
