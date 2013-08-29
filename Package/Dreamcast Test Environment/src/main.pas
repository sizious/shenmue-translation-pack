unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, MakeDisc;

type
  TfrmMain = class(TForm)
    Bevel1: TBevel;
    Button5: TButton;
    Button6: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    GroupBox3: TGroupBox;
    Button2: TButton;
    Button1: TButton;
    GroupBox4: TGroupBox;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    procedure ModulesInitialize;
    procedure ModulesFinalize;
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;
  DreamcastImageMaker: TDreamcastImageMaker;

implementation

uses config, presets;

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  frmConfig.ShowModal;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  frmPresets.ShowModal;
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
//  DreamcastImageMaker.Settings.VirtualDrive.Drive
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  ModulesInitialize;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  ModulesFinalize;
end;

procedure TfrmMain.ModulesFinalize;
begin
  DreamcastImageMaker.Free;
end;

procedure TfrmMain.ModulesInitialize;
begin
  DreamcastImageMaker := TDreamcastImageMaker.Create;
end;

end.
