program makeidx;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  XMLDom,
  XMLIntf,
  MSXMLDom,
  XMLDoc,
  ActiveX,
  charscnt in '..\..\..\src\engine\charscnt.pas',
  charslst in '..\..\..\src\engine\charslst.pas',
  common in '..\..\..\src\engine\common.pas',
  fileslst in '..\..\..\src\engine\fileslst.pas',
  npcinfo in '..\..\..\src\engine\npcinfo.pas',
  scnfedit in '..\..\..\src\engine\scnfedit.pas',
  scnfutil in '..\..\..\src\engine\scnfutil.pas';

const
  WORK_DIRECTORY = '.\';
  OUTPUT_FILE = 'dc_pal_shenmue2.dbi';
  BASE_FILENAME = 'dc_pal_shenmue2';
  GAME_VERSION: TGameVersion = gvShenmue2;

var
  XMLOutputIndex, XMLInput: IXMLDocument;
  InfoNode, Node,
  ContainerDiscsRootNode,
  DiscRootNode,
  InputFileNamesNode: IXMLNode;
  DiscNumberRead, i, j,
  DiscNumber, MaxDatabaseFiles: Integer;
  InputFileEntry: string;
  XMLFileName: TFileName;
  
begin
  if ParamCount < 2 then begin
    WriteLn('Usage: makeidx <DiscNumber> <MaxDatabaseFiles>');
    Exit;
  end;

  try
    DiscNumber := StrToInt(ParamStr(1));
    MaxDatabaseFiles := StrToInt(ParamStr(2));
  except
    WriteLn('Invalid parameters');
    Exit;
  end;

  CoInitialize(nil);
  XMLOutputIndex := TXMLDocument.Create(nil);
  XMLInput := TXMLDocument.Create(nil);
  try

    try
      // initialization for the XML file
      with XMLOutputIndex do begin
        Options := [doNodeAutoCreate, doAttrNull];
        ParseOptions:= [];
        NodeIndentStr:= '  ';
        Active := True;
        Version := '1.0';
        Encoding := 'utf-8'; //'ISO-8859-1';
      end;

      if not FileExists(OUTPUT_FILE) then begin
        // Creating the root
        XMLOutputIndex.DocumentElement := XMLOutputIndex.CreateNode('TextCorrectorDatabaseIndex');

        // adding the file info
(*        InfoNode := XMLOutputIndex.DocumentElement.AddChild('Information');
        Node := InfoNode.AddChild('GameVersion');
        Node.NodeValue := GameVersionToCodeStr(GAME_VERSION);
        Node := InfoNode.AddChild('BaseFileName');
        Node.NodeValue := BASE_FILENAME;
*)
        Node := XMLOutputIndex.DocumentElement.AddChild('GameVersion');
        Node.NodeValue := GameVersionToCodeStr(GAME_VERSION);

        ContainerDiscsRootNode := XMLOutputIndex.DocumentElement.AddChild('Discs');
        ContainerDiscsRootNode.Attributes['Count'] := '1';

        DiscRootNode := ContainerDiscsRootNode.AddChild('Disc');
        DiscRootNode.Attributes['Number'] := DiscNumber;
      end else begin
        XMLOutputIndex.LoadFromFile(OUTPUT_FILE);

        ContainerDiscsRootNode := XMLOutputIndex.DocumentElement.ChildNodes.FindNode('Discs');
        if not Assigned(ContainerDiscsRootNode) then
          ContainerDiscsRootNode := XMLOutputIndex.DocumentElement.AddChild('Discs');

        for i := 1 to ContainerDiscsRootNode.Attributes['Count'] do begin
          DiscRootNode := ContainerDiscsRootNode.ChildNodes.FindNode('Disc');
          DiscNumberRead := DiscRootNode.Attributes['Number'];
          if DiscNumberRead = DiscNumber then
            Break
          else
            DiscRootNode := nil;
        end;

        if not Assigned(DiscRootNode) then begin
          DiscRootNode := ContainerDiscsRootNode.AddChild('Disc');
          DiscRootNode.Attributes['Number'] := DiscNumber;
          ContainerDiscsRootNode.Attributes['Count'] := Integer(ContainerDiscsRootNode.Attributes['Count']) + 1;
        end;
      end;

      // lire les XML
      for i := 1 to MaxDatabaseFiles do begin
        XMLFileName := WORK_DIRECTORY + BASE_FILENAME + '_disc'
          + IntToStr(DiscNumber) + '_' + IntToStr(i) + '.tcd';

        if not FileExists(XMLFileName) then
          Continue;
          
        XMLInput.LoadFromFile(XMLFileName);

        // c'est bon
        if XMLInput.DocumentElement.NodeName = 'TextCorrectorDatabase' then begin
          InputFileNamesNode := XMLInput.DocumentElement.ChildNodes.FindNode('FileNames');

          for j := 0 to InputFileNamesNode.Attributes['Count'] - 1 do begin

            InputFileEntry := InputFileNamesNode.ChildNodes[j].NodeName;

            Node := DiscRootNode.ChildNodes.FindNode(InputFileEntry);
            if not Assigned(Node) then
              Node := DiscRootNode.AddChild(InputFileEntry);
            Node.Attributes['i'] := i;
          end;

        end;

      end;

      XMLOutputIndex.SaveToFile(OUTPUT_FILE);
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;

  finally
    XMLOutputIndex.Active := False;
    XMLOutputIndex := nil;
  end;

end.
