unit SRFKeyDB;

{$DEFINE USE_DCL}

interface

uses
  Windows, SysUtils, Classes, FileSpec
  {$IFDEF USE_DCL}, HashIdx {$ENDIF}
  ;

type
  TCinematicsHashKeyDatabase = class(TObject)
  private
{$IFDEF USE_DCL}
    fHashMap: THashIndexOptimizer;
{$ENDIF}
    fDatabaseList: TList;
    fLoaded: Boolean;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    function GetPlatformVersion(const HashKey: string): TPlatformVersion;
    function OpenDatabase(const FileName: TFileName): Boolean;
    property Loaded: Boolean read fLoaded;
  end;

implementation

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants, WorkDir, LZMADec,
  SysTools;

var
  CinematicsDatabaseFileName: TFileName;
  
{ TCinematicsHashKeyDatabase }

procedure TCinematicsHashKeyDatabase.Clear;
begin
  fLoaded := False;
{$IFDEF USE_DCL}
  fHashMap.Clear;
{$ENDIF}
  fDatabaseList.Clear;
end;

constructor TCinematicsHashKeyDatabase.Create;
begin
{$IFDEF USE_DCL}
  fHashMap := THashIndexOptimizer.Create;
{$ENDIF}
  fDatabaseList := TList.Create;
end;

destructor TCinematicsHashKeyDatabase.Destroy;
begin
{$IFDEF USE_DCL}
  fHashMap.Free;
{$ENDIF}
  fDatabaseList.Free;
  inherited;
end;

function TCinematicsHashKeyDatabase.GetPlatformVersion(
  const HashKey: string): TPlatformVersion;
var
  i: Integer;

begin
  Result := pvUndef;
{$IFDEF USE_DCL}
  i := fHashMap.IndexOf(HashKey);
  if i <> -1 then
    Result := TPlatformVersion(fDatabaseList[i]);
{$ENDIF}
end;

function TCinematicsHashKeyDatabase.OpenDatabase(
  const FileName: TFileName): Boolean;
var
  XMLDoc: IXMLDocument;
  RootNode: IXMLNode;
  i, Index: Integer;
  HashKey, PlatformName: string;

begin
  Result := False;
  if not FileExists(FileName) then Exit;
  
  Clear;

  // Extract the Database
  if not FileExists(CinematicsDatabaseFileName) then begin
    SevenZipExtract(FileName, GetWorkingTempDirectory);
    CinematicsDatabaseFileName := GetWorkingTempDirectory + 'index.dbi';
  end;

  // Open the XML file
  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.LoadFromFile(CinematicsDatabaseFileName);
    XMLDoc.Active := True;
    Result := XMLDoc.DocumentElement.NodeName = 'CinematicsDatabase';
    
    if Result then begin
      RootNode := XMLDoc.DocumentElement.ChildNodes.FindNode('Entries');
      if Assigned(RootNode) then
        for i := 0 to RootNode.Attributes['Count'] - 1 do begin
          PlatformName := RootNode.ChildNodes[i].Attributes['s'];
          HashKey :=  RootNode.ChildNodes[i].NodeName;
          Index := fDatabaseList.Add(Pointer(CodeStringToPlatformVersion(PlatformName)));
{$IFDEF USE_DCL}
          fHashMap.Add(HashKey, Index);
{$ENDIF}
        end;
    end;

    fLoaded := Result;
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

initialization
  CoInitialize(nil);	
  SevenZipInitEngine(GetWorkingTempDirectory);

end.
