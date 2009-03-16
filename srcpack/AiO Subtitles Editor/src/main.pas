//    This file is part of Shenmue AiO Subtitles Editor.
//
//    Shenmue AiO Subtitles Editor is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Shenmue AiO Subtitles Editor is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue AiO Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, StdCtrls, ExtCtrls, USrfStructAiO, JvBaseDlg,
  JvBrowseFolder;

const
  APP_VERSION = '1.01';
  COMPIL_DATE_TIME = 'August 6, 2008 @02:00 PM';

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
    StatusBar1: TStatusBar;
    Help1: TMenuItem;
    About1: TMenuItem;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    lbMain: TListBox;
    editFileCnt: TEdit;
    lblFileCnt: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Exportsubtitles1: TMenuItem;
    Importsubtitles1: TMenuItem;
    N3: TMenuItem;
    Enablecharactersmodification1: TMenuItem;
    lblGame: TLabel;
    lblHeader: TLabel;
    lblSubCnt: TLabel;
    lblSubList: TLabel;
    lblText: TLabel;
    editGame: TEdit;
    editHeader: TEdit;
    editSubCnt: TEdit;
    lbSub: TListBox;
    editChId: TEdit;
    lblChId: TLabel;
    memoLineCnt: TMemo;
    lblLineCnt: TLabel;
    memoText: TMemo;
    Save1: TMenuItem;
    Saveto1: TMenuItem;
    N4: TMenuItem;
    JvBrowseFolder1: TJvBrowseForFolderDialog;
    ShenmueI1: TMenuItem;
    ShenmueII1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Closeselectedfile2: TMenuItem;
    Selectedfile1: TMenuItem;
    Massexportation1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure lbMainClick(Sender: TObject);
    procedure Openfiles1Click(Sender: TObject);
    procedure lbSubClick(Sender: TObject);
    procedure memoTextChange(Sender: TObject);
    procedure Closeselectedfile1Click(Sender: TObject);
    procedure Closeallfiles1Click(Sender: TObject);
    procedure Saveto1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Opendirectory1Click(Sender: TObject);
    procedure ShenmueI1Click(Sender: TObject);
    procedure ShenmueII1Click(Sender: TObject);
    procedure Importsubtitles1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Closeselectedfile2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Selectedfile1Click(Sender: TObject);
    procedure Massexportation1Click(Sender: TObject);
  private
    { Déclarations privées }
    SrfList: TStringList;
    SrfStruct: TSrfStruct;
    fModified: Boolean;
    fNoEdit: Boolean;
    function MsgBox(const Text, Caption: String; Flags: Integer): Integer;
    procedure MenuActivation(const Activated: Boolean);
    procedure StatusChange(const Text: String; const PanelNum: Integer);
    procedure SetModified(const Activated: Boolean);
    procedure SetGlobalMenu;
    procedure ClearInfos;
    procedure AddFiles(const FileName: TFileName);
    procedure AddDirectory(const Directory: String);
    procedure LoadSrf(const FileName: TFileName);
    procedure FillMainInfo;
    procedure FillSingleInfo(const Index: Integer);
    procedure PostImport;
    procedure MassExport(const Directory: String; const FilterIndex: Integer);
    procedure CountChars(const Text: String);
    procedure AddExtension(var FileName: TFileName; const Extension: String);
    procedure SaveModification;
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation
uses charsutils, subutils;
{$R *.dfm}

function TfrmMain.MsgBox(const Text: string; const Caption: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Caption), Flags);
end;

procedure TfrmMain.MenuActivation(const Activated: Boolean);
begin
  //File menu
  Save1.Enabled := Activated;
  Saveto1.Enabled := Activated;
  Closeselectedfile1.Enabled := Activated;
  Closeallfiles1.Enabled := Activated;

  //Tools menu
  Selectedfile1.Enabled := Activated;
  Massexportation1.Enabled := Activated;
  Importsubtitles1.Enabled := Activated;

  //Popup menu
  Closeselectedfile2.Enabled := Activated;
end;

procedure TfrmMain.StatusChange(const Text: string; const PanelNum: Integer);
begin
  StatusBar1.Panels[PanelNum].Text := Text;
end;

procedure TfrmMain.SetModified(const Activated: Boolean);
begin
  fModified := Activated;
  if Activated then begin
    StatusChange('Modified', 1);
  end
  else begin
    StatusChange('', 1);
  end;
end;

procedure TfrmMain.SetGlobalMenu;
var
  Activated: Boolean;
begin
  Activated := lbMain.Count > 0;
  Massexportation1.Enabled := Activated;
  Closeallfiles1.Enabled := Activated;
end;

procedure TfrmMain.ClearInfos;
begin
  editGame.Clear;
  editHeader.Clear;
  editSubCnt.Clear;
  lbSub.Clear;
  editChId.Clear;
  memoText.Clear;
  memoLineCnt.Clear;
  editFileCnt.Text := IntToStr(lbMain.Count);
  memoText.Enabled := False;
  fNoEdit := True;
  SetModified(False);
  if lbMain.Count <= 0 then begin
    MenuActivation(False);
  end;
  if lbMain.ItemIndex < 0 then begin
    Save1.Enabled := False;
    Saveto1.Enabled := False;
    Closeselectedfile1.Enabled := False;
    Closeselectedfile2.Enabled := False;
    Selectedfile1.Enabled := False;
    Importsubtitles1.Enabled := False;
    SetGlobalMenu;
  end;
end;

procedure TfrmMain.AddFiles(const FileName: TFileName);
begin
  if SrfStruct.IsValid(FileName) then begin
    SrfList.Add(FileName);
    lbMain.Items.Add(ExtractFileName(FileName));
  end;
end;

procedure TfrmMain.AddDirectory(const Directory: string);
var
  SR: TSearchRec;
  fName: TFileName;
begin
  if FindFirst(Directory+'*.srf', faAnyFile, SR) = 0 then begin
    repeat
      fName := Directory+SR.Name;
      if (SR.Attr <> faDirectory) then begin
        AddFiles(fName);
      end;
    until (FindNext(SR) <> 0);
  end;
end;

procedure TfrmMain.LoadSrf(const FileName: TFileName);
begin
  SrfStruct.LoadFromFile(FileName);
  FillMainInfo;
end;

procedure TfrmMain.FillMainInfo;
var
  i: Integer;
begin
  //Filling main info component
  ClearInfos;

  if SrfStruct.GameVersion = gvShenmueOne then begin
    editGame.Text := 'Shenmue I';
    editHeader.Text := '8';
  end
  else if SrfStruct.GameVersion = gvShenmueTwo then begin
    editGame.Text := 'Shenmue II';
    editHeader.Text := 'CHID';
  end;

  editSubCnt.Text := IntToStr(SrfStruct.Count);
  for i := 0 to SrfStruct.Count - 1 do begin
    lbSub.Items.Add('Subtitle #'+IntToStr(i+1));
  end;
end;

procedure TfrmMain.FillSingleInfo(const Index: Integer);
var
  SrfEntry: TSrfEntry;
begin
  fNoEdit := True;
  SrfEntry := SrfStruct.Items[Index];

  if SrfEntry.CharName <> '' then begin
    editChId.Text := SrfEntry.CharName;
  end
  else begin
    editChId.Text := '(no name)';
  end;

  if SrfEntry.Editable then begin
    memoText.Text := SrfEntry.Text;
    memoText.Enabled := True;
    fNoEdit := False;
    CountChars(memoText.Text);
  end
  else begin
    memoText.Text := 'No editable subtitle...';
    memoText.Enabled := False;
    memoLineCnt.Clear;
  end;
end;

procedure TfrmMain.PostImport;
begin
  if (lbSub.Count > 0) and (lbSub.ItemIndex >= 0) then begin
    memoText.Text := SrfStruct.Items[lbSub.ItemIndex].Text;
    CountChars(memoText.Text);
  end;
  SetModified(True);
end;

procedure TfrmMain.MassExport(const Directory: string; const FilterIndex: Integer);
var
  i: Integer;
  fName: String;
begin
  for i := 0 to SrfList.Count-1 do begin
    SrfStruct.LoadFromFile(SrfList[i]);
    if FilterIndex = 1 then begin
      fName := Directory+ChangeFileExt(ExtractFileName(SrfList[i]), '.xml');
      ExportToXML(fName, SrfStruct);
    end
    else if FilterIndex = 2 then begin
      fName := Directory+ChangeFileExt(ExtractFileName(SrfList[i]), '.txt');
      ExportToText(fName, SrfStruct);
    end;
  end;
  lbMainClick(Self);
  StatusChange('Mass exportation completed.', 2);
end;

procedure TfrmMain.CountChars(const Text: string);
var
  i: Integer;
begin
  CharsCount(Text);
  memoLineCnt.Clear;
  for i := 0 to Length(lineCharsCnt)-1 do begin
    memoLineCnt.Lines.Add('Line '+IntToStr(i+1)+': '+IntToStr(lineCharsCnt[i]) +' characters');
  end;
end;

procedure TfrmMain.AddExtension(var FileName: TFileName; const Extension: String);
var
  fExt: String;
begin
  fExt := ExtractFileExt(FileName);
  if fExt = '' then begin
    FileName := FileName + Extension;
  end;
end;

procedure TfrmMain.SaveModification;
var
  canDo: Integer;
begin
  if fModified then begin
    canDo := MsgBox('Do you want to save file modifications?', 'Save changes?', MB_YESNOCANCEL + MB_ICONWARNING);
    case canDo of
      IDCANCEL : Exit;
      IDYES : Save1Click(lbMain);
    end;
  end;
end;

procedure TfrmMain.About1Click(Sender: TObject);
begin
  MsgBox('Version '+APP_VERSION+#13#10+'Created by Manic'+#13#10+COMPIL_DATE_TIME, 'Information', MB_ICONINFORMATION);
end;

procedure TfrmMain.ShenmueI1Click(Sender: TObject);
begin
  with ShenmueI1 do begin
    Checked := not Checked;
    SrfStruct.UseCharsListOne := Checked;
  end;
end;

procedure TfrmMain.ShenmueII1Click(Sender: TObject);
begin
  with ShenmueII1 do begin
    Checked := not Checked;
    SrfStruct.UseCharsListTwo := Checked;
  end;
end;

procedure TfrmMain.Save1Click(Sender: TObject);
begin
  SrfStruct.SaveToFile(SrfStruct.FileName);
  SetModified(False);
  StatusChange('File saved to "'+ExtractFileName(SrfStruct.FileName)+'".', 2);
end;

procedure TfrmMain.Saveto1Click(Sender: TObject);
begin
  with SaveDialog1 do begin
    Filter := 'SRF file (*.srf)|*.srf';
    DefaultExt := 'srf';
    Title := 'Save to...';
    if Execute then begin
      SrfStruct.SaveToFile(FileName);
      SetModified(False);
      StatusChange('File saved to "'+ExtractFileName(FileName)+'".', 2);
    end;
  end;
end;

procedure TfrmMain.Closeallfiles1Click(Sender: TObject);
begin
  SrfStruct.Clear;
  SrfList.Clear;
  lbMain.Clear;
  ClearInfos;
end;

procedure TfrmMain.Closeselectedfile1Click(Sender: TObject);
begin
  if lbMain.ItemIndex >= 0 then begin
    SrfStruct.Clear;
    SrfList.Delete(lbMain.ItemIndex);
    lbMain.DeleteSelected;
    ClearInfos;
  end;
end;

procedure TfrmMain.Closeselectedfile2Click(Sender: TObject);
begin
  Closeselectedfile1Click(Self);
end;

procedure TfrmMain.Opendirectory1Click(Sender: TObject);
begin
  with JvBrowseFolder1 do begin
    Title := 'Open directory...';
    Options := [odStatusAvailable,odNewDialogStyle,odNoNewButtonFolder];
    if Execute then begin
      AddDirectory(Directory+'\');
    end;
  end;
  editFileCnt.Text := IntToStr(lbMain.Count);
  SetGlobalMenu;
end;

procedure TfrmMain.Openfiles1Click(Sender: TObject);
var
  i: Integer;
begin
  with OpenDialog1 do begin
    Filter := 'SRF file (*.srf)|*.srf';
    Title := 'Open files...';
    if Execute then begin
      for i := 0 to Files.Count - 1 do begin
        AddFiles(Files[i]);
      end;
    end;
  end;
  editFileCnt.Text := IntToStr(lbMain.Count);
  SetGlobalMenu;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.Selectedfile1Click(Sender: TObject);
var
  fName: TFileName;
begin
  with SaveDialog1 do begin
    Filter := 'XML file (*.xml)|*.xml|Text file (*.txt)|*.txt';
    Title := 'Export subtitles...';
    if Execute then begin
      fName := FileName;
      if FilterIndex = 1 then begin
        AddExtension(fName, '.xml');
        ExportToXML(fName, SrfStruct);
      end
      else if FilterIndex = 2 then begin
        AddExtension(fName, '.txt');
        ExportToText(fName, SrfStruct);
      end;
      StatusChange('Subtitles exported to "'+ExtractFileName(fName)+'".', 2);
    end;
  end;
end;

procedure TfrmMain.Massexportation1Click(Sender: TObject);
begin
  with SaveDialog1 do begin
    Filter := 'XML file (*.xml)|*.xml|Text file (*.txt)|*.txt';
    Title := 'Mass export to...';
    FileName := 'filename will be ignored';
    if Execute then begin
      MassExport(ExtractFilePath(FileName), FilterIndex);
    end;
  end;
  editFileCnt.Text := IntToStr(lbMain.Count);
end;

procedure TfrmMain.Importsubtitles1Click(Sender: TObject);
begin
  with OpenDialog1 do begin
    Filter := 'XML file (*.xml)|*.xml|Text file (*.txt)|*.txt';
    Title := 'Import subtitles...';
    if Execute then begin
      if FilterIndex = 1 then begin
        ImportFromXML(FileName, SrfStruct);
      end
      else if FilterIndex = 2 then begin
        ImportFromText(FileName, SrfStruct);
      end;
      PostImport;
      StatusChange('Subtitles imported from "'+ExtractFileName(FileName)+'".', 2);
    end;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveModification;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  SrfList := TStringList.Create;
  SrfStruct := TSrfStruct.Create;

  //Accentuated characters list
  with ShenmueI1 do begin
    SrfStruct.CharactersListOne := ExtractFilePath(Application.ExeName)+'chars_list_one.csv';
    Enabled := SrfStruct.LoadCharsList(gvShenmueOne);
    Checked := Enabled;
  end;
  with ShenmueII1 do begin
    SrfStruct.CharactersListTwo := ExtractFilePath(Application.ExeName)+'chars_list_two.csv';
    Enabled := SrfStruct.LoadCharsList(gvShenmueTwo);
    Checked := Enabled;
  end;

  MenuActivation(False);
  SetModified(False);
  ClearInfos;
  Caption := 'Shenmue AiO Subtitles Editor v'+APP_VERSION;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  SrfList.Free;
  SrfStruct.Free;
end;

procedure TfrmMain.lbMainClick(Sender: TObject);
begin
  if (lbMain.Count > 0) and (lbMain.ItemIndex >= 0) then begin
    SaveModification;
    LoadSrf(SrfList[lbMain.ItemIndex]);
    MenuActivation(True);
  end;
end;

procedure TfrmMain.lbSubClick(Sender: TObject);
begin
  if (lbSub.Count > 0) and (lbSub.ItemIndex >= 0) then begin
    FillSingleInfo(lbSub.ItemIndex);
  end;
end;

procedure TfrmMain.memoTextChange(Sender: TObject);
begin
  if not fNoEdit then begin
    SrfStruct.Items[lbSub.ItemIndex].Text := memoText.Text;
    CountChars(memoText.Text);
    SetModified(True);
  end;
end;

end.
