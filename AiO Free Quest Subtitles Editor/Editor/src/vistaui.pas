unit vistaui;

interface

uses
  Windows; //, Forms;

function IsWindowsVista: Boolean;  
// procedure SetVistaFonts(const AForm: TCustomForm);
  
implementation

uses 
	SysUtils;

(*
const
  VistaFont = 'Segoe UI';
  XPFont = 'Tahoma';
  
procedure SetVistaFonts(const AForm: TCustomForm);
var
  Size: Integer;
  
begin
  if not SameText(AForm.Font.Name, VistaFont) then
  begin
    Size := AForm.Font.Size;
    if not SameText(AForm.Font.Name, VistaFont) then
      Inc(Size, 1);
    AForm.Font.Name := VistaFont;
    if not SameText(AForm.Font.Name, VistaFont) then
      AForm.Font.Name := XPFont
    else
      AForm.Font.Size := Size;
  end;
end;
*)

function IsWindowsVista: Boolean;   
var
  VerInfo: TOSVersioninfo;
  
begin
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(VerInfo);        
  Result := VerInfo.dwMajorVersion >= 6;
end;

end.

