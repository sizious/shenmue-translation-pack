{
  Some standard common utilities functions...
}
unit utils;

interface

uses
  Windows, SysUtils, Variants, ShellApi, ComCtrls;

procedure SaveConfig;
function LoadConfig: Boolean;
function HexToInt(Hex: string): Integer;
function HexToInt64(Hex: string): Int64;
procedure ShellOpenPropertiesDialog(FileName: TFileName);
function GetConfigFileName: TFileName;
function GetPreviousSelectedPathFileName: TFileName;
function FindNode(Node: TTreeNode; Text: string): TTreeNode;
procedure ListViewSelectItem(ListView: TCustomListView; Index: Integer);

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Main, Warning;

const
  HexValues = '0123456789ABCDEF';
  
var
  AppDir: TFileName;
  ConfigFileName: TFileName;
  PreviousSelectedPathFileName: TFileName;

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
  procedure AddXMLNode(var XML: IXMLDocument; const Key, Value: string); overload;
  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure AddXMLNode(var XML: IXMLDocument; const Key: string; const Value: Integer); overload;
  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure AddXMLNode(var XML: IXMLDocument; const Key: string; const Value: Boolean); overload;
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

    AddXMLNode(XMLDoc, 'autosave', frmMain.AutoSave);
    AddXMLNode(XMLDoc, 'makebackup', frmMain.MakeBackup);
    AddXMLNode(XMLDoc, 'directory', frmMain.SelectedDirectory);
    AddXMLNode(XMLDoc, 'decodesubs', frmMain.EnableCharsMod);
    AddXMLNode(XMLDoc, 'warningdisplayed', IsWarningUnderstood);

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

    try
      Node := XMLDoc.DocumentElement.ChildNodes.FindNode('autosave');
      if Assigned(Node) then frmMain.AutoSave := Node.NodeValue;
    except end;

    try
      Node := XMLDoc.DocumentElement.ChildNodes.FindNode('makebackup');
      if Assigned(Node) then frmMain.MakeBackup := Node.NodeValue;
    except end;

    try
      Node := XMLDoc.DocumentElement.ChildNodes.FindNode('decodesubs');
      if Assigned(Node) then frmMain.EnableCharsMod := Node.NodeValue;
    except end;

    try
      Node := XMLDoc.DocumentElement.ChildNodes.FindNode('directory');
      if Assigned(Node) then
        if not VarIsNull(Node.NodeValue) then
          frmMain.SelectedDirectory := Node.NodeValue;
    except end;

    Result := True;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

//------------------------------------------------------------------------------

// By CodePedia
// http://www.codepedia.com/1/HexToInt
function HexToInt(Hex: string): Integer;
var
  i: integer;
begin
  Result := 0;
  case Length(Hex) of
    0: Result := 0;
    1..8: for i:=1 to Length(Hex) do
      Result := 16*Result + Pos(Upcase(Hex[i]), HexValues)-1;
    else for i:=1 to 8 do
      Result := 16*Result + Pos(Upcase(Hex[i]), HexValues)-1;
  end;
end;

//------------------------------------------------------------------------------

// By CodePedia
// http://www.codepedia.com/1/HexToInt
function HexToInt64(Hex: string): Int64;
var
  i: integer;
begin
  Result := 0;
  case Length(Hex) of
    0: Result := 0;
    1..16: for i:=1 to Length(Hex) do
      Result := 16*Result + Pos(Upcase(Hex[i]), HexValues)-1;
    else for i:=1 to 16 do
      Result := 16*Result + Pos(Upcase(Hex[i]), HexValues)-1;
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

initialization
  AppDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  ConfigFileName := AppDir + 'config.xml';
  PreviousSelectedPathFileName := AppDir + 'selpath.ini';
end.
