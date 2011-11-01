unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, JvExStdCtrls, JvCombobox, JvDriveCtrls,
  OpThBase, DiscAuth, Packer, JvBaseDlg, JvBrowseFolder, ExtDlgs;

type
  TfrmMain = class(TForm)
    pnlBottom: TPanel;
    Bevel1: TBevel;
    btnAbout: TButton;
    btnMake: TButton;
    btnQuit: TButton;
    pcMain: TPageControl;
    tsGeneral: TTabSheet;
    tsDiscAuth: TTabSheet;
    tsSkin: TTabSheet;
    gbxSource: TGroupBox;
    edtSourceDir: TEdit;
    btnSourceDir: TButton;
    Label1: TLabel;
    tsEula: TTabSheet;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Edit3: TEdit;
    Button4: TButton;
    GroupBox4: TGroupBox;
    RichEdit1: TRichEdit;
    gbxDiscKeys: TGroupBox;
    sbMain: TStatusBar;
    pbMain: TProgressBar;
    Shape1: TShape;
    Bevel2: TBevel;
    Label4: TLabel;
    lvDiscKeys: TListView;
    tsOptions: TTabSheet;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    edtAppConfig: TEdit;
    btnAppConfig: TButton;
    gbxDestination: TGroupBox;
    Label5: TLabel;
    edtDestDir: TEdit;
    btnDestDir: TButton;
    Label7: TLabel;
    GroupBox6: TGroupBox;
    cbxDrives: TJvDriveCombo;
    btnAddKey: TButton;
    btnDelKey: TButton;
    Label8: TLabel;
    bfd: TJvBrowseForFolderDialog;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    edtSkinTop: TEdit;
    btnSkinTop: TButton;
    edtSkinBottom: TEdit;
    Label11: TLabel;
    btnSkinBottom: TButton;
    GroupBox5: TGroupBox;
    Label12: TLabel;
    lvwSkinLeft: TListView;
    btnSkinLeftAdd: TButton;
    btnSkinLeftDel: TButton;
    od: TOpenDialog;
    opd: TOpenPictureDialog;
    GroupBox7: TGroupBox;
    Label9: TLabel;
    edtEULA: TEdit;
    btnEULA: TButton;
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
  private
    { Déclarations privées }
    fWorkingThread: TOperationThread;
    fStatusProgress: Double;
    fStatusProgressMax: Double;
    fCanceledByClosingWindow: Boolean;
    fMediaHashKeys: TStringList;
    procedure InitProgressBar;
    procedure CheckPasswordLength(Name: string);
    procedure DiscValidatorStart(Sender: TObject; Total: Int64);
    procedure DiscValidatorProgress(Sender: TObject; Current, Total: Int64);
    procedure DiscValidatorSuccess(Sender: TObject; const MediaKey: string);
    procedure DiscValidatorFailed(Sender: TObject);
    function GetStatus: string;
    function IsThreadRunning: Boolean;
    procedure MakePackage;
    procedure PackageManagerStart(Sender: TObject; Total: Int64);
    procedure PackageManagerStartCrypto(Sender: TObject; Total: Int64);
    procedure PackageManagerProgress(Sender: TObject; Current, Total: Int64);
    procedure PackageManagerProgressCrypto(Sender: TObject; Current,
      Total: Int64);
    procedure PackageManagerFinish(Sender: TObject);
    procedure SetStatus(const Value: string);
    procedure SetControlsState(State: Boolean);
    procedure SetCloseControlsState(State: Boolean);
    procedure SetStatusProgress(const Value: Double);
    procedure SetStatusProgressMax(const MaxValue: Double);
    procedure WorkingThreadTerminateHandler(Sender: TObject);
    property WorkingThread: TOperationThread read fWorkingThread
      write fWorkingThread;
  public
    { Déclarations publiques }
    function MsgBox(Text, Title: string; Flags: Integer): Integer;
    function GetRandomPassword(PasswordLength: Integer = 32): string;
    property Status: string read GetStatus write SetStatus;
    property MediaHashKeys: TStringList read fMediaHashKeys
      write fMediaHashKeys;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  SysTools, UITools, Math, DateUtils, WorkDir;
  
{$R *.dfm}

procedure TfrmMain.btnQuitClick(Sender: TObject);
begin
  fCanceledByClosingWindow := False;
  Close;
end;

procedure TfrmMain.btnSkinBottomClick(Sender: TObject);
begin
  with opd do
  begin
    Title := 'Please select the Bottom Banner (691 x 51) :';
    if Execute then
      edtSkinBottom.Text := FileName;
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
    if Execute then
      with lvwSkinLeft.ItemFocused do
      begin
        SubItems[0] := ExtractFileName(FileName);
        SubItems[1] := ExtractFilePath(FileName);
      end;
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
    with lvwSkinLeft.ItemFocused do
    begin
      SubItems[0] := '';
      SubItems[1] := '';
    end;
end;

procedure TfrmMain.btnSkinTopClick(Sender: TObject);
begin
  with opd do
  begin
    Title := 'Please select the Top Banner (691 x 61) :';
    if Execute then
      edtSkinTop.Text := FileName;
  end;
end;

procedure TfrmMain.btnSourceDirClick(Sender: TObject);
begin
  with bfd do
  begin
    Title := 'Source Directory';
    StatusText := 'Select the directory that contains the files to release.';
    if Execute then
      edtSourceDir.Text := IncludeTrailingPathDelimiter(Directory);
  end;
end;

// Check passwords length and fill the missing characters with random ones.
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
      edtAppConfig.Text := FileName;
  end;
end;

procedure TfrmMain.btnDestDirClick(Sender: TObject);
begin
  with bfd do
  begin
    Title := 'Destination Directory';
    StatusText := 'Select the output directory where the files will be written.';
    if Execute then
      edtDestDir.Text := IncludeTrailingPathDelimiter(Directory);
  end;
end;

procedure TfrmMain.btnEULAClick(Sender: TObject);
begin
  with od do
  begin
    Title := 'Please select the EULA.RTF file...';
    Filter := 'RTF Files (*.rtf)|*.rtf|All Files (*.*)|*.*';
    DefaultExt := 'rtf';
    if Execute then
      edtEULA.Text := FileName;
  end;
end;

procedure TfrmMain.btnMakeClick(Sender: TObject);
const
  EDIT_PASSWORDS: array[0..2] of string = ('AES', 'Camellia', 'PC1');

var
  i: Integer;

begin
  // Check passwords length...
  for i := Low(EDIT_PASSWORDS) to High(EDIT_PASSWORDS) do
    CheckPasswordLength(EDIT_PASSWORDS[i]);

  // Create the package!
  MakePackage;
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
begin
{$IFDEF DEBUG}
  WriteLn('Success! Hash Key = ', MediaKey);
{$ENDIF}

  // Add the key
  if MediaHashKeys.IndexOf(MediaKey) = -1 then
  begin
    with lvDiscKeys.Items.Add do
    begin
      Caption := IntToStr(lvDiscKeys.Items.Count);
      SubItems.Add(cbxDrives.DisplayName);
      SubItems.Add(MediaKey);
    end;
    MediaHashKeys.Add(MediaKey);
  end else begin
    Status := 'The key was already in list.';
    MsgBox('The key was already in list.' + sLineBreak +
      'Please insert another media in your drive.',
      'Information', MB_ICONINFORMATION);
  end;

  Status := 'Ready';
  SetControlsState(True);
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
    
    CanDo := MsgBox('Are you sure to Exit ?', 'Please confirm',
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
var
  i: Integer;

begin
  Caption := Application.Title;
  pcMain.ActivePageIndex := 0;
  InitProgressBar;
  MediaHashKeys := TStringList.Create;
  sbMain.DoubleBuffered := True;

  //init banner list
  for i := 1 to 10 do
    with lvwSkinLeft.Items.Add do
    begin
      Caption := IntToStr(i);
      SubItems.Add('');
      SubItems.Add('');  
    end;
  lvwSkinLeft.ItemIndex := 0;

{$IFDEF DEBUG}
  edtSourceDir.Text := 'C:\Temp\~shenin\';
  edtDestDir.Text := 'C:\Temp\~shenout\';
  DiscValidatorSuccess(Self, 'b17ca3a8cb686ec9689c938271ed4fbd');
  DiscValidatorSuccess(Self, '35406f2bbb712b8102c5620ac4725a2f');
  edtPC1.Text := '________________________________';
  edtCamellia.Text := '________________________________';
  edtAES.Text := '________________________________';
  edtAppConfig.Text := 'M:\Sources\Delphi\Projets\Shenmue Translation Pack\Source\Release Unlocker\Runtime\bin\template\ui_french.ini';
  edtEULA.Text := 'M:\Sources\Delphi\Projets\Shenmue Translation Pack\Source\Release Unlocker\Runtime\bin\template\eula.rtf';
  edtSkinTop.Text := 'M:\Sources\Delphi\Projets\Shenmue Translation Pack\Source\Release Unlocker\Runtime\bin\template\top.bmp';
  edtSkinBottom.Text := 'M:\Sources\Delphi\Projets\Shenmue Translation Pack\Source\Release Unlocker\Runtime\bin\template\bottom.bmp';
  for i := 0 to 9 do
  begin
    lvwSkinLeft.Items[i].SubItems[0] := 'center' + IntToStr(i+1) + '.bmp';
    lvwSkinLeft.Items[i].SubItems[1] := 'M:\Sources\Delphi\Projets\Shenmue Translation Pack\Source\Release Unlocker\Runtime\bin\template\';
  end;
{$ENDIF}
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  WorkingThread.Free;
  MediaHashKeys.Free;
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
  WorkingThread.Free;
  WorkingThread := TPackageMakerThread.Create;
  with (WorkingThread as TPackageMakerThread) do
  begin
    OnStart := PackageManagerStart;
    OnProgress := PackageManagerProgress;
    OnFinish := PackageManagerFinish;
    OnStartCrypto := PackageManagerStartCrypto;
    OnProgressCrypto := PackageManagerProgressCrypto;
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
        Left.Add(lvwSkinLeft.Items[i].SubItems[1] + lvwSkinLeft.Items[i].SubItems[0]);
    end;
    Eula := edtEULA.Text;
    AppConfig := edtAppConfig.Text; // Ui
    MediaHashKeys.Assign(Self.MediaHashKeys);
    Resume;
  end;
end;

function TfrmMain.MsgBox;
begin
  Result := MessageBoxA(Handle, PAnsiChar(Text), PAnsiChar(Title), Flags);
end;

procedure TfrmMain.PackageManagerFinish;
begin
{$IFDEF DEBUG}
  WriteLn('Finish');
{$ENDIF}
  if (Sender as TPackageMakerThread).Aborted then
  begin
    Status := 'Aborted !';
    Delay(2000);
  end else begin
    Status := 'Done !';
    SetStatusProgress(MaxDouble);
    MsgBox('All the files were packaged successfully.' + sLineBreak +
      'Your production is now ready to be released!', 'Congrats!',
      MB_ICONINFORMATION); 
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

procedure TfrmMain.PackageManagerProgressCrypto;
begin
{$IFDEF DEBUG}
  Write('  Crypto = ', Current, '/', Total, #13);
{$ENDIF}
  SetStatusProgress(Current);
end;

procedure TfrmMain.PackageManagerStart;
begin
{$IFDEF DEBUG}
  WriteLn('Total: ', Total);
{$ENDIF}
  SetStatusProgressMax(Total);
  SetStatusProgress(0);
  SetControlsState(False);
  Status := 'Building package... please wait.';
end;

procedure TfrmMain.PackageManagerStartCrypto;
begin
{$IFDEF DEBUG}
  WriteLn('Total: ', Total);
{$ENDIF}
  SetStatusProgressMax(Total);
  SetStatusProgress(0);
  SetControlsState(False);
  Status := 'Encrypting package...';
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
  if not State then
    btnQuit.Caption := '&Cancel'
  else
    btnQuit.Caption := '&Quit';
end;

procedure TfrmMain.SetStatus;
begin
  sbMain.Panels[1].Text := Value;
  if Value = 'Ready' then
    SetStatusProgress(0);
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

end.
