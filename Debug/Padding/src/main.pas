unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    function null_bytes_length(dataSize: Integer): Integer;
    function padding(dataSize: Integer): Integer;
    function padding4(dataSize: Integer): Integer;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  if not Checkbox1.checked then  
    ShowMessage(IntToStr(null_bytes_length(StrToInt(Edit1.Text))))
  else
    Showmessage('not avialable with this method try method 2');
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  startTime64, endTime64, frequency64: Int64;
  elapsedSeconds: single;

begin
  QueryPerformanceFrequency(frequency64);
  QueryPerformanceCounter(startTime64);
  null_bytes_length(StrToInt(Edit1.Text));
  QueryPerformanceCounter(endTime64);
  elapsedSeconds := (endTime64 - startTime64) / frequency64;
  ShowMessage(floattostr(elapsedSeconds));
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  V: Integer;

begin
  V := StrToInt(Edit1.Text);
  if CheckBox1.Checked then
    V := Padding4(V)
  else
    V := Padding(V);

  ShowMessage(IntToStr(V));
end;

procedure TForm2.Button4Click(Sender: TObject);
var
  startTime64, endTime64, frequency64: Int64;
  elapsedSeconds: single;

begin
  QueryPerformanceFrequency(frequency64);
  QueryPerformanceCounter(startTime64);
  padding(StrToInt(Edit1.Text));
  QueryPerformanceCounter(endTime64);
  elapsedSeconds := (endTime64 - startTime64) / frequency64;
  ShowMessage(floattostr(elapsedSeconds));
end;

function TForm2.null_bytes_length(dataSize:Integer): Integer;
var current_num, total_null_bytes:Integer;
begin
  //Finding the correct number of null bytes after file data
  current_num := 0;
  total_null_bytes := 0;
  while current_num <> dataSize do
  begin
    if total_null_bytes = 0 then begin
      total_null_bytes := 31;
    end
    else begin
      Dec(total_null_bytes);
    end;
    Inc(current_num);
  end;

  // {$IFDEF DEBUG} WriteLn('null_bytes_length: dataSize: ', dataSize, ', padding: ', total_null_bytes); {$ENDIF}

  Result := total_null_bytes;
end;

function TForm2.padding(dataSize: Integer): Integer;
begin
  Result := dataSize mod 32;
  if Result <> 0 then  
    Result := 32 - Result;
end;

function TForm2.padding4(dataSize: Integer): Integer;
begin
  Result := dataSize mod 4;
  if Result <> 0 then  
    Result := 4 - Result;
end;

end.
