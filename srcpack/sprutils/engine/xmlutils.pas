//    This file is part of SPR Utils.
//
//    You should have received a copy of the GNU General Public License
//    along with SPR Utils.  If not, see <http://www.gnu.org/licenses/>.

unit xmlutils;

interface

uses
  Classes, SysUtils, UIntList, USprStruct,
  XMLDom, XMLIntf, MSXMLDom, XMLDoc;

procedure SaveQueueToXML(const FileName: TFileName; var SPRStruct: TSprStruct;
                          var IndexList: TIntList);

implementation

procedure SaveQueueToXML(const FileName: TFileName; var SPRStruct: TSprStruct; var IndexList: TIntList);
var
  i, j: Integer;
  fName: String;
  CurrentEntry: TSprEntry;
  XMLDoc: TXMLDocument;
  MainNode, LoopNode: IXMLNode;

  procedure AddXMLNode(var XMLDoc: TXMLDocument; const Key, Value: String); overload;
  var
    CurrentNode: IXMLNode;
  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure AddXMLNode(var XMLDoc: TXMLDocument; const Key: String; const Value: Integer); overload;
  begin
    AddXMLNode(XMLDoc, Key, Value);
  end;
begin
  //Saving SPRStruct entry to XML, according to IndexList
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
    XMLDoc.DocumentElement := XMLDoc.CreateNode('sprutils');

    //Input directory for future use
    AddXMLNode(XMLDoc, 'inputdir', ExtractFilePath(FileName));

    //Files list
    MainNode := XMLDoc.CreateNode('list');
    XMLDoc.DocumentElement.ChildNodes.Add(MainNode);
    MainNode.Attributes['count'] := IndexList.Count;
    for i := 0 to IndexList.Count - 1 do begin
      j := IndexList[i];
      CurrentEntry := SPRStruct.Items[j];
      LoopNode := XMLDoc.CreateNode('file');
      LoopNode.Attributes['texn'] := CurrentEntry.TextureName;

      fName := CurrentEntry.TextureName;
      if CurrentEntry.Format = 'DDS' then begin
        fName := fName + '.dds';
      end
      else if CurrentEntry.Format = 'PVR' then begin
        fName := fName + '.pvr';
      end
      else begin
        fName := fName + '.bin';
      end;

      LoopNode.NodeValue := fName;
      MainNode.ChildNodes.Add(LoopNode);
    end;

    XMLDoc.SaveToFile(FileName);
  finally
    XMLDoc.Active := False;
    XMLDoc.Free;
  end;
end;

end.
