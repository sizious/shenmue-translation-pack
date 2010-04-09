unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TActionMethod = (amDecode, amEncode);
  
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
    od: TOpenDialog;
    sd: TSaveDialog;
    procedure bQuitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rbBytesCustomClick(Sender: TObject);
    procedure rbBytesAutoClick(Sender: TObject);
    procedure rbCharsCustomClick(Sender: TObject);
    procedure rbCharsAutoClick(Sender: TObject);
    procedure rgActionClick(Sender: TObject);
    procedure bInputClick(Sender: TObject);
    procedure bOutputClick(Sender: TObject);
    procedure bExecuteClick(Sender: TObject);
  private
    { Déclarations privées }
    fCustomBytes: Boolean;
    fCustomChars: Boolean;
    fMethod: TActionMethod;
    fAutomaticBytesPerLine: Integer;
    fAutomaticCharsPerLine: Integer;
    function GetBytesValue: Integer;
    function GetCharsValue: Integer;
    function ComputeAutomaticParamatersValues: Boolean;
    function GetStatusText: string;
    procedure JobTerminated(Sender: TObject);
    procedure SetStatusText(const Value: string);
    procedure SetCustomBytes(const Value: Boolean);
    procedure SetCustomChars(const Value: Boolean);
    procedure SetDialogsFilter;
    procedure SetMethod(const Value: TActionMethod);
    function GetOutputExtension: string;
    function GetInputExtension: string;
    property AutomaticBytesPerLine: Integer read fAutomaticBytesPerLine;
    property AutomaticCharsPerLine: Integer read fAutomaticCharsPerLine;
    property InputExtension: string read GetInputExtension;
    property OutputExtension: string read GetOutputExtension;
  public
    { Déclarations publiques }
    procedure Clear;
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    property BytesParameter: Integer read GetBytesValue;
    property CharsParameter: Integer read GetCharsValue;
    property CustomBytes: Boolean read fCustomBytes write SetCustomBytes;
    property CustomChars: Boolean read fCustomChars write SetCustomChars;
    property Method: TActionMethod read fMethod write SetMethod;
    property StatusText: string read GetStatusText write SetStatusText;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  FontMgr, SysTools, FontExec, UITools;

procedure TfrmMain.bExecuteClick(Sender: TObject);
var
  FontManagerThread: TFontManagerThread;

begin
  ComputeAutomaticParamatersValues;

  // Check params
  if (not FileExists(eInput.Text)) or (eOutput.Text = '') then begin
    MsgBox('Please check your input/output file parameters.', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  if (BytesParameter < 1) or (CharsParameter < 1) then begin
    MsgBox('The automatic detection has failed. ' + sLineBreak + 
      'Please change the parameters manually.', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  // Execute
  sbMain.SimpleText := 'Converting...';
  bExecute.Enabled := False;

  FontManagerThread := TFontManagerThread.Create(Method, eInput.Text,
    eOutput.Text, BytesParameter, CharsParameter);
  FontManagerThread.OnTerminate := JobTerminated;
  FontManagerThread.Resume;
end;

procedure TfrmMain.bInputClick(Sender: TObject);
begin
  with od do
    if Execute then begin
      eInput.Text := FileName;
      eInput.SelectAll;
      eOutput.Text := ChangeFileExt(eInput.Text, '.' + OutputExtension);
      eOutput.SelectAll;
      eInput.SetFocus;
    end;
end;

procedure TfrmMain.bOutputClick(Sender: TObject);
begin
  with sd do
    if Execute then begin
      eOutput.Text := FileName;
      eOutput.SetFocus;
      eOutput.SelectAll;
    end;
end;

procedure TfrmMain.bQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.Clear;
begin
  fAutomaticBytesPerLine := -1;
  fAutomaticCharsPerLine := -1;
  eInput.Text := '';
  eOutput.Text := '';
  rbBytesAuto.Checked := True;
  rbCharsAuto.Checked := True;
  StatusText := '';
  eCharsCustom.Text := '1';
  eBytesCustom.Text := '4';
  sbMain.SimpleText := 'Ready';  
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title + ' v' + GetApplicationVersion;
  
  Clear;
  Method := TActionMethod(0);
end;

function TfrmMain.GetBytesValue: Integer;
begin
  Result := -1;
  if rbBytesTwo.Checked then
    // 2
    Result := 2
  else if rbBytesThree.Checked then
    // 3
    Result := 3
  else if rbBytesCustom.Checked then
    // Custom
    Result := StrToIntDef(eBytesCustom.Text, -1)
  else if rbBytesAuto.Checked then begin
    Result := AutomaticBytesPerLine;
  end;
end;

function TfrmMain.GetCharsValue: Integer;
begin
  Result := -1;
  if rbCharsCustom.Checked then
    // Custom
    Result := StrToIntDef(eCharsCustom.Text, -1)
  else if rbCharsAuto.Checked then begin
    Result := AutomaticCharsPerLine;
  end;
end;

function TfrmMain.GetInputExtension: string;
begin
  case Method of
    amDecode: Result := 'FON';
    amEncode: Result := 'BMP';
  end;
end;

function TfrmMain.GetOutputExtension: string;
begin
  case Method of
    amDecode: Result := 'BMP';
    amEncode: Result := 'FON';
  end;
end;

function TfrmMain.ComputeAutomaticParamatersValues: Boolean;
type
  TDecodeAutoBytes = record
    FileSize,
    BytesResult,
    CharsResult: Integer;
  end;

  TEncodeAutoBytes = record
    Width,
    Height,
    BytesResult,
    CharsResult: Integer;
  end;

const
  DECODE_AUTONUMBER: array[0..1] of TDecodeAutoBytes = (
    (FileSize: 7680   ; BytesResult: 2; CharsResult: 32),
    (FileSize: 351270 ; BytesResult: 3; CharsResult: 6)
  );

  ENCODE_AUTONUMBER: array[0..1] of TEncodeAutoBytes = (
    (Width: 512; Height: 120  ; BytesResult: 2; CharsResult: 32),
    (Width: 144; Height: 19515; BytesResult: 3; CharsResult: 6)
  );

var
  InputSize, i: Integer;
  Bmp: TBitmap;
  
begin
  Result := False;
  fAutomaticBytesPerLine := -1;
  fAutomaticCharsPerLine := -1;
  
  case Method of
    amDecode:
      begin
        InputSize := GetFileSize(eInput.Text);
        if InputSize = -1 then Exit;
        for i := Low(DECODE_AUTONUMBER) to High(DECODE_AUTONUMBER) do
          if DECODE_AUTONUMBER[i].FileSize = InputSize then begin
            Result := True;
            fAutomaticBytesPerLine := DECODE_AUTONUMBER[i].BytesResult;
            fAutomaticCharsPerLine := DECODE_AUTONUMBER[i].CharsResult;
            Break;
          end;
      end; // amDecode
    amEncode:
      begin
        if not FileExists(eInput.Text) then Exit;
        Bmp := TBitmap.Create;
        try
          try
            Bmp.LoadFromFile(eInput.Text);
            for i := Low(ENCODE_AUTONUMBER) to High(ENCODE_AUTONUMBER) do
            if (ENCODE_AUTONUMBER[i].Width = Bmp.Width)
              and (ENCODE_AUTONUMBER[i].Height = Bmp.Height) then begin
              Result := True;
              fAutomaticBytesPerLine := ENCODE_AUTONUMBER[i].BytesResult;
              fAutomaticCharsPerLine := ENCODE_AUTONUMBER[i].CharsResult;
              Break;
            end;
          except
            Result := False;
          end;
        finally
          Bmp.Free;
        end;
      end; // amEncode
  end; // case
end;

function TfrmMain.GetStatusText: string;
begin
  Result := sbMain.SimpleText;
end;

procedure TfrmMain.JobTerminated(Sender: TObject);
begin
  bExecute.Enabled := True;

  if FileExists(eOutput.Text) and (GetFileSize(eOutput.Text) > 0) then begin
    sbMain.SimpleText := 'OK!';
    Delay(2000);
  end else
    MsgBox('Error when converting... Check your input parameters.', 'Warning',
      MB_ICONWARNING);

  sbMain.SimpleText := 'Ready';
end;

function TfrmMain.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMain.rbBytesAutoClick(Sender: TObject);
begin
  CustomBytes := False;
end;

procedure TfrmMain.rbBytesCustomClick(Sender: TObject);
begin
  CustomBytes := True;
end;

procedure TfrmMain.rbCharsAutoClick(Sender: TObject);
begin
  CustomChars := False;
end;

procedure TfrmMain.rbCharsCustomClick(Sender: TObject);
begin
  CustomChars := True;
end;

procedure TfrmMain.rgActionClick(Sender: TObject);
begin
  Method := TActionMethod(rgAction.ItemIndex);
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
  eCharsCustom.Enabled := fCustomChars;
  lCharsCustom.Enabled := fCustomChars;
end;

procedure TfrmMain.SetDialogsFilter;
const
  BMP_FILTER = 'Bitmap (*.BMP;*.DIB)|*.BMP;*.DIB';
  FON_FILTER = 'Binary Font (*.FON;*.BIN)|*.FON;*.BIN';
  ALL_FILTER = '|All Files (*.*)|*.*';
  
begin
  case Method of
    amDecode:
      begin
        od.Filter := FON_FILTER + ALL_FILTER;
        sd.Filter := BMP_FILTER + ALL_FILTER;
      end;
    amEncode:
      begin
        od.Filter := BMP_FILTER + ALL_FILTER;
        sd.Filter := FON_FILTER + ALL_FILTER;
      end;
  end;
  od.DefaultExt := InputExtension;
  sd.DefaultExt := OutputExtension;
end;

procedure TfrmMain.SetMethod(const Value: TActionMethod);
begin
  fMethod := Value;
  SetDialogsFilter;
  if eInput.Text <> '' then begin
    eInput.Text := ChangeFileExt(eInput.Text, '.' + InputExtension);
    eInput.SelectAll;
  end;
  if eOutput.Text <> '' then begin
    eOutput.Text := ChangeFileExt(eOutput.Text, '.' + OutputExtension);
    eOutput.SelectAll;
  end;
end;

procedure TfrmMain.SetStatusText(const Value: string);
begin
  sbMain.SimpleText := Value;
end;

end.
