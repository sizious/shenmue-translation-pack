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

function GenerateTextureFileName(Entry: TSprEntry): TFileName;

implementation

function GenerateTextureFileName(Entry: TSprEntry): TFileName;
var
  i: Integer;
  
begin
  Result := '';

  if Entry.TextureName = '' then
    Result := 'noname'
  else
    for i := 1 to Length(Entry.TextureName) do begin
      if Entry.TextureName[i] in ['A'..'Z', 'a'..'z', '0'..'9'] then
        Result := Result + Entry.TextureName[i]
      else
        Result := Result + '_';
    end;

  Result := Result + '_#' + IntToStr(Entry.Index);

  if Entry.Format = 'DDS' then begin
    Result := Result + '.dds';
  end
  else if Entry.Format = 'PVR' then begin
    Result := Result + '.pvr';
  end
  else begin
    Result := Result + '.bin';
  end;
end;

procedure SaveQueueToXML(const FileName: TFileName; var SPRStruct: TSprStruct; var IndexList: TIntList);
var
  i, j: Integer; //, noNameCnt: Integer;
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
//  noNameCnt := 0;

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

      fName := GenerateTextureFileName(CurrentEntry);

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
