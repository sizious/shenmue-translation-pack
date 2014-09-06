unit BugsMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TExceptionCallBack = procedure(Sender: TObject; ExceptionMessage: string) of object;

  TBugsHandlerInterface = class(TObject)
  private
    fSaveLogRequest: TNotifyEvent;
    fExceptionCallBack: TExceptionCallBack;
    fQuitRequest: TNotifyEvent;
    procedure SetExceptionCallBack(const Value: TExceptionCallBack);
    procedure SetQuitRequest(const Value: TNotifyEvent);
    procedure SetSaveLogRequest(const Value: TNotifyEvent);
    function GetLogSaveFeature: Boolean;
    procedure SetLogSaveFeature(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute(Sender: TObject; E: Exception);
    property LogSaveFeature: Boolean
      read GetLogSaveFeature write SetLogSaveFeature;
    property OnExceptionCallBack: TExceptionCallBack read
      fExceptionCallBack write SetExceptionCallBack;
    property OnSaveLogRequest: TNotifyEvent read fSaveLogRequest
      write SetSaveLogRequest;
    property OnQuitRequest: TNotifyEvent read fQuitRequest write SetQuitRequest;
  end;

  TfrmBugsHandler = class(TForm)
    iError: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    mExceptionMessage: TMemo;
    bReturn: TButton;
    bSaveDebugLog: TButton;
    bQuit: TButton;
    procedure FormShow(Sender: TObject);
    procedure bQuitClick(Sender: TObject);
    procedure bReturnClick(Sender: TObject);
    procedure bSaveDebugLogClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
    fErrorMsg : string;
    fErrorType : string;
    fErrorSender : string;
    fExceptionCallBack: TExceptionCallBack;
    fQuitRequest: TNotifyEvent;
    fSaveLogRequest: TNotifyEvent;
    fQuitAction: Boolean;
  protected
    property QuitAction: Boolean read fQuitAction write fQuitAction;
  public
    { Déclarations publiques }
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    property OnExceptionCallBack: TExceptionCallBack read
      fExceptionCallBack write fExceptionCallBack;
    property OnSaveLogRequest: TNotifyEvent read fSaveLogRequest
      write fSaveLogRequest;
    property OnQuitRequest: TNotifyEvent read fQuitRequest write fQuitRequest;
  end;

(* var
  frmBugsHandler: TfrmBugsHandler; *)

implementation

{$R *.dfm}

var
  frmBugsHandler: TfrmBugsHandler;

//------------------------------------------------------------------------------

procedure TfrmBugsHandler.bQuitClick(Sender: TObject);
var
  CanDo : integer;

begin
  CanDo := MsgBox('Are you sure to quit the application ?',
    'Exit application ?', MB_ICONWARNING + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;

  QuitAction := True;
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmBugsHandler.bReturnClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmBugsHandler.bSaveDebugLogClick(Sender: TObject);
begin
  if Assigned(fSaveLogRequest) then
    fSaveLogRequest(Self);
end;

//------------------------------------------------------------------------------

procedure TfrmBugsHandler.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if QuitAction and Assigned(fQuitRequest) then begin
    ExitCode := 255;  
    fQuitRequest(Self); // Don't destroy the BugsHandler object in this procedure!!
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBugsHandler.FormShow(Sender: TObject);
var
  err, s : string;

begin
  QuitAction := False;
  
  s := StringReplace(fErrorMsg, sLineBreak, ' ', [rfReplaceAll]);
  err := s + ' [Exception Class Type: ' + fErrorType + ', Sender : '
    + fErrorSender + '].';
  MessageBeep(MB_ICONERROR);
  mExceptionMessage.Text := fErrorMsg;

  if Assigned(fExceptionCallBack) then
    fExceptionCallBack(Self, Err);
end;

//------------------------------------------------------------------------------

function TfrmBugsHandler.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

//------------------------------------------------------------------------------

{ TBugsHandlerInterface }

constructor TBugsHandlerInterface.Create;
begin
{$IFDEF DEBUG}
  if Assigned(frmBugsHandler) then
    raise Exception.Create('Please remove the frmBugsHandler from the' +
      '''Form created by Delphi'' in the Project option dialog.'
    );
{$ENDIF}

  frmBugsHandler := TfrmBugsHandler.Create(nil);
end;

//------------------------------------------------------------------------------

destructor TBugsHandlerInterface.Destroy;
begin
  if frmBugsHandler.Visible then
    frmBugsHandler.Close;
  frmBugsHandler.Free;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TBugsHandlerInterface.Execute(Sender: TObject; E: Exception);
begin
  try
    with frmBugsHandler do begin
      fErrorMsg := E.Message;
      fErrorSender := Sender.ClassName;
      fErrorType := E.ClassType.ClassName;
      if not Visible then ShowModal;
    end;
  except
    on E:Exception do begin
      MessageBoxA(Application.Handle,
        PChar('TBugsHandlerInterface.Create: Unable to use the Bugs Handler !' + sLineBreak +
        'Abnormal Program Termination.' + sLineBreak + sLineBreak +
        'Reason: "' + E.Message + '".'),
        'Critical Exception', MB_ICONERROR);
      Application.Terminate;
//      Halt(255);
    end;
  end;
end;

//------------------------------------------------------------------------------

function TBugsHandlerInterface.GetLogSaveFeature: Boolean;
begin
  Result := frmBugsHandler.bSaveDebugLog.Enabled;
end;

//------------------------------------------------------------------------------

procedure TBugsHandlerInterface.SetExceptionCallBack(
  const Value: TExceptionCallBack);
begin
  fExceptionCallBack := Value;
  if Assigned(OnExceptionCallBack) then
    frmBugsHandler.OnExceptionCallBack := OnExceptionCallBack;
end;

//------------------------------------------------------------------------------

procedure TBugsHandlerInterface.SetLogSaveFeature(const Value: Boolean);
begin
  frmBugsHandler.bSaveDebugLog.Enabled := Value;
end;

//------------------------------------------------------------------------------

procedure TBugsHandlerInterface.SetQuitRequest(const Value: TNotifyEvent);
begin
  fQuitRequest := Value;
  if Assigned(OnQuitRequest) then
    frmBugsHandler.OnQuitRequest := OnQuitRequest;
end;

//------------------------------------------------------------------------------

procedure TBugsHandlerInterface.SetSaveLogRequest(const Value: TNotifyEvent);
begin
  fSaveLogRequest := Value;
  if Assigned(OnSaveLogRequest) then
    frmBugsHandler.OnSaveLogRequest := OnSaveLogRequest;
end;

//------------------------------------------------------------------------------

end.
