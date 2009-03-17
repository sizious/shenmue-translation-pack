program idx_creator_v2;

uses
  Forms,
  variables in 'variables.pas',
  main in 'main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'IDX Creator v2';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
