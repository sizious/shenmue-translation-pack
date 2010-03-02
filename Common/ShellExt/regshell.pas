unit regshell;

(*
  TRegistryShellFileManager

  This class is here to access the Windows Registry in order to manipulate
  file associations and Context menus.
*)

interface

uses
  Windows, SysUtils, Registry;

type
  ERegistryShellFile = class(Exception);
  EUnableAccessRegistryKey = class(ERegistryShellFile);
  EIllegalExtension = class(ERegistryShellFile);
  ERegistryMustBeInitialized = class(ERegistryShellFile);
  EInvalidParameter = class(ERegistryShellFile);

  TRegistryShellFileManager = class(TObject)
  private
    fRegistryObject: TRegistry;
    function GetExtensionID(FileExtension: string; CanCreate: Boolean): string;
    function GetRealExtension(var FileExtension: string): string;
    property RegistryObject: TRegistry read fRegistryObject;
  protected
    function RegistryDeleteKey(const Key: string): Boolean;
    function RegistryKeyExists(const Key: string): Boolean;
    function RegistryOpenKey(const Key: string; CanCreate: Boolean): Boolean;
    function RegistryRead(const Name: string): string;
    procedure RegistryWrite(const Name, Value: string); overload;
  public
    constructor Create;
    destructor Destroy; override;
    function ContextMenuExists(FileExtension, ApplicationName: string): Boolean;
    procedure CreateContextMenu(FileExtension, ApplicationName, ItemCaption, Command: string);
    procedure CreateExtension(FileExtension, FileDescription, IconFileName, OpenCommand: string);
    function DeleteContextMenu(FileExtension, ApplicationName: string): Boolean;
    function DeleteExtension(FileExtension: string): Boolean;
    function ExtensionExists(FileExtension: string): Boolean;
    function ExtensionOpenWith(FileExtension: string; ApplicationExeName: string): Boolean;
  end;

implementation

{ TRegistryShellFileManager }

procedure TRegistryShellFileManager.CreateContextMenu(FileExtension,
  ApplicationName, ItemCaption, Command: string);
var
  ExtID, FileKey: string;

begin
  // Getting the Extension ID
  ExtID := GetExtensionID(FileExtension, True);
  FileKey := ExtID + '\shell\' + ApplicationName;

  // Writing the context menu item
  RegistryOpenKey(FileKey, True);
  RegistryWrite('', ItemCaption);

  // Writing the command
  RegistryOpenKey(FileKey + '\command', True);
  RegistryWrite('', Command);
end;

function TRegistryShellFileManager.ContextMenuExists(FileExtension,
  ApplicationName: string): Boolean;
var
  ExtID: string;
  
begin
  Result := False;
  ExtID := GetExtensionID(FileExtension, False);
  if ExtID <> '' then
    Result := RegistryKeyExists(ExtID + '\Shell\' + ApplicationName);
end;

constructor TRegistryShellFileManager.Create;
begin
  fRegistryObject := TRegistry.Create;

  // Checking RG object
  if not Assigned(RegistryObject) then
    raise ERegistryMustBeInitialized.Create('The Registry object must be initialized!');

  // Every operation is in the HKEY_CLASSES_ROOT
  RegistryObject.RootKey := HKEY_CLASSES_ROOT;
end;

procedure TRegistryShellFileManager.CreateExtension(FileExtension,
  FileDescription, IconFileName, OpenCommand: string);
var
  ExtID: string;

begin
  // Opening the ExtID key
  ExtID := GetExtensionID(FileExtension, True);

  // Writing the File description
  RegistryOpenKey(ExtID, True);  
  RegistryWrite('', FileDescription);

  // Writing the Default Icon
  RegistryOpenKey(ExtID + '\DefaultIcon', True);
  RegistryWrite('', IconFileName);

  // Writing the open command
  RegistryOpenKey(ExtID + '\shell\open\command', True);
  RegistryWrite('', OpenCommand);
end;

function TRegistryShellFileManager.DeleteExtension(
  FileExtension: string): Boolean;
const
  DENY_EXTENSION : array[0..11] of string = (
    'EXE', 'DLL', 'COM', 'BAT', 'CMD', 'SCR',
    'PIF', 'LNK', 'VXD', 'SYS', 'OCX', '386'
  );

var
  ExtID: string;
  i: Integer;

begin
  //Extension non autorisés (system)
  FileExtension := GetRealExtension(FileExtension);  
  for i := Low(DENY_EXTENSION) to High(DENY_EXTENSION) do
    if DENY_EXTENSION[i] = UpperCase(FileExtension) then
      raise EIllegalExtension.Create('Unable to remove the "' + FileExtension
        + '" extension from the Windows Shell!');

  // Deleting ExtID key
  ExtID := GetExtensionID(FileExtension, False);
  if ExtID <> '' then
    RegistryDeleteKey(ExtID);

  // Deleting the extension key
  Result := RegistryDeleteKey('.' + FileExtension);
end;

destructor TRegistryShellFileManager.Destroy;
begin
  RegistryObject.Free;
  inherited;
end;

function TRegistryShellFileManager.GetExtensionID(FileExtension: string; CanCreate: Boolean): string;
begin
  Result := '';
  FileExtension := GetRealExtension(FileExtension);
  if not RegistryOpenKey('.' + FileExtension, CanCreate) then Exit;

  Result := RegistryRead(''); //lire la valeur par défaut, qui contient l'ID de l'extension
  RegistryObject.CloseKey;

  if (Result = '') or (not RegistryKeyExists(Result)) then begin //il est vide donc l'extension n'existe pas
    Result := FileExtension + 'file'; //création de l'ExtID
    RegistryOpenKey('.' + FileExtension, CanCreate);
    RegistryWrite('', Result);   //ecriture dans le registre
  end;

  RegistryObject.CloseKey; //on retourne à la clef précédente (HKEY_CLASSES_ROOT)
end;

function TRegistryShellFileManager.GetRealExtension(var FileExtension: string): string;
begin
  if FileExtension = '' then
    raise EInvalidParameter.Create('Invalid paramter: FileExtension is empty');
  if FileExtension[1] = '.' then
    Result := Copy(FileExtension, 2, Length(FileExtension) - 1)
  else
    Result := FileExtension;
end;

function TRegistryShellFileManager.RegistryDeleteKey(
  const Key: string): Boolean;
begin
  Result := RegistryObject.DeleteKey(Key);
end;

function TRegistryShellFileManager.RegistryKeyExists(
  const Key: string): Boolean;
begin
  Result := RegistryObject.KeyExists(Key);
end;

function TRegistryShellFileManager.RegistryOpenKey(const Key: string;
  CanCreate: Boolean): Boolean;
begin
  // Checking parameter
  if Key = '' then
    EInvalidParameter.Create('The Key parameter is empty!');

  // Opening the key
  Result := RegistryObject.OpenKey(Key, CanCreate);

  // Checking the result
  if (not Result) and (CanCreate) then
    raise EUnableAccessRegistryKey.Create('Unable to access Registry Key: "'
      + Key + '".');
end;

function TRegistryShellFileManager.RegistryRead(const Name: string): string;
begin
  Result := RegistryObject.ReadString(Name);
end;

procedure TRegistryShellFileManager.RegistryWrite(const Name, Value: string);
begin
  RegistryObject.WriteString(Name, Value);
  RegistryObject.CloseKey;
end;

function TRegistryShellFileManager.ExtensionExists(FileExtension: string): Boolean;
var
  ExtensionID: string;

begin
  FileExtension := GetRealExtension(FileExtension);
  Result := RegistryOpenKey('.' + FileExtension, False);
  if Result then begin
    ExtensionID := RegistryRead('');
    RegistryObject.CloseKey;
    Result := RegistryKeyExists(ExtensionID);
  end;
end;

function TRegistryShellFileManager.ExtensionOpenWith(FileExtension,
  ApplicationExeName: string): Boolean;
var
  ExtID: string;

begin
  Result := False;
  if not ExtensionExists(FileExtension) then Exit;

  ExtID := GetExtensionID(FileExtension, False);
  if ExtID = '' then Exit;

  if not RegistryOpenKey(ExtID + '\shell\open\command', False) then Exit;

  Result :=
    Pos(
      UpperCase(ExtractFileName(ApplicationExeName)),
      UpperCase(ExtractFileName(RegistryRead('')))
    ) > 0;
  RegistryObject.CloseKey;
end;

function TRegistryShellFileManager.DeleteContextMenu(FileExtension,
  ApplicationName: string): Boolean;
var
  ExtID: string;

begin
  Result := False;
  ExtID := GetExtensionID(FileExtension, False);
  if ExtID <> '' then
    Result := RegistryDeleteKey(ExtID + '\shell\' + ApplicationName);
end;

end.
