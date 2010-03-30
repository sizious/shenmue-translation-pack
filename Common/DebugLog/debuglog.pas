unit DebugLog;

// =============================================================================
// DEBUG LOG MODULE
// =============================================================================

(*
  This is the Debug Log Module implementation. You can use it in every
  application.

  To use it, please:
    - Add this unit to your project
    - Declare a DebugLog object, instance of TDebugLogHandlerInterface
    - Declare a InitDebugLog private method
    - In the InitDebugLog, code as following:

    Please note that you MUST initialize the DebugLog module as is, that means
    you must first setting up the events THEN the Configuration property. That's
    because setting the Configuration object run the LoadConfig function. In the
    LoadConfig function, the "visible" property can be changed, and the
    OnVisibilityChange event must be set before loading a config!

    procedure <Your_Main_Form>.InitDebugLog;
    begin
      DebugLog := TDebugLogHandlerInterface.Create;
      with DebugLog do begin
        // Setting up events
        OnException := DebugLogExceptionEvent;
        OnMainWindowBringToFront := DebugLogMainFormToFront;
        OnVisibilityChange := DebugLogVisibilityChange;
        OnWindowActivated := DebugLogWindowActivated;

        // Setting up the properties
        Configuration := GetConfigurationObject; // in this order!
      end;
    end;

    OK, you know all. If you want to update the Debug Log module, you can, of
    course!

    - SiZ!
*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, JvExStdCtrls, JvRichEdit, ComCtrls, JvExComCtrls,
  JvStatusBar, AppEvnts, XmlConf;

type


  TfrmDebugLog = class;

  TLineType = (ltInformation, ltWarning, ltCritical);

  TDebugLogVisibilityChangeEvent =
    procedure(Sender: TObject; const Visible: Boolean) of object;

  // Please use this object in order to integrate the Debug Log functionality
  TDebugLogHandlerInterface = class
  private
    fFormDebugLog: TfrmDebugLog;
    fActive: Boolean;
    fVisibilityChange: TDebugLogVisibilityChangeEvent;
    fException: TExceptionEvent;
    fMainWindowBringToFront: TNotifyEvent;
    fWindowActived: TNotifyEvent;
    function GetConfiguration: TXMLConfigurationFile;
    procedure SetConfiguration(const Value: TXMLConfigurationFile);
    procedure SetActive(const Value: Boolean);
  protected
    property DebugLogWindow: TfrmDebugLog read fFormDebugLog;
  public
    // Initialization
    constructor Create;
    destructor Destroy; override;

    // Methods
    procedure AddLine(LineType: TLineType; const Text: string);
    procedure SaveLogFile;
    procedure Report(LineType: TLineType; MsgText, AdditionalDebugText: string);

    // Properties
    property Configuration: TXMLConfigurationFile
      read GetConfiguration write SetConfiguration;
    property Active: Boolean read fActive write SetActive;

    // Events
    property OnException: TExceptionEvent read fException write fException;
    property OnMainWindowBringToFront: TNotifyEvent read fMainWindowBringToFront
      write fMainWindowBringToFront;
    property OnVisibilityChange: TDebugLogVisibilityChangeEvent
      read fVisibilityChange write fVisibilityChange;
    property OnWindowActivated: TNotifyEvent read fWindowActived
      write fWindowActived;
  end;


  // ===========================================================================
  // STOP TO READ THE CODE HERE
  // ===========================================================================

  (*
    Used in some methods of the Debug Log Form.
  *)
  TDebugAttributes = record
    Color: TColor;
    Style: TFontStyles;
  end;

  (*
    The Debug Log form. Don't use it directly, please use the
    TDebugLogHandlerInterface object instead.
  *)
  TfrmDebugLog = class(TForm)
    mmDebug: TMainMenu;
    miFile: TMenuItem;
    miView: TMenuItem;
    miOnTop: TMenuItem;
    miSave: TMenuItem;
    miEdit: TMenuItem;
    miClearAll: TMenuItem;
    miSeparator2: TMenuItem;
    miCopy: TMenuItem;
    miSelectAll: TMenuItem;
    miSeparator1: TMenuItem;
    miClose: TMenuItem;
    mDebug: TJvRichEdit;
    sbDebug: TJvStatusBar;
    aeDebug: TApplicationEvents;
    sdDebug: TSaveDialog;
    miShowMainWindow: TMenuItem;
    miAutoScroll: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure aeDebugHint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure miOnTopClick(Sender: TObject);
    procedure aeDebugException(Sender: TObject; E: Exception);
    procedure miSaveClick(Sender: TObject);
    procedure miShowMainWindowClick(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miClearAllClick(Sender: TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
    procedure miAutoScrollClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    fOwnerHandler: TDebugLogHandlerInterface;
    fOnTop: Boolean;
    fAutoScroll: Boolean;
    fConfiguration: TXMLConfigurationFile;
    procedure SetOnTop(const Value: Boolean);
    procedure SetAutoScroll(const Value: Boolean);
  protected
    { Déclarations protégées }
    function GenerateDebugLogFileName: TFileName;
    function LineTypeToAttributes(LineType: TLineType): TDebugAttributes;
    function LineTypeToTextLabel(LineType: TLineType): string;
  public
    { Déclarations publiques }
    procedure AddLine(LineType: TLineType; const Text: string);
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
    procedure Report(LineType: TLineType; MsgText, AdditionalDebugText: string);
    procedure LoadConfig;
    procedure SaveConfig;
    procedure SaveLogFile;
    procedure ResetStatus;
    property AutoScroll: Boolean read fAutoScroll write SetAutoScroll;
    property Configuration: TXMLConfigurationFile
      read fConfiguration write fConfiguration;    
    property OnTop: Boolean read fOnTop write SetOnTop;
    property OwnerHandler: TDebugLogHandlerInterface read fOwnerHandler;
  end;

(* var
  frmDebugLog: TfrmDebugLog; *)

//==============================================================================
implementation
//==============================================================================

{$R *.dfm}

uses
  DateUtils;

//------------------------------------------------------------------------------
// TfrmDebugLog
//------------------------------------------------------------------------------

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

  // Selecting last line
  if AutoScroll then
    SendMessage(mDebug.Handle, WM_VSCROLL, SB_BOTTOM, 0);
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.aeDebugException(Sender: TObject; E: Exception);
begin
  if Assigned(OwnerHandler.OnException) then
    OwnerHandler.OnException(Sender, E);
        
  aeDebug.CancelDispatch;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.aeDebugHint(Sender: TObject);
begin
  sbDebug.SimpleText := Application.Hint;
  aeDebug.CancelDispatch;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.FormActivate(Sender: TObject);
begin
  if Assigned(OwnerHandler.OnWindowActivated) then
    OwnerHandler.OnWindowActivated(Sender);
  
  aeDebug.OnException := aeDebugException;
  aeDebug.Activate;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  OwnerHandler.fActive := False;
  if Assigned(OwnerHandler.OnVisibilityChange) then
    OwnerHandler.OnVisibilityChange(OwnerHandler, OwnerHandler.fActive);
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.FormCreate(Sender: TObject);
begin
  aeDebug.OnException := nil;

  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  sbDebug.SimplePanel := True;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.FormDeactivate(Sender: TObject);
begin
  ResetStatus;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.FormShow(Sender: TObject);
begin
{$IFDEF DEBUG}
  if not Assigned(OwnerHandler) then
    raise Exception.Create('Please use the TDebugLogHandlerInterface object to'
      + ' use this special Form!');
{$ENDIF}
end;
 
//------------------------------------------------------------------------------

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

//------------------------------------------------------------------------------

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

//------------------------------------------------------------------------------

function TfrmDebugLog.LineTypeToTextLabel(LineType: TLineType): string;
begin
  Result := '';
  case LineType of
    ltWarning: Result := 'WARNING: ';
    ltCritical: Result := 'CRITICAL: ';
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.LoadConfig;
begin
  if Assigned(Configuration) then
    with Configuration do begin
      OnTop := ReadBool('debug', 'ontop', False);
      AutoScroll := ReadBool('debug', 'autoscroll', True);
      ReadFormAttributes('debug', Self);
      OwnerHandler.Active := ReadBool('debug', 'visible', False);
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.miAutoScrollClick(Sender: TObject);
begin
  AutoScroll := not AutoScroll;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.miClearAllClick(Sender: TObject);
var
  CanDo: Integer;

begin
  CanDo := MsgBox('Are you sure to clear the Debug Log?', 'Question',
    MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;
  mDebug.Clear;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.miCloseClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.miCopyClick(Sender: TObject);
begin
  mDebug.CopyToClipboard;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.miOnTopClick(Sender: TObject);
begin
  OnTop := not OnTop;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.miSaveClick(Sender: TObject);
begin
  SaveLogFile;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.miSelectAllClick(Sender: TObject);
begin
  mDebug.SelectAll;
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.SaveConfig;
begin
  if Assigned(Configuration) then
    with Configuration do begin
      WriteBool('debug', 'visible', OwnerHandler.Active);
      WriteBool('debug', 'ontop', OnTop);
      WriteBool('debug', 'autoscroll', AutoScroll);
      WriteFormAttributes('debug', Self);
    end;
end;

//------------------------------------------------------------------------------

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

//------------------------------------------------------------------------------

procedure TfrmDebugLog.SetAutoScroll(const Value: Boolean);
begin
  fAutoScroll := Value;
  miAutoScroll.Checked := Value;
end;

//------------------------------------------------------------------------------

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

//------------------------------------------------------------------------------

procedure TfrmDebugLog.miShowMainWindowClick(Sender: TObject);
begin
  if Assigned(OwnerHandler.OnMainWindowBringToFront) then
    OwnerHandler.OnMainWindowBringToFront(Self);
end;

//------------------------------------------------------------------------------

function TfrmDebugLog.MsgBox(Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

//------------------------------------------------------------------------------

procedure TfrmDebugLog.Report(LineType: TLineType; MsgText,
  AdditionalDebugText: string);
var
  MsgIcon: Integer;

begin
  MsgIcon := 0;
  case LineType of
    ltInformation:
      begin
        MsgIcon := MB_ICONINFORMATION;
        Caption := 'Information';
      end;
    ltWarning:
      begin
        MsgIcon := MB_ICONWARNING;
        Caption := 'Warning';
      end;
    ltCritical:
      begin
        MsgIcon := MB_ICONERROR;
        Caption := 'Error';
      end;
  end;

  if AdditionalDebugText <> '' then
    AdditionalDebugText := ' [' + AdditionalDebugText + '].';
  AddLine(LineType, Text + AdditionalDebugText);
  MsgBox(Text, Caption, MsgIcon + MB_OK);
end;

procedure TfrmDebugLog.ResetStatus;
begin
  sbDebug.SimpleText := '';
end;

//------------------------------------------------------------------------------
// TDebugLogHandlerInterface
//------------------------------------------------------------------------------

procedure TDebugLogHandlerInterface.AddLine(LineType: TLineType;
  const Text: string);
begin
  DebugLogWindow.AddLine(LineType, Text);
end;

//------------------------------------------------------------------------------

constructor TDebugLogHandlerInterface.Create;
begin
{$IFDEF DEBUG}
  if Assigned(DebugLogWindow) then
    raise Exception.Create('Please remove the frmDebugLog from the' +
      '''Form created by Delphi'' in the Project option dialog.' + sLineBreak +
      'If you do so, that means another instance of TDebugLogHandlerInterface is already running.'
    );
{$ENDIF}

  fFormDebugLog := TfrmDebugLog.Create(nil);
  DebugLogWindow.fOwnerHandler := Self;
end;

//------------------------------------------------------------------------------

destructor TDebugLogHandlerInterface.Destroy;
begin
  with DebugLogWindow do begin
    SaveConfig;
    if Visible then
      Close;
    Free;
  end;
  inherited;
end;
 
//------------------------------------------------------------------------------

function TDebugLogHandlerInterface.GetConfiguration: TXMLConfigurationFile;
begin
  Result := DebugLogWindow.Configuration;
end;

procedure TDebugLogHandlerInterface.Report(LineType: TLineType; MsgText,
  AdditionalDebugText: string);
begin
  DebugLogWindow.Report(LineType, MsgText, AdditionalDebugText);
end;

//------------------------------------------------------------------------------

procedure TDebugLogHandlerInterface.SaveLogFile;
begin
  DebugLogWindow.SaveLogFile;
end;

//------------------------------------------------------------------------------

procedure TDebugLogHandlerInterface.SetConfiguration(
  const Value: TXMLConfigurationFile);
begin
  with DebugLogWindow do begin
    Configuration := Value;
    LoadConfig;
  end;
end;

//------------------------------------------------------------------------------

procedure TDebugLogHandlerInterface.SetActive(const Value: Boolean);
begin
  if fActive <> Value then begin
    fActive := Value;

    // Notify the change to the client
    if Assigned(OnVisibilityChange) then
      OnVisibilityChange(Self, Value);

(*    WriteLn('ACTIVE: ', Active, ', VISIBLE: ', DebugLogWindow.Visible);
    WriteLn(Active and (not DebugLogWindow.Visible)); *)

    // Updating the Visibility state of the Debug Log window
    with DebugLogWindow do begin
      if (Value and not Visible) then
        Show
      else if ((not Value) and Visible) then
        Close;
    end;

  end; // Visible <> Value
end;

//------------------------------------------------------------------------------

end.
