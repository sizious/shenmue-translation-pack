unit FontExec;

interface

uses
  SysUtils, Classes, Main;

type
  TFontManagerThread = class(TThread)
  private
    { Déclarations privées }
    fInput: TFileName;
    fOutput: TFileName;
    fMethod: TActionMethod;
    fBytesPerLine: Integer;
    fCharsPerLine: Integer;
    procedure Proceed;
  protected
    procedure Execute; override;
  public
    constructor Create(Method: TActionMethod; Input,
      Output: TFileName; BytesPerLine, CharsPerLine: Integer);  
  end;

implementation

uses
  FontMgr;

{ TFontManagerThread }

constructor TFontManagerThread.Create(Method: TActionMethod; Input,
  Output: TFileName; BytesPerLine, CharsPerLine: Integer);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  Priority := tpLowest;

  fInput:= Input;
  fOutput:= Output;
  fBytesPerLine:= BytesPerLine;
  fCharsPerLine:= CharsPerLine;
  fMethod := Method;
end;

procedure TFontManagerThread.Execute;
begin
  Synchronize(Proceed);
end;

procedure TFontManagerThread.Proceed;
type
  TFontMgrFuncPtr
    = procedure(Input, Output: TFileName; BytesPerLine, CharsPerLine: Integer);

var
  FontMgrFunc: TFontMgrFuncPtr;

begin
  FontMgrFunc := @DecodeFontFile;
  if fMethod = amEncode then
    FontMgrFunc := @EncodeFontFile;
  FontMgrFunc(fInput, fOutput, fBytesPerLine, fCharsPerLine);
end;

end.
