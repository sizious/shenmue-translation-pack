unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, DTECore;

type
  TfrmMain = class(TForm)
    Bevel1: TBevel;
    btnMake: TButton;
    btnQuit: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    GroupBox3: TGroupBox;
    Button2: TButton;
    Button1: TButton;
    GroupBox4: TGroupBox;
    pbrCurrent: TProgressBar;
    lblProgress: TLabel;
    Label2: TLabel;
    pbrTotal: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnMakeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure ChangeQuitControlsState(State: Boolean);
    procedure InitializeEngineComponents;
    procedure ModulesInitialize;
    procedure ModulesFinalize;
    procedure OnEngineComponentsInitializationTerminate(Sender: TObject);
    function GetProgressText: string;
    procedure SetProgressText(const Value: string);
  public
    { Déclarations publiques }
    property ProgressText: string read GetProgressText write SetProgressText;
  end;

var
  frmMain: TfrmMain;
  DreamcastImageMaker: TDreamcastImageMaker;

implementation

{$R *.dfm}

uses
  SysTools, UITools, WorkDir, LZMADec, Config, Presets;

type
  TDreamcastImageInitializerThread = class(TThread)
  protected
    procedure Execute; override;
  end;

procedure TfrmMain.btnQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  frmConfig.ShowModal;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  frmPresets.ShowModal;
end;

procedure TfrmMain.ChangeQuitControlsState(State: Boolean);
begin
  SetCloseWindowButtonState(Self, State);
  btnQuit.Enabled := State;
  btnMake.Enabled := State;
end;

procedure TfrmMain.btnMakeClick(Sender: TObject);
begin
  DreamcastImageMaker.Execute;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  ChangeQuitControlsState(False);
  ModulesInitialize;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  ModulesFinalize;
end;

function TfrmMain.GetProgressText: string;
begin
  Result := lblProgress.Caption;
end;

procedure TfrmMain.InitializeEngineComponents;
begin
  // Init of the LZMA module
  SevenZipInitEngine(GetWorkingTempDirectory);

  // Extract the binaries
  with TDreamcastImageInitializerThread.Create(False) do
  begin
    OnTerminate := OnEngineComponentsInitializationTerminate;
  end;
end;

procedure TfrmMain.ModulesFinalize;
begin
  DreamcastImageMaker.Free;
end;

procedure TfrmMain.ModulesInitialize;
begin
  // Initialize the components of the engine
  InitializeEngineComponents;

  // Initialize the engine itself
  ProgressText := 'Initializing engine components...';
  DreamcastImageMaker := TDreamcastImageMaker.Create;
end;

procedure TfrmMain.OnEngineComponentsInitializationTerminate(Sender: TObject);
begin
  ChangeQuitControlsState(True);
  ProgressText := '';
end;

procedure TfrmMain.SetProgressText(const Value: string);
var
  S: string;

begin
  if Value = '' then S := 'Idle...' else S := Value;
  lblProgress.Caption := S;
end;

{ TDreamcastImageInitializer }

procedure TDreamcastImageInitializerThread.Execute;
var
  BinariesFileName: TFileName;

begin
  FreeOnTerminate := True;

  BinariesFileName := GetWorkingTempFileName;
  ExtractFile('ENGINE', BinariesFileName);
  if FileExists(BinariesFileName) then
  begin
    SevenZipExtract(BinariesFileName, GetWorkingTempDirectory);
    DeleteFile(BinariesFileName);
  end;
end;

end.
