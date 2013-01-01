{
  Some standard common utilities functions...
}
unit utils;

interface

uses
  Windows, SysUtils;

function GetConfigFileName: TFileName;
function GetPreviousSelectedPathFileName: TFileName;
function GetWorkingTempDirectory: TFileName;
procedure SaveConfig;
function LoadConfig: Boolean;



//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants, Main, Warning,
  SysTools;

const
  WORKING_TEMP_DIR = 'FQEditor';

var
  ConfigFileName: TFileName;
  PreviousSelectedPathFileName: TFileName;
  sWorkingTempDirectory: TFileName;

//------------------------------------------------------------------------------

procedure InitWorkingDirectory;
begin
  sWorkingTempDirectory := GetTempDir + WORKING_TEMP_DIR + '\';
  if not DirectoryExists(sWorkingTempDirectory) then
    ForceDirectories(sWorkingTempDirectory);
end;

//------------------------------------------------------------------------------

procedure DeleteWorkingTempDirectory;
begin
  if DirectoryExists(sWorkingTempDirectory) then
    DeleteDirectory(sWorkingTempDirectory);
end;
  
//------------------------------------------------------------------------------

function GetWorkingTempDirectory: TFileName;
begin
  if sWorkingTempDirectory = '' then
    InitWorkingDirectory;
  Result := sWorkingTempDirectory; 
end;

//------------------------------------------------------------------------------

function GetPreviousSelectedPathFileName: TFileName;
begin
  Result := PreviousSelectedPathFileName;
end;

//------------------------------------------------------------------------------

function GetConfigFileName: TFileName;
begin
  Result := ConfigFileName;
end;

//------------------------------------------------------------------------------

procedure SaveConfig;
var
  XMLDoc: IXMLDocument;

  CurrentNode: IXMLNode;
  procedure WriteXMLNode(var XML: IXMLDocument; const Key, Value: string); overload;
  begin
    CurrentNode := XML.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XML.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure WriteXMLNode(var XML: IXMLDocument; const Key: string; const Value: Integer); overload;
  begin
    CurrentNode := XML.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XML.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure WriteXMLNode(var XML: IXMLDocument; const Key: string; const Value: Boolean); overload;
  begin
    CurrentNode := XML.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XML.DocumentElement.ChildNodes.Add(CurrentNode);
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
      Encoding := 'ISO-8859-1';
    end;

    XMLDoc.DocumentElement := XMLDoc.CreateNode('freequestcfg'); // On crée la racine

    WriteXMLNode(XMLDoc, 'autosave', frmMain.AutoSave);
    WriteXMLNode(XMLDoc, 'directory', frmMain.SelectedDirectory);
    WriteXMLNode(XMLDoc, 'decodesubs', frmMain.EnableCharsMod);
    WriteXMLNode(XMLDoc, 'makebackup', frmMain.MakeBackup);
(*    WriteXMLNode(XMLDoc, 'multitranslate', frmMain.MultiTranslation.Active);*)
    WriteXMLNode(XMLDoc, 'rescandirstartup', frmMain.ReloadDirectoryAtStartup);
    WriteXMLNode(XMLDoc, 'originalsubs', frmMain.EnableOriginalSubtitlesFieldView);
    WriteXMLNode(XMLDoc, 'warningdisplayed', IsWarningUnderstood);
    WriteXMLNode(XMLDoc, 'originalsubscol', frmMain.EnableOriginalSubtitlesColumnView);

    XMLDoc.SaveToFile(ConfigFileName);
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

//------------------------------------------------------------------------------

function LoadConfig: Boolean;
var
  XMLDoc: IXMLDocument;
  Node: IXMLNode;

  function ReadXMLNodeString(var XML: IXMLDocument; const Key: string): string;
  begin
    Result := '';
    try
      Node := XML.DocumentElement.ChildNodes.FindNode(Key);
      if Assigned(Node) then
        if not VarIsNull(Node.NodeValue) then
          Result := Node.NodeValue;
    except
    end;
  end;

  function ReadXMLNodeBoolean(var XML: IXMLDocument; const Key: string): Boolean;
  var
    V: string;

  begin
    V := LowerCase(ReadXMLNodeString(XML, Key));
    Result := (V = 'true') or (V = '1');
  end;
  
begin
  Result := False;
  if not FileExists(ConfigFileName) then Exit;

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

    XMLDoc.LoadFromFile(ConfigFileName);

    if (XMLDoc.DocumentElement.NodeName <> 'freequestcfg') and
      (XMLDoc.DocumentElement.NodeName <> 's2freequestcfg') then Exit;

    // Reading config values
    with frmMain do begin
      AutoSave := ReadXMLNodeBoolean(XMLDoc, 'autosave');
      MakeBackup := ReadXMLNodeBoolean(XMLDoc, 'makebackup');
      EnableCharsMod := ReadXMLNodeBoolean(XMLDoc, 'decodesubs');
      SelectedDirectory := ReadXMLNodeString(XMLDoc, 'directory');
  (*    MultiTranslation.Active := ReadXMLNodeBoolean(XMLDoc, 'multitranslate');*)
      ReloadDirectoryAtStartup := ReadXMLNodeBoolean(XMLDoc, 'rescandirstartup');
      EnableOriginalSubtitlesFieldView := ReadXMLNodeBoolean(XMLDoc, 'originalsubs');
      EnableOriginalSubtitlesColumnView := ReadXMLNodeBoolean(XMLDoc, 'originalsubscol');
    end;

    Result := True;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

//------------------------------------------------------------------------------

initialization
  sWorkingTempDirectory := ''; // see GetWorkingTempDirectory
  ConfigFileName := GetApplicationDirectory + 'config.xml';
  PreviousSelectedPathFileName := GetApplicationDirectory + 'selpath.ini';

//------------------------------------------------------------------------------

finalization
  DeleteWorkingTempDirectory;

//------------------------------------------------------------------------------

end.
