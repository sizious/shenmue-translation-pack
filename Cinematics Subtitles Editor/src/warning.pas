unit Warning;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmWarning = class(TForm)
    bOK: TButton;
    cbUnderstood: TCheckBox;
    Bevel1: TBevel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    tCloseEnabler: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tCloseEnablerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }  
    fEnableCloseState: Boolean;
    procedure SetEnableCloseState(const Value: Boolean);
  public
    { Déclarations publiques }
    property EnableCloseState: Boolean read fEnableCloseState
      write SetEnableCloseState;
  end;

procedure ShowWarningOnDemand;

implementation

{$R *.dfm}

uses
  Config, UITools;

//------------------------------------------------------------------------------

procedure ShowWarningOnDemand;
var
  UI: TfrmWarning;

begin
  if not IsMigrationWarningUnderstood then begin
    UI := TfrmWarning.Create(Application);
    with UI do
      try
        ShowModal;
      finally
        Free;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmWarning.FormClose(Sender: TObject; var Action: TCloseAction);
var
  WarningUnderstood: Boolean;

begin
  WarningUnderstood := (ModalResult = mrOk) and (cbUnderstood.Checked);
  SetWarningUnderstood(WarningUnderstood);
end;

//------------------------------------------------------------------------------

procedure TfrmWarning.FormCreate(Sender: TObject);
begin
  EnableCloseState := False;
end;

//------------------------------------------------------------------------------

procedure TfrmWarning.FormShow(Sender: TObject);
begin
  MessageBeep(MB_ICONWARNING);
end;

//------------------------------------------------------------------------------

procedure TfrmWarning.SetEnableCloseState(const Value: Boolean);
begin
  fEnableCloseState := Value;
  SetCloseWindowButtonState(Self, fEnableCloseState);
  bOK.Enabled := fEnableCloseState;
end;

//------------------------------------------------------------------------------

procedure TfrmWarning.tCloseEnablerTimer(Sender: TObject);
begin
  tCloseEnabler.Enabled := False;
  EnableCloseState := True;
end;

//------------------------------------------------------------------------------

end.
