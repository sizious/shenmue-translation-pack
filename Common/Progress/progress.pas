unit Progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

type
  TProgressInterface = class;
  TProgressionDialogCancelResult =
    procedure(Sender: TObject; Canceled: Boolean) of object;
    
  TProgressionDialog = class(TObject)
  private
    fCancelRequest: TNotifyEvent;
    fWindow: TProgressInterface;
    fCancelResult: TProgressionDialogCancelResult;
    function GetTitle: TCaption;
    procedure SetTitle(const Value: TCaption);
    property Window: TProgressInterface read fWindow write fWindow;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute(const MaxValue: Integer): Boolean;
    procedure Update(const ATextInfo: TCaption);
    procedure Terminate;
    property OnCancelRequest: TNotifyEvent read fCancelRequest
      write fCancelRequest;
    property OnCancelResult: TProgressionDialogCancelResult read fCancelResult
      write fCancelResult;
    property Title: TCaption read GetTitle write SetTitle;
  end;

  TProgressInterface = class(TForm)
    lInfos: TLabel;
    pbar: TProgressBar;
    btnCancel: TButton;
    bvlBottom: TBevel;
    lProgBar: TPanel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    fOwner: TProgressionDialog;
    { Déclarations privées }
    function MsgBox(const Text, Title: string; Flags: Integer): Integer;
    procedure Reset(const MaxValue: Integer);
    function GetTextInfo: TCaption;
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
  fWindow := TProgressInterface.Create(nil);
  Window.ModalResult := mrNone;
  Window.fOwner := Self;
end;

destructor TProgressionDialog.Destroy;
begin
  Window.Free;
  inherited;
end;

function TProgressionDialog.Execute(const MaxValue: Integer): Boolean;
begin
  Window.Reset(MaxValue);
  Result := (Window.ShowModal = mrOK);
end;

function TProgressionDialog.GetTitle: TCaption;
begin
  Result := Window.Caption;
end;

procedure TProgressionDialog.SetTitle(const Value: TCaption);
begin
  Window.Caption := Value;
end;

procedure TProgressionDialog.Terminate;
begin
  Window.ChangeCancelButtonsState(False);
  Window.ModalResult := mrOK;
//  Window.Close;
end;

procedure TProgressionDialog.Update(const ATextInfo: TCaption);
begin
  Window.UpdateStep(ATextInfo);
end;

procedure TProgressInterface.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TProgressInterface.ChangeCancelButtonsState(const State: Boolean);
begin
  SetCloseWindowButtonState(Self, State);
  btnCancel.Enabled := State;
end;

procedure TProgressInterface.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  CanContinue: Integer;

begin
  if (ModalResult <> mrOK) then begin
    // The form will be closed by the Terminate function if needed
    Action := caNone;
    
    // Notify that we want to ask the cancel question
    if Assigned(Owner.OnCancelRequest) then
      Owner.OnCancelRequest(Self);

    // Ask the cancel question
    CanContinue := MsgBox('Cancel the current operation ?', 'Question',
      MB_ICONQUESTION + MB_DEFBUTTON2 + MB_OKCANCEL);
    if Assigned(Owner.OnCancelResult) then
      Owner.OnCancelResult(Self, CanContinue = IDOK);
  end;
end;

procedure TProgressInterface.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

function TProgressInterface.GetTextInfo: TCaption;
begin
  Result := lInfos.Caption;
end;

function TProgressInterface.MsgBox(const Text, Title: string;
  Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Title), Flags);
end;

procedure TProgressInterface.Reset(const MaxValue: Integer);
begin
  pbar.Max := MaxValue;
  pbar.Position := 0;
  pbar.Step := 1;
  lProgBar.Caption := '0.00%';
  TextInfo := '';
end;

procedure TProgressInterface.SetTextInfo(const Value: TCaption);
begin
  lInfos.Caption := Value;
end;

procedure TProgressInterface.UpdateStep(const ATextInfo: TCaption);
begin
  TextInfo := ATextInfo;
  pbar.StepIt;
  lProgBar.Caption :=
    FormatFloat('0.00', SimpleRoundTo((100 * pbar.Position) / pbar.Max, -2)) + '%';
end;

end.
