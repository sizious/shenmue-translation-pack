unit Main;

interface

uses
  Windows, SysUtils, Forms, Graphics, Classes, Controls, StdCtrls, ComCtrls,
  ExtCtrls, JvExStdCtrls, JvCombobox, JvDriveCtrls, OpThBase, Unpacker, Common,
  GraphicEx, AppEvnts, Dialogs, JvBaseDlg, JvBrowseFolder;

type
  TfrmMain = class(TForm)
    pcWizard: TPageControl;
    tsHome: TTabSheet;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlLeft: TPanel;
    tsDisclamer: TTabSheet;
    tsDiscAuth: TTabSheet;
    tsAuthFail: TTabSheet;
    btnPrev: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    btnAbout: TButton;
    imgLeft: TImage;
    imgBottom: TImage;
    imgTop: TImage;
    tsLicense: TTabSheet;
    tsParams: TTabSheet;
    tsDone: TTabSheet;
    tsWorking: TTabSheet;
    lblHomeTitle: TLabel;
    lblLicenseTitle: TLabel;
    reEula: TRichEdit;
    lblLicenseMessage: TLabel;
    rbnLicenseAccept: TRadioButton;
    rbnLicenseDecline: TRadioButton;
    lblDiscAuthTitle: TLabel;
    lblDisclamerTitle: TLabel;
    lblAuthFailTitle: TLabel;
    lblParamsTitle: TLabel;
    lblWorkingTitle: TLabel;
    lblDoneTitle: TLabel;
    lblDiscAuthMessage: TLabel;
    lblDiscAuthWarning: TLabel;
    grpDiscAuthSelectDrive: TGroupBox;
    grpDiscAuthProgress: TGroupBox;
    pbValidator: TProgressBar;
    cbxDrives: TJvDriveCombo;
    lblParamsMessage: TLabel;
    lblAuthFailMessage: TLabel;
    grpWorkingProgress: TGroupBox;
    pbTotal: TProgressBar;
    grpParamsExtract: TGroupBox;
    edtOutputDir: TEdit;
    btnParamsBrowse: TButton;
    lblParamsUnpackedSize: TLabel;
    lblParamsExtractToOutputDir: TLabel;
    tsReady: TTabSheet;
    tsDoneFail: TTabSheet;
    lblHomeMessage: TLabel;
    lblDisclamerMessage: TLabel;
    lblReadyTitle: TLabel;
    lblReadyMessage: TLabel;
    lblDoneFailTitle: TLabel;
    lblDoneFailMessage: TLabel;
    lblUnpackProgress: TLabel;
    lblWorkingMessage: TLabel;
    lblDoneMessage: TLabel;
    grpDoneFailErrorMessage: TGroupBox;
    memDoneFail: TMemo;
    ApplicationEvents: TApplicationEvents;
    bfdOutput: TJvBrowseForFolderDialog;
    imgError: TImage;
    imgWarn: TImage;
    lblDoneFailGroupMessage: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure pcWizardChanging(Sender: TObject; var AllowChange: Boolean);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure pcWizardChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure rbnLicenseAcceptClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure btnParamsBrowseClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
  private
    { Déclarations privées }
    fCanceledByClosingWindow: Boolean;
    fStatusProgress: Double;
    fStatusProgressMax: Double;    
    fWorkingThread: TOperationThread;
    fUnlockPasswords: TPackagePasswords;
    fUnpackedSize: Int64;

    procedure AddDebug(Msg: string);

    procedure DiscValidatorFailed(Sender: TObject);
    procedure DiscValidatorProgress(Sender: TObject; Current, Total: Int64);
    procedure DiscValidatorSuccess(Sender: TObject; const MediaKey: string);
    procedure DiscValidatorFinish(Sender: TObject);

    procedure PackageUnlockStart(Sender: TObject; Total: Int64);
    procedure PackageUnlockProgress(Sender: TObject; Current, Total: Int64);
    procedure PackageUnlockFinish(Sender: TObject);

    procedure WorkingThreadTerminateHandler(Sender: TObject);

    procedure DoIdentificationProcess;
    procedure DoCheckExtractParams;
    procedure DoUnlockPackage;

    procedure InitWizard;
    function GetPageIndex: Integer;
    function GetPageIndexMax: Integer;
    function OnWizardBeforePageChange: Boolean;
    procedure OnWizardAfterPageChange;
    procedure SetPageIndex(const Value: Integer);
    procedure SetUnpackedSize(const Value: Int64);

    procedure SetStatusProgress(const Value: Double);
    procedure SetStatusProgressMax(const MaxValue: Double);

    property UnlockPasswords: TPackagePasswords read fUnlockPasswords;
    property UnpackedSize: Int64 read fUnpackedSize write SetUnpackedSize;
    property WorkingThread: TOperationThread read fWorkingThread
      write fWorkingThread;
  public
    { Déclarations publiques }
    procedure Next;
    procedure Previous;
    function MsgBox(Text, Title: string; Flags: Integer): Integer;
    property PageIndex: Integer read GetPageIndex write SetPageIndex;
    property PageIndexMax: Integer read GetPageIndexMax;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  SysTools, UITools, ResMan, JvTypes, DiscAuth, Math, WorkDir;

const
  // Screen pages indexes
  SCREEN_HOME = 0;
  SCREEN_DISCLAMER = 1;
  SCREEN_LICENSE = 2;
  SCREEN_CHECKDISC = 3;
  SCREEN_CHECKDISC_FAILED = 4;
  SCREEN_EXTRACT_PARAMETERS = 5;
  SCREEN_READY_TO_EXTRACT = 6;
  SCREEN_WORKING = 7;
  SCREEN_FINISH = 8;
  SCREEN_FINISH_FAILED = 9;

  // Buttons action behaviors
  BUTTON_ACTION_DEFAULT = 0;
  BUTTON_ACTION_DO_IDENTIFICATION = 1;
  BUTTON_ACTION_FINISH = 2;
  BUTTON_ACTION_SHOW_CHECKDISC = 3;
  BUTTON_ACTION_DO_UNLOCK_PACKAGE = 4;
  BUTTON_ACTION_CHECK_EXTRACT_PARAMS = 5;

{$R *.dfm}

procedure TfrmMain.AddDebug(Msg: string);
begin
  memDoneFail.Lines.Add(DateToStr(Now) + ' ' + TimeToStr(Now) + ': ' + Msg);
end;

procedure TfrmMain.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  AddDebug('UNCAUGHT EXCEPTION: ' + E.ClassName + ' - ' + E.Message);
  LoadWizardUI('DoneFail');
  PageIndex := SCREEN_FINISH_FAILED;
end;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  raise Exception.Create('test');
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  fCanceledByClosingWindow := False;
  Close;
end;

procedure TfrmMain.btnNextClick(Sender: TObject);
begin
  Next;
end;

procedure TfrmMain.btnParamsBrowseClick(Sender: TObject);
begin
  with bfdOutput do
    if Execute then
      edtOutputDir.Text := Directory;
end;

procedure TfrmMain.btnPrevClick(Sender: TObject);
begin
  Previous;
end;

procedure TfrmMain.DiscValidatorFailed(Sender: TObject);
begin
  // Error when trying to get the media key !!
  cbxDrives.Enabled := True;
  PageIndex := SCREEN_CHECKDISC_FAILED;
end;

procedure TfrmMain.DiscValidatorFinish(Sender: TObject);
var
  Thread: TDiscValidatorThread;

begin
  pbValidator.Position := 0;
  // if discvalidator is cancelled, then show the failed screen...
  Thread := WorkingThread as TDiscValidatorThread;
  if Thread.Aborted then
    PageIndex := SCREEN_CHECKDISC_FAILED;
end;

procedure TfrmMain.DiscValidatorProgress;
begin
  pbValidator.Max := Total;
  pbValidator.Position := Current;
end;

procedure TfrmMain.DiscValidatorSuccess;
var
  USize: Int64;

begin
{$IFDEF DEBUG}
  WriteLn('DiscValidatorSuccess: MediaKey = ', MediaKey);
{$ENDIF}

  // The media key was successfully retrieved, now we have to check if it's valid or not.
  // The MAIN method of this shit... GetUnlockKeys will try to get the unlock keys of the
  // release package!!!
  if GetUnlockKeys(MediaKey, UnlockPasswords, USize) then
  begin
    UnpackedSize := USize;
    PageIndex := SCREEN_EXTRACT_PARAMETERS;
  end else
    PageIndex := SCREEN_CHECKDISC_FAILED;

  cbxDrives.Enabled := True;
end;

procedure TfrmMain.DoCheckExtractParams;
var
  Drive: TFileName;
  i: Integer;
  Space: Int64;
  S: string;
  SU: TSizeUnit;

  function _GetMsgText(Code: string): string;
  begin
    Result := GetStringUI('MsgText', Code);
    Result := StringReplace(Result, '<%OUTPUTDRIVE%>', Drive, [rfReplaceAll]);
  end;

begin
  // if the path is empty can't continue.
  Drive := UpperCase(ExtractFileDrive(edtOutputDir.Text));
  if Length(Drive) < 2 then
  begin
    MsgBox(_GetMsgText('OutputDirectoryNotSpecified'), GetStringUI('MsgTitle', 'Error'), MB_ICONERROR);
    Exit;
  end;

  // Getting the drive index
  i := DriveCharToInteger(Drive[1]);
  if i = -1 then
  begin
    MsgBox(_GetMsgText('DriveInvalid'), GetStringUI('MsgTitle', 'Error'), MB_ICONERROR);
    Exit;
  end;

  // Getting free space
  Space := DiskFree(i);
  if Space = -1 then
  begin
    MsgBox(_GetMsgText('DriveDoesntExists'), GetStringUI('MsgTitle', 'Error'), MB_ICONERROR);
    Exit;
  end;

  // Calculating if we can extract the files here...
  Space := Space - UnpackedSize;
  if Space < 0 then
  begin
    S := _GetMsgText('DriveNoMuchSpace');
    S := StringReplace(S, '<%NEEDEDSPACE%>', FormatByteSize(Space, SU) + ' '
      + SizeUnitToString(SU), [rfReplaceAll]);
    MsgBox(S, GetStringUI('MsgTitle', 'Warning'), MB_ICONWARNING);
    Exit;
  end;

  // OK, go to the next page.
  PageIndex := SCREEN_READY_TO_EXTRACT;
end;

procedure TfrmMain.DoIdentificationProcess;
begin
  fCanceledByClosingWindow := True;
  
  btnNext.Enabled := False;
  btnPrev.Enabled := False;
  cbxDrives.Enabled := False;
  
  // Do the disc authentification...

  WorkingThread.Free; // destroying previous thread object if exists

  // create a new thread for validate the disc...
  WorkingThread := TDiscValidatorThread.Create;
  with (WorkingThread as TDiscValidatorThread) do begin
    OnFail := DiscValidatorFailed;
    OnProgress := DiscValidatorProgress;
    OnSuccess := DiscValidatorSuccess;
    OnFinish := DiscValidatorFinish;
    Drive := cbxDrives.Drive;
    Resume;
  end;
end;

procedure TfrmMain.DoUnlockPackage;
begin
  PageIndex := SCREEN_WORKING;
  fCanceledByClosingWindow := True;
  WorkingThread.Free;
  WorkingThread := TPackageExtractorThread.Create;
  with (WorkingThread as TPackageExtractorThread) do
  begin
    Passwords.Assign(UnlockPasswords);
    OnStart := PackageUnlockStart;
    OnProgress := PackageUnlockProgress;
    OnFinish := PackageUnlockFinish;
    OutputDirectory := edtOutputDir.Text;
    Resume;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  CanDo: Integer;

begin
  if Assigned(WorkingThread) and (not WorkingThread.Terminated) then
  begin
    Action := caNone;
    WorkingThread.Suspend;

    // Disable buttons...
    btnCancel.Enabled := False;
    SetCloseWindowButtonState(Self, False);

    CanDo := MsgBox(GetStringUI('MsgText', 'ConfirmCancel'),
      GetStringUI('MsgTitle', 'Question'),
      MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2);

    if CanDo = IDYES then begin
      // The OnTerminate event is for auto-closing the window when the thread is stopped
      WorkingThread.OnTerminate := WorkingThreadTerminateHandler;

      // Cancel the DiscValidator process...
      WorkingThread.Abort;
    end else begin
      btnCancel.Enabled := True;
      SetCloseWindowButtonState(Self, True);
    end;

    WorkingThread.Resume;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{$IFDEF DEBUG}
  edtOutputDir.Text := 'C:\Temp\~rlzout\';
{$ELSE}
  edtOutputDir.Text := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
{$ENDIF}

  DoubleBuffered := True;
  pbValidator.DoubleBuffered := True;
  pcWizard.DoubleBuffered := True;

  Caption := Application.Title;
  fUnlockPasswords := TPackagePasswords.Create;

  InitWizard;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  UnlockPasswords.Free;
  WorkingThread.Free;
  cbxDrives.ImageSize := isSmall;
end;

function TfrmMain.GetPageIndex: Integer;
begin
  Result := pcWizard.ActivePageIndex;
end;

function TfrmMain.GetPageIndexMax: Integer;
begin
  Result := pcWizard.PageCount - 1;
end;

procedure TfrmMain.InitWizard;
var
  S: string;
{$IFDEF RELEASE}
  i: Integer;
{$ENDIF}

begin
  pcWizard.ActivePage := tsHome;

  // Loading message file
  InitializeStringUI;
  LoadWizardUI('Home');

  // Load images
  InitializeSkin;

  // Load the EULA
  if FileExists(GetWorkingTempDirectory + APPCONFIG_EULA) then  
    reEula.Lines.LoadFromFile(GetWorkingTempDirectory + APPCONFIG_EULA);

  // Modify the Wizard Title
  S := GetStringUI('General', 'WizardTitle');
  if S <> '' then Caption := S + ' - ' + Caption;
  
{$IFDEF RELEASE}
  // There is a memory leak in the JvDriveCtrl and it's really anonying...
  cbxDrives.ImageSize := isLarge;

  // Hide PageControl Tabs
  for i := 0 to pcWizard.PageCount - 1 do
    pcWizard.Pages[i].TabVisible := False;
{$ENDIF}

  // Color of the Wizard TPageControl
  pcWizard.Brush.Color := clCream;
  pcWizard.Brush.Style := bsSolid;
  pnlTop.Color := clMaroon;
  pnlLeft.Color := clCream;
  pnlBottom.Color := clMaroon;

  // Set if the button must be disabled or not.
  OnWizardAfterPageChange;
end;

function TfrmMain.MsgBox(Text, Title: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PAnsiChar(Text), PAnsiChar(Title), Flags);
end;

procedure TfrmMain.Next;
begin
  case btnNext.Tag of
    // Default: Next page
    BUTTON_ACTION_DEFAULT:
      pcWizard.SelectNextPage(True, False);

    // Finish
    BUTTON_ACTION_FINISH:
      Close;

    // Launch Identification process
    BUTTON_ACTION_DO_IDENTIFICATION:
      DoIdentificationProcess;

    // Check the extract params.
    BUTTON_ACTION_CHECK_EXTRACT_PARAMS:
      DoCheckExtractParams;

    // Launch the unpack process
    BUTTON_ACTION_DO_UNLOCK_PACKAGE:
      DoUnlockPackage;
  end;
end;

procedure TfrmMain.OnWizardAfterPageChange;
var
  UISectionName: string;
  
begin
  // Reset default values
  btnPrev.Enabled := PageIndex > 0;
  btnNext.Enabled := True;

  btnPrev.Caption := GetStringUI('Buttons', 'Previous');
  btnNext.Caption := GetStringUI('Buttons', 'Next');
  btnNext.Tag := BUTTON_ACTION_DEFAULT;
  btnPrev.Tag := BUTTON_ACTION_DEFAULT;

  rbnLicenseAccept.Checked := False;
  rbnLicenseDecline.Checked := True;

  // Do something special with the current page...
  case PageIndex of
    // License
    SCREEN_LICENSE:
      btnNext.Enabled := rbnLicenseAccept.Checked;

    // Check disc
    SCREEN_CHECKDISC:
      begin                           
        btnNext.Caption := GetStringUI('Buttons', 'Start');
        btnNext.Tag := BUTTON_ACTION_DO_IDENTIFICATION;
      end;

    // Authentification failed
    SCREEN_CHECKDISC_FAILED:
      begin
        btnPrev.Caption := GetStringUI('Buttons', 'Retry');
        btnNext.Caption := GetStringUI('Buttons', 'Finish');
        btnNext.Tag := BUTTON_ACTION_FINISH;
      end;

    // Parameters
    SCREEN_EXTRACT_PARAMETERS:
      begin
        btnPrev.Tag := BUTTON_ACTION_SHOW_CHECKDISC;
        btnNext.Tag := BUTTON_ACTION_CHECK_EXTRACT_PARAMS;
      end;

    // Ready to extract
    SCREEN_READY_TO_EXTRACT:
      begin
        btnNext.Caption := GetStringUI('Buttons', 'Start');
        btnNext.Tag := BUTTON_ACTION_DO_UNLOCK_PACKAGE;
        SetStatusProgress(0);
      end;

    // Working...
    SCREEN_WORKING:
      begin
        btnPrev.Enabled := False;
        btnNext.Enabled := False;
      end;

    // Finish OK
    SCREEN_FINISH:
      begin
        btnPrev.Enabled := False;
        btnNext.Caption := GetStringUI('Buttons', 'Finish');
        btnNext.Tag := BUTTON_ACTION_FINISH;
      end;

    // Finish failed...
    SCREEN_FINISH_FAILED:
      begin
        btnPrev.Enabled := False;
        btnNext.Caption := GetStringUI('Buttons', 'Finish');
        btnNext.Tag := BUTTON_ACTION_FINISH;
      end;
  end;

  // Load Wizard strings UI...
  UISectionName := pcWizard.FindNextPage(pcWizard.ActivePage, True, False).Name;
  UISectionName := Copy(UISectionName, 3, Length(UISectionName) - 2);
  LoadWizardUI(UISectionName);
  if UISectionName = 'AuthFail' then
    LoadWizardUI('Params'); // load too...
  if UISectionName = 'Done' then
    LoadWizardUi('DoneFail');  
end;

function TfrmMain.OnWizardBeforePageChange;
begin
  Result := True;
end;

procedure TfrmMain.PackageUnlockFinish(Sender: TObject);
var
  Thread: TPackageExtractorThread;

begin
{$IFDEF DEBUG}
  Write('Finish: ');
{$ENDIF}

  Thread := Sender as TPackageExtractorThread;
  if Thread.Aborted then
  begin
    // Aborted
    AddDebug(GetStringUI('MsgText', 'OperationCanceled'));
    PageIndex := SCREEN_FINISH_FAILED;
{$IFDEF DEBUG}
  WriteLn('Aborted');
{$ENDIF}
  end else if (not Thread.Success) then
  begin
    // Error
    AddDebug(Thread.ErrorMessage);
    PageIndex := SCREEN_FINISH_FAILED;
{$IFDEF DEBUG}
  WriteLn('Errpr');
{$ENDIF}
  end else begin
    // Success
    SetStatusProgress(MaxDouble);
    PageIndex := SCREEN_FINISH;
{$IFDEF DEBUG}
  WriteLn('Success');
{$ENDIF}
  end;
end;

procedure TfrmMain.PackageUnlockProgress(Sender: TObject; Current,
  Total: Int64);
begin
{$IFDEF DEBUG}
  Write('  ', Current, '/', Total, #13);
{$ENDIF}
  SetStatusProgress(Current);
end;

procedure TfrmMain.PackageUnlockStart(Sender: TObject; Total: Int64);
begin
{$IFDEF DEBUG}
  WriteLn('Total: ', Total);
{$ENDIF}
  SetStatusProgressMax(Total);
  SetStatusProgress(0);
end;

procedure TfrmMain.pcWizardChange;
begin
  OnWizardAfterPageChange;
end;

procedure TfrmMain.pcWizardChanging;
begin
  AllowChange := ((PageIndex > 0) or (PageIndex < PageIndexMax))
    and OnWizardBeforePageChange;
end;

procedure TfrmMain.Previous;
begin
  case btnPrev.Tag of
    // Default : Previous page
    BUTTON_ACTION_DEFAULT:
      pcWizard.SelectNextPage(False, False);

    // Return to the disc auth page...
    BUTTON_ACTION_SHOW_CHECKDISC:
      PageIndex := SCREEN_CHECKDISC;
  end;
end;

procedure TfrmMain.rbnLicenseAcceptClick(Sender: TObject);
begin
  if PageIndex = SCREEN_LICENSE then
    btnNext.Enabled := rbnLicenseAccept.Checked;
end;

procedure TfrmMain.SetPageIndex(const Value: Integer);
begin
  pcWizard.ActivePageIndex := Value;
  pcWizardChange(Self);
end;

procedure TfrmMain.SetStatusProgress(const Value: Double);
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
  pbTotal.Position := Ceil(Step);
  lblUnpackProgress.Caption := FormatFloat('0.00', Step) + '%';
end;

procedure TfrmMain.SetStatusProgressMax(const MaxValue: Double);
begin
  fStatusProgressMax := MaxValue;
  pbTotal.Max := 100;
  SetStatusProgress(0);
end;

procedure TfrmMain.SetUnpackedSize(const Value: Int64);
var
  SizeUnit: TSizeUnit;

begin
  fUnpackedSize := Value;
  lblParamsUnpackedSize.Caption :=
    GetStringUI('Params', 'lblparamsUnpackedSize') + ' '
      + FormatByteSize(UnpackedSize, SizeUnit) + ' '
      + SizeUnitToString(SizeUnit);
end;

procedure TfrmMain.WorkingThreadTerminateHandler;
begin
  // The thread is closed, we can close the application now.
  if fCanceledByClosingWindow then  
    Close
  else begin
    btnCancel.Enabled := True;
    SetCloseWindowButtonState(Self, True);
  end;
end;

end.
