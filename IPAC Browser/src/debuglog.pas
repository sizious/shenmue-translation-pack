unit debuglog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, JvExStdCtrls, JvRichEdit, ComCtrls, JvExComCtrls,
  JvStatusBar, AppEvnts;

type
  TLineType = (ltInformation, ltWarning, ltCritical);

  TDebugAttributes = record
    Color: TColor;
    Style: TFontStyles;
  end;

  TfrmDebugLog = class(TForm)
    mmDebug: TMainMenu;
    miFile: TMenuItem;
    miView: TMenuItem;
    miOnTop: TMenuItem;
    miSave: TMenuItem;
    miEdit: TMenuItem;
    miClearAll: TMenuItem;
    N1: TMenuItem;
    miCopy: TMenuItem;
    miSelectAll: TMenuItem;
    N2: TMenuItem;
    miClose: TMenuItem;
    mDebug: TJvRichEdit;
    sbDebug: TJvStatusBar;
    aeDebug: TApplicationEvents;
    sdDebug: TSaveDialog;
    miShowMainWindow: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure aeDebugHint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure miOnTopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure aeDebugException(Sender: TObject; E: Exception);
    procedure miSaveClick(Sender: TObject);
    procedure miShowMainWindowClick(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miClearAllClick(Sender: TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
  private
    { Déclarations privées }
    fOnTop: Boolean;
    procedure SetOnTop(const Value: Boolean);
  protected
    function GenerateDebugLogFileName: TFileName;
    function LineTypeToAttributes(LineType: TLineType): TDebugAttributes;
    function LineTypeToTextLabel(LineType: TLineType): string;
  public
    { Déclarations publiques }
    procedure AddLine(LineType: TLineType; const Text: string);
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    procedure SaveLogFile;
    property OnTop: Boolean read fOnTop write SetOnTop;
  end;

var
  frmDebugLog: TfrmDebugLog;

implementation

uses
  DateUtils, Main, Utils;

{$R *.dfm}

procedure TfrmDebugLog.AddLine(LineType: TLineType; const Text: string);
var
  Attr: TDebugAttributes;
  Timestamp: TDateTime;
//  SelLength, SelStart: Integer;

begin
  Timestamp := Now;
  Attr := LineTypeToAttributes(LineType);

//  SelLength := mDebug.SelLength;
//  SelStart := mDebug.SelStart;
//  mDebug.SelLength := 0;
//  mDebug.SelStart := Length(mDebug.Lines.Text) - 1;
{$IFDEF DEBUG}
  WriteLn('Debug: SelStart: ', mDebug.SelStart, ', SelLength: ', mDebug.SelLength,
    ', TextLength: ', Length(mDebug.Lines.Text));
{$ENDIF}

  mDebug.SelAttributes.Color := Attr.Color;
  mDebug.SelAttributes.Style := Attr.Style;

  mDebug.Lines.Add('[' + DateToStr(Timestamp) + ' ' + TimeToStr(Timestamp) + '] '
    + LineTypeToTextLabel(LineType) + Text);

//  mDebug.SelLength := SelLength;
//  mDebug.SelStart := SelStart;
end;

procedure TfrmDebugLog.aeDebugException(Sender: TObject; E: Exception);
begin
  BugsHandler.Execute(Sender, E);
  aeDebug.CancelDispatch;
end;

procedure TfrmDebugLog.aeDebugHint(Sender: TObject);
begin
  sbDebug.SimpleText := Application.Hint;
  aeDebug.CancelDispatch;
end;

procedure TfrmDebugLog.FormActivate(Sender: TObject);
begin
  aeDebug.Activate;
end;

procedure TfrmDebugLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.DebugLogVisible := False;
end;

procedure TfrmDebugLog.FormCreate(Sender: TObject);
begin
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  sbDebug.SimplePanel := True;

  // Load config
  LoadConfigDebug;
end;

procedure TfrmDebugLog.FormDestroy(Sender: TObject);
begin
  SaveConfigDebug;
end;

function TfrmDebugLog.GenerateDebugLogFileName: TFileName;
var
  PrgName: TFileName;
  TimeStamp: string;
  Year, Month, Day,
  Hour, Minute, Second,
  MilliSecond: Word;
  
begin
  DecodeDateTime(Now, Year, Month, Day, Hour, Minute, Second, MilliSecond);
  TimeStamp := Format('%2.4d%2.2d%2.2d_%2.2d%2.2d%2.2d', [Year, Month, Day, Hour, Minute, Second]);
  PrgName := ExtractFileName(ChangeFileExt(Application.ExeName, ''));
  Result := PrgName + '_' + TimeStamp;
end;

function TfrmDebugLog.LineTypeToAttributes(LineType: TLineType): TDebugAttributes;
begin
  Result.Color := clGray;
  Result.Style := [];
  case LineType of
    ltInformation:
      Result.Color := clGray;
    ltWarning:
      Result.Color := $000080FF; // orange
    ltCritical: begin
      Result.Color := clRed;
      Result.Style := [fsBold];
    end;
  end;
end;

function TfrmDebugLog.LineTypeToTextLabel(LineType: TLineType): string;
begin
  Result := '';
  case LineType of
    ltWarning: Result := 'WARNING: ';
    ltCritical: Result := 'CRITICAL: ';
  end;
end;

procedure TfrmDebugLog.miClearAllClick(Sender: TObject);
var
  CanDo: Integer;

begin
  CanDo := MsgBox('Are you sure to clear the Debug Log?', 'Question',
    MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;
  mDebug.Clear;
end;

procedure TfrmDebugLog.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDebugLog.miCopyClick(Sender: TObject);
begin
  mDebug.CopyToClipboard;
end;

procedure TfrmDebugLog.miOnTopClick(Sender: TObject);
begin
  OnTop := not OnTop;
end;

procedure TfrmDebugLog.miSaveClick(Sender: TObject);
begin
  SaveLogFile;
end;

procedure TfrmDebugLog.miSelectAllClick(Sender: TObject);
begin
  mDebug.SelectAll;
end;

procedure TfrmDebugLog.SaveLogFile;
begin
  with sdDebug do begin
    FileName := GenerateDebugLogFileName;
    if Execute then begin
      mDebug.PlainText := (FilterIndex = 2) or (FilterIndex = 3);
      mDebug.Lines.SaveToFile(FileName); // RTF format
    end;
  end;
end;

procedure TfrmDebugLog.SetOnTop(const Value: Boolean);
begin
  fOnTop := Value;
  miOnTop.Checked := Value;
  miShowMainWindow.Enabled := not Value;
  if Value then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TfrmDebugLog.miShowMainWindowClick(Sender: TObject);
begin
  frmMain.BringToFront;
end;

function TfrmDebugLog.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

end.
