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
  private
    fSelectionMode: TFileSelectionMode;
    procedure SetSelectionMode(const Value: TFileSelectionMode);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property SelectionMode: TFileSelectionMode read fSelectionMode
      write SetSelectionMode;
  end;

var
  frmFileSelection: TfrmFileSelection;

implementation

{$R *.dfm}

{ TfrmFileSelection }

procedure TfrmFileSelection.FormCreate(Sender: TObject);
begin
  SelectionMode := fsmOpen;
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
