program afsutils;

{$R 'about\credits.res' 'about\credits.rc'}

uses
  Windows,
  Forms,
  main in 'main.pas' {frmMain},
  afsparser in 'engine\afsparser.pas',
  afsextract in 'engine\afsextract.pas',
  progress in 'progress.pas' {frmProgress},
  UAfsExtraction in 'engine\UAfsExtraction.pas',
  creator in 'creator.pas' {frmCreator},
  afscreate in 'engine\afscreate.pas',
  creatoropts in 'creatoropts.pas' {frmCreatorOpts},
  UAfsCreation in 'engine\UAfsCreation.pas',
  charsutil in 'engine\charsutil.pas',
  search in 'search.pas' {frmSearch},
  xmlutil in 'engine\xmlutil.pas',
  searchutil in 'engine\searchutil.pas',
  appver in '..\..\Common\appver.pas',
  systools in '..\..\Common\systools.pas',
  uitools in '..\..\Common\uitools.pas',
  about in '..\..\Common\About\about.pas' {frmAbout};

{$R *.res}

begin
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Shenmue AFS Utils';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.CreateForm(TfrmCreator, frmCreator);
  Application.CreateForm(TfrmCreatorOpts, frmCreatorOpts);
  Application.CreateForm(TfrmSearch, frmSearch);
  Application.Run;
end.
