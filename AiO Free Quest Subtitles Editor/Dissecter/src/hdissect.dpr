program hdissect;

uses
  Windows,
  Forms,
  main in 'main.pas' {Form1},
  config in 'config.pas',
  scnfedit in '..\..\Editor\src\engine\scnfedit.pas',
  common in '..\..\Editor\src\engine\common.pas',
  scnfutil in '..\..\Editor\src\engine\scnfutil.pas',
  charslst in '..\..\Editor\src\engine\charslst.pas',
  charscnt in '..\..\Editor\src\engine\charscnt.pas',
  npcinfo in '..\..\Editor\src\engine\npc\npcinfo.pas',
  npcsid in '..\..\Editor\src\engine\npc\npcsid.pas',
  pakfutil in '..\..\Editor\src\engine\npc\pakf\pakfutil.pas',
  img2png in '..\..\..\Common\img2png.pas',
  systools in '..\..\..\Common\systools.pas',
  lzmadec in '..\..\..\Common\lzmadec.pas';

{$R *.res}

{$IFDEF DEBUG}
var
  ConsoleCreated: Boolean;
  AppTitle: string;
{$ENDIF}

begin
  {$IFDEF DEBUG}
  ConsoleCreated := AllocConsole;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  
  Application.Initialize;
  Application.Title := 'HUMANS Dissecter';
  Application.CreateForm(TForm1, Form1);
  {$IFDEF DEBUG}
  AppTitle := TApplication(Application).Title; // CodeGear IDE Workaround...
  if ConsoleCreated then SetConsoleTitle(PChar(AppTitle + ' :: DEBUG CONSOLE'));
{$ENDIF}

  Application.Run;

{$IFDEF DEBUG}
  FreeConsole;
{$ENDIF}  
end.
