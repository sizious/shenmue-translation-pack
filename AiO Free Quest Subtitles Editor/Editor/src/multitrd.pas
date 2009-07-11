//    This file is part of Shenmue II Free Quest Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue II Free Quest Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit multitrd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

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
    bTranslate: TButton;
    bClose: TButton;
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
    eCode: TEdit;
    Label8: TLabel;
    GroupBox3: TGroupBox;
    mResults: TMemo;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure bTranslateClick(Sender: TObject);
    procedure mOldSubChange(Sender: TObject);
    procedure mNewSubChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cbSubsChange(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
    procedure LoadSubsComboBox;
    procedure MultiTranslate;
    procedure ShowOldSub;
    procedure AddResultsLog(Msg: string);
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

procedure TfrmMultiTranslation.bCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMultiTranslation.bTranslateClick(Sender: TObject);
var
  cbIndex: Integer;
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
    cbIndex := cbSubs.ItemIndex;
    cbSubs.Items.Delete(cbSubs.ItemIndex);
    cbSubs.Enabled := cbSubs.Items.Count > 0;
    if cbSubs.Enabled then begin
        if cbIndex-1 = cbSubs.Items.Count-1 then begin
          cbSubs.ItemIndex := cbSubs.Items.Count-1;
        end
        else begin
          cbSubs.ItemIndex := cbIndex;
        end;
        Self.mOldSub.Text := cbSubs.Text;
        cbSubsChange(Self);
    end;
  end;

  mNewSub.SetFocus;
end;

procedure TfrmMultiTranslation.ShowOldSub;
begin
  Self.mOldSub.Text := Copy(cbSubs.Text, 7, Length(cbSubs.Text));
  Self.eCode.Text := Copy(cbSubs.Text, 1, 4);
end;

procedure TfrmMultiTranslation.cbSubsChange(Sender: TObject);
begin
  ShowOldSub;
  mNewSub.SetFocus;
end;

procedure TfrmMultiTranslation.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if frmMain.GetTargetFileName <> '' then
    frmMain.LoadSubtitleFile(frmMain.GetTargetFileName); // reload old filename
    
  frmMain.Multitranslation1.Checked := False;
end;

procedure TfrmMultiTranslation.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

procedure TfrmMultiTranslation.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
{var
  pt        : TPoint;
  w          : Hwnd;
  ItemBuffer : array[0..256] of Char;
  return,ptPos,index        : Integer;
  s          : string;
  TmpEchelle: string;  }
begin
{  pt := Mouse.CursorPos;
  w := WindowFromPoint(pt);
  if w = 0 then Exit;

  GetClassName(w, ItemBuffer, SizeOf(ItemBuffer));
  if StrIComp(ItemBuffer, 'ComboLBox') = 0 then
  begin
    Windows.ScreenToClient(w, pt);
    return := SendMessage(w,
                      LB_ITEMFROMPOINT,
                      0,
                      LParam(PointToSmallPoint(pt)));
    index := lOWORD(return);
    ptPos := HIWORD(return);
    if ( index >=0 ) and (ptPos = 0) then
      begin
        TmpEchelle := string(SendMessage(w,LB_GETITEMDATA,index,0));
        if TmpEchelle <> '' then showmessage(tmpechelle);
          //hw.DoActivateHint(ActiveControl.Name + IntToStr(index), TmpEchelle.Hint);
      end;
    end;  }
end;

procedure TfrmMultiTranslation.FormShow(Sender: TObject);
begin
  mResults.Clear;
  LoadSubsComboBox;
  // mOldSub.ReadOnly := True;
  if not mNewSub.Focused then mNewSub.SetFocus;
end;

procedure TfrmMultiTranslation.LoadSubsComboBox;
var
  i: Integer;

begin
  cbSubs.Clear;
  for i := 0 to SCNFEditor.Subtitles.Count - 1 do begin
    cbSubs.Items.Add(SCNFEditor.Subtitles[i].Code + ': ' + SCNFEditor.Subtitles[i].Text);
    // WriteLn(SCNFEditor.SubtitlesList[i].Text);
  end;
  cbSubs.Enabled := cbSubs.Items.Count > 0;
  lSubs.Enabled := cbSubs.Enabled;
  if cbSubs.Enabled then begin
    cbSubs.ItemIndex := 0;
    cbSubsChange(Self);
    // Self.mOldSub.Text := cbSubs.Items[0];
    // if not Self.mOldSub.Focused then Self.mOldSub.SetFocus;
    // Self.mOldSub.SelectAll;
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
  CurrentSub: TSubEntry;
begin
  _cnt := 0;
  
  _oldSub := Self.mOldSub.Text;
  _newSub := Self.mNewSub.Text;
  
  _scnf := TSCNFEditor.Create;
  try
    for i := 0 to frmMain.lbFilesList.Items.Count - 1 do begin
      _filename := frmMain.SelectedDirectory + frmMain.lbFilesList.Items[i];
      _scnf.LoadFromFile(_filename);
      for j := 0 to _scnf.Subtitles.Count - 1 do begin
      
        if _scnf.Subtitles.Items[j].Text = _oldSub then begin
          CurrentSub := _scnf.Subtitles[j];
          CurrentSub.Text := _newSub;
          Inc(_cnt);
        end;
        
      end;
      _scnf.SaveToFile(_filename);
    end;
  finally
    _scnf.Free;
    //MsgBox(IntToStr(_cnt) + ' subtitle(s) replaced with success.', 'Information', MB_ICONINFORMATION);
    AddResultsLog(eCode.Text + ': ' + IntToStr(_cnt) + ' subtitle(s) updated.');
  end;
end;

procedure TfrmMultiTranslation.AddResultsLog(Msg: string);
begin
  mResults.Lines.Add('[' + DateToStr(Date) + ' ' + TimeToStr(Now) + '] ' + Msg);
end;

end.
