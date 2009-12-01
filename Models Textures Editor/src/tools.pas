unit tools;

interface

uses
  Windows, SysUtils;

type
  TApplicationFileVersion = record
    Major,
    Minor,
    Release,
    Build: Integer;
  end;

function ExtremeRight(SubStr: string ; S: string): string;
function GetApplicationFileVersion: TApplicationFileVersion;
function LoadConfig: Boolean;
function Right(SubStr: string ; S: string): string;
procedure SaveConfig;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants, Main;

var
  AppDir,
  ConfigFileName: TFileName;

//------------------------------------------------------------------------------

procedure SaveConfig;
var
  XMLDoc: IXMLDocument;
  CurrentNode: IXMLNode;

  procedure WriteXMLNode(var XML: IXMLDocument; const Key, Value: string); overload;
  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure WriteXMLNode(var XML: IXMLDocument; const Key: string; const Value: Integer); overload;
  begin
    CurrentNode := XMLDoc.CreateNode(Key);
    CurrentNode.NodeValue := Value;
    XMLDoc.DocumentElement.ChildNodes.Add(CurrentNode);
  end;

  procedure WriteXMLNode(var XML: IXMLDocument; const Key: string; const Value: Boolean); overload;
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
      Encoding := 'ISO-8859-1';
    end;

    XMLDoc.DocumentElement := XMLDoc.CreateNode('mteditorcfg'); // On crée la racine

    WriteXMLNode(XMLDoc, 'autosave', frmMain.AutoSave);    
    WriteXMLNode(XMLDoc, 'directory', frmMain.SourceDirectory);
    WriteXMLNode(XMLDoc, 'makebackup', frmMain.MakeBackup);

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

  function ReadXMLNodeString(var XML: IXMLDocument; const Key: string; DefaultValue: string): string;
  begin
    Result := '';
    try
      Node := XMLDoc.DocumentElement.ChildNodes.FindNode(Key);
      if Assigned(Node) then
        if not VarIsNull(Node.NodeValue) then
          Result := Node.NodeValue;
    except
      Result := DefaultValue;
    end;
  end;

  function ReadXMLNodeBoolean(var XML: IXMLDocument; const Key: string; DefaultValue: Boolean): Boolean;
  const
    NOT_SET = '<#NOT_SET#>';

  var
    V: string;

  begin
    V := LowerCase(ReadXMLNodeString(XML, Key, NOT_SET));
    Result := (V = 'true') or (V = '1');
    if V = NOT_SET then
      Result := DefaultValue;
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

    if (XMLDoc.DocumentElement.NodeName <> 'mteditorcfg') then Exit;

    // Reading config values
    frmMain.AutoSave := ReadXMLNodeBoolean(XMLDoc, 'autosave', False);
    frmMain.SourceDirectory := ReadXMLNodeString(XMLDoc, 'directory', ExtractFilePath(ParamStr(0)));
    frmMain.MakeBackup := ReadXMLNodeBoolean(XMLDoc, 'makebackup', True);

    Result := True;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

//------------------------------------------------------------------------------
//
// Procédure de lecture du numéro de version de l'application
//    Par Nono40 et publiée sur nono40.developpez.com
//
// Si le numéro de version est trouvé, la réponse est du style '2.1.3.154'
// Si le numéro de version n'est pas trouvé, la réponse est ''
//
function GetApplicationFileVersion: TApplicationFileVersion;
const
  FRENCH_LANG_CODE = '040C04E4';
  
Var
  Chaine:String;
  i     :Integer;

  function _FileVersion(LanguageCode: string): string;
  Var
    S         : String;
    Taille    : DWord;
    Buffer    : PChar;
    VersionPC : PChar;
    VersionL  : DWord;

  Begin
    Result:='';
    {--- On demande la taille des informations sur l'application ---}
    S := ParamStr(0);
    Taille := GetFileVersionInfoSize(PChar(S), Taille);
    Buffer := nil;
    If Taille>0
    Then Try
    {--- Réservation en mémoire d'une zone de la taille voulue ---}
      Buffer := AllocMem(Taille);
    {--- Copie dans le buffer des informations ---}
      GetFileVersionInfo(PChar(S), 0, Taille, Buffer);
    {--- Recherche de l'information de version ---}
      If VerQueryValue(Buffer, PChar('\StringFileInfo\' + LanguageCode
        + '\FileVersion'), Pointer(VersionPC), VersionL) Then
          Result:=VersionPC;
    Finally
      FreeMem(Buffer, Taille);
    End;
  end;

begin
  Chaine := _FileVersion(FRENCH_LANG_CODE);

  Result.Major := -1;
  Result.Minor := -1;
  Result.Release := -1;
  Result.Build := -1;

  If Chaine <> '' then Begin
    i:=Pos('.',Chaine);
    If i>1
    Then Begin
      Result.Major:=StrToIntDef(Copy(Chaine,1,i-1), -1);
      Chaine:=Copy(Chaine,i+1,Length(Chaine)-i);
      i:=Pos('.',Chaine);
      If i>1
      Then Begin
        Result.Minor:=StrToIntDef(Copy(Chaine,1,i-1), -1);
        Chaine:=Copy(Chaine,i+1,Length(Chaine)-i);
        i:=Pos('.',Chaine);
        If i>1
        Then Begin
          Result.Release:=StrToIntDef(Copy(Chaine,1,i-1), -1);
          Result.Build:=StrToIntDef(Copy(Chaine,i+1,Length(Chaine)-i), -1);
        End;
      End;
    End;
  End;
End;

//------------------------------------------------------------------------------

function Right(SubStr: string ; S: string): string;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;

//------------------------------------------------------------------------------

function ExtremeRight(SubStr: string ; S: string): string;
begin
  Repeat
    S:= Right(substr,s);
  until pos(substr,s)=0;
  result:=S;
end;

//------------------------------------------------------------------------------

initialization
  AppDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  ConfigFileName := AppDir + 'config.xml';
//  PreviousSelectedPathFileName := AppDir + 'selpath.ini';
//  InitWrapStr;

//------------------------------------------------------------------------------

end.
