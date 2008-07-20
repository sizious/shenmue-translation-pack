unit creator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, JvBaseDlg, JvBrowseFolder, ComCtrls, afscreate;

type
  TfrmCreator = class(TForm)
    MainMenu2: TMainMenu;
    File1: TMenuItem;
    Addfiles1: TMenuItem;
    Adddirectory1: TMenuItem;
    N1: TMenuItem;
    ImportXMLlist1: TMenuItem;
    N2: TMenuItem;
    Close1: TMenuItem;
    SaveAfs1: TMenuItem;
    ools1: TMenuItem;
    Deletefiles1: TMenuItem;
    Deleteallfiles1: TMenuItem;
    GroupBox1: TGroupBox;
    lbCreationList: TListBox;
    OpenDialog2: TOpenDialog;
    SaveDialog2: TSaveDialog;
    PopupMenu2: TPopupMenu;
    JvBrowseFolder2: TJvBrowseForFolderDialog;
    StatusBar1: TStatusBar;
    Deleteselectedfiles1: TMenuItem;
    Addfiles2: TMenuItem;
    Adddirectory2: TMenuItem;
    N3: TMenuItem;
    Options1: TMenuItem;
    editFileCnt: TEdit;
    lblFileCnt: TLabel;
    procedure Close1Click(Sender: TObject);
    procedure Addfiles1Click(Sender: TObject);
    procedure Addfiles2Click(Sender: TObject);
    procedure Deleteallfiles1Click(Sender: TObject);
    procedure Deletefiles1Click(Sender: TObject);
    procedure Deleteselectedfiles1Click(Sender: TObject);
    procedure Adddirectory1Click(Sender: TObject);
    procedure Adddirectory2Click(Sender: TObject);
    procedure SaveAfs1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImportXMLlist1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure ReloadList;
    procedure UpdateFileCount;
    procedure LoadXMLList(FileName: TFileName);
    procedure AddToList(FileName: TFileName);
    procedure AddDirToList(FilePath: String);
    procedure QueueCreation(FileName: TFileName);
    function MsgBox(const Text: string; const Caption: string; Flags: Integer): Integer;
  public
    { Déclarations publiques }
  end;

var
  frmCreator: TfrmCreator;

implementation
uses creatoropts, xmlutil;
{$R *.dfm}

procedure TfrmCreator.ReloadList;
var
  i: Integer;
  strBuf: String;
begin
  lbCreationList.Clear;
  for i := 0 to createMainList.GetCount-1 do begin
    strBuf := ExtractFileName(createMainList.GetFileName(i));
    lbCreationList.Items.Add(strBuf);
  end;
end;

procedure TfrmCreator.UpdateFileCount;
begin
  editFileCnt.Text := IntToStr(lbCreationList.Count);
end;

procedure tfrmCreator.LoadXMLList(FileName: TFileName);
begin
  if ImportListFromXML(FileName) then begin
    ReloadList;
  end;
end;

procedure TfrmCreator.AddToList(FileName: TFileName);
begin
  createMainList.AddFile(FileName);
  lbCreationList.Items.Add(ExtractFileName(FileName));
end;

procedure TfrmCreator.AddDirToList(FilePath: String);
var
  SR: TSearchRec;
begin
  //Verifying if there's at least one file
  if FindFirst(FilePath+'*.*', faAnyFile, SR) = 0 then begin
    //Scanning whole directory
    repeat
      //Excluding directory...
      if SR.Attr <> faDirectory then begin
        createMainList.AddFile(FilePath+SR.Name);
        lbCreationList.Items.Add(SR.Name);
      end;
    until (FindNext(SR) <> 0);
    FindClose(SR);
  end;
end;

function TfrmCreator.MsgBox(const Text: string; const Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmCreator.QueueCreation(FileName: TFileName);
begin
  //Queueing creation
  createMainList.OutputFile := FileName;
  if StartAfsCreation then begin
  end;
end;

procedure TfrmCreator.Adddirectory1Click(Sender: TObject);
begin
  //Adding directory
  JvBrowseFolder2.Title := 'Add files of this directory...';
  if JvBrowseFolder2.Execute then begin
    AddDirToList(JvBrowseFolder2.Directory+'\');
    UpdateFileCount;
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
  //Adding one or multiple files
  OpenDialog2.Filter := 'All files (*.*)|*.*';
  OpenDialog2.Title := 'Add files...';
  if OpenDialog2.Execute then begin
    for i := 0 to OpenDialog2.Files.Count - 1 do begin
      AddToList(OpenDialog2.Files[i]);
    end;
    UpdateFileCount;
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
  //Delete all files of the list;
  createMainList.ClearVar;
  lbCreationList.Clear;
  UpdateFileCount;
end;

procedure TfrmCreator.Deletefiles1Click(Sender: TObject);
var
  i: Integer;
begin
  //Deleting selected files
  if (lbCreationList.Count > 0) and (lbCreationList.ItemIndex > -1) then begin
    //Loop going from the highest Index to the lowest, to avoid problems...
    i := lbCreationList.Count-1;
    while i <> -1 do begin
      if lbCreationList.Selected[i] then begin
        createMainList.DeleteFile(i);
        lbCreationList.Items.Delete(i);
      end;
      Dec(i);
    end;
    UpdateFileCount;
  end;
end;

procedure TfrmCreator.Deleteselectedfiles1Click(Sender: TObject);
begin
  Deletefiles1Click(Self);
end;

procedure TfrmCreator.FormCreate(Sender: TObject);
begin
  createMainList.InitializeVar;
  if not IsOptsInit then begin
    InitOptsVars;
  end;
end;

procedure TfrmCreator.FormDestroy(Sender: TObject);
begin
    createMainList.FreeVar;
end;

procedure TfrmCreator.ImportXMLlist1Click(Sender: TObject);
begin
  OpenDialog2.Filter := 'XML file (*.xml)|*.xml';
  OpenDialog2.Title := 'Import XML list...';
  if OpenDialog2.Execute then begin
    Deleteallfiles1Click(Self);
    LoadXMLList(OpenDialog2.FileName);
    UpdateFileCount;
  end;
end;

procedure TfrmCreator.Options1Click(Sender: TObject);
begin
  frmCreatorOpts.Show;
end;

procedure TfrmCreator.SaveAfs1Click(Sender: TObject);
begin
  if createMainList.GetCount <= 0 then begin
    MsgBox('No files in the list.', 'Error', MB_ICONERROR);
    Exit;
  end;

  SaveDialog2.Filter := 'Afs file (*.afs)|*.afs';
  SaveDialog2.Title := 'Save afs to...';
  SaveDialog2.DefaultExt := 'afs';
  if SaveDialog2.Execute then begin
    QueueCreation(SaveDialog2.FileName);
  end;
end;

end.
