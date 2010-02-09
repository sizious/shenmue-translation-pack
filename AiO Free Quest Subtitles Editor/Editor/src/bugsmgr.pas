unit bugsmgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
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
  private
    { Déclarations privées }
    fErrorMsg : string;
    fErrorType : string;
    fErrorSender : string;
  public
    { Déclarations publiques }
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
  end;

var
  frmBugsHandler: TfrmBugsHandler;

procedure RunBugsHandler(Sender: TObject; E: Exception);

implementation

uses
  main, utils;

{$R *.dfm}

//------------------------------------------------------------------------------

procedure RunBugsHandler(Sender: TObject; E: Exception);
begin
  frmBugsHandler := TfrmBugsHandler.Create(Application);
  try
    with frmBugsHandler do begin
      fErrorMsg := E.Message;
      fErrorSender := Sender.ClassName;
      fErrorType := E.ClassType.ClassName;
    end;
    frmBugsHandler.ShowModal;
  finally
    frmBugsHandler.Free;
  end;  
end;

//------------------------------------------------------------------------------

procedure AddException(Msg : string);
begin
  frmMain.AddDebug('FATAL ERROR: ' + Msg);
end;

//------------------------------------------------------------------------------

procedure TfrmBugsHandler.bQuitClick(Sender: TObject);
var
  CanDo : integer;

begin
  CanDo := MsgBox('Are you sure to quit the application ?',
    'Exit application ?', MB_ICONWARNING + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;

  ExitCode := 255;
  if frmMain.Visible then  
    frmMain.miQuit.Click
  else begin
    Application.ShowMainForm := False;
    Application.Terminate;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBugsHandler.bReturnClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmBugsHandler.bSaveDebugLogClick(Sender: TObject);
begin
  frmMain.miSaveDebugLog.Click;
end;

//------------------------------------------------------------------------------

procedure TfrmBugsHandler.FormShow(Sender: TObject);
var
  err, s : string;

begin
  s := StringReplace(fErrorMsg, sLineBreak, ' ', [rfReplaceAll]);
  err := s + ' (exception class type: ' + fErrorType + ', sender : '
    + fErrorSender + ').';
  MessageBeep(MB_ICONERROR);
  mExceptionMessage.Text := fErrorMsg;
  AddException(err);
end;

//------------------------------------------------------------------------------

function TfrmBugsHandler.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

//------------------------------------------------------------------------------

end.
