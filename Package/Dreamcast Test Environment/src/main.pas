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
    procedure DreamcastImageMaker_OnProgress(Sender: TObject; Value: Integer);
    procedure DreamcastImageMaker_OnStatus(Sender: TObject; Status: TMakeImageStatus);
    procedure InitializeEngineComponents;
    procedure ModulesInitialize;
    procedure ModulesFinalize;
    procedure LoadPresets;
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

procedure TfrmMain.DreamcastImageMaker_OnProgress(Sender: TObject;
  Value: Integer);
begin
  pbrCurrent.Position := Value;
end;

procedure TfrmMain.DreamcastImageMaker_OnStatus(Sender: TObject;
  Status: TMakeImageStatus);
begin
  pbrCurrent.Position := 0;
  case Status of
    misInitialize:
      ProgressText := 'Initialization...';
    misBinHacking:
      ProgressText := 'Modifying the files...';
    misPrepareImage:
      ProgressText := 'Preparing the building of the image...';
    misBuildDataTrack:
      ProgressText := 'Building the data track...';
    misMakeImage:
      ProgressText := 'Making the image...';
    misFinalize:
      ProgressText := 'Finalization...';
    misDone:
    begin
      ProgressText := 'Done!';
      pbrCurrent.Position := pbrCurrent.Max;
    end;
  end;
end;

procedure TfrmMain.btnMakeClick(Sender: TObject);
begin
  with DreamcastImageMaker.Presets.Add do
  begin
    Name := 'test';
    SourceDirectory := 'E:\Shenmue Translation Pack\Repository\Package\Dreamcast Test Environment\bin\data\';
    OutputFileName := 'E:\Shenmue Translation Pack\Repository\Package\Dreamcast Test Environment\bin\SHENTEST.NRG';
    VolumeName := 'SHENTEST';
  end;
  with DreamcastImageMaker.Settings.VirtualDrive do
  begin
    Drive := 'L';
    Kind := vdkAlcohol;
    FileName := 'C:\Program Files\Alcohol Soft\Alcohol 120\AxCmd.exe';
  end;
  with DreamcastImageMaker.Settings do
  begin
    Emulator := 'calc.exe';
  end;
  DreamcastImageMaker.Presets[0].Select;
  DreamcastImageMaker.Options.AutoMount := True;
  DreamcastImageMaker.Options.ExecuteEmulator := True;  
//  DreamcastImageMaker.Execute;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  ChangeQuitControlsState(False);
  ModulesInitialize;
  LoadPresets;
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

procedure TfrmMain.LoadPresets;
var
  i: Integer;

begin
  for i := 0 to DreamcastImageMaker.Presets.Count - 1 do
  begin
    ListBox1.Items.Add(DreamcastImageMaker.Presets[i].Name);
  end;
end;

procedure TfrmMain.ModulesFinalize;
begin
  DreamcastImageMaker.Free;
end;

procedure TfrmMain.ModulesInitialize;
begin
  // Initialize the engine itself
  ProgressText := 'Initializing engine components...';

  // Initialize the components of the engine
  InitializeEngineComponents;

  DreamcastImageMaker := TDreamcastImageMaker.Create;
  with DreamcastImageMaker do
  begin
    OnStatus := DreamcastImageMaker_OnStatus;
    OnProgress := DreamcastImageMaker_OnProgress;
  end;
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
