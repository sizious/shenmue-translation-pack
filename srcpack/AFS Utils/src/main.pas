unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, JvBaseDlg, JvSelectDirectory,
  JvBrowseFolder, StrUtils;

const
  APP_VERSION = '2.01';
  COMPIL_DATE_TIME = 'July 19, 2008 @02:00 PM';

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Opensinglefile1: TMenuItem;
    Openadirectory1: TMenuItem;
    N1: TMenuItem;
    Closesinglefile1: TMenuItem;
    Closeallfiles1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Operations1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Extractselectedfiles1: TMenuItem;
    Extractallfiles1: TMenuItem;
    N3: TMenuItem;
    AFSCreator1: TMenuItem;
    N4: TMenuItem;
    SaveXMLlist1: TMenuItem;
    PopupMenu1: TPopupMenu;
    ppmExtractselectedfiles1: TMenuItem;
    ppmExtractallfiles1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    GroupBox1: TGroupBox;
    lbMainList: TListBox;
    editMainCount: TEdit;
    lblMainCount: TLabel;
    StatusBar1: TStatusBar;
    GroupBox2: TGroupBox;
    lblHeader: TLabel;
    editHeader: TEdit;
    lblDataSize: TLabel;
    lblFilesCnt: TLabel;
    lblFiles: TLabel;
    editFilesCnt: TEdit;
    editDataSize: TEdit;
    lbCurrentAfs: TListBox;
    editCurrentSize: TEdit;
    editCurrentDate: TEdit;
    lblCurrentSize: TLabel;
    lblCurrentDate: TLabel;
    Massextraction1: TMenuItem;
    JvBrowseFolder1: TJvBrowseForFolderDialog;
    Searchfilestoselect1: TMenuItem;
    N5: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Opensinglefile1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbMainListClick(Sender: TObject);
    procedure lbCurrentAfsClick(Sender: TObject);
    procedure Closesinglefile1Click(Sender: TObject);
    procedure Closeallfiles1Click(Sender: TObject);
    procedure ppmExtractselectedfiles1Click(Sender: TObject);
    procedure Extractselectedfiles1Click(Sender: TObject);
    procedure ppmExtractallfiles1Click(Sender: TObject);
    procedure Extractallfiles1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Massextraction1Click(Sender: TObject);
    procedure AFSCreator1Click(Sender: TObject);
    procedure Openadirectory1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Searchfilestoselect1Click(Sender: TObject);
    procedure SaveXMLlist1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure ActivateFileOpsMenu(MenuEnabled: Boolean);
    procedure DisableGroupBox(gbEnabled: Boolean);
    procedure Clear;
    procedure AddDirToList(const FilePath: String);
    procedure LoadAfsInfos(const NameIndex: Integer);
    procedure FillAfsInfos;
    procedure FillIndividualInfos(const FileIndex: Integer);
    procedure QueueIndividualExtraction(MultiFiles: Boolean; NameIndex: Integer; OutDir:String);
    procedure QueueMassExtraction(NameIndex: Integer; OutDir: String; SeparateDir: Boolean);
    function IsFilePresent(const FileName: TFileName): Boolean;
    function MsgBox(const Text, Caption: String; Flags: Integer): Integer;
  public
    { Déclarations publiques }
    procedure SelectSearchedFile(SearchString: String);
  end;

var
  frmMain: TfrmMain;

implementation
uses afsparser, afsextract, creator, search, searchutil;
{$R *.dfm}

procedure TfrmMain.Clear;
begin
  //Clearing 'Informations' components
  editHeader.Clear;
  editFilesCnt.Clear;
  editDataSize.Clear;
  lbCurrentAfs.Clear;
  editCurrentSize.Clear;
  editCurrentDate.Clear;
  editMainCount.Text := IntToStr(lbMainList.Count);
  if lbMainList.Count <= 0 then begin
    ActivateFileOpsMenu(False);
  end;
end;

procedure TfrmMain.ActivateFileOpsMenu(MenuEnabled: Boolean);
begin
  Closesinglefile1.Enabled := MenuEnabled;
  Closeallfiles1.Enabled := MenuEnabled;
  Searchfilestoselect1.Enabled := MenuEnabled;
  Extractselectedfiles1.Enabled := MenuEnabled;
  Extractallfiles1.Enabled := MenuEnabled;
  Massextraction1.Enabled := MenuEnabled;
  ppmExtractselectedfiles1.Enabled := MenuEnabled;
  ppmExtractallfiles1.Enabled := MenuEnabled;
end;

procedure TfrmMain.AFSCreator1Click(Sender: TObject);
begin
  frmCreator.Show;
end;

procedure TfrmMain.DisableGroupBox(gbEnabled: Boolean);
begin
  GroupBox1.Enabled := gbEnabled;
  GroupBox2.Enabled := gbEnabled;
end;

procedure TfrmMain.AddDirToList(const FilePath: String);
var
  SR: TSearchRec;
begin
  if FindFirst(FilePath+'*.afs', faAnyFile, SR) = 0 then begin
    repeat
      if SR.Attr <> faDirectory then begin
        if IsFilePresent(FilePath+SR.Name) then begin
          MsgBox(SR.Name+' is already opened.', 'Error', MB_ICONERROR);
        end
        else begin
          if IsValidAfs(FilePath+SR.Name) then begin
            afsFileName.Add(FilePath+SR.Name);
            lbMainList.Items.Add(SR.Name);
          end;
        end;
      end;
    until (FindNext(SR) <> 0);
  end;
end;

procedure TfrmMain.LoadAfsInfos(const NameIndex: Integer);
begin
  if ParseAfs(afsFileName[NameIndex]) then begin
    FillAfsInfos;
    ActivateFileOpsMenu(True);
  end;
end;

procedure TfrmMain.FillAfsInfos;
var
  i, dataSize: Integer;
begin
  Clear;

  //Filling text zone and list with current afs infos
  editHeader.Text := 'AFS';
  editFilesCnt.Text := IntToStr(afsMain.FileName.Count);

  dataSize := 0;
  for i := 0 to afsMain.FileSize.Count - 1 do begin
    Inc(dataSize, afsMain.FileSize[i]);
  end;
  editDataSize.Text := IntToStr(dataSize) + ' bytes';

  for i := 0 to afsMain.FileName.Count - 1 do begin
    lbCurrentAfs.Items.Add(afsMain.FileName[i]);
  end;
end;

procedure TfrmMain.FillIndividualInfos(const FileIndex: Integer);
begin
  //Showing individual infos
  editCurrentSize.Text := IntToStr(afsMain.FileSize[FileIndex])+' bytes';
  editCurrentDate.Text := afsMain.FileDate[FileIndex];
end;

procedure TfrmMain.QueueIndividualExtraction(MultiFiles: Boolean; NameIndex:Integer; OutDir: String);
var
  i: Integer;
begin
  //Queueing individual files for extraction
  //Only the selected Afs with his selected files is taken in count
  ClearQueue;
  afsMainQueue.NameIndex := NameIndex;
  afsMainQueue.OutputDir := OutDir + '\';
  if MultiFiles then begin
    for i := 0 to lbCurrentAfs.Count - 1 do begin
      if lbCurrentAfs.Selected[i] then begin
        afsMainQueue.FileIndex.Add(i);
      end;
    end;
  end
  else begin
    afsMainQueue.FileIndex.Add(lbCurrentAfs.ItemIndex);
  end;
  StartAfsExtraction;
end;

procedure TfrmMain.QueueMassExtraction(NameIndex: Integer; OutDir: string; SeparateDir:Boolean);
var
  i: Integer;
  fExt, fName, fDir, strBuf: String;
begin
  //Queueing all the files of one Afs in one shot
  ClearQueue;
  afsMainQueue.NameIndex := NameIndex;
  afsMainQueue.OutputDir := OutDir + '\';
  ParseAfs(afsFileName[NameIndex]);

  //Creating directory
  if SeparateDir then begin
    fName := ExtractFileName(afsFileName[NameIndex]);
    fExt := ExtractFileExt(fName);
    Delete(fName, Pos(fExt, fName), Length(fExt));
    fDir := afsMainQueue.OutputDir;

    //Creating the folder
    i := 1;
    strBuf := fDir + fName + '_' + IntToStr(i);

    if not DirectoryExists(fDir+fName) then begin
      CreateDir(fDir + fName);
      afsMainQueue.OutputDir := fDir + fName + '\';
    end
    else begin
      while DirectoryExists(strBuf) do begin
        Inc(i);
        strBuf := fDir + fName + '_' + IntToStr(i);
      end;
      if not DirectoryExists(strBuf) then begin
        CreateDir(strBuf);
      end;
      afsMainQueue.OutputDir := strBuf + '\';
    end;
  end;

  //Queueing files
  for i := 0 to afsMain.FileName.Count - 1 do begin
    afsMainQueue.FileIndex.Add(i);
  end;

  if StartAfsExtraction then begin
    //Waiting for the extraction to be finished
    Application.ProcessMessages;
  end;
end;

procedure TfrmMain.SaveXMLlist1Click(Sender: TObject);
begin
  with SaveXMLlist1 do begin
    if Checked then begin
      Checked := False;
    end
    else begin
      Checked := True;
    end;

    doXmlList := Checked;
  end;
end;

procedure TfrmMain.SelectSearchedFile(SearchString: String);
var
  i: Integer;
begin
  for i := 0 to afsMain.FileName.Count - 1 do begin
    lbCurrentAfs.Selected[i] := False;
    if SearchFile(SearchString, i) then begin
      lbCurrentAfs.Selected[i] := True;
    end;
  end;
end;

function TfrmMain.IsFilePresent(const FileName: TFileName): Boolean;
var
  i: Integer;
begin
  //Verifying if the file is already opened
  Result := False;
  for i := 0 to afsFileName.Count - 1 do begin
    if FileName = afsFileName[i] then begin
      Result := True;
      Break;
    end;
  end;
end;

function TfrmMain.MsgBox(const Text: string; const Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitializeVars;
  Caption := 'AFS Utils v' + APP_VERSION;
  Clear;
end;

procedure TfrmMain.About1Click(Sender: TObject);
begin
  MsgBox('Version '+APP_VERSION+#13#10+'Created by Manic'+#13#10+COMPIL_DATE_TIME, 'Information', MB_ICONINFORMATION);
end;

procedure TfrmMain.Searchfilestoselect1Click(Sender: TObject);
begin
  frmSearch.Show;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeVars;
end;

procedure TfrmMain.lbCurrentAfsClick(Sender: TObject);
begin
  with lbCurrentAfs do begin
    if (Count > 0) and (ItemIndex >= 0) then begin
      FillIndividualInfos(ItemIndex);
    end;
  end;
end;

procedure TfrmMain.lbMainListClick(Sender: TObject);
begin
  with lbMainList do begin
    if (Count > 0) and (ItemIndex >= 0) then begin
      LoadAfsInfos(ItemIndex);
    end;
  end;
end;

procedure TfrmMain.Openadirectory1Click(Sender: TObject);
begin
  JvBrowseFolder1.Title := 'Add directory to the list...';
  JvBrowseFolder1.Options := [odStatusAvailable,odNewDialogStyle,odNoNewButtonFolder];
  if JvBrowseFolder1.Execute then begin
    AddDirToList(JvBrowseFolder1.Directory + '\');
  end;
  editMainCount.Text := IntToStr(lbMainList.Count);
end;

procedure TfrmMain.Opensinglefile1Click(Sender: TObject);
var
  i: Integer;
  fName: TFileName;
begin
  OpenDialog1.Filter := 'Afs files (*.afs)|*.afs';
  OpenDialog1.Title := 'Open Afs...';
  if OpenDialog1.Execute then begin
    for i := 0 to OpenDialog1.Files.Count - 1 do begin
      fName := OpenDialog1.Files[i];

      if IsFilePresent(fName) then begin
        MsgBox(ExtractFileName(fName)+' is already opened.', 'Error', MB_ICONERROR);
      end
      else begin
        if IsValidAfs(fName) then begin
          afsFileName.Add(fName);
          lbMainList.Items.Add(ExtractFileName(fName));
          editMainCount.Text := IntToStr(lbMainList.Count);
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.Massextraction1Click(Sender: TObject);
var
  i: Integer;
begin
  JvBrowseFolder1.Title := 'Mass extract to...';
  JvBrowseFolder1.Options := [odStatusAvailable,odNewDialogStyle];
  if JvBrowseFolder1.Execute then begin
    DisableGroupBox(False);
    for i := 0 to lbMainList.Count - 1 do begin
      QueueMassExtraction(i, JvBrowseFolder1.Directory, True);
    end;
    DisableGroupBox(True);
    lbMainListClick(Self);
  end;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.Extractallfiles1Click(Sender: TObject);
begin
  JvBrowseFolder1.Title := 'Extract all files of '+lbMainList.Items[lbMainList.ItemIndex]+' to...';
  if JvBrowseFolder1.Execute then begin
    DisableGroupBox(False);
    QueueMassExtraction(lbMainList.ItemIndex, JvBrowseFolder1.Directory, False);
    DisableGroupBox(True);
  end;
end;

procedure TfrmMain.Extractselectedfiles1Click(Sender: TObject);
begin
  //Extracting selected files
  DisableGroupBox(False);
  if lbCurrentAfs.SelCount > 1 then begin
    JvBrowseFolder1.Title := 'Extract selected files to...';
    if JvBrowseFolder1.Execute then begin
      QueueIndividualExtraction(True, lbMainList.ItemIndex, JvBrowseFolder1.Directory);
    end;
  end
  else if lbCurrentAfs.SelCount = 1 then begin
    SaveDialog1.Filter := 'All files (*.*)|*.*';
    SaveDialog1.Title := 'Extract selected file to...';
    SaveDialog1.FileName := lbCurrentAfs.Items[lbCurrentAfs.ItemIndex];
    if SaveDialog1.Execute then begin
      QueueIndividualExtraction(False, lbMainList.ItemIndex, ExtractFilePath(SaveDialog1.FileName));
    end;
  end
  else begin
    MsgBox('No files selected...', 'Error', MB_ICONERROR);
  end;
  DisableGroupBox(True);
end;

procedure TfrmMain.ppmExtractallfiles1Click(Sender: TObject);
begin
  Extractallfiles1Click(Self);
end;

procedure TfrmMain.ppmExtractselectedfiles1Click(Sender: TObject);
begin
  Extractselectedfiles1Click(Self);
end;

procedure TfrmMain.Closesinglefile1Click(Sender: TObject);
begin
  afsFileName.Delete(lbMainList.ItemIndex);
  lbMainList.Items.Delete(lbMainList.ItemIndex);
  Clear;
  ClearVars;
end;

procedure TfrmMain.Closeallfiles1Click(Sender: TObject);
begin
  afsFileName.Clear;
  lbMainList.Clear;
  Clear;
  ClearVars;
end;

end.
