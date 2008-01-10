program shen1_subs_editor;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  variables in 'variables.pas',
  USRFEntry in 'USRFEntry.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Shenmue I Subtitles Editor v1';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
