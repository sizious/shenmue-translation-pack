//    This file is part of IDX Creator.
//
//    You should have received a copy of the GNU General Public License
//    along with IDX Creator.  If not, see <http://www.gnu.org/licenses/>.

unit xmlutils;

interface

uses
  Classes, SysUtils, Variants, XMLDom, XMLIntf, MSXMLDom, XMLDoc;

procedure LoadConfig(const FileName: TFileName);
procedure SaveConfig(const FileName: TFileName);

implementation

uses
  main;
  
procedure LoadConfig(const FileName: TFileName);
var
  XMLDoc: IXMLDocument;
  Node: IXMLNode;
  oldIdx, oldAfs, newAfs, newIdx, game: String;

  function ReadNode(var XMLDoc: IXMLDocument; const Key: String): String;
  begin
    Result := '';
    Node := XMLDoc.DocumentElement.ChildNodes.FindNode(Key);
    if Assigned(Node) then begin
      if Node.NodeValue <> null then begin
        Result := Node.NodeValue;
      end;
    end;
  end;
  
begin
  if FileExists(FileName) then begin
    XMLDoc := TXMLDocument.Create(nil);

    try
      with XMLDoc do begin
        Options := [doNodeAutoCreate];
        ParseOptions:= [];
        NodeIndentStr:= '  ';
        Active := True;
        Version := '1.0';
        Encoding := 'UTF-8';
      end;

      XMLDoc.LoadFromFile(FileName);

      if XMLDoc.DocumentElement.NodeName <> 'idxcreatorcfg' then Exit;

      try
        Node := XMLDoc.DocumentElement.ChildNodes.FindNode('remember');
        if Assigned(Node) then frmMain.cbConfig.Checked := Node.NodeValue;
      except end;

      if (Assigned(Node)) and (Node.NodeValue = True) then begin
        //Template groupbox
        Node := XMLDoc.DocumentElement.ChildNodes.FindNode('template');
        if Assigned(Node) then frmMain.templateChkBox.Checked := Node.NodeValue;
      
        oldIdx := ReadNode(XMLDoc, 'oldidx');
        oldAfs := ReadNode(XMLDoc, 'oldafs');
        newAfs := ReadNode(XMLDoc, 'newafs');
        newIdx := ReadNode(XMLDoc, 'newidx');
        game := ReadNode(XMLDoc, 'game');

        frmMain.editOldIdx.Text := oldIdx;
        frmMain.editOldAfs.Text := oldAfs;
        frmMain.editModAfs.Text := newAfs;
        frmMain.editNewIdx.Text := newIdx;

        if game = 's2' then
          frmMain.GameVersion := gvShenmue2
        else
          frmMain.GameVersion := gvShenmue;

      end;
    finally
      XMLDoc.Active := False;
      XMLDoc := nil;
    end;
  end
  else begin
    SaveConfig(FileName);
  end;
end;

procedure SaveConfig(const FileName: TFileName);
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
      Encoding := 'UTF-8';
    end;

    //Creating "root"
    XMLDoc.DocumentElement := XMLDoc.CreateNode('idxcreatorcfg');
    AddXMLNode(XMLDoc, 'remember', frmMain.cbConfig.Checked);
    AddXMLNode(XMLDoc, 'template', frmMain.templateChkBox.Checked);
    AddXMLNode(XMLDoc, 'oldidx', frmMain.editOldIdx.Text);
    AddXMLNode(XMLDoc, 'oldafs', frmMain.editOldAfs.Text);
    AddXMLNode(XMLDoc, 'newafs', frmMain.editModAfs.Text);
    AddXMLNode(XMLDoc, 'newidx', frmMain.editNewIdx.Text);

    case frmMain.GameVersion of
      gvShenmue:  AddXMLNode(XMLDoc, 'game', 's1');
      gvShenmue2: AddXMLNode(XMLDoc, 'game', 's2');
    end;

    XMLDoc.SaveToFile(FileName);
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;

end;

end.
