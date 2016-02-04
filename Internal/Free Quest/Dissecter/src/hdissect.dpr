program hdissect;

uses
  Windows,
  Forms,
  main in 'main.pas' {Form1},
  config in 'config.pas',
  scnfedit in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\scnfedit.pas',
  common in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\common.pas',
  charslst in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\charslst.pas',
  charscnt in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\charscnt.pas',
  npcinfo in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\npc\npcinfo.pas',
  pakfutil in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\npc\pakf\pakfutil.pas',
  img2png in '..\..\..\..\Common\img2png.pas',
  systools in '..\..\..\..\Common\systools.pas',
  lzmadec in '..\..\..\..\Common\lzmadec.pas',
  npclist in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\npc\npclist.pas',
  imgtools in '..\..\..\..\Common\imgtools.pas',
  scnfutil in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\scnfutil.pas',
  srfnpcdb in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\srfnpcdb.pas',
  hashidx in '..\..\..\..\Common\hashidx.pas';

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
