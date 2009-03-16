program shen_aio_subseditor_v1;

uses
  Forms,
  main in 'main.pas' {frmMain},
  USrfStructAiO in 'engine\USrfStructAiO.pas',
  charsutils in 'engine\charsutils.pas',
  subutils in 'engine\subutils.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
