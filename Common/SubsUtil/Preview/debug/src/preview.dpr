program preview;

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows,
  Forms,
  main in 'main.pas' {Form1},
  viewer_intf in '..\..\viewer_intf.pas',
  oldskool_font_mapper in '..\..\oldskool_font_mapper.pas',
  oldskool_font_vcl in '..\..\oldskool_font_vcl.pas',
  viewer in '..\..\viewer.pas' {frmSubsPreview};

{$R *.res}

begin
  {Display leaks on shutdown if a debugger is present}
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmSubsPreview, frmSubsPreview);
  Application.Run;
end.
