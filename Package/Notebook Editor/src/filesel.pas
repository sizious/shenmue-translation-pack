unit FileSel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFileSelectionMode = (fsmOpen, fsmSave);
  
  TfrmFileSelection = class(TForm)
    gbxFlagFileName: TGroupBox;
    edtDataFileName: TEdit;
    btnDataFileName: TButton;
    gbxDataFileName: TGroupBox;
    edtFlagFileName: TEdit;
    btnFlagFileName: TButton;
    lblFlagFileName: TLabel;
    Bevel1: TBevel;
    btnCancel: TButton;
    btnOK: TButton;
    Label1: TLabel;
    odData: TOpenDialog;
    sdData: TSaveDialog;
    odFlag: TOpenDialog;
    sdFlag: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnDataFileNameClick(Sender: TObject);
    procedure btnFlagFileNameClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }  
    fSelectionMode: TFileSelectionMode;
    procedure SetSelectionMode(const Value: TFileSelectionMode);
    function GetSelectedDataFile: TFileName;
    function GetSelectedFlagFile: TFileName;
  protected
    function RunDialog(OpenDialog, SaveDialog: TOpenDialog;
      DefaultFileName: TFileName): TFileName;
  public
    { Déclarations publiques }
    function MsgBox(Text, Title: string; Flags: Integer): Integer;
    property SelectionMode: TFileSelectionMode read fSelectionMode
      write SetSelectionMode;
    property SelectedDataFile: TFileName read GetSelectedDataFile;
    property SelectedFlagFile: TFileName read GetSelectedFlagFile;
  end;

var
  frmFileSelection: TfrmFileSelection;

implementation

{$R *.dfm}

uses
  Config;
  
{ TfrmFileSelection }

procedure TfrmFileSelection.btnDataFileNameClick(Sender: TObject);
begin
  edtDataFileName.Text := RunDialog(odData, sdData, edtDataFileName.Text);
  edtDataFileName.SelectAll;
  edtDataFileName.SetFocus;
end;

procedure TfrmFileSelection.btnFlagFileNameClick(Sender: TObject);
begin
  edtFlagFileName.Text := RunDialog(odFlag, sdFlag, edtFlagFileName.Text);
  edtFlagFileName.SelectAll;
  edtFlagFileName.SetFocus;
end;

procedure TfrmFileSelection.btnOKClick(Sender: TObject);
begin
  if SelectionMode = fsmOpen then
    if (not FileExists(SelectedDataFile))
      or (not FileExists(SelectedFlagFile)) then begin
      MsgBox('At least one input file wasn''t found. Check your input files.',
        'Warning', MB_ICONWARNING);
      ModalResult := mrNone;
    end;
end;

procedure TfrmFileSelection.FormCreate(Sender: TObject);
begin
  SelectionMode := fsmOpen;
  LoadConfigFileSelection;
end;

procedure TfrmFileSelection.FormDestroy(Sender: TObject);
begin
  SaveConfigFileSelection;
end;

procedure TfrmFileSelection.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Ord(Key) of
    VK_ESCAPE:
      begin
        Key := #0;
        Close;
      end;
    VK_RETURN:
      begin
        Key := #0;
        ModalResult := mrOK;
      end;
  end;
end;

function TfrmFileSelection.GetSelectedDataFile: TFileName;
begin
  Result := edtDataFileName.Text;
end;

function TfrmFileSelection.GetSelectedFlagFile: TFileName;
begin
  Result := edtFlagFileName.Text;
end;

function TfrmFileSelection.MsgBox(Text, Title: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Title), Flags);
end;

function TfrmFileSelection.RunDialog(OpenDialog,
  SaveDialog: TOpenDialog; DefaultFileName: TFileName): TFileName;
var
  TempDialog: TOpenDialog;

begin
  Result := DefaultFileName;
  TempDialog := OpenDialog;
  if SelectionMode = fsmSave then
    TempDialog := SaveDialog;
  with TempDialog do begin
    FileName := DefaultFileName;
    if Execute then
      Result := FileName;
  end;
end;

procedure TfrmFileSelection.SetSelectionMode(const Value: TFileSelectionMode);
begin
  fSelectionMode := Value;
  case fSelectionMode of
    fsmOpen:
      begin
        Caption := 'Open Notebook data from...';
        btnOK.Caption := '&Open';
      end;
    fsmSave:
      begin
        Caption := 'Save Notebook data to...';
        btnOK.Caption := '&Save';
      end;
  end;
end;

end.
