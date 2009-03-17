program idx_creator_v2;

uses
  Forms,
  variables in 'variables.pas',
  main in 'main.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'IDX Creator v2';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
