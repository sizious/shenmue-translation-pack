program preview;

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows,
  Forms,
  main in 'main.pas' {Form1},
  viewer in '..\..\..\Common\SubsUtil\Preview\viewer.pas' {frmSubsPreview},
  oldskool_font_mapper in '..\..\..\Common\SubsUtil\Preview\oldskool_font_mapper.pas',
  oldskool_font_vcl in '..\..\..\Common\SubsUtil\Preview\oldskool_font_vcl.pas';

{$R *.res}

begin
  {Display leaks on shutdown if a debugger is present}
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
