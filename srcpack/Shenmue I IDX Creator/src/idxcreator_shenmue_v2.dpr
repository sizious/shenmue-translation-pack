program idxcreator_shenmue_v2;

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  UIdxStruct in 'engine\UIdxStruct.pas',
  USrfStruct in 'engine\USrfStruct.pas',
  UAfsStruct in 'engine\UAfsStruct.pas',
  UIdxTemplateCreation in 'engine\UIdxTemplateCreation.pas',
  UIdxCreation in 'engine\UIdxCreation.pas',
  progress in 'progress.pas' {frmProgress},
  xmlutils in 'engine\xmlutils.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.Run;
end.
