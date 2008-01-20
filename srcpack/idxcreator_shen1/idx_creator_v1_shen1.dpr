program idx_creator_v1_shen1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  variables in 'variables.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'IDX Creator v1 for Shenmue';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
