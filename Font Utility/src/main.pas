unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmMain = class(TForm)
    gbFiles: TGroupBox;
    eInput: TEdit;
    rgAction: TRadioGroup;
    gbBytes: TGroupBox;
    rbBytesAuto: TRadioButton;
    rbBytesTwo: TRadioButton;
    bExecute: TButton;
    rbBytesCustom: TRadioButton;
    eOutput: TEdit;
    gbChars: TGroupBox;
    rbCharsAuto: TRadioButton;
    rbCharsCustom: TRadioButton;
    eCharsCustom: TEdit;
    rbBytesThree: TRadioButton;
    eBytesCustom: TEdit;
    lBytes: TLabel;
    lCharsCustom: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    bInput: TButton;
    bOutput: TButton;
    bvl: TBevel;
    sbMain: TStatusBar;
    bQuit: TButton;
    procedure bQuitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rbBytesCustomClick(Sender: TObject);
    procedure rbBytesAutoClick(Sender: TObject);
  private
    fCustomBytes: Boolean;
    fCustomChars: Boolean;
    function GetStatusText: string;
    procedure SetStatusText(const Value: string);
    procedure SetCustomBytes(const Value: Boolean);
    procedure SetCustomChars(const Value: Boolean);
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Clear;
    property CustomBytes: Boolean read fCustomBytes write SetCustomBytes;
    property CustomChars: Boolean read fCustomChars write SetCustomChars;
    property StatusText: string read GetStatusText write SetStatusText;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  FontMgr;

//  DecodeFontFile('DC_KANA.FON', 'DC_KANA.BMP', 2, 32);
//  DecodeFontFile('DC_KANJI.FON', 'DC_KANJI.BMP', 3, 6);

procedure TfrmMain.bQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.Clear;
begin
  eInput.Text := '';
  eOutput.Text := '';
  rbBytesAuto.Checked := True;
  rbCharsAuto.Checked := True;
  StatusText := '';
  eCharsCustom.Text := '';
  eBytesCustom.Text := '';
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Clear;
end;

function TfrmMain.GetStatusText: string;
begin
  Result := sbMain.SimpleText;
end;

procedure TfrmMain.rbBytesAutoClick(Sender: TObject);
begin
  CustomBytes := False;
end;

procedure TfrmMain.rbBytesCustomClick(Sender: TObject);
begin
  CustomBytes := True;
end;

procedure TfrmMain.SetCustomBytes(const Value: Boolean);
begin
  fCustomBytes := Value;
  eBytesCustom.Enabled := fCustomBytes;
  lBytes.Enabled := fCustomBytes;
end;

procedure TfrmMain.SetCustomChars(const Value: Boolean);
begin
  fCustomChars := Value;
end;

procedure TfrmMain.SetStatusText(const Value: string);
begin
  sbMain.SimpleText := Value;
end;

end.
