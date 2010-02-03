program hdissect;

uses
  Forms,
  main in 'main.pas' {Form1},
  config in 'config.pas',
  scnfedit in '..\..\Editor\src\engine\scnfedit.pas',
  common in '..\..\Editor\src\engine\common.pas',
  scnfutil in '..\..\Editor\src\engine\scnfutil.pas',
  charslst in '..\..\Editor\src\engine\charslst.pas',
  charscnt in '..\..\Editor\src\engine\charscnt.pas',
  npcinfo in '..\..\Editor\src\engine\npcinfo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'HUMANS Dissecter';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
