unit multitrd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmMultiTranslation = class(TForm)
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    mNewSub: TMemo;
    eNewFirstLineLength: TEdit;
    eNewSecondLineLength: TEdit;
    Bevel1: TBevel;
    Button2: TButton;
    Button3: TButton;
    Label7: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    mOldSub: TMemo;
    eOldFirstLineLength: TEdit;
    eOldSecondLineLength: TEdit;
    cbSubs: TComboBox;
    lSubs: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure mOldSubChange(Sender: TObject);
    procedure mNewSubChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cbSubsChange(Sender: TObject);
  private
    { Déclarations privées }
    procedure LoadSubsComboBox;
    procedure MultiTranslate;
  public
    { Déclarations publiques }
    function MsgBox(Text, Caption: string; Flags: Integer): Integer;
  end;

var
  frmMultiTranslation: TfrmMultiTranslation;

implementation

uses
  Main, ScnfEdit, CharsCnt;
  
{$R *.dfm}

procedure TfrmMultiTranslation.Button2Click(Sender: TObject);
begin
  if Self.mOldSub.Text = '' then begin
    MsgBox('Please input the searched subtitle.', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  if Self.mNewSub.Text = '' then begin
    MsgBox('Please input the new subtitle.', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  MultiTranslate;

  Self.mNewSub.Text := '';
  Self.mOldSub.Text := '';
  
  if cbSubs.Enabled then begin
    cbSubs.Items.Delete(cbSubs.ItemIndex);
    cbSubs.Enabled := cbSubs.Items.Count > 0;
    if cbSubs.Enabled then begin
      cbSubs.ItemIndex := 0;
      Self.mOldSub.Text := cbSubs.Text;
    end;
  end;
end;

procedure TfrmMultiTranslation.cbSubsChange(Sender: TObject);
begin
  Self.mOldSub.Text := cbSubs.Text;
end;

procedure TfrmMultiTranslation.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if frmMain.GetTargetFileName <> '' then
    frmMain.LoadSubtitleFile(frmMain.GetTargetFileName);
end;

procedure TfrmMultiTranslation.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

procedure TfrmMultiTranslation.FormShow(Sender: TObject);
begin
  LoadSubsComboBox;
end;

procedure TfrmMultiTranslation.LoadSubsComboBox;
var
  i: Integer;

begin
  cbSubs.Clear;
  for i := 0 to SCNFEditor.SubtitlesList.Count - 1 do begin
    cbSubs.Items.Add(SCNFEditor.SubtitlesList[i].Text);
    // WriteLn(SCNFEditor.SubtitlesList[i].Text);
  end;
  cbSubs.Enabled := cbSubs.Items.Count > 0;
  lSubs.Enabled := cbSubs.Enabled;
  if cbSubs.Enabled then begin
    cbSubs.ItemIndex := 0;
    Self.mOldSub.Text := cbSubs.Items[0];
    Self.mOldSub.SelectAll;
  end;
end;

procedure TfrmMultiTranslation.mNewSubChange(Sender: TObject);
var
  l1, l2: Integer;

begin
  CalculateCharsCount(mNewSub.Text, l1, l2);
  Self.eNewFirstLineLength.Text := IntToStr(l1);
  Self.eNewSecondLineLength.Text := IntToStr(l2);
end;

procedure TfrmMultiTranslation.mOldSubChange(Sender: TObject);
var
  l1, l2: Integer;

begin
  CalculateCharsCount(mOldSub.Text, l1, l2);
  Self.eOldFirstLineLength.Text := IntToStr(l1);
  Self.eOldSecondLineLength.Text := IntToStr(l2);
end;

function TfrmMultiTranslation.MsgBox(Text, Caption: string;
  Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMultiTranslation.MultiTranslate;
var
  i, j, _cnt: Integer;
  _scnf: TSCNFEditor;
  _filename, _oldSub, _newSub: string;

begin
  _cnt := 0;
  
  _oldSub := Self.mOldSub.Text;
  _newSub := Self.mNewSub.Text;
  
  _scnf := TSCNFEditor.Create;
  try
    for i := 0 to frmMain.lbFilesList.Items.Count - 1 do begin
      _filename := frmMain.GetTargetDirectory + frmMain.lbFilesList.Items[i];
      _scnf.LoadFromFile(_filename);
      for j := 0 to _scnf.SubtitlesList.Count - 1 do begin
      
        if _scnf.SubtitlesList.Items[j].Text = _oldSub then begin
          _scnf.SubtitlesList.Items[j].Text := _newSub;
          Inc(_cnt);
        end;
        
      end;
      _scnf.SaveToFile(_filename);
    end;
  finally
    _scnf.Free;
    MsgBox(IntToStr(_cnt) + ' subtitle(s) replaced with success.', 'Information', MB_ICONINFORMATION);
  end;
end;

end.
