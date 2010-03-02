unit shellext;

(*
  TShellExtensionManager

  This class is here to manage the File Associations. It's the client of the
  RegShell.TRegistryShellFileManager class.
*)

interface

uses
  Windows, SysUtils, Forms, Classes, RegShell;

type
  TFileAssociationInfo = record
    Extension: string;
    IconIndex: Integer;
    Description: string;
  end;

  TFileAssociationInfoListItem = class
  private
    fIconIndex: Integer;
    fExtension: string;
    fDescription: string;
  public
    property Extension: string read fExtension;
    property IconIndex: Integer read fIconIndex;
    property Description: string read fDescription;
  end;
  
  TFileAssociationInfoList = class
  private
    fList: TList;
    function GetItem(Index: Integer): TFileAssociationInfoListItem;
    function GetCount: Integer;
  protected
    procedure Add(E: TFileAssociationInfo);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TFileAssociationInfoListItem read
      GetItem; default;
  end;

  TShellExtensionManager = class(TObject)
  private
    fFileAssociationInfoList: TFileAssociationInfoList;
    fRegistryOpenWithTheApplication: string;
    fRegistryApplicationName: string;
    fRegistryShell: TRegistryShellFileManager;
  protected
    procedure AssociateFile(Entry: TFileAssociationInfoListItem);
    procedure UnassociateFile(Entry: TFileAssociationInfoListItem);
    property FileAssociationList: TFileAssociationInfoList
      read fFileAssociationInfoList;
    property RegistryShell: TRegistryShellFileManager read fRegistryShell;
  public
    constructor Create(FilesAssoc: array of TFileAssociationInfo);
    destructor Destroy; override;
    function IsFilesAssociated: Boolean;
    procedure RegisterShellFilesAssociation(const Associate: Boolean);    
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  ShlObj, UITools;

//------------------------------------------------------------------------------
// TShellExtensionManager
//------------------------------------------------------------------------------

procedure TShellExtensionManager.AssociateFile(Entry: TFileAssociationInfoListItem);
var
  Command, DefaultIcon: string;
  
begin
  Command := '"' + Application.ExeName + '" "%1"';
  DefaultIcon := '"' + Application.ExeName + '",' + IntToStr(Entry.IconIndex);

  with RegistryShell do
    if ExtensionExists(Entry.Extension) then begin

      if not ExtensionOpenWith(Entry.Extension, Application.ExeName) then
        CreateContextMenu(Entry.Extension, fRegistryApplicationName,
          fRegistryOpenWithTheApplication, Command);

    end else
      CreateExtension(Entry.Extension, Entry.Description, DefaultIcon, Command);
end;

//------------------------------------------------------------------------------

constructor TShellExtensionManager.Create(FilesAssoc: array of TFileAssociationInfo);
var
  i: Integer;
  
begin
  fRegistryShell := TRegistryShellFileManager.Create;
  fFileAssociationInfoList := TFileAssociationInfoList.Create;

  // Init FileAssociationInfoList
  for i := Low(FilesAssoc) to High(FilesAssoc) do
    FileAssociationList.Add(FilesAssoc[i]);

  fRegistryApplicationName := GetShortApplicationTitle;
  fRegistryOpenWithTheApplication := 'Open with ' + fRegistryApplicationName;
  fRegistryApplicationName :=
    LowerCase(StringReplace(fRegistryApplicationName, ' ', '', [rfReplaceAll]));
end;

//------------------------------------------------------------------------------

destructor TShellExtensionManager.Destroy;
begin
  fRegistryShell.Free;
  fFileAssociationInfoList.Free;
  inherited;
end;

//------------------------------------------------------------------------------

function TShellExtensionManager.IsFilesAssociated: Boolean;
var
  i: Integer;
  Extension: string;

begin
  Result := True;
  for i := 0 to FileAssociationList.Count - 1 do begin
    Extension := FileAssociationList[i].Extension;
    Result :=
      Result and (
          RegistryShell.ExtensionOpenWith(Extension, Application.ExeName)
        or
          RegistryShell.ContextMenuExists(Extension, fRegistryApplicationName)
      );
  end;
end;

//------------------------------------------------------------------------------

procedure TShellExtensionManager.RegisterShellFilesAssociation(
  const Associate: Boolean);
type
  TRegistryShellFunc = procedure(Entry: TFileAssociationInfoListItem) of object;

var
  i: Integer;
  RegistryShellAction: TRegistryShellFunc;

begin
  if Associate then
    RegistryShellAction := AssociateFile
  else
    RegistryShellAction := UnassociateFile;

  for i := 0 to FileAssociationList.Count - 1 do begin
    RegistryShellAction(FileAssociationList[i]);
  end;

  // Thanks Columbo!
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
end;

//------------------------------------------------------------------------------

procedure TShellExtensionManager.UnassociateFile(Entry: TFileAssociationInfoListItem);
begin
  with RegistryShell do
    if ExtensionOpenWith(Entry.Extension, Application.ExeName) then
      DeleteExtension(Entry.Extension)
    else
      DeleteContextMenu(Entry.Extension, fRegistryApplicationName);
end;

//------------------------------------------------------------------------------
// TFileAssociationInfoList
//------------------------------------------------------------------------------

procedure TFileAssociationInfoList.Add(E: TFileAssociationInfo);
var
  Item: TFileAssociationInfoListItem;

begin
  Item := TFileAssociationInfoListItem.Create;
  Item.fExtension := E.Extension;
  Item.fIconIndex := E.IconIndex;
  Item.fDescription := E.Description;
  fList.Add(Item);
end;

//------------------------------------------------------------------------------

procedure TFileAssociationInfoList.Clear;
var
  i: Integer;

begin
  for i := 0 to fList.Count - 1 do
    TFileAssociationInfoListItem(fList[i]).Free;
  fList.Clear;
end;

//------------------------------------------------------------------------------

constructor TFileAssociationInfoList.Create;
begin
  fList := TList.Create;
end;

//------------------------------------------------------------------------------

destructor TFileAssociationInfoList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

//------------------------------------------------------------------------------

function TFileAssociationInfoList.GetCount: Integer;
begin
  Result := fList.Count;
end;

//------------------------------------------------------------------------------

function TFileAssociationInfoList.GetItem(Index: Integer): TFileAssociationInfoListItem;
begin
  Result := TFileAssociationInfoListItem(fList.Items[Index]);
end;

//------------------------------------------------------------------------------

end.
