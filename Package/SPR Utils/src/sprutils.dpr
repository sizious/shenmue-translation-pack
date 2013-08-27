program sprutils;

uses
  Forms,
  main in 'main.pas' {frmMain},
  USprStruct in 'engine\USprStruct.pas',
  sprcheck in 'engine\sprcheck.pas',
  USprExtraction in 'engine\USprExtraction.pas',
  progress in 'progress.pas' {frmProgress},
  creator in 'creator.pas' {frmCreator},
  fileparse in 'engine\fileparse.pas',
  creatorFileInfo in 'creatorFileInfo.pas' {frmFileInfo},
  xmlutils in 'engine\xmlutils.pas',
  USprCreation in 'engine\USprCreation.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.CreateForm(TfrmCreator, frmCreator);
  Application.CreateForm(TfrmFileInfo, frmFileInfo);
  Application.Run;
end.
