//    This file is part of SPR Utils.
//
//    You should have received a copy of the GNU General Public License
//    along with SPR Utils.  If not, see <http://www.gnu.org/licenses/>.

unit creatorFileInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, USprStruct;

type
  TfrmFileInfo = class(TForm)
    editName: TEdit;
    lblName: TLabel;
    lblSize: TLabel;
    lblOffset: TLabel;
    lblFormat: TLabel;
    lblFormatCode: TLabel;
    lblResolution: TLabel;
    editOffset: TEdit;
    editSize: TEdit;
    cbFormat: TComboBox;
    editFormatCode: TEdit;
    editResolution: TEdit;
    btSave: TButton;
    btCancel: TButton;
    procedure btCancelClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure cbFormatChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure LoadInfos(var SPRStruct: TSprStruct; const Index: Integer);
  end;

var
  frmFileInfo: TfrmFileInfo;
  CurrentEntry: TSprEntry;
  initialFormat: Integer;

implementation
{$R *.dfm}

procedure TfrmFileInfo.LoadInfos(var SPRStruct: TSprStruct; const Index: Integer);
begin
  CurrentEntry := SPRStruct.Items[Index];
  editName.Text := CurrentEntry.TextureName;
  editOffset.Text := IntToStr(CurrentEntry.Offset);
  editSize.Text := IntToStr(CurrentEntry.Size)+' bytes';

  if CurrentEntry.Format = 'PVR' then begin
    initialFormat := 2;
  end
  else if CurrentEntry.Format = 'DDS' then begin
    case CurrentEntry.FormatCode of
      32896 : initialFormat := 0;
      32897 : initialFormat := 1;
    end;
  end;

  cbFormat.ItemIndex := initialFormat;
  editFormatCode.Text := IntToStr(CurrentEntry.FormatCode);
  editResolution.Text := IntToStr(CurrentEntry.Width)+'x'+IntToStr(CurrentEntry.Height);
  Show;
end;

procedure TfrmFileInfo.btSaveClick(Sender: TObject);
var
  strBuf: String;
  j: Integer;
begin
  //Texture name
  if Length(editName.Text) > 8 then begin
    strBuf := editName.Text;
    Delete(strBuf, 9, Length(strBuf)-8);
    CurrentEntry.TextureName := strBuf;
  end
  else begin
    CurrentEntry.TextureName := editName.Text;
  end;

  //File format
  j := cbFormat.ItemIndex;
  if j <> initialFormat then begin
    if (j = 0) or (j = 1) then begin
      CurrentEntry.Format := 'DDS';
      case j of
        0 : CurrentEntry.FormatCode := 32896;
        1 : CurrentEntry.FormatCode := 32897;
      end;
    end
    else if j = 2  then begin
      CurrentEntry.Format := 'PVR';
      //Most common 'format code' for PVR = 770
      CurrentEntry.FormatCode := StrToInt(editFormatCode.Text);
    end;
  end;

  Close;
end;

procedure TfrmFileInfo.cbFormatChange(Sender: TObject);
begin
  case cbFormat.ItemIndex of
    0 : editFormatCode.Text := '32896';
    1 : editFormatCode.Text := '32897';
    2 : editFormatCode.Text := '770';
  end;
end;

procedure TfrmFileInfo.btCancelClick(Sender: TObject);
begin
  Close;
end;

end.
