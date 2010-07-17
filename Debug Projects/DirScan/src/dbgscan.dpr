program dbgscan;

{$APPTYPE CONSOLE}

uses windows,
  SysUtils,
  dirscan in '..\..\..\Common\DirScan\dirscan.pas' {DirectoryScannerInterface},
  systools in '..\..\..\Common\systools.pas';

type
  TDirectoryScannerClient = class(TObject)
  private
    procedure DirectoryScannerFileProceed(Sender: TObject; FileName: TFileName; Result: Boolean);
  end;

  TCustomDirectoryScanner = class(TDirectoryScanner)
  protected
    function IsValidFile(const FileName: TFileName): Boolean; override;
  end;

var
  Scanner: TCustomDirectoryScanner;
  Client: TDirectoryScannerClient;

{ TCustomDirectoryScanner }

function TCustomDirectoryScanner.IsValidFile(const FileName: TFileName): Boolean;
begin
  Result := ExtractFileExt(FileName) = '.exe';
end;

{ TDirectoryScannerClient }

procedure TDirectoryScannerClient.DirectoryScannerFileProceed(Sender: TObject;
  FileName: TFileName; Result: Boolean);
begin
 WriteLn(' Found "', FileName, '": ', Result);
end;

{ Main }

begin
  ReportMemoryLeaksOnShutdown := True;

  Client := TDirectoryScannerClient.Create;
  Scanner := TCustomDirectoryScanner.Create;
  try

    try
      Scanner.OnFileProceed := Client.DirectoryScannerFileProceed;
      Scanner.QueryProperties.Caption := 'Custom title...';
      Scanner.QueryProperties.Title := 'Woh';
//      Scanner.SourceDirectory := '.\';

//      Scanner.Filter := '*.exe';
      WriteLn('Scan Result=', Scanner.Execute(True));
      MessageBoxA(
        0,
        'The Main Thread must be kept alive to leave time to the Scanner for doing his job...' +
        sLineBreak +
        'In your real VCL application you don''t need to do that, because the Application object is still running...',
        'Artificial keep alive main thread process...',
        MB_ICONINFORMATION
      );
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;

  finally
    Client.Free;
    Scanner.Free;
    WriteLn('*** Main Thread Finished ***', sLineBreak, '<ENTER> to exit');
    ReadLn;    
  end;
end.
