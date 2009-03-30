//    This file is part of SPR Utils.
//
//    You should have received a copy of the GNU General Public License
//    along with SPR Utils.  If not, see <http://www.gnu.org/licenses/>.

unit creator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, StdCtrls, USprStruct, JvBaseDlg, JvBrowseFolder,
  xmldom, XMLIntf, msxmldom, XMLDoc;

type
  TfrmCreator = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    GroupBox1: TGroupBox;
    StatusBar1: TStatusBar;
    lbMain: TListBox;
    Addfiles1: TMenuItem;
    Adddirectory1: TMenuItem;
    ImportXMLlist1: TMenuItem;
    Tools1: TMenuItem;
    N1: TMenuItem;
    SaveSpr1: TMenuItem;
    N2: TMenuItem;
    Close1: TMenuItem;
    Deleteselectedfiles1: TMenuItem;
    Deleteallfiles1: TMenuItem;
    N3: TMenuItem;
    Rewritegbix1: TMenuItem;
    OpenDialog2: TOpenDialog;
    SaveDialog2: TSaveDialog;
    PopupMenu1: TPopupMenu;
    Deleteselectedfiles2: TMenuItem;
    Addfiles2: TMenuItem;
    Adddirectory2: TMenuItem;
    Fileinformations1: TMenuItem;
    JvBrowseFolder2: TJvBrowseForFolderDialog;
    N4: TMenuItem;
    XMLDoc1: TXMLDocument;
    GZipfileatcreation1: TMenuItem;
    editCnt: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Deleteallfiles1Click(Sender: TObject);
    procedure Deleteselectedfiles1Click(Sender: TObject);
    procedure Fileinformations1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Deleteselectedfiles2Click(Sender: TObject);
    procedure Addfiles1Click(Sender: TObject);
    procedure Addfiles2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Adddirectory1Click(Sender: TObject);
    procedure Adddirectory2Click(Sender: TObject);
    procedure Rewritegbix1Click(Sender: TObject);
    procedure ImportXMLlist1Click(Sender: TObject);
    procedure SaveSpr1Click(Sender: TObject);
    procedure GZipfileatcreation1Click(Sender: TObject);
  private
    { Déclarations privées }

    procedure ReloadWindow;
    procedure MenuActivation(const Activated: Boolean);
    procedure StatusChange(const Text: String);
    function MsgBox(const Text, Caption: String; Flags: Integer): Integer;
    procedure AddFile(const FileName: TFileName; const TextureName: String);
    procedure AddDir(const Directory: String);
    procedure LoadXML(const FileName: TFileName);
    procedure QueueCreation(const FileName: TFileName);
    function StartCreation(const FileName: TFileName): Boolean;
    function VerifyFormat(const Format: String): Boolean;
    function AddExtension(const FileName: TFileName; const Ext: String): TFileName;
  public
    { Déclarations publiques }
  end;

var
  frmCreator: TfrmCreator;
  FileList: TStringList;
  SPRStruct: TSprStruct;
  RewriteGBIX: Boolean;
  GzipOutput: Boolean;

implementation
uses creatorFileInfo, fileparse, USprCreation;
{$R *.dfm}

procedure TfrmCreator.ReloadWindow;
begin
  if lbMain.Count <= 0 then begin
    MenuActivation(False);
  end
  else begin
    MenuActivation(True);
  end;
  editCnt.Text := IntToStr(lbMain.Count);
end;

procedure TfrmCreator.Rewritegbix1Click(Sender: TObject);
begin
  with Rewritegbix1 do begin
    Checked := not Checked;
    RewriteGBIX := Checked;
  end;
end;

procedure TfrmCreator.MenuActivation(const Activated: Boolean);
begin
     Deleteselectedfiles1.Enabled := Activated;
     Deleteallfiles1.Enabled := Activated;
     Savespr1.Enabled := Activated;
     Deleteselectedfiles2.Enabled := Activated;
     Fileinformations1.Enabled := Activated;
end;

procedure TfrmCreator.StatusChange(const Text: string);
begin
  StatusBar1.Panels[0].Text := Text;
end;

function TfrmCreator.MsgBox(const Text, Caption: String; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmCreator.AddFile(const FileName: TFileName; const TextureName: String);
var
  SprEntry: TSprEntry;
  validFile: Boolean;
  inFormat: String;
begin
  validFile := False;

  if IsValidDDS(FileName) then begin
    inFormat := 'DDS';
    validFile := VerifyFormat(inFormat);
  end
  else if IsValidPVR(FileName) then begin
    inFormat := 'PVR';
    validFile := VerifyFormat(inFormat);
  end;

  if validFile then begin
    if inFormat = 'DDS' then begin
      SprEntry := ParseDDS(FileName, TextureName);
    end
    else if inFormat = 'PVR' then begin
      SprEntry := ParsePVR(FileName, TextureName);
    end;

    SPRStruct.Add(SprEntry);
    FileList.Add(FileName);
    lbMain.Items.Add(ExtractFileName(FileName));
    StatusChange(''''+ExtractFileName(FileName)+''' added to the list.');
  end;
end;

procedure TfrmCreator.AddDir(const Directory: string);
var
  SR: TSearchRec;
begin
  if FindFirst(Directory+'*.*', faAnyFile, SR) = 0 then begin
    repeat
      if SR.Attr <> faDirectory then begin
        AddFile(Directory+SR.Name, '');
      end;
    until (FindNext(SR) <> 0);
  end;
end;

procedure TfrmCreator.LoadXML(const FileName: TFileName);
var
  CurrentNode, LoopNode: IXMLNode;
  fDir, fName, fTexName: String;
  i: Integer;
begin
  XMLDoc1.Active := True;
  XMLDoc1.Encoding := 'UTF-8';
  XMLDoc1.Version := '1.0';
  XMLDoc1.LoadFromFile(FileName);

  if XMLDoc1.DocumentElement.NodeName = 'sprutils' then begin
    //Input directory
    CurrentNode := XMLDoc1.DocumentElement.ChildNodes.FindNode('inputdir');
    fDir := CurrentNode.NodeValue;

    //Files list
    CurrentNode := XMLDoc1.DocumentElement.ChildNodes.FindNode('list');
    for i := 0 to CurrentNode.Attributes['count'] - 1 do begin
      LoopNode := CurrentNode.ChildNodes.Nodes[i];
      if Assigned(LoopNode) then begin
        try
          fTexName := LoopNode.Attributes['texn'];
          fName := LoopNode.NodeValue;
        except
          fTexName := '';
          fName := '';
        end;

        if (fName <> '') and (FileExists(fDir+fName)) then begin
          AddFile(fDir+fName, fTexName);
        end;
      end;
    end;

    StatusChange(''''+ExtractFileName(FileName)+''' imported.');
  end
  else begin
    StatusChange(''''+ExtractFileName(FileName)+''' is not a valid list.');
  end;

  XMLDoc1.Active := False;
end;

procedure TfrmCreator.QueueCreation(const FileName: TFileName);
begin
  if StartCreation(FileName) then begin
    Application.ProcessMessages;
    StatusChange('Creation completed for '''+ExtractFileName(FileName)+'''.');
  end;
end;

function TfrmCreator.StartCreation(const FileName: TFileName): Boolean;
var
  sprThread: TSprCreation;
begin
  sprThread := TSprCreation.Create(FileName, FileList, SPRStruct, RewriteGBIX, GzipOutput);
  repeat
    Application.ProcessMessages;
  until (sprThread.ThreadTerminated);
  Result := True;
end;

function TfrmCreator.VerifyFormat(const Format: string): Boolean;
begin
 //All the files must be the same format...
 //The first file of the SPR structure is the reference.
 if SPRStruct.Count > 0 then begin
  if SPRStruct.Items[0].Format = Format then begin
    Result := True;
  end
  else begin
    MsgBox('All the files must be the same format (DDS or PVR).', 'Error', MB_ICONERROR);
    Result := False;
  end;
 end
 else begin
  Result := True;
 end;
end;

function TfrmCreator.AddExtension(const FileName: TFileName; const Ext: string): TFileName;
var
  fName: TFileName;
  fExt: String;
begin
  fName := FileName;
  fExt := ExtractFileExt(fName);
  if LowerCase(fExt) = LowerCase(Ext) then begin
    Result := fName;
  end
  else if fExt = '' then begin
    Result := fName + Ext;
  end;
end;

procedure TfrmCreator.SaveSpr1Click(Sender: TObject);
var
  fName: TFileName;
begin
  SaveDialog2.Filter := 'SPR file (*.spr)|*.spr|All file (*.*)|*.*';
  SaveDialog2.Title := 'Save Spr...';
  if SaveDialog2.Execute then begin
    if SaveDialog2.FilterIndex = 1 then begin
      fName := AddExtension(SaveDialog2.FileName, '.spr');
    end
    else begin
      fName := SaveDialog2.FileName;
    end;
    QueueCreation(fName);
  end;
end;

procedure TfrmCreator.Adddirectory1Click(Sender: TObject);
begin
  JvBrowseFolder2.Title := 'Add directory...';
  if JvBrowseFolder2.Execute then begin
    AddDir(JvBrowseFolder2.Directory+'\');
    ReloadWindow;
  end;
end;

procedure TfrmCreator.Adddirectory2Click(Sender: TObject);
begin
  Adddirectory1Click(Self);
end;

procedure TfrmCreator.Addfiles1Click(Sender: TObject);
var
  i: Integer;
begin
  OpenDialog2.Filter := 'All file (*.*)|*.*|DDS file (*.dds)|*.dds|PVR file (*.pvr)|*.pvr';
  OpenDialog2.Title := 'Add files...';
  if OpenDialog2.Execute then begin
    for i := 0 to OpenDialog2.Files.Count - 1 do begin
      AddFile(OpenDialog2.Files[i], '');
    end;
    ReloadWindow;
  end;
end;

procedure TfrmCreator.Addfiles2Click(Sender: TObject);
begin
  Addfiles1Click(Self);
end;

procedure TfrmCreator.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmCreator.Deleteallfiles1Click(Sender: TObject);
begin
  SPRStruct.Clear;
  FileList.Clear;
  lbMain.Clear;
  ReloadWindow;
  StatusChange('');
end;

procedure TfrmCreator.Deleteselectedfiles1Click(Sender: TObject);
var
  i: Integer;
begin
  if (lbMain.Count > 0) and (lbMain.ItemIndex > -1) then begin
    i := lbMain.Count - 1;
    while i <> -1 do begin
      if lbMain.Selected[i] then begin
        SPRStruct.Delete(i);
        FileList.Delete(i);
        lbMain.Items.Delete(i);
      end;
      Dec(i);
    end;
    ReloadWindow;
    StatusChange('Selected files deleted.');
  end;
end;

procedure TfrmCreator.Deleteselectedfiles2Click(Sender: TObject);
begin
  Deleteselectedfiles1Click(Self);
end;

procedure TfrmCreator.Fileinformations1Click(Sender: TObject);
var
  i: Integer;
begin
  if (lbMain.Count > 0) and (lbMain.ItemIndex > -1) then begin
    i := lbMain.ItemIndex;
    frmFileInfo.Caption := ExtractFileName(FileList[i])+' - Infos';
    frmFileInfo.LoadInfos(SPRStruct, i);
  end;
end;

procedure TfrmCreator.FormCreate(Sender: TObject);
begin
  SPRStruct := TSprStruct.Create;
  FileList := TStringList.Create;
  RewriteGBIX := True;
  GzipOutput := False;
end;

procedure TfrmCreator.FormDestroy(Sender: TObject);
begin
  SPRStruct.Free;
  FileList.Free;
end;

procedure TfrmCreator.FormShow(Sender: TObject);
begin
  ReloadWindow;
end;

procedure TfrmCreator.GZipfileatcreation1Click(Sender: TObject);
begin
  with Gzipfileatcreation1 do begin
    Checked := not Checked;
    GzipOutput := Checked;
  end;
end;

procedure TfrmCreator.ImportXMLlist1Click(Sender: TObject);
begin
  OpenDialog2.Filter := 'XML file (*.xml)|*.xml';
  OpenDialog2.Title := 'Import XML list...';
  if OpenDialog2.Execute then begin
    LoadXML(OpenDialog2.FileName);
    ReloadWindow;
  end;
end;

end.
