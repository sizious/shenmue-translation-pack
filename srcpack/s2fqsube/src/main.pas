//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    Shenmue II Free Quest Subtitles Editor is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Shenmue II Free Quest Subtitles Editor is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Menus, ScnfScan, ScnfEdit;

const
  APP_VERSION = '1.0';
  COMPIL_DATE_TIME = '28 mai 2008 @14:00';
  
type
  TfrmMain = class(TForm)
    GroupBox1: TGroupBox;
    sb: TStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    GroupBox2: TGroupBox;
    lbFilesList: TListBox;
    Label1: TLabel;
    lbSubSelect: TListBox;
    mSubText: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    eGameVersion: TEdit;
    Label6: TLabel;
    eCharID: TEdit;
    eVoiceID: TEdit;
    Label7: TLabel;
    eFirstLineLength: TEdit;
    eSecondLineLength: TEdit;
    Label8: TLabel;
    eSubCount: TEdit;
    Opensinglefile1: TMenuItem;
    Scandirectory1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ools1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    GroupBox3: TGroupBox;
    mDebug: TMemo;
    N2: TMenuItem;
    Clearfileslist1: TMenuItem;
    Label9: TLabel;
    eFilesCount: TEdit;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    N3: TMenuItem;
    Exportsubtitles1: TMenuItem;
    N4: TMenuItem;
    Importsubtitles1: TMenuItem;
    Autosave1: TMenuItem;
    N5: TMenuItem;
    Multitranslation1: TMenuItem;
    Makebackup1: TMenuItem;
    N6: TMenuItem;
    Cleardebuglog1: TMenuItem;
    Savedebuglog1: TMenuItem;
    Closesinglefile1: TMenuItem;
    odMain: TOpenDialog;
    sdMain: TSaveDialog;
    charsModMenu1: TMenuItem;
    procedure Scandirectory1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbFilesListClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbSubSelectClick(Sender: TObject);
    procedure mSubTextChange(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Multitranslation1Click(Sender: TObject);
    procedure Makebackup1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Clearfileslist1Click(Sender: TObject);
    procedure Opensinglefile1Click(Sender: TObject);
    procedure Cleardebuglog1Click(Sender: TObject);
    procedure Savedebuglog1Click(Sender: TObject);
    procedure Autosave1Click(Sender: TObject);
    procedure Exportsubtitles1Click(Sender: TObject);
    procedure Closesinglefile1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Importsubtitles1Click(Sender: TObject);
    procedure charsModMenu1Click(Sender: TObject);
  private
    { Déclarations privées }
    fTargetFileName: TFileName;
    fTargetDirectory: string;
    fFileModified: Boolean;
    fAutoSave: Boolean;
    fMakeBackup: Boolean;
    procedure SetFileOperationMenusItemEnabledState(const State: Boolean);
    procedure SetAutoSave(const Value: Boolean);
    procedure SetMakeBackup(const Value: Boolean);
    procedure ResetApplication;
    procedure SetSingleFileMenusItemState(const State: Boolean);
    procedure SetFileSaveOperationsMenusItemEnabledState(const State: Boolean);
  public
    { Déclarations publiques }
    procedure ActiveMultifilesOptions;
    procedure AddDebug(m: string);
    procedure Clear;
    function GetTargetDirectory: string;
    function GetTargetFileName: TFileName;
    function MsgBox(const Text, Caption: string; Flags: Integer): Integer;
    procedure LoadSubtitleFile(const FileName: TFileName);
    procedure ScanDirectory(const Directory: string);
    procedure SetStatus(const Text: string);
    procedure SetModified(const State: Boolean);

    property AutoSave: Boolean read fAutoSave write SetAutoSave;
    property FileModified: Boolean read fFileModified;
    property MakeBackup: Boolean read fMakeBackup write SetMakeBackup;
    property TargetDirectory: string read fTargetDirectory write fTargetDirectory;
  end;

var
  frmMain: TfrmMain;
  SCNFScanner: TSCNFScanDirectory;
  SCNFEditor: TSCNFEditor;

implementation

uses scandir, seldir, multitrd, ScnfUtil, Utils, CharsCnt, charsutil;

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.About1Click(Sender: TObject);
begin
  MsgBox('Version ' + APP_VERSION + #13#10 + 'Modifié par Manic' + #13#10 + COMPIL_DATE_TIME, 'Information', MB_ICONINFORMATION);
end;

procedure TfrmMain.ActiveMultifilesOptions;
begin
  Self.Clearfileslist1.Enabled := True;
  Self.Multitranslation1.Enabled := True;
end;

procedure TfrmMain.AddDebug(m: string);
begin
  mDebug.Lines.Add('[' + DateToStr(Date) + ' ' + TimeToStr(Now) + '] ' + m);
end;

procedure TfrmMain.Autosave1Click(Sender: TObject);
begin
  AutoSave := not AutoSave;
  {$IFDEF DEBUG} WriteLn('AutoSave: ', AutoSave); {$ENDIF}
end;

procedure TfrmMain.charsModMenu1Click(Sender: TObject);
begin
  with charsModMenu1 do begin
    if Checked then begin
      Checked := False;
    end
    else begin
      Checked := True;
    end;
    SCNFEditor.fCharsMod := Checked;
  end;
end;

procedure TfrmMain.Clear;
begin
  Self.SetFileOperationMenusItemEnabledState(False);
  Self.SetFileSaveOperationsMenusItemEnabledState(False);
  eGameVersion.Clear;
  eCharID.Clear;
  eVoiceID.Clear;
  eFirstLineLength.Text := '0';
  eSecondLineLength.Text := '0';
  eSubCount.Text := '0';
  mSubText.Text := '';
  lbSubSelect.Clear;
  eFilesCount.Text := IntToStr(lbFilesList.Count);
  SetStatus('Ready');
  SetModified(False);
end;

procedure TfrmMain.Cleardebuglog1Click(Sender: TObject);
var
  CanDo: Integer;

begin
  CanDo := MsgBox('Clear debug log ?', 'Confirm', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;
  mDebug.Clear;
end;

procedure TfrmMain.Clearfileslist1Click(Sender: TObject);
var
  CanDo: Integer;
begin
  CanDo := MsgBox('Are you sure to clear all the files list? Changes not saved will be LOST!', 'Warning',
    + MB_ICONWARNING + MB_DEFBUTTON2 + MB_YESNO);
  if CanDo = IDNO then Exit;
  ResetApplication;
end;

procedure TfrmMain.Closesinglefile1Click(Sender: TObject);
var
  CanDo: Integer;

begin
  // autosave
  if FileModified then
    if AutoSave then
      Save1Click(lbFilesList)
    else begin
      CanDo := MsgBox('Do you want to save the current file before closing it?', 'Save changes?', MB_YESNOCANCEL + MB_ICONWARNING);
      case CanDo of
         IDCANCEL : Exit;
         IDYES    : Save1Click(lbFilesList);
      end;
    end;

  ResetApplication;
  SetSingleFileMenusItemState(False);
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.Exportsubtitles1Click(Sender: TObject);
begin
  sdMain.Title := 'Export subtitles to';
  sdMain.Filter := 'XML Files (*.xml)|*.xml';
  sdMain.DefaultExt := 'xml';

  with sdMain do begin
    FileName := ChangeFileExt(SCNFEditor.SourceFileName, '.xml');
    if Execute then begin
      SCNFEditor.ExportSubtitlesToFile(FileName);
      AddDebug('Saving subtitles from ' + ExtractFileName(SCNFEditor.SourceFileName) + ' to ' + FileName);
    end;
  end;
end;

procedure TfrmMain.Importsubtitles1Click(Sender: TObject);
begin
  odMain.Title := 'Import subtitles from';
  odMain.Filter := 'XML Files (*.xml)|*.xml';

  with odMain do begin
    if Execute then begin
      if SCNFEditor.ImportSubtitlesToFile(FileName) then SetModified(True);
      AddDebug('Importing subtitles from ' + ExtractFileName(FileName));
    end;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := 'Shenmue II Free Quest Subtitles Editor - v'
    + APP_VERSION + ' - by [big_fury]SiZiOUS';
  
  // create the SCNF editor (Shenmue II Free Quest Subtitles Editor)
  SCNFEditor := TSCNFEditor.Create;
  
  AutoSave := Self.Autosave1.Checked;
  ResetApplication;
  SetFileOperationMenusItemEnabledState(False);
  SetModified(False);
  SetSingleFileMenusItemState(False);
  SetStatus('Ready');

  // Reset the form
  Clear;

  // Load config
  LoadConfig;

  // Load chars list
  charsModMenu1.Enabled := loadCharsList('chars_list.csv');
  SCNFEditor.fCharsMod := charsModMenu1.Enabled;
  SCNFEditor.fCSVLoaded := SCNFEditor.fCharsMod;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Saving configuration
  SaveConfig;

  SCNFEditor.Free;
  charsList.Free;
  decimalList.Free;
end;

function TfrmMain.GetTargetDirectory: string;
begin
  Result := fTargetDirectory;
end;

function TfrmMain.GetTargetFileName: TFileName;
begin
  Result := fTargetFileName;
end;

procedure TfrmMain.lbFilesListClick(Sender: TObject);
var
  CanDo: Integer;

begin
  if lbFilesList.ItemIndex = -1 then Exit;
  
  // autosave
  if FileModified then
    if AutoSave then
      Save1Click(lbFilesList)
    else begin
      CanDo := MsgBox('Do you want to save file modifications ?', 'Save changes?', MB_YESNOCANCEL + MB_ICONWARNING);
      case CanDo of
         IDCANCEL : Exit;
         IDYES    : Save1Click(lbFilesList);
      end;
    end;
    
  Clear;
  fTargetFileName := GetTargetDirectory + lbFilesList.Items[lbFilesList.ItemIndex];
  LoadSubtitleFile(GetTargetFileName);
end;

procedure TfrmMain.lbSubSelectClick(Sender: TObject);
var
  Sub: string;

begin
  Sub := SCNFEditor.SubtitlesList[Self.lbSubSelect.ItemIndex].Text;
  // Sub := StringReplace(Sub, #$A1#$F5, #13#10, []);
  Self.mSubText.Text := Sub;
end;

procedure TfrmMain.LoadSubtitleFile(const FileName: TFileName);
var
  i: Integer;

begin
  SCNFEditor.LoadFromFile(FileName);
  case SCNFEditor.GameVersion of
    gvDreamcast: eGameVersion.Text := 'Dreamcast';
    gvXbox     : eGameVersion.Text := 'Xbox';
  end;
  eCharID.Text := SCNFEditor.CharacterID;
  eVoiceID.Text := SCNFEditor.VoiceID;

  eSubCount.Text := IntToStr(SCNFEditor.SubtitlesList.Count);
  lbSubSelect.Clear;
  for i := 0 to SCNFEditor.SubtitlesList.Count - 1 do
    lbSubSelect.Items.Add(SCNFEditor.SubtitlesList[i].Code);

  if lbSubSelect.Items.Count > 0 then begin
    lbSubSelect.ItemIndex := 0;
    lbSubSelectClick(Self);
  end;

  SetFileOperationMenusItemEnabledState(True);
  // AddDebug('SCNF file "' + ExtractFileName(FileName) + '" loaded successfully.');
end;

procedure TfrmMain.Makebackup1Click(Sender: TObject);
begin
  MakeBackup := not MakeBackup;
end;

function TfrmMain.MsgBox(const Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMain.mSubTextChange(Sender: TObject);
var
  CurrentSub: TSubEntry;
  l1, l2: Integer;
  
{const
  MaxLineCount = 2;}

begin
  {if mSubText.Lines.Count > MaxLineCount then begin
    mSubText.Perform(EM_UNDO, 0, 0); // undo the last change
    MessageBeep(MB_OK);
  end;}

  // The EM_EMPTYUNDOBUFFER message clears the undo flag,
  // which means that you can no longer undo your last change
  // to the edit control.
  // mSubText.Perform(EM_EMPTYUNDOBUFFER, 0, 0);
  if Self.lbSubSelect.ItemIndex = -1 then Exit;

  CurrentSub := SCNFEditor.SubtitlesList[Self.lbSubSelect.ItemIndex];

  if CurrentSub.Text <> mSubText.Text then SetModified(True);
  CurrentSub.Text := mSubText.Text;

  CalculateCharsCount(CurrentSub.Text, l1, l2);
  Self.eFirstLineLength.Text := IntToStr(l1);
  Self.eSecondLineLength.Text := IntToStr(l2);
end;

procedure TfrmMain.Multitranslation1Click(Sender: TObject);
begin
  (*MsgBox('Ceci est une petite fonction bonus qui va prendre pas mal de temps à développer mais qui se révèlera très utile! ' +
    'En plus j''ai développé l''interface afin de l''implémenter. Ca reste la surprise du chef ;)', 'Surprise ;)', MB_ICONINFORMATION);
  Exit;*)
  
  frmMultiTranslation.ShowModal;

  (*CanDo := MsgBox('', 'Warning', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;   *)
end;

procedure TfrmMain.Opensinglefile1Click(Sender: TObject);
begin
  odMain.Title := 'Open NPC file from';
  odMain.Filter := 'All Files (*.*)|*.*';

  with odMain do
    if Execute then begin
      if not IsFileValidScnf(FileName) then begin
        MsgBox('This file isn''t a valid Shenmue II Free Quest subtitles format.', 'Not a valid SCNF file', MB_ICONWARNING);
        Exit;
      end;
      ResetApplication;
      SetSingleFileMenusItemState(True);
      Self.fTargetDirectory := ExtractFilePath(FileName);
      Self.lbFilesList.Items.Add(ExtractFileName(FileName));
      // Self.Multitranslation1.Enabled := True;
    end;
end;

procedure TfrmMain.ResetApplication;
begin
  Self.lbFilesList.Clear;
  Self.Clear;
  Clearfileslist1.Enabled := False;
  Self.Multitranslation1.Enabled := False;
end;

procedure TfrmMain.Save1Click(Sender: TObject);
begin
  if SCNFEditor.FileLoaded then begin
    SetStatus('Saving...');
    SCNFEditor.SaveToFile(SCNFEditor.GetLoadedFileName);
    AddDebug('File "' + SCNFEditor.GetLoadedFileName + '" successfully saved.');
    SetStatus('Ready');
    SetModified(False);
    {$IFDEF DEBUG} WriteLn('Saving file to: ', SCNFEditor.GetLoadedFileName); {$ENDIF}
  end; { else
    MsgBox('Please load a file first.', 'Warning', MB_ICONWARNING);}
end;

procedure TfrmMain.Saveas1Click(Sender: TObject);
begin
  sdMain.Title := 'Save patched NPC file to';
  sdMain.Filter := 'All Files (*.*)|*.*';
  sdMain.DefaultExt := '';

  if SCNFEditor.FileLoaded then begin
    with sdMain do begin
      FileName := SCNFEditor.GetLoadedFileName;
      if Execute then begin
        SCNFEditor.SaveToFile(FileName);
        SetModified(False);
      end;
    end;
  end; {else
    MsgBox('Please load a file first.', 'Warning', MB_ICONWARNING);}
end;

procedure TfrmMain.Savedebuglog1Click(Sender: TObject);
begin
  sdMain.Title := 'Save debug log as';
  sdMain.Filter := 'Debug Log Files (*.log)|*.log|Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
  sdMain.DefaultExt := 'log';

  with sdMain do
    if Execute then
      mDebug.Lines.SaveToFile(FileName);    
end;

procedure TfrmMain.ScanDirectory(const Directory: string);
begin
  // start the scanning thread
  SCNFScanner := TSCNFScanDirectory.Create(True);
  with SCNFScanner do begin
    FreeOnTerminate := True;
    OnTerminate := frmDirScan.DirectoryScanningEndEvent;
    fTargetDirectory := IncludeTrailingPathDelimiter(Directory);
    SetTargetDirectory(fTargetDirectory);
    Resume;
  end;

  ResetApplication;
  
  // show the progress window
  frmDirScan.ShowModal;
end;

procedure TfrmMain.Scandirectory1Click(Sender: TObject);
begin
  with frmSelectDir do begin
    eDirectory.Text := TargetDirectory;
    ShowModal;
    if ModalResult = mrOK then begin
      Clear;
      SetStatus('Scanning directory ... Please wait.');
      ScanDirectory(GetSelectedDirectory);
      Clearfileslist1.Enabled := True;
      Self.Multitranslation1.Enabled := Self.lbFilesList.Count > 1;
    end;
  end;
end;

procedure TfrmMain.SetAutoSave(const Value: Boolean);
begin
  fAutoSave := Value;
  Self.Autosave1.Checked := AutoSave;
end;

procedure TfrmMain.SetFileOperationMenusItemEnabledState(const State: Boolean);
begin
  Self.Importsubtitles1.Enabled := State;
  Self.Exportsubtitles1.Enabled := State;
  // Self.Multitranslation1.Enabled := State;
end;

procedure TfrmMain.SetFileSaveOperationsMenusItemEnabledState(
  const State: Boolean);
begin
  Self.Save1.Enabled := State;
  Self.Saveas1.Enabled := State;
end;

procedure TfrmMain.SetMakeBackup(const Value: Boolean);
begin
  fMakeBackup := Value;
  SCNFEditor.MakeBackup := Value;
  Self.Makebackup1.Checked := Value;
end;

procedure TfrmMain.SetModified(const State: Boolean);
begin
  if State then
    sb.Panels[1].Text := 'Modified'
  else
    sb.Panels[1].Text := '';
  fFileModified := State;
  SetFileSaveOperationsMenusItemEnabledState(State);
end;

procedure TfrmMain.SetSingleFileMenusItemState(const State: Boolean);
begin
  Self.Closesinglefile1.Enabled := State;
end;

procedure TfrmMain.SetStatus(const Text: string);
begin
  sb.Panels[2].Text := Text;
end;

end.
