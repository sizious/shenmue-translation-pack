{
  Some standard common utilities functions...
}
unit utils;

interface

uses
  Windows, SysUtils, Variants, ShellApi, ComCtrls;

procedure SaveConfig;
function LoadConfig: Boolean;

procedure ShellOpenPropertiesDialog(FileName: TFileName);
function GetConfigFileName: TFileName;
function GetPreviousSelectedPathFileName: TFileName;
function FindNode(Node: TTreeNode; Text: string): TTreeNode;
procedure ListViewSelectItem(ListView: TCustomListView; Index: Integer);
function WrapStr: string;
function GetWorkingTempDirectory: TFileName;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Main, Warning, VistaUI, SysTools;

const
  WORKING_TEMP_DIR = 'FQEditor';

var
  AppDir: TFileName;
  ConfigFileName: TFileName;
  PreviousSelectedPathFileName: TFileName;
  sWrapStr: string; // used for MsgBox
  sWorkingTempDirectory: TFileName;

//------------------------------------------------------------------------------

procedure InitWorkingDirectory;
begin
  sWorkingTempDirectory := GetTempDir + WORKING_TEMP_DIR + '\';
  if not DirectoryExists(sWorkingTempDirectory) then
    ForceDirectories(sWorkingTempDirectory);
end;

//------------------------------------------------------------------------------

procedure DeleteWorkingDirectory;
begin
  if DirectoryExists(sWorkingTempDirectory) then
    DeleteDirectory(sWorkingTempDirectory);
end;
  
//------------------------------------------------------------------------------

function GetWorkingTempDirectory: TFileName;
begin
  if sWorkingTempDirectory = '' then
    InitWorkingDirectory;
  Result := sWorkingTempDirectory; 
end;

//------------------------------------------------------------------------------

function GetPreviousSelectedPathFileName: TFileName;
begin
  Result := PreviousSelectedPathFileName;
end;

//------------------------------------------------------------------------------

function GetConfigFileName: TFileName;
begin
  Result := ConfigFileName;
end;

//------------------------------------------------------------------------------

procedure SaveConfig;
var
  XMLDoc: IXMLDocument;

  CurrentNode: IXMLNode;
  procedure WriteXMLNode(var XML: IXMLDocument; const Key, Value: string); overload;
  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure WriteXMLNode(var XML: IXMLDocument; const Key: string; const Value: Integer); overload;
  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure WriteXMLNode(var XML: IXMLDocument; const Key: string; const Value: Boolean); overload;
  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;
  
begin
  XMLDoc := TXMLDocument.Create(nil);
  try
    with XMLDoc do begin                  
      Options := [doNodeAutoCreate, doAttrNull];
      ParseOptions:= [];
      NodeIndentStr:= '  ';
      Active := True;
      Version := '1.0';
      Encoding := 'ISO-8859-1';
    end;

    XMLDoc.DocumentElement := XMLDoc.CreateNode('freequestcfg'); // On crée la racine

    WriteXMLNode(XMLDoc, 'autosave', frmMain.AutoSave);
    WriteXMLNode(XMLDoc, 'makebackup', frmMain.MakeBackup);
    WriteXMLNode(XMLDoc, 'directory', frmMain.SelectedDirectory);
    WriteXMLNode(XMLDoc, 'decodesubs', frmMain.EnableCharsMod);
    WriteXMLNode(XMLDoc, 'warningdisplayed', IsWarningUnderstood);
    WriteXMLNode(XMLDoc, 'multitranslate', frmMain.MultiTranslation.Active);
    WriteXMLNode(XMLDoc, 'rescandirstartup', frmMain.ReloadDirectoryAtStartup);

    XMLDoc.SaveToFile(ConfigFileName);
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

//------------------------------------------------------------------------------

function LoadConfig: Boolean;
var
  XMLDoc: IXMLDocument;
  Node: IXMLNode;

  function ReadXMLNodeString(var XML: IXMLDocument; const Key: string): string;
  begin
    Result := '';
    try
      Node := XMLDoc.DocumentElement.ChildNodes.FindNode(Key);
      if Assigned(Node) then
        if not VarIsNull(Node.NodeValue) then
          Result := Node.NodeValue;
    except
    end;
  end;

  function ReadXMLNodeBoolean(var XML: IXMLDocument; const Key: string): Boolean;
  var
    V: string;

  begin
    V := LowerCase(ReadXMLNodeString(XML, Key));
    Result := (V = 'true') or (V = '1');
  end;
  
begin
  Result := False;
  if not FileExists(ConfigFileName) then Exit;

  XMLDoc := TXMLDocument.Create(nil);
  try
    with XMLDoc do begin
      Options := [doNodeAutoCreate];
      ParseOptions:= [];
      NodeIndentStr:= '  ';
      Active := True;
      Version := '1.0';
      Encoding := 'ISO-8859-1';
    end;

    XMLDoc.LoadFromFile(ConfigFileName);

    if (XMLDoc.DocumentElement.NodeName <> 'freequestcfg') and
      (XMLDoc.DocumentElement.NodeName <> 's2freequestcfg') then Exit;

    // Reading config values
    frmMain.AutoSave := ReadXMLNodeBoolean(XMLDoc, 'autosave');
    frmMain.MakeBackup := ReadXMLNodeBoolean(XMLDoc, 'makebackup');
    frmMain.EnableCharsMod := ReadXMLNodeBoolean(XMLDoc, 'decodesubs');
    frmMain.SelectedDirectory := ReadXMLNodeString(XMLDoc, 'directory');
    frmMain.MultiTranslation.Active := ReadXMLNodeBoolean(XMLDoc, 'multitranslate');
    frmMain.ReloadDirectoryAtStartup := ReadXMLNodeBoolean(XMLDoc, 'rescandirstartup');

    Result := True;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

//------------------------------------------------------------------------------

procedure ShellOpenPropertiesDialog(FileName: TFileName);
var
  ShellExecuteInfo: TShellExecuteInfo;

begin
  FillChar(ShellExecuteInfo, SizeOf(ShellExecuteInfo), 0);
  ShellExecuteInfo.cbSize := SizeOf(ShellExecuteInfo);
  ShellExecuteInfo.fMask := SEE_MASK_INVOKEIDLIST;
  ShellExecuteInfo.lpVerb := 'properties';
  ShellExecuteInfo.lpFile := PChar(FileName);
  ShellExecuteEx(@ShellExecuteInfo);
end;

//------------------------------------------------------------------------------

function FindNode(Node: TTreeNode; Text: string): TTreeNode;
var
  i: Integer;

begin
  Result := nil;
  if not Node.HasChildren then Exit;

  for i := 0 to Node.Count - 1 do
    if Node.Item[i].Text = Text then begin
      Result := Node.Item[i];
      Break;
    end;

end;

//------------------------------------------------------------------------------

procedure ListViewSelectItem(ListView: TCustomListView; Index: Integer);
var
  P: TPoint;

begin
  if Index = 0 then begin
//    ListView.Scroll(0, - MaxInt);
    ListView.ItemIndex := 0;
  end else begin
    ListView.ItemIndex := Index - 1;
    P := ListView.Selected.Position;
    ListView.Scroll(0, P.Y);
    ListView.ItemIndex := Index;
  end;
end;

//------------------------------------------------------------------------------

procedure InitWrapStr;
begin
  sWrapStr := sLineBreak; // WrapStr for Windows XP
  if IsWindowsVista then sWrapStr := ' ';
end;

//------------------------------------------------------------------------------

function WrapStr: string;
begin
  Result := sWrapStr;
end;

//------------------------------------------------------------------------------

initialization
  sWorkingTempDirectory := ''; // see GetWorkingTempDirectory
  AppDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  ConfigFileName := AppDir + 'config.xml';
  PreviousSelectedPathFileName := AppDir + 'selpath.ini';
  InitWrapStr;

//------------------------------------------------------------------------------

finalization
  DeleteWorkingDirectory;

//------------------------------------------------------------------------------

end.
