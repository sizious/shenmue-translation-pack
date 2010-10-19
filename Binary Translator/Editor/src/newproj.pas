unit NewProj;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmNewProject = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    bBrowse: TButton;
    eNewFileName: TEdit;
    GroupBox2: TGroupBox;
    cbGameVersionSelect: TComboBox;
    Bevel1: TBevel;
    bOK: TButton;
    bCancel: TButton;
    sdNewScript: TSaveDialog;
    cbCreateDTD: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure bBrowseClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    fCreationResult: Boolean;
    fDTDFile: TFileName;
    { Déclarations privées }
    procedure LoadGameVersionList;
    function GetNewFileName: TFileName;
    function GetSelectedSourceScriptFileName: TFileName;
    property DTDFile: TFileName read fDTDFile;
  public
    { Déclarations publiques }
    function MsgBox(Text, Title: string; Flags: Integer): Integer;
    property CreationResult: Boolean read fCreationResult;
    property NewFileName: TFileName read GetNewFileName;
  end;

var
  frmNewProject: TfrmNewProject;
  
//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

{$R *.dfm}

uses
  SysTools, LZMADec, XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, FileSpec,
  WorkDir, Main, DebugLog, Config;

const
  BINARY_SCRIPT_DB_DTD = 'binedit.dtd';

type
  TScriptFileNameObject = class(TObject)
  private
    fScriptFileName: TFileName;
  public
    constructor Create(AScriptFileName: TFileName);
    property ScriptFileName: TFileName read fScriptFileName;
  end;

//------------------------------------------------------------------------------
// TfrmNewProject
//------------------------------------------------------------------------------

procedure TfrmNewProject.bBrowseClick(Sender: TObject);
begin
  with sdNewScript do begin
    InitialDir := ExtractFilePath(NewFileName);
    FileName := ExtractFileName(NewFileName);
    if Execute then begin
      eNewFileName.Text := FileName;
      eNewFileName.SelectAll;
      eNewFileName.SetFocus;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmNewProject.bOKClick(Sender: TObject);
begin
  if eNewFileName.Text = '' then begin
    MsgBox('Please entry a valid filename.', 'Warning', MB_ICONWARNING);
    ModalResult := mrNone;
    Exit;
  end;

  if LowerCase(ExtractFileExt(NewFileName)) <> '.xml' then
    eNewFileName.Text := eNewFileName.Text + '.xml';

  // copy the xml file!
  fCreationResult := CopyFile(GetSelectedSourceScriptFileName, NewFileName, False);
  if cbCreateDTD.Checked then
    fCreationResult := fCreationResult and
      CopyFile(DTDFile, ExtractFilePath(NewFileName) + BINARY_SCRIPT_DB_DTD, False);

{$IFDEF DEBUG}
  WriteLn('GetSelectedSourceScriptFileName: ', GetSelectedSourceScriptFileName,
    sLineBreak, 'NewFileName: ', NewFileName,
    sLineBreak, 'CopyResult: ', CreationResult);
{$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TfrmNewProject.FormCreate(Sender: TObject);
begin
  LoadGameVersionList;
  eNewFileName.Text := ExtractFilePath(GetApplicationDirectory) + 'new.xml';

  // Reading configuration...
  with Configuration do begin
    eNewFileName.Text := ReadString('newproj', 'filename', eNewFileName.Text);
    cbGameVersionSelect.ItemIndex := ReadInteger('newproj', 'gameversionselected',
      cbGameVersionSelect.ItemIndex);
    cbCreateDTD.Checked := ReadBool('newproj', 'createdtd', cbCreateDTD.Checked);
  end;
  eNewFileName.SelectAll;
end;

//------------------------------------------------------------------------------

procedure TfrmNewProject.FormDestroy(Sender: TObject);
var
  i: Integer;

begin
  for i := 0 to cbGameVersionSelect.Items.Count - 1 do
    cbGameVersionSelect.Items.Objects[i].Free;

  // Saving configuration..
  with Configuration do begin
    WriteString('newproj', 'filename', eNewFileName.Text);
    WriteInteger('newproj', 'gameversionselected', cbGameVersionSelect.ItemIndex);
    WriteBool('newproj', 'createdtd', cbCreateDTD.Checked);    
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmNewProject.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

//------------------------------------------------------------------------------

function TfrmNewProject.GetNewFileName: TFileName;
begin
  Result := eNewFileName.Text;
end;

//------------------------------------------------------------------------------

function TfrmNewProject.GetSelectedSourceScriptFileName: TFileName;
begin
  Result := ((cbGameVersionSelect.Items.Objects[cbGameVersionSelect.ItemIndex])
    as TScriptFileNameObject).ScriptFileName;
end;

//------------------------------------------------------------------------------

procedure TfrmNewProject.LoadGameVersionList;
const
  BINARY_SCRIPT_DB = 'binedit.db';
  BINARY_SCRIPT_DB_INDEX = 'index.dbi';

var
  IndexFile, ScriptFile: TFileName;
  xmlIndex: IXMLDocument;
  i: Integer;
  Node: IXMLNode;
  GameVersionName: string;
  DBExtracted: Boolean;
  
begin
  IndexFile := GetWorkingTempDirectory + BINARY_SCRIPT_DB_INDEX;

  // Extracting if needed
  DBExtracted := FileExists(IndexFile);
  if not DBExtracted then  
    DBExtracted := SevenZipExtract(GetApplicationDataDirectory
      + BINARY_SCRIPT_DB, GetWorkingTempDirectory);

  // Go working
  if DBExtracted then begin

    fDTDFile := GetWorkingTempDirectory + BINARY_SCRIPT_DB_DTD;
    XmlIndex := TXMLDocument.Create(nil);
    try
      try
        xmlIndex.LoadFromFile(IndexFile);
        for i := 0 to xmlIndex.DocumentElement.ChildNodes.Count - 1 do begin
          Node := xmlIndex.DocumentElement.ChildNodes[i];

          // building the source script file path
          ScriptFile := GetWorkingTempDirectory
            + Node.Attributes['game'] + Node.Attributes['platform']
            + Node.Attributes['region'] + '.xml';

          // building the game version name
          GameVersionName :=
              GameVersionCodeStringToString(Node.Attributes['game'])
            + ' [' + GameRegionCodeStringToString(Node.Attributes['region']) + ' / '
            + PlatformVersionCodeStringToString(Node.Attributes['platform']) + ']';

          // adding object to the combobox
          cbGameVersionSelect.Items.AddObject(GameVersionName, TScriptFileNameObject.Create(ScriptFile));
        end;
        cbGameVersionSelect.ItemIndex := 0;
      except
      end;
    finally
      xmlIndex.Active := False;
      xmlIndex := nil;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TfrmNewProject.MsgBox(Text, Title: string; Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Title), Flags);
end;

//------------------------------------------------------------------------------

{ TScriptFileNameObject }

constructor TScriptFileNameObject.Create(AScriptFileName: TFileName);
begin
  fScriptFileName := AScriptFileName;
end;

//------------------------------------------------------------------------------

initialization
  SevenZipInitEngine(GetWorkingTempDirectory);

//------------------------------------------------------------------------------

end.
