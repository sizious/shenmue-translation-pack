program hashdb;

{$APPTYPE CONSOLE}

// Don't forget to undef DEBUG_SCNFEDITOR in scnfedit.pas

uses
  Windows,
  SysUtils,
  Classes,
  XMLDom,
  XMLIntf,
  MSXMLDom,
  XMLDoc,
  ActiveX,
  filespec in '..\..\..\..\Common\filespec.pas',
  systools in '..\..\..\..\Common\systools.pas',
  srfedit in '..\..\..\..\AiO Cinematics Subtitles Editor\src\engine\srfedit.pas',
  MD5Core in '..\..\..\..\Common\MD5\MD5Core.pas',
  MD5Api in '..\..\..\..\Common\MD5\MD5Api.pas',
  chrcodec in '..\..\..\..\Common\SubsUtil\chrcodec.pas',
  hashidx in '..\..\..\..\Common\hashidx.pas';

var
  DBINumEntries, FilesCount, FileIndex: Integer;
  AFSFileName, Filter, DiscNumber: string;
  SRFEditor: TSRFEditor;
  SR: TSearchRec;
  PrgName, PKSDirectory, TCDOutputFile, FoundFile, DBIOutputFile: TFileName;
  DBI_XMLDoc: IXMLDocument;
  InfoNode, Node,
  FileNamesRootNode,
  ContainerDiscsRootNode: IXMLNode;

  GameVersion: TGameVersion;
  Region: TGameRegion;
  PlatformVersion: TPlatformVersion;

  SL: TStringList;

//------------------------------------------------------------------------------

function UpdateDBI: Boolean;
var
  sRegion, Key, SameMD5, SRFName, AFSName: string;
  i: Integer;
  
begin
  Result := False;
  Key := SRFEditor.HashKey;

  sRegion := LowerCase(GameRegionToCodeString(Region)[1]);
  SRFName := ExtractFileName(ChangeFileExt(SRFEditor.SourceFileName, ''));
  AFSName := ExtremeRight('\', AFSFileName);

  Node := ContainerDiscsRootNode.ChildNodes.FindNode(Key); // search for the key in DBI
  if not Assigned(Node) then begin // add the new key to the database
    Inc(DBINumEntries);  
    Node := ContainerDiscsRootNode.AddChild(Key);
    Result := True;

//    for i := 1 to 4 do
//      Node.Attributes['d' + IntToStr(i)] := False;
//    Node.Attributes['j'] := false;
//    Node.Attributes['u'] := false;
//    Node.Attributes['e'] := false;
//    Node.Attributes['NAME'] := SRFName;
//    Node.Attributes['AFS'] := AFSName;
//    Node.NodeValue := MD5FromFile(SRFEditor.SourceFileName);

//    WriteLn('ACCEPT: "' + Key + '" (i = ', FileIndex, ', d = ', DiscNumber, ')');
  end else begin
    WriteLn('**************** REJECT ' + KEY);
    SameMD5 := '';
    
    if Node.NodeValue <> MD5FromFile(SRFEditor.SourceFileName) then
      SameMD5 := '_MD5_';

    if Node.Attributes['NAME'] <> SRFName then
      SameMD5 := SameMD5 + '_NAME_';

    if Node.Attributes['AFS'] <> AFSName then
      SameMD5 := SameMD5 + '_AFS_';

    if SameMD5 = '' then SameMD5 := 'OK';

    SL.Add(KEY + ';' + SRFEditor.SourceFileName + ';' + DiscNumber + ';' + SameMD5);
  end;

//  Node.Attributes['v'] := GameVersionToCodeString(GameVersion);
  Node.Attributes['s'] := PlatformVersionToCodeString(PlatformVersion);
//  Node.Attributes['d' + DiscNumber] := True;
//  Node.Attributes[sRegion] := True;
//  Node.Attributes['n' + DiscNumber] := SRFName;
//  Node.Attributes['a' + DiscNumber] := AFSName;

//    WriteLn('REJECT: "' + Key);
end;

//------------------------------------------------------------------------------

procedure InitParameters;

  procedure DetermineGameInformation(Param: string);
  begin
    // game version
    GameVersion := gvUndef;
    if IsInString('s1', param) then
      GameVersion := gvShenmue
    else if IsInString('wh', param) then
      GameVersion := gvWhatsShenmue // incorrect..
    else if IsInString('s2', param) then
      GameVersion := gvShenmue2
    else if IsInString('us', param) then
      GameVersion := gvUSShenmue;

    // game region
    Region := prUndef;
    if IsInString('jap', param) then
      Region := prJapan
    else if IsInString('eur', param) then
      Region := prEurope
    else if IsInString('usa', param) then
      Region := prUSA;

    // platform version
    PlatformVersion := pvUndef;
    if IsInString('dc', param) then
      PlatformVersion := pvDreamcast
    else if IsInString('xb', param) then
      PlatformVersion := pvXbox;         
  end;

begin
  // <PKS_Folder> <Filter> <OutputFile> <DBI_Folder> <DiscNumber> <GameVersion>
  try
    PKSDirectory := IncludeTrailingPathDelimiter(ParamStr(1));
    Filter := ParamStr(2);
//    TCDOutputFile := ParamStr(3);
//    FileIndex := StrToInt(ExtractFileName(ChangeFileExt(TCDOutputFile, '')));
    DBIOutputFile := ParamStr(3);
    DiscNumber := ParamStr(4);
    DetermineGameInformation(paramstr(5));
    AFSFileName := ParamStr(6);
  except
    WriteLn('Invalid parameters!');
    Exit;
  end;
end;

//------------------------------------------------------------------------------

procedure InitDBI;
var
  HeaderNode: IXMLNode;
  
begin
  DBINumEntries := 0;
  
  with DBI_XMLDoc do begin
    Options := [doNodeAutoCreate, doAttrNull];
    ParseOptions:= [];
    Active := True;
    Version := '1.0';
    Encoding := 'utf-8'; //'ISO-8859-1';
  end;

  // Loading the DBIOutputFile
  if not FileExists(DBIOutputFile) then begin
    // Creating the root
    DBI_XMLDoc.DocumentElement := DBI_XMLDoc.CreateNode('CinematicsDatabase');

    ContainerDiscsRootNode := DBI_XMLDoc.DocumentElement.AddChild('Entries');
    FilesCount := 0;
    ContainerDiscsRootNode.Attributes['Count'] := FilesCount;
  end else begin
    DBI_XMLDoc.LoadFromFile(DBIOutputFile);

    ContainerDiscsRootNode := DBI_XMLDoc.DocumentElement.ChildNodes.FindNode('Entries');
    if not Assigned(ContainerDiscsRootNode) then
      ContainerDiscsRootNode := DBI_XMLDoc.DocumentElement.AddChild('Entries')
    else
      FilesCount := ContainerDiscsRootNode.Attributes['Count'];
  end;
end;

//------------------------------------------------------------------------------
{
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
        '       whats         : What''s Shenmue JAP DC', sLineBreak,
        '       s1_dc_jap     : Shenmue 1 JAP DC', sLineBreak,
        '       s1_dc_eur     : Shenmue 1 PAL DC', sLineBreak,
        '       s2_dc_jap     : Shenmue 2 JAP DC', sLineBreak,
        '       s2_dc_eur     : Shenmue 2 PAL DC', sLineBreak,
        '       s2_xb_eur     : Shenmue 2X PAL Xbox', sLineBreak,
        sLineBreak,
        'Example:', sLineBreak,
        '       ', PrgName, ' .\db_root\disc1\ *.* 1.tcd .\db_root\ 1 s1_dc_eur'
  );
  ExitCode := 1;
end;
}
//------------------------------------------------------------------------------

begin
  ReportMemoryLeaksOnShutDown := True;

  PrgName := ExtractFileName(ChangeFileExt(ParamStr(0), ''));
  if ParamCount < 6 then begin
//    ShowHelp;
    Exit;
  end;

  InitParameters;

  SL := TStringList.Create;

  CoInitialize(nil);
  DBI_XMLDoc := TXMLDocument.Create(nil);
  SRFEditor := TSRFEditor.Create;
  try
    try
      if FileExists('REJECT.LOG') then
        SL.LoadFromFile('REJECT.LOG');
        
//      InitTCD;                                  

      InitDBI;

      // Searching the selected directory
      if FindFirst(PKSDirectory + Filter, faAnyFile, SR) = 0 then
      begin
        repeat
          FoundFile := PKSDirectory + SR.Name;
          WriteLn('*** LOADING: ', FoundFile);

          SRFEditor.LoadFromFile(FoundFile);

          // this is a valid file
          if SRFEditor.Loaded and UpdateDBI then
              Inc(FilesCount);

        until FindNext(SR) <> 0;
        FindClose(SR);
      end;

//      ContainerDiscsRootNode.Attributes['Count'] :=
//        Integer(ContainerDiscsRootNode.Attributes['Count']) + DBINumEntries;

      // Saving the file
      DBI_XMLDoc.SaveToFile(DBIOutputFile);
      SL.SaveToFile('REJECT.LOG');
    except
      on E:Exception do
        Writeln('MAIN EXCEPTION: ', FoundFile, ': ', E.Message);
    end;

  finally
    SL.Free;
    SRFEditor.Free;
    DBI_XMLDoc.Active := False;
    DBI_XMLDoc := nil;
  end;
end.
