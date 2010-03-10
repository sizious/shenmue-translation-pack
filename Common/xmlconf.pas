unit xmlconf;

interface

uses
  Windows, SysUtils, Forms, XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX;
  
type
  EXMLConfigurationFile = class(Exception);
  EInvalidConfigID = class(EXMLConfigurationFile);

  TXMLConfigurationFile = class
  private
    fXMLDocument: IXMLDocument;
    fLoadedFileName: TFileName;
    fConfigID: string;
    fFirstConfiguration: Boolean;
  protected
    function GetSectionNode(Section: string; var ResultNode: IXMLNode;
      AllowCreate: Boolean): Boolean;
    procedure InitDocument;
    property XMLDocument: IXMLDocument read fXMLDocument;
  public
    constructor Create(const FileName: TFileName; const ConfigID: string);
    destructor Destroy; override;
    function ReadBool(const Section, Key: string; DefaultValue: Boolean): Boolean;
    procedure ReadFormAttributes(Form: TForm); overload;
    procedure ReadFormAttributes(const Section: string; Form: TForm); overload;
    function ReadInteger(const Section, Key: string; DefaultValue: Integer): Integer;
    function ReadString(const Section, Key: string; DefaultValue: string): string;
    procedure WriteBool(const Section, Key: string; Value: Boolean);
    procedure WriteFormAttributes(Form: TForm); overload;
    procedure WriteFormAttributes(const Section: string; Form: TForm); overload;
    procedure WriteInteger(const Section, Key: string; Value: Integer);
    procedure WriteString(const Section, Key, Value: string);
    property ConfigID: string read fConfigID;
    property FirstConfiguration: Boolean read fFirstConfiguration;
    property LoadedFileName: TFileName read fLoadedFileName;
  end;
  
implementation

uses
  Variants;
  
{ TXmlConfigurationFile }

constructor TXMLConfigurationFile.Create(const FileName: TFileName;
  const ConfigID: string);
begin
  CoInitialize(nil);
  fLoadedFileName := FileName;
  fFirstConfiguration := not FileExists(LoadedFileName);
  fConfigID := ConfigID;
  InitDocument;
end;

destructor TXMLConfigurationFile.Destroy;
begin
  XMLDocument.SaveToFile(LoadedFileName);
  XMLDocument.Active := False;
  fXMLDocument := nil;
  inherited;
end;


function TXMLConfigurationFile.GetSectionNode(Section: string;
  var ResultNode: IXMLNode; AllowCreate: Boolean): Boolean;
begin
  Result := False;
  if Section = '' then
    ResultNode := XMLDocument.DocumentElement
  else begin
    ResultNode := XMLDocument.DocumentElement.ChildNodes.FindNode(Section);
    Result :=  Assigned(ResultNode);

    // Create node if requested
    if (not Result) and AllowCreate then begin
      ResultNode := XMLDocument.CreateNode(Section);
      XMLDocument.DocumentElement.ChildNodes.Add(ResultNode);
      Result := True;
    end;
    
  end; // else
end;

procedure TXMLConfigurationFile.InitDocument;
var
  ReadConfigID: string;

begin
  fXMLDocument := TXMLDocument.Create(nil);
  
  // Setting XMLDocument properties
  with XMLDocument do begin
    Options := [doNodeAutoCreate];
    ParseOptions:= [];
    NodeIndentStr:= '  ';
    Active := True;
    Version := '1.0';
    Encoding := 'ISO-8859-1';
  end;

  // Loading the current file
  if not FirstConfiguration then begin
    XMLDocument.LoadFromFile(LoadedFileName);

    // Checking the root
    ReadConfigID := XMLDocument.DocumentElement.NodeName;
    if ReadConfigID <> ConfigID then
      raise EInvalidConfigID.Create('Invalid configuration file. ' +
        'The ConfigID is incorrect.' + sLineBreak +
        'ConfigID requested: "' + ConfigID + '", found: "' + ReadConfigID + '"' + sLineBreak + 
        'Input file: "' + LoadedFileName + '".'
      );
  end else
    XMLDocument.DocumentElement := XMLDocument.CreateNode(ConfigID);
end;

function TXMLConfigurationFile.ReadBool(const Section, Key: string;
  DefaultValue: Boolean): Boolean;
begin
  Result := StrToBool(ReadString(Section,
    Key, LowerCase(BoolToStr(DefaultValue, True))));
end;

procedure TXMLConfigurationFile.ReadFormAttributes(const Section: string;
  Form: TForm);
begin
  Form.Left := ReadInteger(Section, 'left', Form.Left);
  Form.Top := ReadInteger(Section, 'top', Form.Top);
  Form.Width := ReadInteger(Section, 'width', Form.Width);
  Form.Height := ReadInteger(Section, 'height', Form.Height);
  Form.WindowState := TWindowState(ReadInteger(Section, 'state',
    Integer(Form.WindowState)));
end;

procedure TXMLConfigurationFile.ReadFormAttributes(Form: TForm);
var
  Section: string;

begin
  Section := LowerCase(StringReplace(Form.Name, 'frm', '', []));
  ReadFormAttributes(Section, Form);
end;

function TXMLConfigurationFile.ReadInteger(const Section, Key: string;
  DefaultValue: Integer): Integer;
begin
  Result := StrToInt(ReadString(Section, Key, IntToStr(DefaultValue)));
end;

function TXMLConfigurationFile.ReadString(const Section, Key: string;
  DefaultValue: string): string;
var
  RootNode, Node: IXMLNode;

begin
  Result := DefaultValue;
  try
    if GetSectionNode(Section, RootNode, False) then begin
      Node := RootNode.ChildNodes.FindNode(Key);
      if Assigned(Node) and (not VarIsNull(Node.NodeValue)) then
        Result := Node.NodeValue;
    end;
  except
  end;
end;

procedure TXMLConfigurationFile.WriteBool(const Section, Key: string; Value: Boolean);
begin
  WriteString(Section, Key, LowerCase(BoolToStr(Value, True)));
end;

procedure TXMLConfigurationFile.WriteFormAttributes(const Section: string;
  Form: TForm);
begin
  WriteInteger(Section, 'state', Integer(Form.WindowState));

  if Form.WindowState = wsMaximized then begin
    WriteInteger(Section, 'width', ReadInteger(Section, 'width', Form.Width));
    WriteInteger(Section, 'height', ReadInteger(Section, 'height', Form.Height));
    WriteInteger(Section, 'left', ReadInteger(Section, 'left', Form.Left));
    WriteInteger(Section, 'top', ReadInteger(Section, 'top', Form.Top));
  end else begin
    WriteInteger(Section, 'width', Form.Width);
    WriteInteger(Section, 'height', Form.Height);
    WriteInteger(Section, 'left', Form.Left);
    WriteInteger(Section, 'top', Form.Top);
  end;
end;

procedure TXMLConfigurationFile.WriteFormAttributes(Form: TForm);
var
  Section: string;

begin
  Section := LowerCase(StringReplace(Form.Name, 'frm', '', []));
  WriteFormAttributes(Section, Form);
end;

procedure TXMLConfigurationFile.WriteInteger(const Section, Key: string;
  Value: Integer);
begin
  WriteString(Section, Key, IntToStr(Value));
end;

procedure TXMLConfigurationFile.WriteString(const Section, Key, Value: string);
var
  RootNode,
  CurrentNode: IXMLNode;
  
begin
  if GetSectionNode(Section, RootNode, True) then begin

    CurrentNode := RootNode.ChildNodes.FindNode(Key);
    if not Assigned(CurrentNode) then begin
      CurrentNode := XMLDocument.CreateNode(Key);
      RootNode.ChildNodes.Add(CurrentNode);
    end;

    CurrentNode.NodeValue := Value;
  end;
end;

end.
