//    This file is part of IDX Creator for Shenmue.
//
//    IDX Creator for Shenmue is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    IDX Creator for Shenmue is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with IDX Creator for Shenmue.  If not, see <http://www.gnu.org/licenses/>.

unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

const
  APP_VERSION = '2.0';
  COMPIL_DATE_TIME = 'July 20, 2008 @02:00 PM';

type
  TfrmMain = class(TForm)
    GroupBox1: TGroupBox;
    templateChkBox: TCheckBox;
    lblOldIdx: TLabel;
    lblOldAfs: TLabel;
    editOldIdx: TEdit;
    editOldAfs: TEdit;
    btBrowseOldIdx: TButton;
    btBrowseOldAfs: TButton;
    GroupBox2: TGroupBox;
    btGo: TButton;
    lblModAfs: TLabel;
    lblNewIdx: TLabel;
    editModAfs: TEdit;
    editNewIdx: TEdit;
    btBrowseModAfs: TButton;
    btSaveNewIdx: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    procedure btBrowseOldIdxClick(Sender: TObject);
    procedure btBrowseOldAfsClick(Sender: TObject);
    procedure btBrowseModAfsClick(Sender: TObject);
    procedure btSaveNewIdxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure templateChkBoxClick(Sender: TObject);
    procedure btGoClick(Sender: TObject);
  private
    { Déclarations privées }
    fOldAfsName, fOldIdxName, fModAfsName, fNewIdxName: TFileName;
    procedure GroupBoxActivation(const Activated: Boolean);
    procedure TemplateActivation(const Activated: Boolean);
    procedure StatusChange(const Text: String);
    function VerifyFiles(const UseTemplate: Boolean): Boolean;
    function StartTemplateCreation: Boolean;
    function StartCreation: Boolean;
    procedure QueueIdxCreation(const UseTemplate: Boolean);
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation
uses UIdxCreation, UIdxTemplateCreation;
{$R *.dfm}

procedure TfrmMain.GroupBoxActivation(const Activated: Boolean);
begin
  GroupBox1.Enabled := Activated;
  GroupBox2.Enabled := Activated;
end;

procedure TfrmMain.TemplateActivation(const Activated: Boolean);
begin
  lblOldAfs.Enabled := Activated;
  lblOldIdx.Enabled := Activated;
  editOldAfs.Enabled := Activated;
  editOldIdx.Enabled := Activated;
  btBrowseOldAfs.Enabled := Activated;
  btBrowseOldIdx.Enabled := Activated;
end;

procedure TfrmMain.StatusChange(const Text: string);
begin
  StatusBar1.Panels[0].Text := Text;
end;

function TfrmMain.VerifyFiles(const UseTemplate: Boolean): Boolean;
begin
  Result := False;
  if (fModAfsName <> '') and (fNewIdxName <> '') then begin
    if (UseTemplate) and (fOldIdxName <> '') and (fOldAfsName <> '') then begin
      Result := True;
    end
    else if not UseTemplate then begin
      Result := True;
    end
    else begin
      Result := False;
    end;
  end;
end;

function TfrmMain.StartTemplateCreation: Boolean;
var
  idxThread: TIdxTemplateCreation;
begin
  Result := False;
  idxThread := TIdxTemplateCreation.Create(fNewIdxName, fModAfsName, fOldIdxName, fOldAfsName);
  repeat
    Application.ProcessMessages;
  until (idxThread.ThreadTerminated);

  //If no error...
  if not idxThread.ErrorRaised then begin
    Result := True;
  end;

  idxThread.Free;
end;

function TfrmMain.StartCreation: Boolean;
var
  idxThread: TIdxCreation;
begin
  Result := False;
  idxThread := TIdxCreation.Create(fModAfsName, fNewIdxName);
  repeat
    Application.ProcessMessages;
  until (idxThread.ThreadTerminated);

  if not idxThread.ErrorRaised then begin
    Result := True;
  end;

  idxThread.Free;
end;

procedure TfrmMain.QueueIdxCreation(const UseTemplate: Boolean);
var
  threadCompleted: Boolean;
begin
  if VerifyFiles(UseTemplate) then begin
    GroupBoxActivation(False);

    //Starting creation
    StatusChange('Starting creation...');
    if UseTemplate then begin
      threadCompleted := StartTemplateCreation;
    end
    else begin
      threadCompleted := StartCreation;
    end;

    //Modifying form
    if threadCompleted then begin
      StatusChange('New IDX saved to '+ExtractFileName(fNewIdxName));
    end
    else begin
       StatusChange('Error during creation...');
    end;
    GroupBoxActivation(True);
  end
  else begin
    StatusChange('Error: input or output file not defined correctly...');
  end;
end;

procedure TfrmMain.templateChkBoxClick(Sender: TObject);
begin
  with templateChkBox do begin
    TemplateActivation(Checked);
  end;
end;

procedure TfrmMain.btBrowseModAfsClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'AFS file (*.afs)|*.afs';
  OpenDialog1.Title := 'Open modified AFS...';
  if OpenDialog1.Execute then begin
    editModAfs.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmMain.btBrowseOldAfsClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'AFS file (*.afs)|*.afs';
  OpenDialog1.Title := 'Open original AFS...';
  if OpenDialog1.Execute then begin
    editOldAfs.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmMain.btBrowseOldIdxClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'IDX file (*.idx)|*.idx';
  OpenDialog1.Title := 'Open original IDX...';
  if OpenDialog1.Execute then begin
    editOldIdx.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmMain.btGoClick(Sender: TObject);
begin
  fOldIdxName := editOldIdx.Text;
  fOldAfsName := editOldAfs.Text;
  fModAfsName := editModAfs.Text;
  fNewIdxName := editNewIdx.Text;

  if templateChkBox.Checked then begin
    QueueIdxCreation(True);
  end
  else begin
    QueueIdxCreation(False);
  end;
end;

procedure TfrmMain.btSaveNewIdxClick(Sender: TObject);
begin
  SaveDialog1.Filter := 'IDX file (*.idx)|*.idx';
  SaveDialog1.Title := 'Save new IDX to...';
  if SaveDialog1.Execute then begin
    editNewIdx.Text := SaveDialog1.FileName;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  TemplateActivation(False);
  Caption := 'IDX Creator for Shenmue v'+APP_VERSION;
end;

end.
