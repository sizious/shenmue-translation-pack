unit shell;

interface

uses
  ShellExt;

var
  ShellExtension: TShellExtensionManager;

procedure InitializeShellExtension;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

const
  FILE_ASSOCIATION_TABLE: array[0..2] of TFileAssociationInfo = (
    (Extension: '.PKS'; IconIndex: 1; Description: 'Shenmue PAKS File Package'),
    (Extension: '.PKF'; IconIndex: 2; Description: 'Shenmue PAKF File Package'),
    (Extension: '.BIN'; IconIndex: 3; Description: 'Generic Binary File')
  );

//------------------------------------------------------------------------------

procedure InitializeShellExtension;
begin
  ShellExtension := TShellExtensionManager.Create(FILE_ASSOCIATION_TABLE);
end;

//------------------------------------------------------------------------------

initialization

finalization
  ShellExtension.Free;

//------------------------------------------------------------------------------

end.
