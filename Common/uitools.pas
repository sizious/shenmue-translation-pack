unit uitools;

interface

uses
  Windows, SysUtils, Classes, Forms, ComCtrls, JvToolbar;

type
  EUserInterfaceException = class(Exception);
  EInvalidToolBarButton = class(EUserInterfaceException);

function FindNode(Node: TTreeNode; Text: string): TTreeNode;
function GetApplicationVersion(LangID, SubLangID: Byte): string;
function GetApplicationCodeName: string;
function GetApplicationShortTitle: string;
procedure InitToolBarControl(SourceForm: TForm; ToolBar: TJvToolBar);
procedure ListViewSelectItem(ListView: TCustomListView; Index: Integer);
function OpenLink(const LinkURL: string): Boolean;
procedure ShellOpenPropertiesDialog(FileName: TFileName);

implementation

uses
  Menus, ShellApi;

//------------------------------------------------------------------------------

// Returns the Application.Title without the "Shenmue " string before
// Eg: "Shenmue IPAC Browser" becomes "IPAC Browser"
function GetApplicationShortTitle: string;
const
  SHENMUE_TITLE_SIGN = 'Shenmue ';

begin
  Result := StringReplace(Application.Title, SHENMUE_TITLE_SIGN, '', []);
end;

//------------------------------------------------------------------------------

// Returns a "encoded" string from Application.Title
// Eg: "Shenmue IPAC Browser" becomes "ipacbrowser".
function GetApplicationCodeName: string;
begin
  Result := LowerCase(StringReplace(GetApplicationShortTitle, ' ', '', [rfReplaceAll]))
end;

//------------------------------------------------------------------------------
(*
  Based on the original function published by Nono40 (nono40.developpez.com)
  Thanks to Olivier Lance:
        http://delphi.developpez.com/faq/?page=systemedivers#langidcquoi
*)
function ExtractApplicationVersion(const wLanguage: LANGID): string;
const
  VERSION_INFO_VALUE = '04E4';

var
  InfoSize,
  InfoLength: LongWord;
  Buffer,
  VersionPC: PChar;
  LangCode: string;

begin
  Result := '';
  Buffer := nil;

  LangCode := IntToHex(wLanguage, 4) + VERSION_INFO_VALUE;

  // Asking file version information size
  InfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), InfoSize);

  // We have file version information on the file.
  if InfoSize > 0 then
    try
      // Allocating memory for reading file info
      Buffer := AllocMem(InfoSize);

      // Copying file info in the buffer
      GetFileVersionInfo(PChar(ParamStr(0)), 0, InfoSize, Buffer);

      // Reading the ProductVersion value
      if VerQueryValue(Buffer, PChar('\StringFileInfo\' + LangCode
        + '\ProductVersion'), Pointer(VersionPC), InfoLength
      ) then
        Result := VersionPC;
    finally
      FreeMem(Buffer, InfoSize);
    end;
end;

//------------------------------------------------------------------------------

function MakeLangID(LangID, SubLangID: Byte): Word;
begin
  Result := (SubLangID shl 10) or LangID;
end;

//------------------------------------------------------------------------------

function GetApplicationVersion(LangID, SubLangID: Byte): string;
begin
  Result := ExtractApplicationVersion(MakeLangID(LangID, SubLangID));
end;

//------------------------------------------------------------------------------

function FindNode(Node: TTreeNode; Text: string): TTreeNode;
var
  i: Integer;

begin
  Result := nil;
  if not Node.HasChildren then Exit;

  for i := 0 to Node.Count - 1 do
    if Node.Item[i].Text = Text then begin
      Result := Node.Item[i];
      Break;
    end;

end;

//------------------------------------------------------------------------------

procedure ListViewSelectItem(ListView: TCustomListView; Index: Integer);
var
  P: TPoint;

begin
  if Index = 0 then begin
//    ListView.Scroll(0, - MaxInt);
    ListView.ItemIndex := 0;
  end else begin
    ListView.ItemIndex := Index - 1;
    P := ListView.Selected.Position;
    ListView.Scroll(0, P.Y);
    ListView.ItemIndex := Index;
  end;
end;

//------------------------------------------------------------------------------

procedure ShellOpenPropertiesDialog(FileName: TFileName);
var
  ShellExecuteInfo: TShellExecuteInfo;

begin
  FillChar(ShellExecuteInfo, SizeOf(ShellExecuteInfo), 0);
  ShellExecuteInfo.cbSize := SizeOf(ShellExecuteInfo);
  ShellExecuteInfo.fMask := SEE_MASK_INVOKEIDLIST;
  ShellExecuteInfo.lpVerb := 'properties';
  ShellExecuteInfo.lpFile := PChar(FileName);
  ShellExecuteEx(@ShellExecuteInfo);
end;

//------------------------------------------------------------------------------

procedure InitToolBarControl(SourceForm: TForm; ToolBar: TJvToolBar);
var
  i: Integer;
  MenuName: TComponentName;
  MenuItem: TMenuItem;
  ShortCutStr: string;

begin
  // Associating each ToolButton with the appropriate MenuItem
  for i := 0 to ToolBar.ButtonCount - 1 do
    if ToolBar.Buttons[i].Style = tbsButton then begin
      // Searching the MenuItem corresponding at the ToolButton
      MenuName := 'mi' +
        Copy(ToolBar.Buttons[i].Name, 3, Length(ToolBar.Buttons[i].Name) - 2);
      MenuItem := SourceForm.FindComponent(MenuName) as TMenuItem;

      // Setting action for the ToolButton
      if Assigned(MenuItem) then begin
        ToolBar.Buttons[i].Caption := StringReplace(MenuItem.Caption, '&', '', [rfReplaceAll]);
        ShortCutStr := ShortCutToText(MenuItem.ShortCut);
        if ShortCutStr <> '' then
          ShortCutStr := ' (' + ShortCutStr + ')';
        ToolBar.Buttons[i].Hint := ToolBar.Buttons[i].Caption + ShortCutStr
          + '|' + MenuItem.Hint;
        ToolBar.Buttons[i].OnClick := MenuItem.OnClick;
      end {$IFNDEF DEBUG}; {$ELSE} else
        raise EInvalidToolBarButton.Create(
          'InitToolBarControl: Invalid main menu item: "' + MenuName + '".'
        );
      {$ENDIF}
    end; // Style = tbsButton
end;

//------------------------------------------------------------------------------

function OpenLink(const LinkURL: string): Boolean;
begin
  Result := ShellExecute(
    Application.Handle, 'open', PChar(LinkURL), '', '', SW_SHOWNORMAL
  ) > 32;
end;

//------------------------------------------------------------------------------

    
end.