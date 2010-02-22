program scinsube;



uses
  Forms,
  main in 'main.pas' {frmMain},
  USrfStructAiO in 'engine\USrfStructAiO.pas',
  charsutils in 'engine\charsutils.pas',
  subutils in 'engine\subutils.pas',
  about in 'about.pas' {frmAbout},
  tools in 'tools.pas',
  systools in '..\..\Common\systools.pas',
  oldskool_font_mapper in '..\..\Common\Preview\src\oldskool_font_mapper.pas',
  oldskool_font_vcl in '..\..\Common\Preview\src\oldskool_font_vcl.pas',
  viewer in '..\..\Common\Preview\src\viewer.pas' {frmSubsPreview},
  viewer_intf in '..\..\Common\Preview\src\viewer_intf.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Shenmue AiO Cinematics Subtitles Editor';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSubsPreview, frmSubsPreview);
  Application.Run;
end.
