(*
  Implements a Progress Window
*)
unit Progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

type
  TProgressWindow = class;
  TProgressionDialogCancelResult =
    procedure(Sender: TObject; Canceled: Boolean) of object;

  TProgressionDialog = class(TObject)
  private
    fCancelRequest: TNotifyEvent;
    fWindow: TProgressWindow;
    fCancelResult: TProgressionDialogCancelResult;
    fTerminated: Boolean;
    function GetTitle: TCaption;
    procedure SetTitle(const Value: TCaption);
    property Terminated: Boolean read fTerminated write fTerminated;
    property Window: TProgressWindow read fWindow write fWindow;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute: Boolean;
    procedure Initialize(const MaxValue: Integer);
    procedure Update(const ATextInfo: TCaption);
    procedure Terminate;
    property OnCancelRequest: TNotifyEvent read fCancelRequest
      write fCancelRequest;
    property OnCancelResult: TProgressionDialogCancelResult read fCancelResult
      write fCancelResult;
    property Title: TCaption read GetTitle write SetTitle;
  end;

  TProgressWindow = class(TForm)
    lInfos: TLabel;
    pbar: TProgressBar;
    btnCancel: TButton;
    bvlBottom: TBevel;
    lProgBar: TPanel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }  
    fOwner: TProgressionDialog;
    function MsgBox(const Text, Title: string; Flags: Integer): Integer;
    procedure Initialize(const MaxValue: Integer);
    function GetTextInfo: TCaption;
    procedure Reset;
    procedure SetTextInfo(const Value: TCaption);
    procedure UpdateStep(const ATextInfo: TCaption);
    procedure ChangeCancelButtonsState(const State: Boolean);
    property TextInfo: TCaption read GetTextInfo write SetTextInfo;
  public
    { Déclarations publiques }
    property Owner: TProgressionDialog read fOwner;
  end;

implementation

{$R *.dfm}

uses
  Math, UITools;

{ TProgressionDialog }

constructor TProgressionDialog.Create;
begin
  fWindow := TProgressWindow.Create(nil);
  Terminated := False;
  Window.fOwner := Self;
  Title := 'Operation in progress... please wait.';
end;

destructor TProgressionDialog.Destroy;
begin
  Window.Free;
  inherited;
end;

function TProgressionDialog.Execute: Boolean;
begin
  Terminated := False;
  Window.ShowModal;
{$IFDEF DEBUG}
  WriteLn('[Progress] Execute: End');
{$ENDIF}
  Result := Terminated;
end;

function TProgressionDialog.GetTitle: TCaption;
begin
  Result := Window.Caption;
end;

procedure TProgressionDialog.Initialize(const MaxValue: Integer);
begin
  Window.Initialize(MaxValue);
end;

procedure TProgressionDialog.SetTitle(const Value: TCaption);
begin
  Window.Caption := Value;
end;

procedure TProgressionDialog.Terminate;
begin
{$IFDEF DEBUG}
  WriteLn('[Progress] Terminate');
{$ENDIF}
  Terminated := True;
  with Window do begin
    ModalResult := mrOK;
    ChangeCancelButtonsState(False);
    Close;
  end;
end;

procedure TProgressionDialog.Update(const ATextInfo: TCaption);
begin
  Window.UpdateStep(ATextInfo);
end;

{ TProgressWindow }

procedure TProgressWindow.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TProgressWindow.ChangeCancelButtonsState(const State: Boolean);
begin
  SetCloseWindowButtonState(Self, State);
  btnCancel.Enabled := State;
end;

procedure TProgressWindow.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  CanContinue: Integer;

begin
{$IFDEF DEBUG}
  WriteLn('[Progress] Close: Begin');
{$ENDIF}

  with Owner do begin

    if not Terminated then begin
{$IFDEF DEBUG}
      WriteLn('[Progress] Close: Not Terminated');
{$ENDIF}
      // The form will be closed by the Terminate function if needed
      Action := caNone;

      // Notify that we want to ask the cancel question
      if Assigned(OnCancelRequest) then
        OnCancelRequest(Self);

      // Ask the cancel question
      CanContinue := MsgBox('Cancel the current operation ?', 'Question',
        MB_ICONQUESTION + MB_DEFBUTTON2 + MB_OKCANCEL);

      Terminated := CanContinue = IDOK;
      if Assigned(OnCancelResult) then
        OnCancelResult(Self, Terminated);
    end;
    
  end;
  
{$IFDEF DEBUG}
  WriteLn('[Progress] Close: End');
{$ENDIF}
end;

procedure TProgressWindow.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
end;

procedure TProgressWindow.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

procedure TProgressWindow.FormShow(Sender: TObject);
begin
  Reset;
end;

function TProgressWindow.GetTextInfo: TCaption;
begin
  Result := lInfos.Caption;
end;

function TProgressWindow.MsgBox(const Text, Title: string;
  Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Title), Flags);
end;

procedure TProgressWindow.Reset;
begin
  ChangeCancelButtonsState(True);
  pbar.Position := 0;
  pbar.Step := 1;
  lProgBar.Caption := '0.00%';
  TextInfo := '';
end;

procedure TProgressWindow.Initialize(const MaxValue: Integer);
begin
  pbar.Max := MaxValue;
end;

procedure TProgressWindow.SetTextInfo(const Value: TCaption);
begin
  lInfos.Caption := Value;
  Application.ProcessMessages;
end;

procedure TProgressWindow.UpdateStep(const ATextInfo: TCaption);
begin
  TextInfo := ATextInfo;
  pbar.StepIt;
  try
    lProgBar.Caption :=
      FormatFloat('0.00', SimpleRoundTo((100 * pbar.Position) / pbar.Max, -2)) + '%';
  except
    lProgBar.Caption := '0.00%';
  end;
end;

end.
