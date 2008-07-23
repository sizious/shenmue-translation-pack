//    This file is part of SPR Utils.
//
//    SPR Utils is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    SPR Utils is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with SPR Utils.  If not, see <http://www.gnu.org/licenses/>.

unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, USprStruct, JvBaseDlg, JvBrowseFolder,
  Math, UIntList, xmldom, XMLIntf, msxmldom, XMLDoc;

const
  APP_VERSION = '2.01';
  COMPIL_DATE_TIME = 'July 23, 2008 @02:00 PM';

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Openfiles1: TMenuItem;
    Opendirectory1: TMenuItem;
    N1: TMenuItem;
    Closeselectedfile1: TMenuItem;
    Closeallfiles1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Tools1: TMenuItem;
    Extractselectedfiles1: TMenuItem;
    Extractallfiles1: TMenuItem;
    Massextraction1: TMenuItem;
    N3: TMenuItem;
    SPRCreator1: TMenuItem;
    N4: TMenuItem;
    Savexmllist1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    GroupBox1: TGroupBox;
    OpenDialog1: TOpenDialog;
    StatusBar1: TStatusBar;
    sprListBox: TListBox;
    GroupBox2: TGroupBox;
    lblHeader: TLabel;
    lblGraphCnt: TLabel;
    lblDataSize: TLabel;
    lblGraphList: TLabel;
    lblGraphInfos: TLabel;
    lblGraphSize: TLabel;
    editGraphSize: TEdit;
    editGraphInfos: TEdit;
    editDataSize: TEdit;
    editHeader: TEdit;
    currSprList: TListBox;
    editGraphCnt: TEdit;
    editListCnt: TEdit;
    lblFilesCnt: TLabel;
    JvBrowseFolder1: TJvBrowseForFolderDialog;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    Closeselectedfile2: TMenuItem;
    Extractselectedfiles2: TMenuItem;
    Extractallfiles2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Openfiles1Click(Sender: TObject);
    procedure Opendirectory1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Closeselectedfile1Click(Sender: TObject);
    procedure sprListBoxClick(Sender: TObject);
    procedure Closeallfiles1Click(Sender: TObject);
    procedure Closeselectedfile2Click(Sender: TObject);
    procedure currSprListClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Extractselectedfiles1Click(Sender: TObject);
    procedure Extractselectedfiles2Click(Sender: TObject);
    procedure Extractallfiles1Click(Sender: TObject);
    procedure Extractallfiles2Click(Sender: TObject);
    procedure Massextraction1Click(Sender: TObject);
    procedure SPRCreator1Click(Sender: TObject);
    procedure Savexmllist1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure ClearWindow;
    procedure MenuActivation(const Activated: Boolean);
    procedure GroupBoxActivation(const Activated: Boolean);
    function MsgBox(const Text, Caption: String; Flags: Integer): Integer;
    procedure StatusChange(const Text: String);
    function StartExtraction(const FileName, OutputDir: TFileName; var IndexList: TIntList): Boolean;
    procedure QueueFilesExtraction(const AllFiles: Boolean; const FileName, OutputDir: TFileName);
    procedure QueueMassExtraction(const FileName, OutputDir: TFileName);
    procedure LoadSPRFile(const FileName: TFileName);
    procedure LoadSPRFolder(const FilePath: TFileName);
    procedure LoadSPRInfos(const FileIndex: Integer);
    function IsFileOpened(const FileName: TFileName): Boolean;
    procedure FillSPRInfos;
    procedure FillSingleSPR(const GraphIndex: Integer);
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;
  SPRStruct: TSprStruct;
  SPRFileList: TStringList;
  WriteXML: Boolean;

implementation
uses creator, sprcheck, USprExtraction;
{$R *.dfm}

procedure TfrmMain.ClearWindow;
begin
  editHeader.Clear;
  editGraphCnt.Clear;
  editDataSize.Clear;
  currSprList.Clear;
  editGraphInfos.Clear;
  editGraphSize.Clear;
  editListCnt.Text := IntToStr(sprListBox.Count);
  if sprListBox.Count <= 0 then begin
    MenuActivation(False);
  end;
end;

procedure TfrmMain.MenuActivation(const Activated: Boolean);
begin
  //Main menu
  Closeselectedfile1.Enabled := Activated;
  Closeallfiles1.Enabled := Activated;
  Extractselectedfiles1.Enabled := Activated;
  Extractallfiles1.Enabled := Activated;
  Massextraction1.Enabled := Activated;

  //Popup menu, main list
  Closeselectedfile2.Enabled := Activated;

  //Popup menu, graphics list
  Extractselectedfiles2.Enabled := Activated;
  Extractallfiles2.Enabled := Activated;
end;

procedure TfrmMain.GroupBoxActivation(const Activated: Boolean);
begin
  GroupBox1.Enabled := Activated;
  GroupBox2.Enabled := Activated;
end;

function TfrmMain.MsgBox(const Text, Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMain.StatusChange(const Text: string);
begin
  StatusBar1.Panels[0].Text := Text;
end;

function TfrmMain.StartExtraction(const FileName, OutputDir: TFileName; var IndexList: TIntList): Boolean;
var
  sprThread: TSprExtraction;
begin
  sprThread := TSprExtraction.Create(FileName, OutputDir, IndexList, WriteXML);

  repeat
    Application.ProcessMessages;
  until (sprThread.ThreadTerminated);

  Result := True;
end;

procedure TfrmMain.QueueFilesExtraction(const AllFiles: Boolean; const FileName, OutputDir: TFileName);
var
  indexList: TIntList;
  i: Integer;
begin
  //Finding selected files
  indexList := TIntList.Create;

  //Adding selected files to queue
  if AllFiles then begin
    for i := 0 to SPRStruct.Count - 1 do begin
      indexList.Add(i);
    end;
  end
  else begin
    for i := 0 to currSprList.Count - 1 do begin
      if currSprList.Selected[i] then begin
        indexList.Add(i);
      end;
    end;
  end;

  //Starting extraction
  if StartExtraction(FileName, OutputDir, indexList) then
  begin
    Application.ProcessMessages;
    StatusChange('Files extraction completed.');
  end;
  indexList.Free;
end;

procedure TfrmMain.QueueMassExtraction(const FileName, OutputDir: TFileName);
var
  i: Integer;
  indexList: TIntList;
  tempSPR: TSprStruct;
  fName, fExt, fDir, outDir: String;
begin
  //Queueing all the files of one AFS in one shot
  fName := ExtractFileName(FileName);
  fExt := ExtractFileExt(FileName);
  Delete(fName, Pos(fExt, fName), Length(fExt));

  //Creating the folder
  if not DirectoryExists(OutputDir + fName) then begin
    //Ideal folder name: SPR name without extension
    CreateDir(OutputDir + fName);
    outDir := OutputDir + fName + '\';
  end
  else begin
    //Otherwise, adding a number to the name
    i := 1;
    fDir := OutputDir + fName + '_' + IntToStr(i);
    while DirectoryExists(fDir) do begin
      Inc(i);
      fDir := OutputDir + fName + '_' + IntToStr(i);
    end;
    CreateDir(fDir);
    outDir := fDir + '\';
  end;

  //Loading SPR for infos
  tempSPR := TSprStruct.Create;
  tempSPR.LoadFromFile(FileName);
  indexList := TIntList.Create;
  for i := 0 to tempSPR.Count - 1 do begin
    indexList.Add(i);
  end;
  tempSPR.Free;

  if StartExtraction(FileName, outDir, indexList) then begin
    Application.ProcessMessages;
  end;

  indexList.Free;
end;

procedure TfrmMain.LoadSPRFile(const FileName: TFileName);
begin
  if (IsFileOpened(FileName) = False) and (IsValidSpr(FileName)) then begin
    SPRFileList.Add(FileName);
    sprListBox.Items.Add(ExtractFileName(FileName));
  end;
end;

procedure TfrmMain.LoadSPRFolder(const FilePath: TFileName);
var
  SR: TSearchRec;
  fName: TFileName;
begin
  if FindFirst(FilePath+'*.spr', faAnyFile, SR) = 0 then begin
    repeat
      if (SR.Attr <> faDirectory) then begin
        fName := FilePath+SR.Name;
        if (not IsFileOpened(fName)) and (IsValidSpr(fName)) then begin
          SPRFileList.Add(fName);
          sprListBox.Items.Add(SR.Name);
        end;
      end;
    until (FindNext(SR) <> 0);
  end;
end;

procedure TfrmMain.LoadSPRInfos(const FileIndex: Integer);
begin
  SPRStruct.LoadFromFile(SPRFileList[FileIndex]);
  FillSPRInfos;
  MenuActivation(True);
  StatusChange('"'+ExtractFileName(SPRFileList[FileIndex])+'" loaded.');
end;

function TfrmMain.IsFileOpened(const FileName: TFileName): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to SPRFileList.Count - 1 do begin
    if SPRFileList[i] = FileName then begin
      MsgBox(ExtractFileName(FileName)+' is already opened.', 'Error', MB_ICONERROR);
      Result := True;
      Break;
    end;
  end;
end;

procedure TfrmMain.FillSPRInfos;
var
  CurrentGraph: TSprEntry;
  i, dataSize: Integer;
  mbSize: Real;
begin
  ClearWindow;

  //Filling text zone
  editHeader.Text := 'TEXN';
  editGraphCnt.Text := IntToStr(SPRStruct.Count);

  dataSize := 0;
  for i := 0 to SPRStruct.Count - 1 do begin
    CurrentGraph := SPRStruct.Items[i];
    if CurrentGraph.TextureName = '' then begin
      currSprList.Items.Add('(no name)');
    end
    else begin
      currSprList.Items.Add(CurrentGraph.TextureName);
    end;
    Inc(dataSize, CurrentGraph.Size);
  end;

  mbSize := SimpleRoundTo((dataSize/1024)/1024, -2);
  editDataSize.Text := IntToStr(dataSize)+' bytes ('+FloatToStr(mbSize)+' MB)';
end;

procedure TfrmMain.FillSingleSPR(const GraphIndex: Integer);
var
  CurrentGraph: TSprEntry;
  sprInfo: String;
  mbSize: Real;
begin
  //Filling individual infos
  CurrentGraph := SPRStruct.Items[GraphIndex];
  sprInfo := CurrentGraph.Format;

  if sprInfo = 'DDS' then begin
    case CurrentGraph.FormatCode of
      32896 : sprInfo := sprInfo + ' / DXT1';
      32897 : sprInfo := sprInfo + ' / DXT3';  
    end;
  end;
  sprInfo := sprInfo + ' / '+IntToStr(CurrentGraph.Width)+'x'+IntToStr(CurrentGraph.Height);

  editGraphInfos.Text := sprInfo;
  mbSize := SimpleRoundTo((CurrentGraph.Size/1024)/1024, -2);
  editGraphSize.Text := IntToStr(CurrentGraph.Size) + ' bytes ('+FloatToStr(mbSize)+' MB)';
end;

procedure TfrmMain.About1Click(Sender: TObject);
begin
  MsgBox('Version '+APP_VERSION+#13#10+'Created by Manic'+#13#10+COMPIL_DATE_TIME, 'Information', MB_ICONINFORMATION);
end;

procedure TfrmMain.Savexmllist1Click(Sender: TObject);
begin
  with Savexmllist1 do begin
    Checked := not Checked;
    WriteXML := Checked;
  end;
end;

procedure TfrmMain.SPRCreator1Click(Sender: TObject);
begin
  frmCreator.Show;
end;

procedure TfrmMain.Closeallfiles1Click(Sender: TObject);
begin
  sprListBox.Clear;
  SPRStruct.Clear;
  SPRFileList.Clear;
  ClearWindow;
  StatusChange('');
end;

procedure TfrmMain.Closeselectedfile1Click(Sender: TObject);
var
  i: Integer;
begin
  i := sprListBox.ItemIndex;
  if i >= 0 then begin
    sprListBox.Items.Delete(i);
    SPRFileList.Delete(i);
    SPRStruct.Clear;
    ClearWindow;
  end;
  StatusChange('');
end;

procedure TfrmMain.Closeselectedfile2Click(Sender: TObject);
begin
  Closeselectedfile1Click(Self);
end;

procedure TfrmMain.currSprListClick(Sender: TObject);
begin
  with currSprList do begin
    if (Count >= 0) and (ItemIndex >= 0) then begin
      FillSingleSPR(ItemIndex);
    end;
  end;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.Extractallfiles1Click(Sender: TObject);
begin
  GroupBoxActivation(False);
  JvBrowseFolder1.Title := 'Extract all graphics to...';
  JvBrowseFolder1.Options := [odStatusAvailable,odNewDialogStyle];
  if JvBrowseFolder1.Execute then
  begin
    QueueFilesExtraction(True, SPRFileList[sprListBox.ItemIndex], JvBrowseFolder1.Directory+'\');
  end;
  GroupBoxActivation(True);
end;

procedure TfrmMain.Extractallfiles2Click(Sender: TObject);
begin
  Extractallfiles1Click(Self);
end;

procedure TfrmMain.Extractselectedfiles1Click(Sender: TObject);
begin
  GroupBoxActivation(False);
  if currSprList.SelCount >= 1 then begin
    JvBrowseFolder1.Title := 'Extract selected graphics to...';
    JvBrowseFolder1.Options := [odStatusAvailable,odNewDialogStyle];
    if JvBrowseFolder1.Execute then begin
      QueueFilesExtraction(False, SPRFileList[sprListBox.ItemIndex], JvBrowseFolder1.Directory+'\');
    end;
  end
  else begin
    MsgBox('No graphics selected...', 'Error', MB_ICONERROR);
  end;
  GroupBoxActivation(True);
end;

procedure TfrmMain.Extractselectedfiles2Click(Sender: TObject);
begin
  Extractselectedfiles1Click(Self);
end;

procedure TfrmMain.Massextraction1Click;
var
  i: Integer;
begin
  JvBrowseFolder1.Title := 'Mass extract to...';
  JvBrowseFolder1.Options := [odStatusAvailable,odNewDialogStyle];
  GroupBoxActivation(False);
  if JvBrowseFolder1.Execute then begin
    for i := 0 to SPRFileList.Count - 1 do begin
      StatusChange('Mass extraction in progress... '+IntToStr(i)+'/'+IntToStr(SPRFileList.Count));
      QueueMassExtraction(SPRFileList[i], JvBrowseFolder1.Directory+'\');
    end;
    StatusChange('Mass extraction completed.');
  end;
  GroupBoxActivation(True);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //Initializing main variables
  SPRStruct := TSprStruct.Create;
  SPRFileList := TStringList.Create;
  WriteXML := True;
  Caption := 'SPR Utils v'+APP_VERSION;
  ClearWindow;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  SPRStruct.Free;
  SPRFileList.Free;
end;

procedure TfrmMain.Opendirectory1Click(Sender: TObject);
begin
  JvBrowseFolder1.Title := 'Open directory...';
  JvBrowseFolder1.Options := [odStatusAvailable,odNewDialogStyle,odNoNewButtonFolder];
  if JvBrowseFolder1.Execute then begin
    LoadSPRFolder(JvBrowseFolder1.Directory+'\');
  end;
  editListCnt.Text := IntToStr(sprListBox.Count);
end;

procedure TfrmMain.Openfiles1Click(Sender: TObject);
var
  i: Integer;
begin
  OpenDialog1.Filter := 'SPR files (*.spr)|*.spr|All files (*.*)|*.*';
  OpenDialog1.Title := 'Open files...';
  if OpenDialog1.Execute then begin
    for i := 0 to OpenDialog1.Files.Count - 1 do begin
      LoadSPRFile(OpenDialog1.Files[i]);
    end;
  end;
  editListCnt.Text := IntToStr(sprListBox.Count);
end;

procedure TfrmMain.sprListBoxClick(Sender: TObject);
begin
  with sprListBox do begin
    if (Count >= 0) and (ItemIndex >= 0) then begin
      LoadSPRInfos(ItemIndex);
    end;
  end;
end;

end.
