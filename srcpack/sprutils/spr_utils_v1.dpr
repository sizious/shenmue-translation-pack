program spr_utils_v1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  variables in 'variables.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SPR Utils v1.0.1';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
