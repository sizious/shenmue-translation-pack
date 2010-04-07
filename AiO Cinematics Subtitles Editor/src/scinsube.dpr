program scinsube;



uses
  Forms,
  main in 'main.pas' {frmMain},
  USrfStructAiO in 'engine\USrfStructAiO.pas',
  charsutils in 'engine\charsutils.pas',
  subutils in 'engine\subutils.pas',
  about in 'about.pas' {frmAbout},
  systools in '..\..\Common\systools.pas',
  uitools in '..\..\Common\uitools.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Shenmue AiO Cinematics Subtitles Editor';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
