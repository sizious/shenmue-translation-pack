unit utils;

interface

uses
  Windows, SysUtils;

procedure SaveConfig;
function LoadConfig: Boolean;

implementation

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Main;

var
  ConfigFileName: TFileName;
  
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

    // On crée la racine
    XMLDoc.DocumentElement := XMLDoc.CreateNode('s2freequestcfg');

    AddXMLNode(XMLDoc, 'autosave', frmMain.AutoSave);
    AddXMLNode(XMLDoc, 'makebackup', frmMain.MakeBackup);
    AddXMLNode(XMLDoc, 'directory', frmMain.TargetDirectory);

    XMLDoc.SaveToFile(ConfigFileName);
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

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

    if XMLDoc.DocumentElement.NodeName <> 's2freequestcfg' then Exit;

    try
      Node := XMLDoc.DocumentElement.ChildNodes.FindNode('autosave');
      if Assigned(Node) then frmMain.AutoSave := Node.NodeValue;
    except end;

    try
      Node := XMLDoc.DocumentElement.ChildNodes.FindNode('makebackup');
      if Assigned(Node) then frmMain.MakeBackup := Node.NodeValue;
    except end;

    try
      Node := XMLDoc.DocumentElement.ChildNodes.FindNode('directory');
      if Assigned(Node) then frmMain.TargetDirectory := Node.NodeValue;
    except end;

    Result := True;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

initialization
  ConfigFileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'config.xml';
  
end.
