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
  OUTPUT_FILE_EXT = '.dbi';
  MAX_DATABASE_FILES = 256;
  
var
  XMLOutputIndex, XMLInput: IXMLDocument;
  InfoNode, Node,
  ContainerDiscsRootNode,
  InputFileNamesNode: IXMLNode;
  i, j,
  DiscNumber, NumFiles: Integer;
  InputFileEntry: string;
  WorkDirectory, XMLFileName, DBIOutputFile: TFileName;
  GameVersion: TGameVersion;

begin
   WRITELN('THIS PROGRAM IS OUTDATED. PLEASE USE THE DATASGEN PROGRAM ONLY INSTEAD.');
   READLN;
   EXIT;
   
  if ParamCount < 3 then begin
    WriteLn('Usage: makeidx <Directory> <GameVersion> <DiscNumber>');
    Exit;
  end;

  try
    WorkDirectory := IncludeTrailingPathDelimiter(ParamStr(1));
    GameVersion := StrToGameVersion(ParamStr(2));
    if GameVersion = gvUndef then raise Exception.Create('INVALID VERSION');    
    DiscNumber := StrToInt(ParamStr(3));
  except
    WriteLn('Invalid parameters');
    Exit;
  end;

  DBIOutputFile := WorkDirectory + LowerCase(GameVersionToCodeStr(GameVersion))
    + OUTPUT_FILE_EXT;

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

      if not FileExists(DBIOutputFile) then begin
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
        Node.NodeValue := GameVersionToCodeStr(GameVersion);

(*        ContainerDiscsRootNode := XMLOutputIndex.DocumentElement.AddChild('Discs');
        ContainerDiscsRootNode.Attributes['Count'] := '1';

        DiscRootNode := ContainerDiscsRootNode.AddChild('Disc');
        DiscRootNode.Attributes['Number'] := DiscNumber; *)

        ContainerDiscsRootNode := XMLOutputIndex.DocumentElement.AddChild('Entries');
        ContainerDiscsRootNode.Attributes['Count'] := 0;
      end else begin
        XMLOutputIndex.LoadFromFile(DBIOutputFile);

(*        ContainerDiscsRootNode := XMLOutputIndex.DocumentElement.ChildNodes.FindNode('Discs');
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
*)

        ContainerDiscsRootNode := XMLOutputIndex.DocumentElement.ChildNodes.FindNode('Entries');
        if not Assigned(ContainerDiscsRootNode) then
          ContainerDiscsRootNode := XMLOutputIndex.DocumentElement.AddChild('Entries');
      end;

      NumFiles := 0;
      
      // lire les XML
      for i := 1 to MAX_DATABASE_FILES do begin
        (*XMLFileName := WORK_DIRECTORY + BASE_FILENAME + '_disc'
          + IntToStr(DiscNumber) + '_' + IntToStr(i) + '.tcd';*)
        XMLFileName := WorkDirectory + IntToStr(i) + '.tcd';

        if not FileExists(XMLFileName) then
          Continue;
          
        XMLInput.LoadFromFile(XMLFileName);
        
        // c'est bon
        if XMLInput.DocumentElement.NodeName = 'TextCorrectorDatabase' then begin
          InputFileNamesNode := XMLInput.DocumentElement.ChildNodes.FindNode('FileNames');

          for j := 0 to InputFileNamesNode.Attributes['Count'] - 1 do begin

            InputFileEntry := InputFileNamesNode.ChildNodes[j].NodeName;

            Node := ContainerDiscsRootNode.ChildNodes.FindNode(InputFileEntry);
            if not Assigned(Node) then
              Node := ContainerDiscsRootNode.AddChild(InputFileEntry);
            Node.Attributes['i'] := i;
            Node.Attributes['d'] := DiscNumber;
            Inc(NumFiles);

            writeln(InputFileEntry, ';', Node.Attributes['i'], ';', Node.Attributes['d']);
          end;

        end;

      end;

      ContainerDiscsRootNode.Attributes['Count'] := Integer(ContainerDiscsRootNode.Attributes['Count']) + NumFiles;

      XMLOutputIndex.SaveToFile(DBIOutputFile);
    except
      on E:Exception do
        Writeln(E.Classname, ': ', E.Message);
    end;

  finally
    XMLOutputIndex.Active := False;
    XMLOutputIndex := nil;
  end;

end.
