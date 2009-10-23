unit tools;

interface

uses
  Windows, SysUtils;

function LoadConfig: Boolean;
procedure SaveConfig;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants, Main;

var
  AppDir,
  ConfigFileName: TFileName;

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

    XMLDoc.DocumentElement := XMLDoc.CreateNode('mteditorcfg'); // On crée la racine

    WriteXMLNode(XMLDoc, 'directory', frmMain.SourceDirectory);

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

    if (XMLDoc.DocumentElement.NodeName <> 'mteditorcfg') then Exit;

    // Reading config values
    frmMain.SourceDirectory := ReadXMLNodeString(XMLDoc, 'directory');

    Result := True;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

//------------------------------------------------------------------------------

initialization
  AppDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  ConfigFileName := AppDir + 'config.xml';
//  PreviousSelectedPathFileName := AppDir + 'selpath.ini';
//  InitWrapStr;

//------------------------------------------------------------------------------

end.
