program idx_creator_v2;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  variables in 'variables.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'IDX Creator v2';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
