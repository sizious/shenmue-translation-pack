program idx_creator_v2;

uses
  Forms,
  main in 'main.pas' {frmMain},
  s2idx in 's2idx.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  
  Application.Initialize;
  Application.Title := 'IDX Creator v2';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
