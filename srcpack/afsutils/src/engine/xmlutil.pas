unit xmlutil;

interface

uses
  SysUtils;

procedure SaveListToXML(FileName: TFileName);
function ImportListFromXML(FileName: TFileName): Boolean;

implementation
uses XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX,
  afscreate, afsextract;

procedure SaveListToXML(FileName: TFileName);
var
  i, intBuf: Integer;
  XMLDoc: IXMLDocument;
  CurrentNode, SubCurrentNode: IXMLNode;

  procedure AddXMLNode(var XML: IXMLDocument; const Key, Value: string); overload;
  var
    CurrentNode: IXMLNode;
  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure AddXMLNode(var XML: IXMLDocument; const Key: string; const Value: Integer); overload;
  begin
    AddXMLNode(XML, Key, IntToStr(Value));
  end;

begin
  //Exporting current afsMainQueue to XML
  XMLDoc := TXMLDocument.Create(nil);
  try
    with XMLDoc do begin
      Options := [doNodeAutoCreate, doAttrNull];
      ParseOptions := [];
      NodeIndentStr := '  ';
      Active := True;
      Version := '1.0';
      Encoding := 'UTF-8';
    end;

    //Creating the root
    XMLDoc.DocumentElement := XMLDoc.CreateNode('afsutils');

    //Directory
    AddXMLNode(XMLDoc, 'inputdir', afsMainQueue.OutputDir);

    //Files list
    CurrentNode := XMLDoc.CreateNode('list');
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
    CurrentNode.Attributes['count'] := afsMainQueue.FileIndex.Count;
    for i := 0 to afsMainQueue.FileIndex.Count - 1 do begin
      intBuf := afsMainQueue.FileIndex[i];
      SubCurrentNode := XMLDoc.CreateNode('file');
      SubCurrentNode.NodeValue := ExtractFileName(afsMain.FileName[intBuf]);
      CurrentNode.ChildNodes.Add(SubCurrentNode);
    end;

    XMLDoc.SaveToFile(FileName);
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;

end;

function ImportListFromXML(FileName: TFileName): Boolean;
var
  XMLDoc: IXMLDocument;
  CurrentNode, LoopNode: IXMLNode;
  i: Integer;
  xmlDir, xmlFile: String;
begin
  Result := False;

  //Importing XML to createMainList
  XMLDoc := TXMLDocument.Create(nil);
  try
    with XMLDoc do begin
      Options := [doNodeAutoCreate, doAttrNull];
      ParseOptions := [];
      NodeIndentStr := '  ';
      Active := True;
      Version := '1.0';
      Encoding := 'UTF-8';
    end;

    XMLDoc.LoadFromFile(FileName);
    if XMLDoc.DocumentElement.NodeName <> 'afsutils' then Exit;

    //Input directory
    CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('inputdir');
    xmlDir := CurrentNode.NodeValue;

    //Files list
    CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('list');
    for i := 0 to CurrentNode.Attributes['count'] - 1 do begin
      LoopNode := CurrentNode.ChildNodes.Nodes[i];
      if Assigned(LoopNode) then begin
        try
          xmlFile := LoopNode.NodeValue;
        except
          xmlFile := '';
        end;

        if FileExists(xmlDir+xmlFile) then begin
          createMainList.AddFile(xmlDir+xmlFile);
        end;
      end;
    end;

    Result := True;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

end.
