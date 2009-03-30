//    This file is part of Shenmue AiO Subtitles Editor.
//
//    You should have received a copy of the GNU General Public License
//    along with Shenmue AiO Subtitles Editor.  If not, see <http://www.gnu.org/licenses/>.

unit subutils;

interface

uses
  Classes, SysUtils, USrfStructAiO,
  XMLDom, XMLIntf, MSXMLDom, XMLDoc;

procedure ExportToText(const FileName: TFileName; var SrfStruct: TSrfStruct);
procedure ExportToXML(const FileName: TFileName; var SrfStruct: TSrfStruct);
procedure ImportFromText(const FileName: TFileName; var SrfStruct: TSrfStruct);
procedure ImportFromXML(const FileName: TFileName; var SrfStruct: TSrfStruct);

const
  LINE_BREAK = #$A1#$F5;

implementation

procedure ExportToText(const FileName: TFileName; var SrfStruct: TSrfStruct);
var
  F: TextFile;
  i: Integer;
  strBuf: String;
begin
  //Assigning output file
  AssignFile(F, FileName);
  ReWrite(F);

  //Filename and subtitle count
  WriteLn(F, ExtractFileName(SrfStruct.FileName));
  WriteLn(F, IntToStr(SrfStruct.Count));

  for i := 0 to SrfStruct.Count-1 do begin
    if SrfStruct.Items[i].Editable then begin
      WriteLn(F, '----------');
      WriteLn(F, IntToStr(i+1));
      WriteLn(F, SrfStruct.Items[i].CharName);
      strBuf := StringReplace(SrfStruct.Items[i].Text, sLineBreak, LINE_BREAK, [rfReplaceAll]);
      WriteLn(F, strBuf);
    end;
  end;

  CloseFile(F);
end;

procedure ExportToXML(const FileName: TFileName; var SrfStruct: TSrfStruct);
var
  XMLDoc: IXMLDocument;
  MainNode, LoopNode: IXMLNode;
  SrfEntry: TSrfEntry;
  i, intBuf: Integer;
  strBuf: String;

  procedure AddXMLNode(var XMLDoc: IXMLDocument; const Key, Value: String); overload;
  var
    CurrentNode: IXMLNode;
  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure AddXMLNode(var XMLDoc: IXMLDocument; const Key: String; const Value: Integer); overload;
  begin
    AddXMLNode(XMLDoc, Key, IntToStr(Value));
  end;

begin
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
    XMLDoc.DocumentElement := XMLDoc.CreateNode('subseditor');

    //Original file name
    AddXMLNode(XMLDoc, 'file', ExtractFileName(SrfStruct.FileName));

    //Total subs count
    AddXMLNode(XMLDoc, 'total', SrfStruct.Count);

    //Subtitle list
    MainNode := XMLDoc.CreateNode('list');
    XMLDoc.DocumentElement.ChildNodes.Add(MainNode);
    intBuf := 0;
    for i := 0 to SrfStruct.Count-1 do begin
      SrfEntry := SrfStruct.Items[i];
      if SrfEntry.Editable then begin
        Inc(intBuf);
        LoopNode := XMLDoc.CreateNode('sub');
        LoopNode.Attributes['num'] := i;
        LoopNode.Attributes['charid'] := SrfEntry.CharName;

        strBuf := StringReplace(SrfEntry.Text, sLineBreak, LINE_BREAK, [rfReplaceAll]);
        LoopNode.NodeValue := strBuf;
        MainNode.ChildNodes.Add(LoopNode);
      end;
    end;

    MainNode.Attributes['count'] := intBuf;
    XMLDoc.SaveToFile(FileName);
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

procedure ImportFromText(const FileName: TFileName; var SrfStruct: TSrfStruct);
var
  F: TextFile;
  Line: String;
  currLine, nextLine, subCnt, subNum: Integer;
begin
  //Assigning input file
  AssignFile(F, FileName);
  Reset(F);

  currLine := 0;
  nextLine := 4;
  subCnt := 0;
  subNum := 0;

  repeat
    Inc(currLine);
    ReadLn(F, Line);

    if currLine = 2 then begin
      subCnt := StrToInt(Line);
    end;

    if (currLine > 2) and (subCnt = SrfStruct.Count) then begin
      if (currLine = nextLine) and (Line <> '') then begin
        subNum := StrToInt(Line);
      end;

      if (currLine = nextLine+2) and (Line <> '') then begin
        Line := StringReplace(Line, LINE_BREAK, sLineBreak, [rfReplaceAll]);
        SrfStruct.Items[subNum-1].Text := Line;
        Inc(nextLine, 4);
      end;
    end
    else if (currLine > 2) and (subCnt <> SrfStruct.Count) then begin
      Break;
    end;
  until EOF(F);

  CloseFile(F);
end;

procedure ImportFromXML(const FileName: TFileName; var SrfStruct: TSrfStruct);
var
  XMLDoc: IXMLDocument;
  CurrentNode, LoopNode: IXMLNode;
  i, intBuf: Integer;
  strBuf: String;
begin
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
    if XMLDoc.DocumentElement.NodeName = 'subseditor' then begin
      //We need to compare SrfStruct count and XML sub count
      CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('total');
      intBuf := CurrentNode.NodeValue;

      if intBuf = SrfStruct.Count then begin
        CurrentNode := XMLDoc.DocumentElement.ChildNodes.FindNode('list');
        for i := 0 to CurrentNode.Attributes['count']-1 do begin
          LoopNode := CurrentNode.ChildNodes.Nodes[i];
          if Assigned(LoopNode) then begin
            try
              intBuf := LoopNode.Attributes['num'];
              strBuf := LoopNode.NodeValue;
            except
              intBuf := -1;
              strBuf := '';
            end;

            if (intBuf >= 0) and (strBuf <> '') then begin
              strBuf := StringReplace(strBuf, LINE_BREAK, sLineBreak, [rfReplaceAll]);
              SrfStruct.Items[intBuf].Text := strBuf;
            end;
          end;
        end;
      end;
    end;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

end.
