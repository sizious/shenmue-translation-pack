unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, JvExStdCtrls, JvCombobox, JvDriveCtrls,
  OpThBase, DiscAuth, Packer, JvBaseDlg, JvBrowseFolder, ExtDlgs, JvDialogs,
  JvRichEdit, Mask, JvExMask, JvToolEdit, JvMaskEdit, JvCheckedMaskEdit,
  JvDatePickerEdit, GIFImg;

type
  TfrmMain = class(TForm)
    pnlBottom: TPanel;
    Bevel1: TBevel;
    btnAbout: TButton;
    btnMake: TButton;
    btnQuit: TButton;
    pcMain: TPageControl;
    tsGeneral: TTabSheet;
    tsUnlock: TTabSheet;
    tsSkin: TTabSheet;
    gbxSource: TGroupBox;
    edtSourceDir: TEdit;
    btnSourceDir: TButton;
    Label1: TLabel;
    tsEula: TTabSheet;
    GroupBox4: TGroupBox;
    gbxDiscKeys: TGroupBox;
    sbMain: TStatusBar;
    pbMain: TProgressBar;
    shpTop: TShape;
    bvlTop: TBevel;
    lblTitleHint: TLabel;
    lvDiscKeys: TListView;
    tsConfig: TTabSheet;
    gbxUI: TGroupBox;
    Label2: TLabel;
    edtAppConfig: TEdit;
    btnAppConfig: TButton;
    gbxDestination: TGroupBox;
    Label5: TLabel;
    edtDestDir: TEdit;
    btnDestDir: TButton;
    Label7: TLabel;
    gbxDiscKeysMgr: TGroupBox;
    cbxDrives: TJvDriveCombo;
    btnAddKey: TButton;
    btnDelKey: TButton;
    Label8: TLabel;
    bfd: TJvBrowseForFolderDialog;
    gbxGlobalSkin: TGroupBox;
    Label10: TLabel;
    edtSkinTop: TEdit;
    btnSkinTop: TButton;
    edtSkinBottom: TEdit;
    Label11: TLabel;
    btnSkinBottom: TButton;
    gbxCenterSkin: TGroupBox;
    Label12: TLabel;
    lvwSkinLeft: TListView;
    btnSkinLeftAdd: TButton;
    btnSkinLeftDel: TButton;
    od: TOpenDialog;
    opd: TOpenPictureDialog;
    gbxKeysAuth: TGroupBox;
    lblPC1: TLabel;
    lblCamellia: TLabel;
    lblAES: TLabel;
    Label6: TLabel;
    edtPC1: TEdit;
    edtCamellia: TEdit;
    btnPC1: TButton;
    btnCamellia: TButton;
    edtAES: TEdit;
    btnAES: TButton;
    btnLoadMediaKeys: TButton;
    odMediaKey: TJvOpenDialog;
    btnSaveMediaKeys: TButton;
    sdMediaKey: TJvSaveDialog;
    lblAppTitle: TLabel;
    imgTitleIcon: TImage;
    tsLogger: TTabSheet;
    mLog: TMemo;
    reEula: TJvRichEdit;
    btnOpenSourceDir: TButton;
    btnOpenDestDir: TButton;
    tsInfo: TTabSheet;
    grpReleaseInfo: TGroupBox;
    edtAuthor: TEdit;
    edtWebURL: TEdit;
    edtReleaseDate: TJvDatePickerEdit;
    edtVersion: TEdit;
    Label4: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    btnWebURL: TButton;
    edtGameName: TComboBox;
    grpWizardTitle: TGroupBox;
    Label3: TLabel;
    imgWizardTitleExample: TImage;
    edtWizardTitle: TEdit;
    cbxShowAppName: TCheckBox;
    gbxEULA: TGroupBox;
    Label9: TLabel;
    edtEULA: TEdit;
    btnEULA: TButton;
    cbxProtocolWebURL: TComboBox;
    opdPackIcon: TOpenPictureDialog;
    gbxPackIcon: TGroupBox;
    pnlPackIcon: TPanel;
    imgPackIcon: TImage;
    btnPackIconLoad: TButton;
    btnPackIconDefault: TButton;
    edtPackIcon: TEdit;
    Label22: TLabel;
    tsColors: TTabSheet;
    gbxTextColors: TGroupBox;
    Label23: TLabel;
    Label25: TLabel;
    clbText: TColorBox;
    clbWarning: TColorBox;
    gbxBkgndColors: TGroupBox;
    clbLeft: TColorBox;
    Label21: TLabel;
    clbTop: TColorBox;
    Label18: TLabel;
    Label19: TLabel;
    clbBottom: TColorBox;
    clbCenter: TColorBox;
    Label20: TLabel;
    gbxLinksColor: TGroupBox;
    Label24: TLabel;
    clbLinks: TColorBox;
    Label27: TLabel;
    clbLinksClicked: TColorBox;
    Label28: TLabel;
    clbLinksHot: TColorBox;
    pnlColorsPreview: TPanel;
    pnlColorsPreviewForm: TPanel;
    pnlColorsPreviewTop: TPanel;
    pnlColorsPreviewBottom: TPanel;
    pnlColorsPreviewLeft: TPanel;
    pnlColorsPreviewCenter: TPanel;
    lblColorsPreviewTitle: TLabel;
    lblColorsPreviewText: TLabel;
    btnColorsPreviewAbout: TButton;
    btnColorsPreviewQuit: TButton;
    btnColorsPreviewPrevious: TButton;
    btnColorsPreviewNext: TButton;
    lblColorsPreviewLinks: TLabel;
    lblColorsPreviewWarning: TLabel;
    cbxLangUI: TComboBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label26: TLabel;
    procedure btnQuitClick(Sender: TObject);
    procedure btnAddKeyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPC1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnMakeClick(Sender: TObject);
    procedure btnSourceDirClick(Sender: TObject);
    procedure btnDestDirClick(Sender: TObject);
    procedure btnSkinTopClick(Sender: TObject);
    procedure btnSkinBottomClick(Sender: TObject);
    procedure btnSkinLeftAddClick(Sender: TObject);
    procedure btnSkinLeftDelClick(Sender: TObject);
    procedure btnAppConfigClick(Sender: TObject);
    procedure btnEULAClick(Sender: TObject);
    procedure lvwSkinLeftDblClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnLoadMediaKeysClick(Sender: TObject);
    procedure btnSaveMediaKeysClick(Sender: TObject);
    procedure btnDelKeyClick(Sender: TObject);
    procedure edtEULAChange(Sender: TObject);
    procedure reEulaURLClick(Sender: TObject; const URLText: string;
      Button: TMouseButton);
    procedure btnOpenSourceDirClick(Sender: TObject);
    procedure opdClose(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnWebURLClick(Sender: TObject);
    procedure edtWebURLChange(Sender: TObject);
    procedure edtSourceDirChange(Sender: TObject);
    procedure edtWizardTitleChange(Sender: TObject);
    procedure btnPackIconDefaultClick(Sender: TObject);
    procedure btnPackIconLoadClick(Sender: TObject);
    procedure edtPackIconChange(Sender: TObject);
    procedure clbTopSelect(Sender: TObject);
    procedure lblColorsPreviewLinksMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lblColorsPreviewLinksMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlColorsPreviewCenterClick(Sender: TObject);
    procedure clbLinksSelect(Sender: TObject);
    procedure clbTextSelect(Sender: TObject);
    procedure clbWarningSelect(Sender: TObject);
    procedure btnColorsPreviewAboutClick(Sender: TObject);
    procedure lblColorsPreviewLinksClick(Sender: TObject);
  private
    { Déclarations privées }
    fWorkingThread: TOperationThread;
    fStatusProgress: Double;
    fStatusProgressMax: Double;
    fCanceledByClosingWindow: Boolean;
    fMediaHashKeys: TStringList;
    fAppIconFileName: TFileName;
    procedure InitProgressBar;
    procedure CheckPasswordLength(Name: string);
    function CheckInputs: Boolean;
    function ConvertToRelativePath(AbsolutePath: TFileName): TFileName;
    procedure DiscValidatorStart(Sender: TObject; Total: Int64);
    procedure DiscValidatorProgress(Sender: TObject; Current, Total: Int64);
    procedure DiscValidatorSuccess(Sender: TObject; const MediaKey: string);
    procedure DiscValidatorFailed(Sender: TObject);
    function GetStatus: string;
    procedure GeneratePasswords;
    function IsThreadRunning: Boolean;
    procedure DeleteMediaKey(const KeyIndex: Integer);
    procedure LoadDefaultPackageIcon;
    procedure LoadMediaKeys(const FileName: TFileName);
    procedure LoadLanguagePacks;
    procedure SaveMediaKeys(const FileName: TFileName);
    procedure MakePackage;
    procedure PackageManagerStart(Sender: TObject; Total: Int64);
    procedure PackageManagerProgress(Sender: TObject; Current, Total: Int64);
    procedure PackageManagerStatus(Sender: TObject; StatusText: string);
    procedure PackageManagerFinish(Sender: TObject);
    procedure SetStatus(const Value: string);
    procedure SetControlsState(State: Boolean);
    procedure SetCloseControlsState(State: Boolean);
    procedure SetStatusProgress(const Value: Double);
    procedure SetStatusProgressMax(const MaxValue: Double);
    procedure WorkingThreadTerminateHandler(Sender: TObject);
    function GetLeftImage(Index: Integer): TFileName;
    procedure SetLeftImage(Index: Integer; const Value: TFileName);
    function GetWebURL: string;
    procedure SetAppIconFileName(const Value: TFileName);
    property WebURL: string read GetWebURL;
    property WorkingThread: TOperationThread read fWorkingThread
      write fWorkingThread;
  public
    { Déclarations publiques }
    procedure AddLog(const MessageText: string);
    function AddMediaKey(const MediaKey, Source: string): Boolean;
    function MsgBox(Text, Title: string; Flags: Integer): Integer;
    function GetRandomPassword(PasswordLength: Integer = 32): string;
    procedure UpdateShowAppTitleCheckBox;
    property AppIconFileName: TFileName read fAppIconFileName
      write SetAppIconFileName;
    property Status: string read GetStatus write SetStatus;
    property MediaHashKeys: TStringList read fMediaHashKeys
      write fMediaHashKeys;
    property LeftImages[Index: Integer]: TFileName read GetLeftImage
      write SetLeftImage;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  SysTools, UITools, Math, DateUtils, WorkDir, About, AppVer, IniFiles, Config;

var
  LanguagePacks: TStringList;

procedure TfrmMain.btnQuitClick(Sender: TObject);
begin
  fCanceledByClosingWindow := False;
  Close;
end;

procedure TfrmMain.btnSaveMediaKeysClick(Sender: TObject);
begin
  with sdMediaKey do
    if Execute then
      SaveMediaKeys(FileName);
end;

procedure TfrmMain.btnSkinBottomClick(Sender: TObject);
begin
  with opd do
  begin
    Title := 'Please select the Bottom Banner (691 x 51) :';
    if FileExists(edtSkinBottom.Text) then
      FileName := ConvertToRelativePath(edtSkinBottom.Text);
    if Execute then
      edtSkinBottom.Text := ConvertToRelativePath(FileName);
  end;
end;

procedure TfrmMain.btnSkinLeftAddClick(Sender: TObject);
begin
  if lvwSkinLeft.ItemIndex = -1 then
  begin
    MsgBox('Please select a wizard page in the list below.', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  with opd do
  begin
    Title := 'Please select the Left Banner (173 x 385) for the #'
      + IntToStr(lvwSkinLeft.ItemIndex + 1) + ' wizard page :';
    if FileExists(LeftImages[lvwSkinLeft.ItemIndex]) then
      FileName := ConvertToRelativePath(LeftImages[lvwSkinLeft.ItemIndex]);
    if Execute then
      LeftImages[lvwSkinLeft.ItemIndex] := ConvertToRelativePath(FileName);
  end;
end;

procedure TfrmMain.btnSkinLeftDelClick(Sender: TObject);
var
  CanDo: Integer;

begin
  if lvwSkinLeft.ItemIndex = -1 then
  begin
    MsgBox('Please select a wizard page in the list below.', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  CanDo := MsgBox('Sure to clean this wizard image ?', 'Question', MB_ICONQUESTION + MB_DEFBUTTON2 + MB_YESNO);
  if CanDo = IDYES then
    LeftImages[lvwSkinLeft.ItemIndex] := '';
end;

procedure TfrmMain.btnSkinTopClick(Sender: TObject);
begin
  with opd do
  begin
    Title := 'Please select the Top Banner (691 x 61) :';
    if FileExists(edtSkinTop.Text) then
      FileName := ConvertToRelativePath(edtSkinTop.Text);
    if Execute then
      edtSkinTop.Text := ConvertToRelativePath(FileName);
  end;
end;

procedure TfrmMain.btnSourceDirClick(Sender: TObject);
begin
  with bfd do
  begin
    Title := 'Source Directory';
    StatusText := 'Select the directory that contains the files to release.';
    if DirectoryExists(ConvertToRelativePath(edtSourceDir.Text)) then
      Directory := ConvertToRelativePath(edtSourceDir.Text);
    if Execute then
      edtSourceDir.Text := ConvertToRelativePath(IncludeTrailingPathDelimiter(Directory));
  end;
end;

procedure TfrmMain.btnWebURLClick(Sender: TObject);
begin
  OpenLink(WebURL);
end;

procedure TfrmMain.btnColorsPreviewAboutClick(Sender: TObject);
begin
  lblColorsPreviewLinks.Font.Color := clbLinks.Selected;
  MsgBox((Sender as TButton).Hint + '!', 'Woohoo', MB_ICONINFORMATION);
end;

// Check passwords length and fill the missing characters with random ones.
function TfrmMain.CheckInputs: Boolean;
const
  FILES_EDIT: array[0..1] of string = ('edtAppConfig', 'edtEULA');
  FILES_EDIT_OPTIONAL: array[0..1] of string = ('edtSkinTop', 'edtSkinBottom');
  FOLDER_EDIT: array[0..1] of string = ('edtSourceDir', 'edtDestDir');
  INFOS_EDIT: array[0..3] of string = ('edtAuthor', 'edtGameName', 'edtWebURL', 'edtVersion');

var
  i: Integer;
  Ctrl: TWinControl;
  Edit: TEdit;
  ComboBox: TComboBox;

  function _CHK(Folder: Boolean): Boolean;
  var
    S: string;

  begin
    S := 'file';
    if Folder then
    begin
      S := 'folder';
      Result := DirectoryExists(Edit.Text);
    end else begin
      Result := FileExists(Edit.Text);
    end;

    if not Result then
    begin
      try
        TTabSheet(Edit.Parent.Parent).Show;
        Edit.SetFocus;
      except
      end;
      MsgBox('The specified ' + S + ' doesn''t exists.' + WrapStr
        + 'FileName: "' + Edit.Text + '".', 'Warning', MB_ICONWARNING);
    end;
  end;

  procedure _MandatoryMsg();
  begin
    MsgBox('Please fill this mandatory field.', 'Warning', MB_ICONWARNING);
  end;

begin
  // Check passwords
  GeneratePasswords;

  // Check folders
  for i := Low(FOLDER_EDIT) to High(FOLDER_EDIT) do
  begin
    Edit := FindComponent(FOLDER_EDIT[i]) as TEdit;
    Result := _CHK(True);
    if not Result then Exit;
  end;

  // Check files
  for i := Low(FILES_EDIT) to High(FILES_EDIT) do
  begin
    Edit := FindComponent(FILES_EDIT[i]) as TEdit;
    Result := _CHK(False);
    if not Result then Exit;
  end;

  // Check optional files...
  for i := Low(FILES_EDIT_OPTIONAL) to High(FILES_EDIT_OPTIONAL) - 1 do
  begin
    Edit := FindComponent(FILES_EDIT[i]) as TEdit;
    Result := (Edit.Text = '') or _CHK(False);
    if not Result then Exit;
  end;

  // Left skins...
  for i := 0 to lvwSkinLeft.Items.Count - 1 do
  begin
    Result := (LeftImages[i] = '') or FileExists(LeftImages[i]);
    if not Result then
    begin
      tsSkin.Show;
      lvwSkinLeft.ItemIndex := i;
      lvwSkinLeft.SetFocus;
      MsgBox('The left skin image #' + IntToStr(i+1)
        + ' doesn''t exists.' + WrapStr
        + 'FileName: "' + LeftImages[i] + '".', 'Warning', MB_ICONWARNING);      
      Exit;
    end;
  end;

  // Check media keys
  Result := MediaHashKeys.Count > 0;
  if not Result then
  begin
    tsUnlock.Show;
    MsgBox('Please extract at least one media key'
      + 'from an original disc.', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  // Release informations
  for i := Low(INFOS_EDIT) to High(INFOS_EDIT) do
  begin
    // TEdit
    Ctrl := FindComponent(INFOS_EDIT[i]) as TWinControl;
    if Ctrl is TEdit then
    begin
      Edit := Ctrl as TEdit;
      Result := Edit.Text <> '';
      if not Result then
      begin
        try
          TTabSheet(Edit.Parent.Parent).Show;
          Edit.SelectAll;
          Edit.SetFocus;
        except
        end;
        _MandatoryMsg();
        Exit;
      end;
    end else if Ctrl is TComboBox then
    begin
      // TComboBox
      ComboBox := Ctrl as TComboBox;
      Result := ComboBox.Text <> '';
      if not Result then
      begin
        try
          TTabSheet(ComboBox.Parent.Parent).Show;
          ComboBox.SelectAll;
          ComboBox.SetFocus;
        except
        end;
        _MandatoryMsg();
        Exit;
      end;
    end; // TComboBox
  end; // for
end;

procedure TfrmMain.CheckPasswordLength;
var
  _e: TEdit;
  _s: Integer;

begin
  _e := FindComponent('edt' + Name) as TEdit;
  if Assigned(_e) and (Length(_e.Text) < 32) then
  begin
    _s := 32 - Length(_e.Text);
    _e.Text := _e.Text + GetRandomPassword(_s);
  end;
end;

procedure TfrmMain.clbLinksSelect(Sender: TObject);
begin
  lblColorsPreviewLinks.Font.Color := clbLinks.Selected;
end;

procedure TfrmMain.clbTextSelect(Sender: TObject);
begin
  lblColorsPreviewTitle.Font.Color := clbText.Selected;
  lblColorsPreviewText.Font.Color := clbText.Selected;  
end;

procedure TfrmMain.clbTopSelect(Sender: TObject);
var
  PanelName: string;
  C: TColorBox;

begin
  C := (Sender as TColorBox);
  PanelName := StringReplace(C.Name, 'clb',
    'pnlColorsPreview', []);
  with FindComponent(PanelName) as TPanel do
    Color := C.Selected;
end;

procedure TfrmMain.clbWarningSelect(Sender: TObject);
begin
    lblColorsPreviewWarning.Font.Color := clbWarning.Selected;
end;

function TfrmMain.ConvertToRelativePath(AbsolutePath: TFileName): TFileName;
begin
  Result := AbsolutePath;
  if IsInString(GetApplicationDirectory, AbsolutePath) then
    Result := StringReplace(AbsolutePath, GetApplicationDirectory, '.\',
      [rfReplaceAll, rfIgnoreCase]);
end;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  RunAboutBox;
end;

procedure TfrmMain.btnAddKeyClick(Sender: TObject);
begin
  fCanceledByClosingWindow := True;
  WorkingThread.Free;
  WorkingThread := TDiscValidatorThread.Create;
  with (WorkingThread as TDiscValidatorThread) do
  begin
    OnStart := DiscValidatorStart;
    OnProgress := DiscValidatorProgress;
    OnSuccess := DiscValidatorSuccess;
    OnFail := DiscValidatorFailed;
    Drive := cbxDrives.Drive;
    Resume;
  end;
end;

procedure TfrmMain.btnAppConfigClick(Sender: TObject);
begin
  with od do
  begin
    Title := 'Please select the UI.INI file...';
    Filter := 'INI Files (*.ini)|*.ini|All Files (*.*)|*.*';
    DefaultExt := 'ini';
    if Execute then
      edtAppConfig.Text := ConvertToRelativePath(FileName);
  end;
end;

procedure TfrmMain.btnDelKeyClick(Sender: TObject);
var
  CanDo: Integer;

begin
  if lvDiscKeys.ItemIndex = -1 then
    MsgBox('Please select an entry in the list.', 'Warning', MB_ICONWARNING)
  else begin
    CanDo := MsgBox('Are you sure to delete this media key ?', 'Question',
      MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION);
    if CanDo = IDYES then
      DeleteMediaKey(lvDiscKeys.ItemIndex);
  end;
end;

procedure TfrmMain.btnDestDirClick(Sender: TObject);
begin
  with bfd do
  begin
    Title := 'Destination Directory';
    StatusText := 'Select the output directory where the files will be written.';
    if DirectoryExists(ConvertToRelativePath(edtDestDir.Text)) then
      Directory := ConvertToRelativePath(edtDestDir.Text);
    if Execute then
      edtDestDir.Text := ConvertToRelativePath(IncludeTrailingPathDelimiter(Directory));
  end;
end;

procedure TfrmMain.btnEULAClick(Sender: TObject);
begin
  with od do
  begin
    Title := 'Please select the EULA file...';
    Filter := 'Rich Text Format Files (*.rtf)|*.rtf|Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
    DefaultExt := 'rtf';
    if Execute then
      edtEULA.Text := ConvertToRelativePath(FileName);
  end;
end;

procedure TfrmMain.btnLoadMediaKeysClick(Sender: TObject);
begin
  with odMediaKey do
    if Execute then
      LoadMediaKeys(FileName);
end;

procedure TfrmMain.btnMakeClick(Sender: TObject);
begin
  // Because we can use relative path in the input fields
  SetCurrentDir(GetApplicationDirectory);

  // Create the package!
  if CheckInputs then
    MakePackage;
end;

procedure TfrmMain.btnOpenSourceDirClick(Sender: TObject);
var
  EditName: string;
  E: TEdit;

begin
  EditName := StringReplace((Sender as TButton).Name, 'btnOpen', 'edt', []);
  E := FindComponent(EditName) as TEdit;
  if Assigned(E) then
    OpenWindowsExplorer(ExpandFileName(E.Text));
end;

procedure TfrmMain.btnPackIconDefaultClick(Sender: TObject);
var
  CanDo: Integer;

begin
  CanDo := MsgBox('Restore default package icon ?', 'Question',
    MB_ICONQUESTION + MB_YESNO);
  if CanDo = IDNO then Exit;
  AppIconFileName := '';
end;

procedure TfrmMain.btnPackIconLoadClick(Sender: TObject);
begin
  with opdPackIcon do
    if Execute then
      AppIconFileName := FileName;
end;

procedure TfrmMain.btnPC1Click(Sender: TObject);
var
  _n: string;
  _e: TEdit;

begin
  if Sender is TButton then
  begin
    _n := (Sender as TButton).Name;
    _e := FindComponent('edt' + Copy(_n, 4, Length(_n) - 3)) as TEdit;
    if Assigned(_e) then
      _e.Text := GetRandomPassword;
  end;
end;

procedure TfrmMain.DeleteMediaKey(const KeyIndex: Integer);
begin
  MediaHashKeys.Delete(KeyIndex);
  lvDiscKeys.Items[KeyIndex].Delete;
  if MediaHashKeys.Count > 0 then
  begin
    lvDiscKeys.ItemIndex := MediaHashKeys.Count - 1;
    lvDiscKeys.SetFocus;
  end;
end;

procedure TfrmMain.DiscValidatorFailed;
begin
  MsgBox('Failed to get the media hash key !', 'Error', MB_ICONERROR);
  Status := 'Ready';
  SetControlsState(True);
end;

procedure TfrmMain.DiscValidatorProgress;
begin
  SetStatusProgress(Current);
end;

procedure TfrmMain.DiscValidatorStart;
begin
  SetStatusProgressMax(Total);
  SetStatusProgress(0);
  Status := 'Retrieving media hash key... Please wait.';
  SetControlsState(False);
end;

procedure TfrmMain.DiscValidatorSuccess;
var
  DiscLabelName: string;

begin
{$IFDEF DEBUG}
  WriteLn('Success! Hash Key = ', MediaKey);
{$ENDIF}

  DiscLabelName := (WorkingThread as TDiscValidatorThread).VolumeLabel;
  if not AddMediaKey(MediaKey, DiscLabelName) then
  begin
    Status := 'The key was already in list.';
    MsgBox('The key was already in list.' + WrapStr +
      'Please insert another media in your drive.',
      'Information', MB_ICONINFORMATION);
  end;

  Status := 'Ready';
  SetControlsState(True);
end;

procedure TfrmMain.edtEULAChange(Sender: TObject);
var
  FileName: TFileName;

begin
  FileName := (Sender as TEdit).Text;
  RichEditClear(reEula);
  if FileExists(FileName) then
    reEula.Lines.LoadFromFile(FileName);
end;

procedure TfrmMain.edtPackIconChange(Sender: TObject);
begin
  AppIconFileName := (Sender as TEdit).Text;
end;

procedure TfrmMain.edtSourceDirChange(Sender: TObject);
var
  BtnName: string;
  Btn: TButton;

begin
  BtnName := StringReplace((Sender as TEdit).Name, 'edt', 'btnOpen', []);
  Btn := FindComponent(BtnName) as TButton;
  if Assigned(Btn) then
    Btn.Enabled := DirectoryExists((Sender as TEdit).Text);
end;

procedure TfrmMain.edtWebURLChange(Sender: TObject);
begin
  btnWebURL.Enabled := edtWebURL.Text <> '';
end;

procedure TfrmMain.edtWizardTitleChange(Sender: TObject);
begin
  UpdateShowAppTitleCheckBox;
end;

procedure TfrmMain.WorkingThreadTerminateHandler;
begin
{$IFDEF DEBUG}
  WriteLn('Thread closed... we can send the close command if needed');
{$ENDIF}

  // The thread is closed, we can close the application now.
  if fCanceledByClosingWindow then
    Close
  else begin
    SetCloseControlsState(True);
    Status := 'Ready';
    SetControlsState(True);
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  CanDo: Integer;

begin
  if IsThreadRunning then
  begin
    Action := caNone;
    WorkingThread.Suspend;

    // Disable buttons...
    SetCloseControlsState(False);
    
    CanDo := MsgBox('Are you sure to cancel ?', 'Please confirm',
      MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2);

    if CanDo = IDYES then begin
      // The OnTerminate event is for auto-closing the window when the thread is stopped
      WorkingThread.OnTerminate := WorkingThreadTerminateHandler;

      // Cancel the process... (setting the Aborted flag to True)
      WorkingThread.Abort;
    end else
      SetCloseControlsState(True);

    // The thread must be resumed to continue AND to be cancelled
    WorkingThread.Resume;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
const
  WIZARD_PAGE_NAMES: array[1..10] of string = (
    'Home',     'Disclamer',  'License',    'DiscAuth',   'AuthFail',
    'Params',   'Ready',      'Working',    'Done',       'DoneFail'
  );

var
  i: Integer;

begin
  // Init the Main Form
  Caption := Application.Title + ' v' + GetApplicationVersion;
{$IFDEF DEBUG}
  Caption := Caption + ' *DEBUG*';
{$ENDIF}
  lblAppTitle.Caption := Application.Title;

  // Init the About Box
  InitAboutBox(
    Application.Title,
    GetApplicationVersion
  );

  pcMain.ActivePageIndex := 0;
  InitProgressBar;
  MediaHashKeys := TStringList.Create;
  sbMain.DoubleBuffered := True;
  DoubleBuffered := True;

  btnOpenSourceDir.Enabled := False;
  btnOpenDestDir.Enabled := False;

  // Init the Release Info Tab
  edtReleaseDate.Date := Now;
  btnWebURL.Enabled := False;
  edtWizardTitleChange(edtWizardTitle);

  // Init the Logger
  mLog.Clear;
  mLog.Lines.Add(
    Caption + ' - Activity Log' + sLineBreak +
    '---' + sLineBreak
  );
  
  //init banner list
  for i := 1 to 10 do
    with lvwSkinLeft.Items.Add do
    begin
      Caption := IntToStr(i);
      SubItems.Add(WIZARD_PAGE_NAMES[i]);
      SubItems.Add('');
      SubItems.Add('');  
    end;
  lvwSkinLeft.ItemIndex := 0;

  // Load the default package icon
  LoadDefaultPackageIcon;

  // Load the language packs
  LoadLanguagePacks;
  
  // Generate default passwords
  GeneratePasswords;

  // Load the configuration !
  LoadConfig;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  SaveConfig;
  WorkingThread.Free;
  MediaHashKeys.Free;
  LanguagePacks.Free;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then
  begin
    Key := #0;
    Close;
  end;
end;

procedure TfrmMain.GeneratePasswords;
const
  EDIT_PASSWORDS: array[0..2] of string = ('AES', 'Camellia', 'PC1');

var
  i: Integer;

begin
  // Check passwords length...
  for i := Low(EDIT_PASSWORDS) to High(EDIT_PASSWORDS) do
    CheckPasswordLength(EDIT_PASSWORDS[i]);
end;

function TfrmMain.GetLeftImage(Index: Integer): TFileName;
var
  D, F: TFileName;

begin
  Result := '';
  D := lvwSkinLeft.Items[Index].SubItems[2];
  F := lvwSkinLeft.Items[Index].SubItems[1];
  if (D <> '') and (F <> '') then
    Result := IncludeTrailingPathDelimiter(D) + F
end;

function TfrmMain.GetRandomPassword;
const
  VALID_CHARS = 'abcdefghijklmnopqrstuvwxyz' +
                '0123456789&é"''(-è_çà~#{[|' +
                'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
                '`\^@]}¨¤$£ù%µ*!:;,?./§<>²=' +
                'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
                '+)°&é"(-è_çà)=+^$ù*¨£%µ§!:' +
                'abcdefghijklmnopqrstuvwxyz';
var
  i, l, k: Integer;

begin
  Result := '';
  l := Length(VALID_CHARS);
  for i := 1 to PasswordLength do
  begin
    k := ((Random(l) + SecondOf(Now)) mod L) + 1;
    Result := Result + VALID_CHARS[k];
  end;
end;

function TfrmMain.GetStatus;
begin
  Result := sbMain.Panels[1].Text;
end;

function TfrmMain.GetWebURL: string;
begin
  Result := cbxProtocolWebURL.Items[cbxProtocolWebURL.ItemIndex] + edtWebURL.Text;
end;

procedure TfrmMain.InitProgressBar;
const
  PANEL_INDEX : integer = 2;

var
  i, Size : integer;

begin
  pbMain.DoubleBuffered := True;
  sbMain.Panels[PANEL_INDEX].Text := '';
  
  // pour que le ProgressBar se place sur le StatusBar
  pbMain.Parent := sbMain;

  // le placement de la ProgressBar se fait maintenant par rapport au StatusBar
  Size := 0;

  for i := 0 to PANEL_INDEX - 1 do
    Size := Size + sbMain.Panels[i].Width;

  pbMain.SetBounds(Size + 2, 2, sbMain.Panels[PANEL_INDEX].Width - 4,
    sbMain.Height - 3);

  // Init progressbar
  SetStatusProgressMax(0);
end;

function TfrmMain.IsThreadRunning;
begin
  Result := Assigned(WorkingThread) and (not WorkingThread.Terminated);
end;

procedure TfrmMain.lblColorsPreviewLinksClick(Sender: TObject);
begin
  MsgBox('Click outside the link to remove the Active state.', 'Information',
    MB_ICONINFORMATION);
end;

procedure TfrmMain.lblColorsPreviewLinksMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  lblColorsPreviewLinks.Font.Color := clbLinksClicked.Selected;
end;

procedure TfrmMain.lblColorsPreviewLinksMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  lblColorsPreviewLinks.Font.Color := clbLinksHot.Selected;
end;

procedure TfrmMain.LoadDefaultPackageIcon;
begin
  imgPackIcon.Picture.Bitmap.Handle := LoadBitmap(hInstance, 'DEFICON');
end;

procedure TfrmMain.LoadLanguagePacks;
var
  SR: TSearchRec;
  LngDir: TFileName;
  LangName: string;
  
begin
  LanguagePacks := TStringList.Create;
  try
    LngDir := GetApplicationDataDirectory + 'ui\';
    if FindFirst(LngDir + '*.ini', faAnyFile, SR) = 0 then
    begin
      repeat
        if ((SR.Attr and faDirectory) = 0) then
        begin
          LangName := ChangeFileExt(SR.Name, '');
          LangName[1] := UpCase(LangName[1]);
          cbxLangUI.Items.Add(LangName);
          LanguagePacks.Add(LngDir + SR.Name);
        end;
      until (FindNext(SR) <> 0);
      FindClose(SR);
    end;
  except
    on E:Exception do
      raise EUserInterface.Create('Unable to load the language packs!');
  end;
end;

procedure TfrmMain.LoadMediaKeys;
var
  Ini: TIniFile;
  SL: TStringList;
  i: Integer;
  
begin
  Ini := TIniFile.Create(FileName);
  SL := TStringList.Create;
  try
    Ini.ReadSection('MEDIAKEYS', SL);
    for i := 0 to SL.Count - 1 do
      AddMediaKey(SL[i], Ini.ReadString('MEDIAKEYS', SL[i], ''));
  finally
    SL.Free;
    Ini.Free;
  end;
end;

procedure TfrmMain.AddLog(const MessageText: string);
var
  DT: string;
  
begin
  DT := DateToStr(Now) + ' ' + TimeToStr(Now);
  if MessageText <> '' then  
    mLog.Lines.Add(DT + ': ' + MessageText)
  else
    mLog.Lines.Add('');
end;

function TfrmMain.AddMediaKey;
begin
  Result := False;
  if MediaHashKeys.IndexOf(MediaKey) = -1 then
  begin
    with lvDiscKeys.Items.Add do
    begin
      Caption := IntToStr(lvDiscKeys.Items.Count);
      SubItems.Add(Source);
      SubItems.Add(MediaKey);
    end;
    MediaHashKeys.Add(MediaKey);
    Result := True;
  end;
end;

procedure TfrmMain.lvwSkinLeftDblClick(Sender: TObject);
begin
  btnSkinLeftAdd.Click;
end;

// Main function of this application : Make the package!
procedure TfrmMain.MakePackage;
var
  i: Integer;

begin
  fCanceledByClosingWindow := True;
  tsLogger.Show;

  WorkingThread.Free;
  WorkingThread := TPackageMakerThread.Create;
  with (WorkingThread as TPackageMakerThread) do
  begin
    OnStart := PackageManagerStart;
    OnProgress := PackageManagerProgress;
    OnStatus := PackageManagerStatus;
    OnFinish := PackageManagerFinish;
    InputDirectory := edtSourceDir.Text;
    OutputDirectory := edtDestDir.Text;
    with Passwords do
    begin
      AES := edtAES.Text;
      PC1 := edtPC1.Text;
      Camellia := edtCamellia.Text;
    end;
    with SkinImages do
    begin
      Top := edtSkinTop.Text;
      Bottom := edtSkinBottom.Text;
      for i := 0 to 9 do
        Left.Add(LeftImages[i]);
    end;
    Eula := edtEULA.Text;
    AppConfig := edtAppConfig.Text; // ui.ini file
    AppIcon := AppIconFileName;
    MediaHashKeys.Assign(Self.MediaHashKeys);
    with ReleaseInfo do // config.ini file
    begin
      Add('Author', edtAuthor.Text);
      // Background Colors
      Add('ColorTop', ColorToString(clbTop.Selected));
      Add('ColorBottom', ColorToString(clbBottom.Selected));
      Add('ColorLeft', ColorToString(clbLeft.Selected));
      Add('ColorCenter', ColorToString(clbCenter.Selected));
      // Text Colors
      Add('ColorText', ColorToString(clbText.Selected));
      Add('ColorWarningText', ColorToString(clbWarning.Selected));
      // Link Colors
      Add('ColorLinksNormal', ColorToString(clbLinks.Selected));
      Add('ColorLinksClicked', ColorToString(clbLinksClicked.Selected));
      Add('ColorLinksHot', ColorToString(clbLinksHot.Selected));
      // Infos
      Add('GameName', edtGameName.Text);
      Add('ReleaseDate', DateToStr(edtReleaseDate.Date));
      Add('ShowAppTitle', BoolToStr(cbxShowAppName.Checked));      
      Add('Version', edtVersion.Text);
      Add('WebURL', WebURL);
      Add('WizardTitle', edtWizardTitle.Text);
    end;
    Resume;
  end;
end;

function TfrmMain.MsgBox;
begin
  Result := MessageBoxA(Handle, PAnsiChar(Text), PAnsiChar(Title), Flags);
end;

procedure TfrmMain.opdClose(Sender: TObject);
begin
  SetCurrentDir(GetApplicationDirectory);
end;

procedure TfrmMain.PackageManagerFinish;
var
  CanDo: Integer;
  Thread: TPackageMakerThread;

begin
{$IFDEF DEBUG}
  WriteLn('Finish');
{$ENDIF}

  Thread := (Sender as TPackageMakerThread);
  if Thread.Aborted then
  begin
    Status := 'Aborted !';
    Delay(2000);
  end else begin
    Status := 'Done !';
    SetStatusProgress(MaxDouble);
    CanDo := MsgBox('All the files were packaged successfully.' + WrapStr +
      'Your production is now ready to be released!' + WrapStr +
      'You should test the generated package before spreading it.' + WrapStr +
      'Do it know ?', 'Congrats!',
      MB_ICONINFORMATION + MB_YESNO);

    // Run the production to test it...
    if CanDo = IDYES then
      RunNoWait(Thread.OutputFileName);
  end;

  Status := 'Ready';

  // Clean passwords fields!
  edtPC1.Text := '';
  edtCamellia.Text := '';
  edtAES.Text := '';

  SetControlsState(True);
end;

procedure TfrmMain.PackageManagerProgress;
begin
{$IFDEF DEBUG}
  Write('  ', Current, '/', Total, #13);
{$ENDIF}
  SetStatusProgress(Current);
end;

(*procedure TfrmMain.PackageManagerProgressCrypto;
begin
{$IFDEF DEBUG}
  Write('  Crypto = ', Current, '/', Total, #13);
{$ENDIF}
  SetStatusProgress(Current);
end;*)

procedure TfrmMain.PackageManagerStart;
begin
{$IFDEF DEBUG}
  WriteLn('Total: ', Total);
{$ENDIF}
  SetStatusProgressMax(Total);
  SetStatusProgress(0);
  SetControlsState(False);
//  Status := 'Building package... please wait.';
end;

procedure TfrmMain.PackageManagerStatus(Sender: TObject; StatusText: string);
begin
  Status := StatusText;
end;

procedure TfrmMain.pnlColorsPreviewCenterClick(Sender: TObject);
begin
  lblColorsPreviewLinks.Font.Color := clbLinks.Selected;
end;

procedure TfrmMain.reEulaURLClick(Sender: TObject; const URLText: string;
  Button: TMouseButton);
begin
  OpenLink(URLText);
end;

procedure TfrmMain.SaveMediaKeys(const FileName: TFileName);
var
  Ini: TIniFile;
  i: Integer;
  
begin
  Ini := TIniFile.Create(FileName);
  try
    for i := 0 to lvDiscKeys.Items.Count - 1 do
      with lvDiscKeys.Items[i] do
        Ini.WriteString('MEDIAKEYS', SubItems[1], SubItems[0]);
  finally
    Ini.Free;
  end;
end;

procedure TfrmMain.SetAppIconFileName(const Value: TFileName);
begin
  if FileExists(Value) then
  begin
    fAppIconFileName := ExpandFileName(Value);
    edtPackIcon.Text := AppIconFileName;
    imgPackIcon.Picture.LoadFromFile(fAppIconFileName);
  end else begin
    fAppIconFileName := '';
    LoadDefaultPackageIcon
  end;
end;

procedure TfrmMain.SetCloseControlsState;
begin
  btnQuit.Enabled := State;
  SetCloseWindowButtonState(Self, State);
end;

procedure TfrmMain.SetControlsState;
begin
  btnMake.Enabled := State;
  btnAbout.Enabled := State;
  btnAddKey.Enabled := State;
  btnDelKey.Enabled := State;
  cbxDrives.Enabled := State;
  edtPC1.Enabled := State;
  btnPC1.Enabled := State;
  edtCamellia.Enabled := State;
  btnCamellia.Enabled := State;
  edtAES.Enabled := State;
  btnAES.Enabled := State;
  lvDiscKeys.Enabled := State;
  edtSourceDir.Enabled := State;
  btnSourceDir.Enabled := State;
  edtDestDir.Enabled := State;
  btnDestDir.Enabled := State;
  edtAppConfig.Enabled := State;
  btnAppConfig.Enabled := State;
  edtEULA.Enabled := State;
  btnEULA.Enabled := State;
  btnSkinTop.Enabled := State;
  btnSkinBottom.Enabled := State;
  btnSkinLeftAdd.Enabled := State;
  btnSkinLeftDel.Enabled := State;
  lvwSkinLeft.Enabled := State;
  edtSkinTop.Enabled := State;
  edtSkinBottom.Enabled := State;
  btnLoadMediaKeys.Enabled := State;
  btnSaveMediaKeys.Enabled := State;
  edtAuthor.Enabled := State;
  edtGameName.Enabled := State;
  edtReleaseDate.Enabled := State;
  edtWebURL.Enabled := State;
  edtVersion.Enabled := State;
  edtWizardTitle.Enabled := State;
  cbxProtocolWebURL.Enabled := State;
  if not State then
  begin
    cbxShowAppName.Enabled := False;
    btnQuit.Caption := '&Cancel';
  end else begin
    UpdateShowAppTitleCheckBox;
    btnQuit.Caption := '&Quit';
  end;
end;

procedure TfrmMain.SetLeftImage(Index: Integer; const Value: TFileName);
begin
  if ((Value <> '') and (Value <> '\')) then
  begin
    lvwSkinLeft.Items[Index].SubItems[1] := ExtractFileName(Value);
    lvwSkinLeft.Items[Index].SubItems[2] := ExtractFilePath(Value);
  end else begin
    lvwSkinLeft.Items[Index].SubItems[1] := '';
    lvwSkinLeft.Items[Index].SubItems[2] := '';
  end;
end;

procedure TfrmMain.SetStatus;
begin
  sbMain.Panels[1].Text := Value;
  AddLog(Value);
  if Value = 'Ready' then
  begin
    SetStatusProgress(0);
    AddLog('');
  end;
end;

procedure TfrmMain.SetStatusProgress;
var
  Step: Double;

begin
  if Value > fStatusProgressMax then
    fStatusProgress := fStatusProgressMax
  else
    fStatusProgress := Value;

  Step := 0;
  if fStatusProgressMax <> 0 then
    Step := SimpleRoundTo((fStatusProgress / fStatusProgressMax) * 100, -2);
  pbMain.Position := Ceil(Step);
  sbMain.Panels[3].Text := FormatFloat('0.00', Step) + '%';
end;

procedure TfrmMain.SetStatusProgressMax;
begin
  fStatusProgressMax := MaxValue;
  pbMain.Max := 100;
  SetStatusProgress(0);
end;

procedure TfrmMain.UpdateShowAppTitleCheckBox;
begin
  cbxShowAppName.Enabled := edtWizardTitle.Text <> '';
  if not cbxShowAppName.Enabled then
    cbxShowAppName.Checked := True;
end;

end.
