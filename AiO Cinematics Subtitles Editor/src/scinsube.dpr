program scinsube;



uses
  Forms,
  main in 'main.pas' {frmMain},
  USrfStructAiO in 'engine\USrfStructAiO.pas',
  charsutils in 'engine\charsutils.pas',
  subutils in 'engine\subutils.pas',
  viewer_intf in '..\..\Shenmue Subtitles Preview\src\viewer_intf.pas',
  oldskool_font_mapper in '..\..\Shenmue Subtitles Preview\src\oldskool_font_mapper.pas',
  oldskool_font_vcl in '..\..\Shenmue Subtitles Preview\src\oldskool_font_vcl.pas',
  viewer in '..\..\Shenmue Subtitles Preview\src\viewer.pas' {frmSubsPreview},
  about in 'about.pas' {frmAbout},
  tools in 'tools.pas';

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
