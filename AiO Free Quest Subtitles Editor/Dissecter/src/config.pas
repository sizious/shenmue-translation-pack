unit config;

interface

uses
  Windows, SysUtils, Classes, XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants;

procedure SaveConfig;
function LoadConfig: Boolean;

implementation

uses
  Main;
  
procedure SaveConfig;
var
  XMLDoc: IXMLDocument;
  FileName: TFileName;

  procedure AddXMLNode(var XML: IXMLDocument; const Key, Value: string); overload;
  var
    CurrentNode: IXMLNode;

  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  {procedure AddXMLNode(var XML: IXMLDocument; const Key: string; const Value: Integer); overload;
  begin
    AddXMLNode(XML, Key, IntToStr(Value));
  end;}

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

    // Creating the root
    XMLDoc.DocumentElement := XMLDoc.CreateNode('humans_dissecter_config');

    // Values
    AddXMLNode(XMLDoc, 'input_dir', Main.Form1.input_dir_edit.Text);
    AddXMLNode(XMLDoc, 'output_dir', Main.Form1.output_dir_edit.Text);

    FileName := ChangeFileExt(ParamStr(0), '.xml');
    
    XMLDoc.SaveToFile(FileName);
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

function LoadConfig: Boolean;
var
  XMLDoc: IXMLDocument;
  CurrentNode: IXMLNode;
  xmlOutputDir, xmlInputDir: string;
  FileName: TFileName;

begin
  Result := False;
  FileName := ChangeFileExt(ParamStr(0), '.xml');
  if not FileExists(FileName) then Exit;

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

    XMLDoc.LoadFromFile(FileName);

    // Verifying if it's a valid XML to import
    if XMLDoc.DocumentElement.NodeName <> 'humans_dissecter_config' then Exit;

    // Values
    CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('input_dir');
    if not VarIsNull(CurrentNode.NodeValue) then xmlInputDir := CurrentNode.NodeValue else xmlInputDir := '';

    CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('output_dir');
    if not VarIsNull(CurrentNode.NodeValue) then xmlOutputDir := CurrentNode.NodeValue else xmlOutputDir := ''; 

    Main.Form1.input_dir_edit.Text := xmlInputDir;
    Main.Form1.output_dir_edit.Text := xmlOutputDir;

    Result := True;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

end.
