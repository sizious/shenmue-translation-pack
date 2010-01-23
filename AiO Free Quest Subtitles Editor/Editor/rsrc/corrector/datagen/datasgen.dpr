program datasgen;

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

var
  FilesCount: Integer;
  Filter, DiscNumber: string;
  SCNFEditor: TSCNFEditor;
  SR: TSearchRec;
  PrgName, Directory, OutputFile,
  FoundFile: TFileName;
  XMLDoc: IXMLDocument;
  InfoNode, Node,
  FileNamesRootNode: IXMLNode;
  GameVersion: TGameVersion;

//------------------------------------------------------------------------------

(*function GetGameVersionRootNode(GameVersion: TGameVersion): IXMLNode;
var
  sVersion: string;

begin
  sVersion := GameVersionToCodeStr(GameVersion);
  Result := XMLDoc.DocumentElement.ChildNodes.FindNode(sVersion);
  if not Assigned(Result) then
    Result := XMLDoc.DocumentElement.AddChild(sVersion);
end;*)

//------------------------------------------------------------------------------

procedure AddEntryToDatabase;
var
  i: Integer;
  FileNode,
  SubtitleNode: IXMLNode;

begin
  try
    FileNode := FileNamesRootNode.AddChild(SCNFEditor.VoiceShortID + '_' + SCNFEditor.CharacterID);

    // Disque number
//    Node := FileNode.AddChild('DiscNumber');
//    Node.NodeValue := DiscNumber;

    // Subtitles
    Node := FileNode.AddChild('Subtitles');
    Node.Attributes['Count'] := SCNFEditor.Subtitles.Count;
    for i := 0 to SCNFEditor.Subtitles.Count - 1 do
    begin
      SubtitleNode := XMLDoc.CreateNode('Subtitle');
      SubtitleNode.Attributes['Code'] := SCNFEditor.Subtitles[i].Code;
      SubtitleNode.NodeValue := SCNFEditor.Subtitles[i].RawText;
      Node.ChildNodes.Add(SubtitleNode);
    end;

  except
    on E:Exception do
      WriteLn('AddEntryToDatabase: Exception - ', E.Message);
  end;
end;

//------------------------------------------------------------------------------

begin
  ReportMemoryLeaksOnShutDown := True;
  CoInitialize(nil);

  PrgName := ExtractFileName(ChangeFileExt(ParamStr(0), ''));
  if ParamCount < 5 then begin
    WriteLn('Shenmue Corrector Data Generator - INTERNAL TOOL', sLineBreak,
            sLineBreak,
            'Usage: ', sLineBreak,
            '       ', PrgName, ' <Folder> <Filter> <OutputFile.xml> <DiscNumber> <GameVersion>', sLineBreak,
            sLineBreak,
            'Where: ', sLineBreak,
            '       <Folder>      : The target directory', sLineBreak,
            '       <Filter>      : The filter for searching files (ie "*.*")', sLineBreak,
            '       <OutputFile>  : The output XML file', sLineBreak,
            '       <DiscNumber>  : The disc number of the folder (ie "1")', sLineBreak,
            '       <GameVersion> : The game version of the folder (see below)', sLineBreak,
            sLineBreak,
            'Game Version values:', sLineBreak,
            '       dc_jap_wh     : What''s Shenmue (JAP) (Dreamcast)', sLineBreak,
            '       dc_jap_s1     : Shenmue 1 (JAP) (Dreamcast)', sLineBreak,
            '       dc_pal_s1     : Shenmue 1 (PAL) (Dreamcast)', sLineBreak,
            '       dc_jap_s2     : Shenmue 2 (JAP) (Dreamcast)', sLineBreak,
            '       dc_pal_s2     : Shenmue 2 (PAL) (Dreamcast)', sLineBreak,
            '       xb_pal_s2     : Shenmue 2 (PAL) (Xbox)', sLineBreak,
            sLineBreak,
            'Example:', sLineBreak,
            '       ', PrgName, ' .\ *.* output.xml 1 dc_pal_s2'
    );
    ExitCode := 1;
    Exit;
  end;

  Directory := IncludeTrailingPathDelimiter(ParamStr(1));
  Filter := ParamStr(2);
  OutputFile := ParamStr(3);
  DiscNumber := ParamStr(4);
  GameVersion := StrToGameVersion(ParamStr(5));

  XMLDoc := TXMLDocument.Create(nil);
  SCNFEditor := TSCNFEditor.Create;
  try
    try
      // initialization for the XML file
      with XMLDoc do begin
        Options := [doNodeAutoCreate, doAttrNull];
        ParseOptions:= [];
        NodeIndentStr:= '  ';
        Active := True;
        Version := '1.0';
        Encoding := 'utf-8'; //'ISO-8859-1';
      end;

      FilesCount := 0;
      if not FileExists(OutputFile) then begin
        // Creating the root
        XMLDoc.DocumentElement := XMLDoc.CreateNode('TextCorrectorDatabase');

        // adding the file info
        InfoNode := XMLDoc.DocumentElement.AddChild('Information');
        Node := InfoNode.AddChild('GameVersion');
        Node.NodeValue := GameVersionToCodeStr(GameVersion);
        Node := InfoNode.AddChild('DiscNumber');
        Node.NodeValue := DiscNumber;

        // creating the filenames entries root
        FileNamesRootNode := XMLDoc.DocumentElement.AddChild('FileNames');
      end else begin
        XMLDoc.LoadFromFile(OutputFile);
        FileNamesRootNode := XMLDoc.DocumentElement.ChildNodes.FindNode('FileNames');
        if not Assigned(FileNamesRootNode) then
          FileNamesRootNode := XMLDoc.DocumentElement.AddChild('FileNames')
        else
          FilesCount := FileNamesRootNode.Attributes['Count'];
      end;

      // Searching the selected directory
      if FindFirst(Directory + Filter, faAnyFile, SR) = 0 then
      begin
        repeat
          FoundFile := Directory + SR.Name;

          SCNFEditor.LoadFromFile(FoundFile);

          // this is a valid file
          if SCNFEditor.FileLoaded then begin
            AddEntryToDatabase;
            Inc(FilesCount);
          end;

        until FindNext(SR) <> 0;
        FindClose(SR);
      end;

      FileNamesRootNode.Attributes['Count'] := FilesCount;

      // Saving the file
      XMLDoc.SaveToFile(OutputFile);
    except
      on E:Exception do
        Writeln(FoundFile, ': ', E.Message);
    end;

  finally
    SCNFEditor.Free;
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end.
