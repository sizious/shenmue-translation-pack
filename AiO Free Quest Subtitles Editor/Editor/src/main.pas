//    This file is part of Shenmue AiO Free Quest Subtitles Editor.
//
//    Shenmue AiO Free Quest Subtitles Editor is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Shenmue AiO Free Quest Subtitles Editor is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue AiO Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Menus, ScnfEdit, MultiScan, ExtCtrls, ScnfScan,
  MultiTrad, JvExExtCtrls, JvExComCtrls, JvListView, Clipbrd, ShellApi,
  AppEvnts, FilesLst, SubsExp, JvBaseDlg, JvBrowseFolder, Viewer_Intf;

const
  APP_VERSION = '2.1';
  COMPIL_DATE_TIME = 'July 11, 2009 @01:41AM';

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Opensinglefile1: TMenuItem;
    Scandirectory1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ools1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    N2: TMenuItem;
    Clearfileslist1: TMenuItem;
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
    Findsubtitle1: TMenuItem;
    N7: TMenuItem;
    gbFilesList: TGroupBox;
    lbFilesList: TListBox;
    pcSubs: TPageControl;
    tsEditor: TTabSheet;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    eSecondLineLength: TEdit;
    eFirstLineLength: TEdit;
    mSubText: TMemo;
    eSubCount: TEdit;
    eCharID: TEdit;
    tsMultiTrad: TTabSheet;
    Label10: TLabel;
    GroupBox2: TGroupBox;
    GroupBox4: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    bRetrieveSubs: TButton;
    Panel2: TPanel;
    Label9: TLabel;
    eFilesCount: TEdit;
    gbDebug: TGroupBox;
    mDebug: TMemo;
    sb: TStatusBar;
    pmSubsSelect: TPopupMenu;
    Copy1: TMenuItem;
    N8: TMenuItem;
    Savetofile1: TMenuItem;
    miSubsPreview: TMenuItem;
    sdSubsList: TSaveDialog;
    lvSubsSelect: TJvListView;
    N9: TMenuItem;
    Exportsubtitles2: TMenuItem;
    Importsubtitles2: TMenuItem;
    pmFilesList: TPopupMenu;
    miFileProperties: TMenuItem;
    Opendirectory1: TMenuItem;
    Locatefile1: TMenuItem;
    N10: TMenuItem;
    miFileProperties2: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    Batchimportsubtitles1: TMenuItem;
    Batchexportsubtitles1: TMenuItem;
    N13: TMenuItem;
    miReloadDir: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    bfdExportSubs: TJvBrowseForFolderDialog;
    mOldSubEd: TMemo;
    Label18: TLabel;
    lGender: TLabel;
    rbMale: TRadioButton;
    rbFemale: TRadioButton;
    Panel1: TPanel;
    iFace: TImage;
    Panel4: TPanel;
    lCharType: TLabel;
    rbAdult: TRadioButton;
    rbChild: TRadioButton;
    Label7: TLabel;
    eVoiceID: TEdit;
    eGame: TEdit;
    Label5: TLabel;
    Website1: TMenuItem;
    N14: TMenuItem;
    rbatUnknow: TRadioButton;
    rbcgUnknow: TRadioButton;
    View1: TMenuItem;
    N15: TMenuItem;
    miExportFilesList: TMenuItem;
    tvMultiSubs: TTreeView;
    Memo1: TMemo;
    Memo2: TMemo;
    bMultiTranslate: TButton;
    procedure Scandirectory1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbFilesListClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
    procedure FormActivate(Sender: TObject);
    procedure bRetrieveSubsClick(Sender: TObject);
    procedure bMultiTranslateClick(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Savetofile1Click(Sender: TObject);
    procedure miSubsPreviewClick(Sender: TObject);
    procedure lvSubsSelectClick(Sender: TObject);
    procedure lvSubsSelectKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miFilePropertiesClick(Sender: TObject);
    procedure lbFilesListContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbFilesListDblClick(Sender: TObject);
    procedure Locatefile1Click(Sender: TObject);
    procedure Opendirectory1Click(Sender: TObject);
    procedure miFileProperties2Click(Sender: TObject);
    procedure Batchexportsubtitles1Click(Sender: TObject);
    procedure miReloadDirClick(Sender: TObject);
    procedure Batchimportsubtitles1Click(Sender: TObject);
    procedure ApplicationEventsHint(Sender: TObject);
    procedure lbFilesListKeyPress(Sender: TObject; var Key: Char);
    procedure Website1Click(Sender: TObject);
    procedure miExportFilesListClick(Sender: TObject);
  private
    { Déclarations privées }
    fTargetFileName: TFileName;
    fSelectedDirectory: string;
    fFileModified: Boolean;
    fAutoSave: Boolean;
    fMakeBackup: Boolean;
    fSubsViewerVisible: Boolean;
    fEnableCharsMod: Boolean;
    fCanEnableCharsMod: Boolean;
    fWorkFilesList: TFilesList;
    procedure SetFileOperationMenusItemEnabledState(const State: Boolean);
    procedure SetAutoSave(const Value: Boolean);
    procedure SetMakeBackup(const Value: Boolean);
    procedure ResetApplication;
    procedure SetSingleFileMenusItemState(const State: Boolean);
    procedure SetFileSaveOperationsMenusItemEnabledState(const State: Boolean);
    procedure SaveSubtitlesList(const FileName: TFileName);
    procedure RefreshSubtitlesList(UpdateView: Boolean);
    procedure BatchExportSubtitles(const OutputDirectory: TFileName);
    procedure SetEnableCharsMod(const Value: Boolean);
    procedure SetCanEnableCharsMod(const Value: Boolean);
  protected
    procedure PreviewWindowClosedEvent(Sender: TObject);
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
    procedure RetrieveSubtitles;
    procedure MultiTranslateSubtitles;
    procedure MultiTranslationFillControls;

    property AutoSave: Boolean read fAutoSave write SetAutoSave;
    property FileModified: Boolean read fFileModified;
    property MakeBackup: Boolean read fMakeBackup write SetMakeBackup;
    property SubsViewerVisible: Boolean read fSubsViewerVisible write fSubsViewerVisible; 
    property SelectedDirectory: string read fSelectedDirectory write fSelectedDirectory;

    property CanEnableCharsMod: Boolean read fCanEnableCharsMod write SetCanEnableCharsMod;
    property EnableCharsMod: Boolean read fEnableCharsMod write SetEnableCharsMod;

    property WorkFilesList: TFilesList read fWorkFilesList write fWorkFilesList;
  end;

var
  frmMain: TfrmMain;

  SCNFScanner: TSCNFScanDirectory;                    // enable to scan directory to retrieve valid SCNF files
  SCNFEditor: TSCNFEditor;                            // enable to edit any valid SCNF file: this's the main class of this application

  SubsRetriever: TMultiTranslationSubtitlesRetriever; // enable to retrieve all subtitles from loaded file list
  MultiTranslator: TMultiTranslator;                  // enable to multi-translate subtitles
  BatchSubsExporter: TSubsMassExporterThread;         // enable to batch export subtitles

  Previewer: TSubtitlesPreviewWindow;                 // Implements the Subtitles Previewer

implementation

uses
  Progress, SelDir, MultiTrd, ScnfUtil, Utils, CharsCnt, CharsLst, FileInfo,
  MassImp, Common, NPCInfo, VistaUI, TextData;

{$R *.dfm}

const
  WIN_MIN_HEIGHT = 550;
  WIN_MIN_WIDTH = 580;

{ TfrmMain }

procedure TfrmMain.About1Click(Sender: TObject);
begin
  MsgBox('Version ' + APP_VERSION + #13#10
  + 'Created by [big_fury]SiZiOUS, additionnal code by Manic' + #13#10 + COMPIL_DATE_TIME + #13#10#13#10
  + 'Engine version: ' + SCNF_EDITOR_ENGINE_VERSION + #13#10
  + 'Engine date: ' + SCNF_EDITOR_ENGINE_COMPIL_DATE_TIME, 'Information', MB_ICONINFORMATION);
end;

procedure TfrmMain.ActiveMultifilesOptions;
begin
  EXIT; // DEBUG

  Self.Clearfileslist1.Enabled := True;
  Self.Multitranslation1.Enabled := True;
end;

procedure TfrmMain.AddDebug(m: string);
begin
  mDebug.Lines.Add('[' + DateToStr(Date) + ' ' + TimeToStr(Now) + '] ' + m);
end;

procedure TfrmMain.ApplicationEventsHint(Sender: TObject);
begin
  if Sender is TMenuItem then AddDebug(Application.Hint)
end;

procedure TfrmMain.Autosave1Click(Sender: TObject);
begin
  AutoSave := not AutoSave;
  {$IFDEF DEBUG} WriteLn('AutoSave: ', AutoSave); {$ENDIF}
end;

procedure TfrmMain.BatchExportSubtitles(const OutputDirectory: TFileName);
var
  Temp: TFilesList;
  i: Integer;

begin
  Temp := TFilesList.Create;
  try
    for i := 0 to lbFilesList.Items.Count - 1 do
      Temp.Add(Self.GetTargetDirectory + lbFilesList.Items[i]);

    BatchSubsExporter := TSubsMassExporterThread.Create(OutputDirectory, Temp);
    frmProgress.Mode := pmBatchSubsExport;
    BatchSubsExporter.Resume;
    frmProgress.ShowModal;
  finally
    Temp.Free;
  end;
end;

procedure TfrmMain.Batchexportsubtitles1Click(Sender: TObject);
begin
  with bfdExportSubs do begin
    Directory := GetTargetDirectory;
    if Execute then
      BatchExportSubtitles(Directory);
  end;
end;

procedure TfrmMain.Batchimportsubtitles1Click(Sender: TObject);
begin
  frmMassImport.ShowModal;
end;

procedure TfrmMain.bMultiTranslateClick(Sender: TObject);
begin
  MultiTranslateSubtitles;
end;

procedure TfrmMain.bRetrieveSubsClick(Sender: TObject);
begin
  RetrieveSubtitles;
end;

procedure TfrmMain.charsModMenu1Click(Sender: TObject);
begin
  EnableCharsMod := not EnableCharsMod;
end;

procedure TfrmMain.Clear;
begin
  Self.SetFileOperationMenusItemEnabledState(False);
  Self.SetFileSaveOperationsMenusItemEnabledState(False);
  //rbDC.Checked := False;
  //rbXB.Checked := False;
  eGame.Clear;
  eCharID.Clear;
  eVoiceID.Clear;
  eFirstLineLength.Text := '0';
  eSecondLineLength.Text := '0';
  eSubCount.Text := '0';
  mSubText.Text := '';
  lvSubsSelect.Clear;
  eFilesCount.Text := IntToStr(lbFilesList.Count);
  SetStatus('Ready');
  SetModified(False);
  mOldSubEd.Clear;
  Self.rbMale.Checked := False;
  Self.rbFemale.Checked := False;
  Self.rbAdult.Checked := False;
  Self.rbChild.Checked := False;
  Self.iFace.Picture := nil;
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

procedure TfrmMain.Copy1Click(Sender: TObject);
var
  i: Integer;

begin
  i := lvSubsSelect.ItemIndex ;
  if i <> -1 then begin
    Clipboard.SetTextBuf(PChar(lvSubsSelect.Items[i].SubItems[0]));
  end;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miExportFilesListClick(Sender: TObject);
begin
  with sdMain do begin
    FileName := ExtremeRight('\', Copy(SelectedDirectory, 1, Length(SelectedDirectory)-1)) + '_FilesList.txt';
    Title := 'Export files list to...';
    DefaultExt := 'txt';
    Filter := 'Text Files (*.txt)|*.txt';
    if Execute then
      lbFilesList.Items.SaveToFile(FileName);
  end;
end;

procedure TfrmMain.Exportsubtitles1Click(Sender: TObject);
begin
  sdMain.Title := 'Export subtitles to';
  sdMain.Filter := 'XML Files (*.xml)|*.xml';
  sdMain.DefaultExt := 'xml';

  with sdMain do begin
    FileName := ChangeFileExt(SCNFEditor.SourceFileName, '.xml');
    if Execute then begin
      SCNFEditor.Subtitles.ExportToFile(FileName);
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
      if SCNFEditor.Subtitles.ImportFromFile(FileName) then begin
        //lbFilesListClick(Self);
        RefreshSubtitlesList(True);
        SetModified(True);
        AddDebug('Subtitles imported from ' + ExtractFileName(FileName) + ' file.');
      end
      else begin
        AddDebug('Subtitles importation: Error » XML not valid for the current file.');
      end;
    end;
  end;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  // --- DEBUG -----------------------------------------------------------------
  //ScanDirectory('H:\SHENMUE II XBOX\research\specials_pks\');
  // --- DEBUG -----------------------------------------------------------------
  //BringToFront;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  CanDo: Integer;

begin
  // autosave
  if FileModified then
    if AutoSave then
      Save1Click(lbFilesList)
    else begin
      CanDo := MsgBox('Do you want to save file modifications ?', 'Save changes?', MB_YESNOCANCEL + MB_ICONWARNING);
      case CanDo of
         IDCANCEL : begin
                      Action := caNone;
                      Exit;
                    end;
         IDYES    : Save1Click(lbFilesList);
      end;
    end;

  // Free the Previewer
  Previewer.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
{var
  i: Integer;
  c: TControl;}
  
begin
  // SetVistaFonts(Self);
  
  Caption := Application.Title + ' - v' + APP_VERSION + ' - by [big_fury]SiZiOUS';

  //DoubleBuffered := True;
  //lbSubSelect.DoubleBuffered := True;
  //pcSubs.DoubleBuffered := True;

  WorkFilesList := TFilesList.Create;

  // Create the Subtitles Previewer
  Previewer := TSubtitlesPreviewWindow.Create;
  Previewer.OnWindowClosed := PreviewWindowClosedEvent;

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
//  LoadConfig;

  // Loading chars list
  CanEnableCharsMod := SCNFEditor.CharsList.LoadFromFile('data\chars_list.csv');
  EnableCharsMod := CanEnableCharsMod;
  
  if not CanEnableCharsMod then
    AddDebug('WARNING: Unable to enable subtitles text characters modifications. data\chars_list.csv file not found.');

  // Loading CharsID info
  SCNFEditor.NPCInfos.LoadFromFile('data\npc_info.csv');
  if not SCNFEditor.NPCInfos.Loaded then begin
    AddDebug('WARNING: Unable to get NPC characters info. data\npc_infos.csv file not found.');
    lGender.Enabled := False;
    lCharType.Enabled := False;
  end;

  // Constraints for the form
  Self.Height := WIN_MIN_HEIGHT;
  Self.Width := WIN_MIN_WIDTH;
  Self.Constraints.MinHeight := WIN_MIN_HEIGHT;
  Self.Constraints.MinWidth := WIN_MIN_WIDTH;

  // contraintes pour la zone de texte d'entrée de sous-titres
  {with mSubText.Constraints do begin
    MinHeight := 80;
    MinWidth := 240;
  end;

  with lbSubSelect.Constraints do begin
    MinHeight := 82;
    MinWidth := 240;
  end;

  with Self.lbFilesList.Constraints do begin
    MinWidth := Self.lbFilesList.Width;
  end;

  with Self.pcSubs do begin
    Constraints.MinWidth := Width;
    Constraints.MinHeight := Height;
  end;}

  //Self.mDebug.Constraints.MinHeight := 50;

  {for i := 0 to Self.ComponentCount - 1 do
    if Self.Components[i] is TControl then
      if not (Self.Components[i] is TSplitter) then begin
         c := Self.Components[i] as TControl;
         c.Constraints.MinHeight := c.Height;
         c.Constraints.MinWidth := c.Width;
      end;}
  //Self.lbFilesList.Constraints.MinHeight := 20;
  //Self.gbFilesList.Constraints.MinHeight := 0

  pcSubs.TabIndex := 0;

  // Load config
  LoadConfig;

  //----------------------------------------------------------------------------
  // DEBUG
  //----------------------------------------------------------------------------
  {$IFNDEF DEBUG} tsMultiTrad.TabVisible := False; {$ENDIF}
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Saving configuration
  SaveConfig;

  SCNFEditor.Free;
  WorkFilesList.Free;
end;

function TfrmMain.GetTargetDirectory: string;
begin
  Result := fSelectedDirectory;
end;

function TfrmMain.GetTargetFileName: TFileName;
begin
  Result := fTargetFileName;
end;

procedure TfrmMain.lbFilesListClick(Sender: TObject);
var
  CanDo: Integer;
  _newFile: TFileName;
  
begin
  if lbFilesList.ItemIndex = -1 then Exit;

  _newFile := GetTargetDirectory + lbFilesList.Items[lbFilesList.ItemIndex];

  // do nothing if same item selected...
  if UpperCase(ExtractFileName(_newFile)) = UpperCase(ExtractFileName(GetTargetFileName)) then
    if lvSubsSelect.Items.Count <> 0 then Exit;

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
  fTargetFileName := _newFile;
  LoadSubtitleFile(GetTargetFileName);
end;

procedure TfrmMain.lbFilesListContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  Point : TPoint;

begin
  // enable right-click selection
  GetCursorPos(Point);
  Mouse_Event(MOUSEEVENTF_LEFTDOWN, Point.X, Point.Y, 0, 0);
  Mouse_Event(MOUSEEVENTF_LEFTUP, Point.X, Point.Y, 0, 0);
  Application.ProcessMessages;

  // enable or not some menus
  miFileProperties.Enabled := (lbFilesList.ItemIndex <> -1);
  miFileProperties2.Enabled := miFileProperties.Enabled;
  miReloadDir.Enabled := DirectoryExists(SelectedDirectory);
  miExportFilesList.Enabled := lbFilesList.Items.Count > 0;
end;

procedure TfrmMain.lbFilesListDblClick(Sender: TObject);
begin
  miFilePropertiesClick(Self);
end;

procedure TfrmMain.lbFilesListKeyPress(Sender: TObject; var Key: Char);
begin
    if (lbFilesList.ItemIndex <> -1) and (Ord(Key) = VK_RETURN) then
    miFilePropertiesClick(Self);
end;

procedure TfrmMain.RefreshSubtitlesList(UpdateView: Boolean);
var
  i: Integer;
  SubText: string;

begin
  if UpdateView then begin

    // Updating current view
    for i := 0 to SCNFEditor.Subtitles.Count - 1 do begin
      SubText := StringReplace(SCNFEditor.Subtitles[i].Text, #13#10, '<br>', [rfReplaceAll]);
      lvSubsSelect.Items[i].SubItems[1] := SubText;
    end;

    i := lvSubsSelect.ItemIndex;
    if (i <> -1) then mOldSubEd.Text := SCNFEditor.Subtitles[i].Text;

  end else begin

    // Adding new subs
    lvSubsSelect.Clear;

    for i := 0 to SCNFEditor.Subtitles.Count - 1 do begin
      with lvSubsSelect.Items.Add do begin
        Caption := SCNFEditor.Subtitles[i].CharID;
        SubItems.Add(SCNFEditor.Subtitles[i].Code);
        SubText := StringReplace(SCNFEditor.Subtitles[i].Text, #13#10, '<br>', [rfReplaceAll]);
        SubItems.Add(SubText);
      end;
    end;

  end;
end;

procedure TfrmMain.miReloadDirClick(Sender: TObject);
begin
  ScanDirectory(GetTargetDirectory);
end;

procedure TfrmMain.LoadSubtitleFile(const FileName: TFileName);
var
  PictFile, GameVersionFolder: TFileName;
  GenderChar, AgeChar: string;
  LoadRes: Boolean;

begin
  Clear;

  LoadRes := SCNFEditor.LoadFromFile(FileName);
  if not LoadRes then begin
    GenderChar := 'ERROR: File "' + FileName + '" is UNREADABLE!';
    AgeChar := 'ERROR: File "' + ExtractFileName(FileName) + '" is UNREADABLE!';
    AddDebug(GenderChar);
    MsgBox(AgeChar, 'FATAL ERROR !', MB_ICONERROR);
    Exit;
  end;

  // version
  case SCNFEditor.GameVersion of
    gvShenmue2    : begin
                      eGame.Text := 'Shenmue II (DC)'; //rbDC.Checked := True;
                      GameVersionFolder := 'shenmue2';
                    end;
    gvShenmue2X   : begin
                      eGame.Text := 'Shenmue II (XBOX)'; //rbXB.Checked := True;
                      GameVersionFolder := 'shenmue2';
                    end;
    gvShenmue     : begin
                      eGame.Text := 'Shenmue I (DC)';
                      GameVersionFolder := 'shenmue';
                    end;
    gvWhatsShenmue: begin
                      eGame.Text := 'What''s Shenmue (DC)';
                      GameVersionFolder := 'whats';
                    end;
  end;
  eCharID.Text := SCNFEditor.CharacterID;
  eVoiceID.Text := SCNFEditor.VoiceShortID;

  rbcgUnknow.Checked := True;
  rbatUnknow.Checked := True;
  case SCNFEditor.Gender of
    gtMale:   begin
                GenderChar := 'M';
                rbMale.Checked := True;
              end;
    gtFemale: begin
                GenderChar := 'F';
                rbFemale.Checked := True;
              end;
  end;

  case SCNFEditor.AgeType of
    atAdult:  begin
                AgeChar := 'A';
                rbAdult.Checked := True;
              end;
    atChild:  begin
                AgeChar := 'C';
                rbChild.Checked := True;
              end;
  end;

  eSubCount.Text := IntToStr(SCNFEditor.Subtitles.Count);
  RefreshSubtitlesList(False);

  if lvSubsSelect.Items.Count > 0 then begin
    lvSubsSelect.ItemIndex := 0;
    lvSubsSelectClick(Self);
    Self.miSubsPreview.Enabled := True;
  end else
    if Previewer.IsVisible then Previewer.Clear;

  SetFileOperationMenusItemEnabledState(True);
  // AddDebug('SCNF file "' + ExtractFileName(FileName) + '" loaded successfully.');

  // load face
  PictFile := ExtractFilePath(Application.ExeName) + '\data\faces\'
    + GameVersionFolder + '\' + SCNFEditor.CharacterID + GenderChar + '_'
    + AgeChar + '.JPG';

  if FileExists(PictFile) then
    iFace.Picture.LoadFromFile(PictFile)
  else
    iFace.Picture := nil;

  // Refresh FileInfo dialog
  frmFileInfo.LoadFileInfo;
end;

procedure TfrmMain.Locatefile1Click(Sender: TObject);
var
  FName: string;

begin
  FName := SCNFEditor.GetLoadedFileName;
  ShellExecute(Handle, 'open', 'explorer', PChar('/e,/select,' + FName), '', SW_SHOWNORMAL);
end;

procedure TfrmMain.lvSubsSelectClick(Sender: TObject);
var
  Sub: string;
  i: Integer;
  
begin
  i := Self.lvSubsSelect.ItemIndex;
  if i <> -1 then begin
    Sub := SCNFEditor.Subtitles[i].Text;
    Self.mSubText.Text := Sub;
    Self.mOldSubEd.Text := Sub;
  end;
end;

procedure TfrmMain.lvSubsSelectKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  lvSubsSelectClick(Self);
end;

procedure TfrmMain.Makebackup1Click(Sender: TObject);
begin
  MakeBackup := not MakeBackup;
end;

procedure TfrmMain.miSubsPreviewClick(Sender: TObject);
begin
  miSubsPreview.Checked := not miSubsPreview.Checked;
  SubsViewerVisible := miSubsPreview.Checked;

  if SubsViewerVisible then begin
    Previewer.Show(Self.mSubText.Text)
  end else
    Previewer.Hide;
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
  if Self.lvSubsSelect.ItemIndex = -1 then Exit;

  CurrentSub := SCNFEditor.Subtitles[Self.lvSubsSelect.ItemIndex];

  if CurrentSub.Text <> mSubText.Text then SetModified(True);
  CurrentSub.Text := mSubText.Text;

  //update listbox
  //Self.lvSubsSelect.Items[Self.lvSubsSelect.ItemIndex] := CurrentSub.Code + ': ' + CurrentSub.Text;
  // lvSubsSelect.Items[lvSubsSelect.ItemIndex].SubItems[0] := CurrentSub.Text;
  lvSubsSelect.Items[lvSubsSelect.ItemIndex].SubItems[1] := StringReplace(CurrentSub.Text, #13#10, '<br>', [rfReplaceAll]);

  CalculateCharsCount(CurrentSub.Text, l1, l2);
  Self.eFirstLineLength.Text := IntToStr(l1);
  Self.eSecondLineLength.Text := IntToStr(l2);

  if SubsViewerVisible then
    Previewer.Update(Self.mSubText.Text);
end;

procedure TfrmMain.MultiTranslateSubtitles;
begin
  SetStatus('Translating subtitles ... Please wait.');

  // start the retrieving scanner thread
  MultiTranslator := TMultiTranslator.Create(True);
  with MultiTranslator do begin
    FreeOnTerminate := True;
    // OnTerminate := frmProgress.MultiTranslatorEndEvent;
    // FileList := frmMain.lbFilesList.Items.Text;
    Resume;
  end;

  // show the progress window
  frmProgress.ShowModal;
end;

procedure TfrmMain.Multitranslation1Click(Sender: TObject);
begin
  if frmMultiTranslation.Visible then
    frmMultiTranslation.Close
  else
    frmMultiTranslation.Show;
    
  Multitranslation1.Checked := frmMultiTranslation.Visible;
end;

procedure TfrmMain.MultiTranslationFillControls;
var
  i,j: Integer;
  SubTitle, Code, FileName: string;
  List: ISubtitleInfoList;
  ParentNode, FileNode: TTreeNode;

begin
  AddDebug('Files list scanned successfully. ' + IntToStr(MultiTranslationTextData.Subtitles.Count) + ' subtitle(s) retrieved.');

  for i := 0 to MultiTranslationTextData.Subtitles.Count - 1 do begin
    SubTitle := MultiTranslationTextData.Subtitles[i];
    List := MultiTranslationTextData.GetSubtitleInfo(SubTitle);

    if List <> nil then begin
    
      ParentNode := tvMultiSubs.Items.Add(nil, SubTitle);

      for j := 0 to List.Count - 1 do begin
        FileName := ExtractFileName(List.Items[j].FileName);
        Code := List.Items[j].Code;

        FileNode := FindNode(ParentNode, FileName);
        if FileNode = nil then
          FileNode := tvMultiSubs.Items.AddChild(ParentNode, FileName);

        tvMultiSubs.Items.AddChild(FileNode, Code);
      end;

    end;

  end;
end;

procedure TfrmMain.Opendirectory1Click(Sender: TObject);
var
  FName: string;

begin
  FName := ExtractFilePath(SCNFEditor.GetLoadedFileName);
  ShellExecute(Handle, 'open', 'explorer', PChar(FName), '', SW_SHOWNORMAL);
end;

procedure TfrmMain.Opensinglefile1Click(Sender: TObject);
begin
  odMain.Title := 'Open NPC file from';
  odMain.DefaultExt := '.pks';
  odMain.Filter := 'PAKS Files (*.PKS)|*.PKS|All Files (*.*)|*.*';

  with odMain do
    if Execute then begin
      if not IsFileValidScnf(FileName) then begin
        MsgBox('This file isn''t a valid Shenmue Free Quest subtitles format.', 'Not a valid PAKS SCNF file', MB_ICONWARNING);
        Exit;
      end;
      ResetApplication;
      SetSingleFileMenusItemState(True);
      Self.fSelectedDirectory := ExtractFilePath(FileName);
      Self.lbFilesList.Items.Add(ExtractFileName(FileName));
      if lbFilesList.Count > 0 then begin
        lbFilesList.ItemIndex := 0;
        lbFilesListClick(Self);
      end;
      
      // Self.Multitranslation1.Enabled := True;
    end;
end;

procedure TfrmMain.PreviewWindowClosedEvent(Sender: TObject);
begin
  // ShowMessage('CLOSED');
  Self.miSubsPreview.Checked := False;
end;

procedure TfrmMain.miFileProperties2Click(Sender: TObject);
begin
  miFilePropertiesClick(Self);
end;

procedure TfrmMain.miFilePropertiesClick(Sender: TObject);
begin
  frmFileInfo.Show;
end;

procedure TfrmMain.ResetApplication;
begin
  Self.lbFilesList.Clear;
  Self.Clear;
  Clearfileslist1.Enabled := False;
  Self.Multitranslation1.Enabled := False;
  Self.Batchimportsubtitles1.Enabled := False;
  Self.Batchexportsubtitles1.Enabled := False;
  if SubsViewerVisible then Previewer.Clear();
end;

procedure TfrmMain.RetrieveSubtitles;
begin
  // start the retrieving scanner thread
  SubsRetriever := TMultiTranslationSubtitlesRetriever.Create(SelectedDirectory, lbFilesList.Items.Text);
  frmProgress.Mode := pmMultiScan;
//  SubsRetriever.OnCompleted := MultiTranslationFillControls;

  SubsRetriever.Resume;

  // show the progress window
  frmProgress.ShowModal;
end;

procedure TfrmMain.Save1Click(Sender: TObject);
begin
  if SCNFEditor.FileLoaded then begin
    SetStatus('Saving...');
    SCNFEditor.SaveToFile(SCNFEditor.GetLoadedFileName);
    AddDebug('File "' + SCNFEditor.GetLoadedFileName + '" successfully saved.');
    SetStatus('Ready');
    SetModified(False);
    {$IFDEF DEBUG} WriteLn('Saving file : ', ExtractFileName(SCNFEditor.GetLoadedFileName), #13#10); {$ENDIF}
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
        {$IFDEF DEBUG} WriteLn('Saving file to: ', SCNFEditor.GetLoadedFileName, #13#10); {$ENDIF}
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

procedure TfrmMain.SaveSubtitlesList(const FileName: TFileName);
var
  FileFormat, IndexText, SubText: string;
  i: Integer;
  List: TStringList;

begin
  FileFormat := ExtractFileExt(FileName);
  List := TStringList.Create;
  try
    if LowerCase(FileFormat) = '.csv' then begin

      // CSV format
      List.Add('Index;Code;Subtitle');
      for i := 0 to ScnfEditor.Subtitles.Count - 1 do begin
        IndexText := IntToStr(i + 1);
        SubText := StringReplace(ScnfEditor.Subtitles[i].Text, #13#10, '<br>', [rfReplaceAll]);
        List.Add(IndexText + ';' + ScnfEditor.Subtitles[i].Code + ';' + SubText);
      end;

    end else begin

      // Text format
      for i := 0 to ScnfEditor.Subtitles.Count - 1 do begin
        SubText := StringReplace(ScnfEditor.Subtitles[i].Text, #13#10, '<br>', [rfReplaceAll]);
        List.Add(ScnfEditor.Subtitles[i].Code + ': ' + SubText);
      end;

    end;
    
    List.SaveToFile(FileName);

  finally
    List.Free;
  end;
end;

procedure TfrmMain.Savetofile1Click(Sender: TObject);
begin
  with sdSubsList do begin
    sdSubsList.FileName := ChangeFileExt(SCNFEditor.GetLoadedFileName, '');
    if Execute then SaveSubtitlesList(sdSubsList.FileName);
  end;
end;

procedure TfrmMain.ScanDirectory(const Directory: string);
begin
  // init main form
  ResetApplication;

  // start the scanning thread
  SelectedDirectory := IncludeTrailingPathDelimiter(Directory);

  SCNFScanner := TSCNFScanDirectory.Create(SelectedDirectory);
  frmProgress.Mode := pmSCNFScanner;

  SCNFScanner.Resume;

  frmProgress.ShowModal;

  Clearfileslist1.Enabled := True;
  Self.Batchimportsubtitles1.Enabled := True;
  Self.Batchexportsubtitles1.Enabled := True;
  //Self.Multitranslation1.Enabled := Self.lbFilesList.Count > 1;
  //Self.miSubsPreview.Enabled := Self.lbFilesList.Count > 1;
end;

procedure TfrmMain.Scandirectory1Click(Sender: TObject);
begin
  with frmSelectDir do begin
    eDirectory.Text := SelectedDirectory;
    ShowModal;
    if ModalResult = mrOK then
      ScanDirectory(GetSelectedDirectory);
  end;
end;

procedure TfrmMain.SetAutoSave(const Value: Boolean);
begin
  fAutoSave := Value;
  Self.Autosave1.Checked := AutoSave;
end;

procedure TfrmMain.SetCanEnableCharsMod(const Value: Boolean);
begin
  fCanEnableCharsMod := Value;
  charsModMenu1.Enabled := Value;
end;

procedure TfrmMain.SetEnableCharsMod(const Value: Boolean);
begin
  charsModMenu1.Checked := Value;
  if SCNFEditor.CharsList.Loaded then begin
    fEnableCharsMod := Value;
    SCNFEditor.CharsList.Active := Value;
    RefreshSubtitlesList(True);
  end;
end;

procedure TfrmMain.SetFileOperationMenusItemEnabledState(const State: Boolean);
begin
  Self.Importsubtitles1.Enabled := State;
  Self.Exportsubtitles1.Enabled := State;
  Self.miFileProperties.Enabled := State;
  Self.miFileProperties2.Enabled := State;
  if State then
    lvSubsSelect.PopupMenu := pmSubsSelect
  else
    lvSubsSelect.PopupMenu := nil;
  Self.Locatefile1.Enabled := State;
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

procedure TfrmMain.Website1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://shenmuesubs.sourceforge.net/', '', '', SW_SHOWNORMAL);
end;

end.
