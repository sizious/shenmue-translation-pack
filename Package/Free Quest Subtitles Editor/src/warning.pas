(*
  This file is part of Shenmue Free Quest Subtitles Editor.

  Shenmue Free Quest Subtitles Editor is free software: you can redistribute it
  and/or modify it under the terms of the GNU General Public License as
  published by the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Shenmue AiO Free Quest Subtitles Editor is distributed in the hope that it
  will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Shenmue AiO Free Quest Subtitles Editor.  If not, see
  <http://www.gnu.org/licenses/>.
*)

unit Warning;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmWarning = class(TForm)
    bOK: TButton;
    cbUnderstood: TCheckBox;
    Bevel1: TBevel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    tCloseEnabler: TTimer;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure tCloseEnablerTimer(Sender: TObject);
  private
    { Déclarations privées }
    procedure ChangeCloseState(const Value: Boolean);
  public
    { Déclarations publiques }
  end;

var
  frmWarning: TfrmWarning;

procedure ShowWarningIfNeeded;
function IsWarningUnderstood: Boolean;

implementation

{$R *.dfm}

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Utils;

var
  WarningUnderstood: Boolean;

//------------------------------------------------------------------------------

function GetWarningDialogAlreadyShown: Boolean;
var
  XMLDoc: IXMLDocument;
  Node: IXMLNode;

begin
  Result := False;

  if not FileExists(GetConfigFileName) then Exit;

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

    XMLDoc.LoadFromFile(GetConfigFileName);

    if (XMLDoc.DocumentElement.NodeName <> 'freequestcfg') then Exit;

    Node := XMLDoc.DocumentElement.ChildNodes.FindNode('warningdisplayed');
    if Assigned(Node) then Result := Boolean(Node.NodeValue);
  finally
    XMLDoc.Active := False;
    XMLDoc := nil;
  end;
end;

//------------------------------------------------------------------------------

procedure SetWarningDialogAlreadyShownValue(Value: Boolean);
begin
  WarningUnderstood := Value;
end;

//------------------------------------------------------------------------------

procedure ShowWarningIfNeeded;
begin
  WarningUnderstood := GetWarningDialogAlreadyShown;

  if not WarningUnderstood then begin
    frmWarning := TfrmWarning.Create(Application);
    try
      frmWarning.ShowModal;
    finally
      frmWarning.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmWarning.ChangeCloseState(const Value: Boolean);
var
  HandleMenu: THandle;
  Buf: Cardinal;

begin
  if Value then Buf := MF_ENABLED else Buf := MF_DISABLED;
  bOK.Enabled := Value;
  HandleMenu := GetSystemMenu(Handle, False);
  EnableMenuItem(HandleMenu, SC_CLOSE, Buf);
end;

//------------------------------------------------------------------------------

procedure TfrmWarning.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetWarningDialogAlreadyShownValue(cbUnderstood.Checked);
end;

//------------------------------------------------------------------------------

procedure TfrmWarning.FormCreate(Sender: TObject);
begin
  WarningUnderstood := GetWarningDialogAlreadyShown;
  ChangeCloseState(False);
end;

//------------------------------------------------------------------------------

procedure TfrmWarning.FormShow(Sender: TObject);
begin
  MessageBeep(MB_ICONWARNING);
end;

//------------------------------------------------------------------------------

procedure TfrmWarning.tCloseEnablerTimer(Sender: TObject);
begin
  ChangeCloseState(True);
  tCloseEnabler.Enabled := False;
end;

//------------------------------------------------------------------------------

function IsWarningUnderstood: Boolean;
begin
  Result := WarningUnderstood;
end;

//------------------------------------------------------------------------------

end.
