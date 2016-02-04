program datasgen;

{$APPTYPE CONSOLE}

// Don't forget to undef DEBUG_SCNFEDITOR in scnfedit.pas

{$R 'lzmabin.res' 'lzmabin.rc'}

uses
  Windows,
  SysUtils,
  XMLDom,
  XMLIntf,
  MSXMLDom,
  XMLDoc,
  ActiveX,
  charslst in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\charslst.pas',
  common in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\common.pas',
  scnfutil in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\scnfutil.pas',
  npcinfo in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\npc\npcinfo.pas',
  charscnt in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\charscnt.pas',
  systools in '..\..\..\..\Common\systools.pas',
  scnfedit in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\scnfedit.pas',
  srfnpcdb in '..\..\..\..\Packages\Free Quest Subtitles Editor\src\engine\srfnpcdb.pas',
  hashidx in '..\..\..\..\Common\hashidx.pas',
  lzmadec in '..\..\..\..\Common\lzmadec.pas';

const
  OUTPUT_FILE_EXT = '.dbi';
  MAX_DATABASE_FILES = 256;
  
var
  DBINumEntries, FilesCount, FileIndex: Integer;
  Filter, DiscNumber: string;
  SCNFEditor: TSCNFEditor;
  SR: TSearchRec;
  PrgName, PKSDirectory, TCDOutputFile, FoundFile, DBIOutputFile,
  DBIOutputDirectory: TFileName;
  TCD_XMLDoc, DBI_XMLDoc: IXMLDocument;
  InfoNode, Node,
  FileNamesRootNode,
  ContainerDiscsRootNode: IXMLNode;
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
  Key: string;
  i: Integer;
  Node, FileNode,
  SubtitleNode: IXMLNode;

begin
  try
    Key := SCNFEditor.VoiceShortID + '_' + SCNFEditor.CharacterID;
    Node := FileNamesRootNode.ChildNodes.FindNode(Key);

    if not Assigned(Node) then begin      
      FileNode := FileNamesRootNode.AddChild(Key);

      // Disque number
  //    Node := FileNode.AddChild('DiscNumber');
  //    Node.NodeValue := DiscNumber;

      // Subtitles
      Node := FileNode.AddChild('Subtitles');
      Node.Attributes['Count'] := SCNFEditor.Subtitles.Count;
      for i := 0 to SCNFEditor.Subtitles.Count - 1 do
      begin
        SubtitleNode := TCD_XMLDoc.CreateNode('Subtitle');
        SubtitleNode.Attributes['Code'] := SCNFEditor.Subtitles[i].Code;
        SubtitleNode.NodeValue := SCNFEditor.Subtitles[i].RawText;
        Node.ChildNodes.Add(SubtitleNode);
      end;
    end else begin
      // la node existe déjà. 
      WriteLn('Key "', Key, '" already in database'); (*(entry count = ',
        Node.ChildNodes.FindNode('Subtitles').Attributes['Count'], ', new entry count = ',
        SCNFEditor.Subtitles.Count
      );*)
    end;

  except
    on E:Exception do
      WriteLn('AddEntryToDatabase: Exception - ', E.Message);
  end;
end;

//------------------------------------------------------------------------------

function UpdateDBI: Boolean;
var
  Key: string;
  
begin
  Result := False;
  Key := SCNFEditor.VoiceShortID + '_' + SCNFEditor.CharacterID;

  Node := ContainerDiscsRootNode.ChildNodes.FindNode(Key); // search for the key in DBI
  if not Assigned(Node) then begin // add the new key to the database
    Inc(DBINumEntries);  
    Node := ContainerDiscsRootNode.AddChild(Key);
    Node.Attributes['i'] := FileIndex;
    Node.Attributes['d'] := DiscNumber;
    Result := True;

    WriteLn('ACCEPT: "' + Key + '" (i = ', FileIndex, ', d = ', DiscNumber, ')');
  end else
    WriteLn('REJECT: "' + Key + '" (i = ', Node.Attributes['i'], ', d = ', Node.Attributes['d'], ')');
end;

//------------------------------------------------------------------------------

procedure InitParameters;
begin
  try
    PKSDirectory := IncludeTrailingPathDelimiter(ParamStr(1));
    Filter := ParamStr(2);
    TCDOutputFile := ParamStr(3);
    FileIndex := StrToInt(ExtractFileName(ChangeFileExt(TCDOutputFile, '')));
    DBIOutputDirectory := IncludeTrailingPathDelimiter(ParamStr(4));
    DiscNumber := ParamStr(5);
    GameVersion := StrToGameVersion(ParamStr(6));
    if GameVersion = gvUndef then
      raise Exception.Create('INVALID VERSION');
  except
    WriteLn('Invalid parameters!');
    Exit;
  end;
end;

//------------------------------------------------------------------------------

procedure InitDBI;
begin
  DBINumEntries := 0;
  
  with DBI_XMLDoc do begin
    Options := [doNodeAutoCreate, doAttrNull];
    ParseOptions:= [];
    Active := True;
    Version := '1.0';
    Encoding := 'utf-8'; //'ISO-8859-1';
  end;

  DBIOutputFile := DBIOutputDirectory + LowerCase(GameVersionToCodeStr(GameVersion))
    + OUTPUT_FILE_EXT;

  // Loading the DBIOutputFile
  if not FileExists(DBIOutputFile) then begin
    // Creating the root
    DBI_XMLDoc.DocumentElement := DBI_XMLDoc.CreateNode('TextCorrectorDatabaseIndex');

    Node := DBI_XMLDoc.DocumentElement.AddChild('GameVersion');
    Node.NodeValue := GameVersionToCodeStr(GameVersion);

    ContainerDiscsRootNode := DBI_XMLDoc.DocumentElement.AddChild('Entries');
    ContainerDiscsRootNode.Attributes['Count'] := 0;
  end else begin
    DBI_XMLDoc.LoadFromFile(DBIOutputFile);

    ContainerDiscsRootNode := DBI_XMLDoc.DocumentElement.ChildNodes.FindNode('Entries');
    if not Assigned(ContainerDiscsRootNode) then
      ContainerDiscsRootNode := DBI_XMLDoc.DocumentElement.AddChild('Entries');
  end;
end;

//------------------------------------------------------------------------------

procedure ShowHelp;
begin
  WriteLn('Shenmue Corrector Data Generator - INTERNAL TOOL', sLineBreak,
        sLineBreak,
        'Usage: ', sLineBreak,
        '       ', PrgName, ' <PKS_Folder> <Filter> <OutputFile> <DBI_Folder> <DiscNumber> <GameVersion>', sLineBreak,
        sLineBreak,
        'Where: ', sLineBreak,
        '       <PKS_Folder>  : The target directory which contains PKS files', sLineBreak,
        '       <Filter>      : The filter for searching files (ie "*.*")', sLineBreak,
        '       <OutputFile>  : The output TCD file, MUST BE A NUMBER', sLineBreak,
        '       <DBI_Folder>  : The target directory where to store the output DBI', sLineBreak,
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
        '       ', PrgName, ' .\db_root\disc1\ *.* 1.tcd .\db_root\ 1 dc_pal_s2'
  );
  ExitCode := 1;
end;

//------------------------------------------------------------------------------

procedure InitTCD;
begin
  try
  
    // initialization for the XML file
    with TCD_XMLDoc do begin
      Options := [doNodeAutoCreate, doAttrNull];
      ParseOptions:= [];
      NodeIndentStr:= '  ';
      Active := True;
      Version := '1.0';
      Encoding := 'utf-8'; //'ISO-8859-1';
    end;

    // Starting to open PKS files and generate TCD files
    FilesCount := 0;
    if not FileExists(TCDOutputFile) then begin
      // Creating the root
      TCD_XMLDoc.DocumentElement := TCD_XMLDoc.CreateNode('TextCorrectorDatabase');

      // adding the file info
      InfoNode := TCD_XMLDoc.DocumentElement.AddChild('Information');
      Node := InfoNode.AddChild('GameVersion');
      Node.NodeValue := GameVersionToCodeStr(GameVersion);
      Node := InfoNode.AddChild('DiscNumber');
      Node.NodeValue := DiscNumber;

      // creating the filenames entries root
      FileNamesRootNode := TCD_XMLDoc.DocumentElement.AddChild('FileNames');
      FileNamesRootNode.Attributes['Count'] := 0;      
    end else begin
      TCD_XMLDoc.LoadFromFile(TCDOutputFile);
      FileNamesRootNode := TCD_XMLDoc.DocumentElement.ChildNodes.FindNode('FileNames');
      if not Assigned(FileNamesRootNode) then
        FileNamesRootNode := TCD_XMLDoc.DocumentElement.AddChild('FileNames')
      else
        FilesCount := FileNamesRootNode.Attributes['Count'];
    end;

  except
    on E:Exception do WriteLn('EXCEPTION InitTCD: "' + E.Message + '".');
  end;
end;

//------------------------------------------------------------------------------

begin
  ReportMemoryLeaksOnShutDown := True;

  PrgName := ExtractFileName(ChangeFileExt(ParamStr(0), ''));
  if ParamCount < 5 then begin
    ShowHelp;
    Exit;
  end;

  InitParameters;

  CoInitialize(nil);    
  TCD_XMLDoc := TXMLDocument.Create(nil);
  DBI_XMLDoc := TXMLDocument.Create(nil);
  SCNFEditor := TSCNFEditor.Create;
  try
    try
      InitTCD;

      InitDBI;

      // Searching the selected directory
      if FindFirst(PKSDirectory + Filter, faAnyFile, SR) = 0 then
      begin
        repeat
          FoundFile := PKSDirectory + SR.Name;

          SCNFEditor.LoadFromFile(FoundFile);

          // this is a valid file
          if SCNFEditor.FileLoaded then begin
            if UpdateDBI then begin // this entry wasn't in the DBI file so must add it
              AddEntryToDatabase;
              Inc(FilesCount);
            end;
          end;

        until FindNext(SR) <> 0;
        FindClose(SR);
      end;

      FileNamesRootNode.Attributes['Count'] :=
        Integer(FileNamesRootNode.Attributes['Count']) + FilesCount;
      ContainerDiscsRootNode.Attributes['Count'] :=
        Integer(ContainerDiscsRootNode.Attributes['Count']) + DBINumEntries;

      // Saving the file
      TCD_XMLDoc.SaveToFile(TCDOutputFile);
      DBI_XMLDoc.SaveToFile(DBIOutputFile);
    except
      on E:Exception do
        Writeln('MAIN EXCEPTION: ', FoundFile, ': ', E.Message);
    end;

  finally
    SCNFEditor.Free;
    TCD_XMLDoc.Active := False;
    TCD_XMLDoc := nil;
    DBI_XMLDoc.Active := False;
    DBI_XMLDoc := nil;
  end;
end.
