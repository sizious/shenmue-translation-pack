unit Presets;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, DTECore, JvBaseDlg, JvBrowseFolder,
  JvDialogs;

type
  TfrmPresets = class(TForm)
    gbxPresets: TGroupBox;
    lbxPresets: TListBox;
    gbxDetails: TGroupBox;
    edtName: TEdit;
    lblName: TLabel;
    edtVolumeName: TEdit;
    lblVolumeName: TLabel;
    edtOutputFileName: TEdit;
    lblOutputFileName: TLabel;
    edtSourceDirectory: TEdit;
    lblSourceDirectory: TLabel;
    btnSourceDirectory: TButton;
    btnOutputFileName: TButton;
    btnAdd: TButton;
    btnDel: TButton;
    bvlMain: TBevel;
    btnClose: TButton;
    svdOutputFileName: TJvSaveDialog;
    bfdSourceDirectory: TJvBrowseForFolderDialog;
    procedure FormShow(Sender: TObject);
    procedure lbxPresetsClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure edtVolumeNameChange(Sender: TObject);
    procedure edtSourceDirectoryChange(Sender: TObject);
    procedure edtOutputFileNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSourceDirectoryClick(Sender: TObject);
    procedure btnOutputFileNameClick(Sender: TObject);
    procedure edtVolumeNameKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    fSelectedItemIndex: Integer;
    fFakeItem: TDreamcastImagePresetItem;
    procedure ChangeControlsState(State: Boolean);
    procedure LoadItem(const ItemIndex: Integer);
    function GetSelectedItem: TDreamcastImagePresetItem;
    procedure SetSelectedItemIndex(const Value: Integer);
    property SelectedItemIndex: Integer read fSelectedItemIndex write SetSelectedItemIndex;
    property SelectedItem: TDreamcastImagePresetItem read GetSelectedItem;
  public
    { Déclarations publiques }
    procedure Clear;
  end;

var
  frmPresets: TfrmPresets;

implementation

{$R *.dfm}

uses
  SysTools, UITools, Main;

procedure TfrmPresets.btnAddClick(Sender: TObject);
const
  NEW_PRESET = '<New Preset>';

begin
  lbxPresets.Items.Add(NEW_PRESET);
  with DreamcastImageMaker.Presets.Add do
  begin
    Name := NEW_PRESET;
    VolumeName := 'SHENTEST';
    SourceDirectory := GetApplicationDirectory;
    OutputFileName := GetApplicationDirectory + 'shentest.nrg';
  end;
end;

procedure TfrmPresets.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPresets.btnDelClick(Sender: TObject);
begin
  if SelectedItemIndex <> -1 then
  begin
    DreamcastImageMaker.Presets.Delete(SelectedItemIndex);
    lbxPresets.Items.Delete(SelectedItemIndex);
    Clear;
  end;
end;

procedure TfrmPresets.btnOutputFileNameClick(Sender: TObject);
begin
  with svdOutputFileName do
  begin
    FileName := edtOutputFileName.Text;
    if Execute then
      edtOutputFileName.Text := FileName;
  end;
end;

procedure TfrmPresets.btnSourceDirectoryClick(Sender: TObject);
begin
  with bfdSourceDirectory do
  begin
    Directory := edtSourceDirectory.Text;
    if Execute then
      edtSourceDirectory.Text := IncludeTrailingPathDelimiter(Directory);
  end;
end;

procedure TfrmPresets.ChangeControlsState(State: Boolean);
begin
  edtName.Enabled := State;
  edtVolumeName.Enabled := State;
  edtOutputFileName.Enabled := State;
  edtSourceDirectory.Enabled := State;
  btnSourceDirectory.Enabled := State;
  btnOutputFileName.Enabled := State;
  lblName.Enabled := State;
  lblVolumeName.Enabled := State;
  lblOutputFileName.Enabled := State;
  lblSourceDirectory.Enabled := State;
end;

procedure TfrmPresets.Clear;
begin
  SelectedItemIndex := -1;    
  edtName.Clear;
  edtVolumeName.Clear;
  edtOutputFileName.Clear;
  edtSourceDirectory.Clear;
end;

procedure TfrmPresets.edtNameChange(Sender: TObject);
begin
  if SelectedItemIndex <> -1 then
  begin
    lbxPresets.Items[SelectedItemIndex] := edtName.Text;
    SelectedItem.Name := edtName.Text;
  end;
end;

procedure TfrmPresets.edtOutputFileNameChange(Sender: TObject);
begin
  SelectedItem.OutputFileName := edtOutputFileName.Text;
end;

procedure TfrmPresets.edtSourceDirectoryChange(Sender: TObject);
begin
  SelectedItem.SourceDirectory := edtSourceDirectory.Text;
end;

procedure TfrmPresets.edtVolumeNameChange(Sender: TObject);
begin
  edtVolumeName.Text := StringReplace(edtVolumeName.Text, ' ', '_', [rfReplaceAll]);
  if edtVolumeName.Tag <> 0 then
  begin
    edtVolumeName.SelectAll;
    EditSetCaretEndPosition(edtVolumeName.Handle);
    edtVolumeName.SelLength := 0;
    edtVolumeName.Tag := 0;
  end;
  SelectedItem.VolumeName := edtVolumeName.Text;
end;

procedure TfrmPresets.edtVolumeNameKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, ^Z, ^X, ^C, ^V, '0'..'9', 'A'..'Z', 'a'..'z', '_', ' ']) then
    Key := #0
  else
  begin
    case Key of
      ' ': Key := '_';
      ^V : edtVolumeName.Tag := 1;
    end;
  end;
end;

procedure TfrmPresets.FormCreate(Sender: TObject);
begin
  fFakeItem := TDreamcastImagePresetItem.Create;
end;

procedure TfrmPresets.FormDestroy(Sender: TObject);
begin
  fFakeItem.Free;
end;

procedure TfrmPresets.FormShow(Sender: TObject);
var
  i: Integer;

begin
  lbxPresets.Clear;
  Clear;
  for i := 0 to DreamcastImageMaker.Presets.Count - 1 do
    lbxPresets.Items.Add(DreamcastImageMaker.Presets[i].Name);
  if lbxPresets.Items.Count > 0 then
    SelectedItemIndex := 0;
end;

function TfrmPresets.GetSelectedItem: TDreamcastImagePresetItem;
begin
  if SelectedItemIndex = -1 then
    Result := fFakeItem
  else
    Result := DreamcastImageMaker.Presets[SelectedItemIndex];
end;

procedure TfrmPresets.lbxPresetsClick(Sender: TObject);
begin
  SelectedItemIndex := lbxPresets.ItemIndex;
end;

procedure TfrmPresets.LoadItem(const ItemIndex: Integer);
var
  Item: TDreamcastImagePresetItem;

begin
  if ItemIndex <> -1 then
  begin
    Item := DreamcastImageMaker.Presets[ItemIndex];
    edtName.Text := Item.Name;
    edtVolumeName.Text := Item.VolumeName;
    edtOutputFileName.Text := Item.OutputFileName;
    edtSourceDirectory.Text := Item.SourceDirectory;
  end;
end;

procedure TfrmPresets.SetSelectedItemIndex(const Value: Integer);
var
  State: Boolean;

begin
  State := (Value > -1) and (Value < DreamcastImageMaker.Presets.Count);
  ChangeControlsState(State);
  if State then
  begin
    fSelectedItemIndex := Value;
    lbxPresets.ItemIndex := fSelectedItemIndex;
    LoadItem(fSelectedItemIndex);
  end
  else
    fSelectedItemIndex := -1;
end;

end.
