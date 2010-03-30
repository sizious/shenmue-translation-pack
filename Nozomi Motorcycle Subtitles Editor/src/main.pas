unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NbikEdit, ComCtrls, Menus, ImgList, ToolWin, JvExComCtrls,
  JvToolBar, DebugLog;

type
  TfrmMain = class(TForm)
    lvSubs: TListView;
    Label1: TLabel;
    mOldSub: TMemo;
    mNewSub: TMemo;
    lblText: TLabel;
    mmMain: TMainMenu;
    miFile: TMenuItem;
    sbMain: TStatusBar;
    tbMain: TJvToolBar;
    ToolButton1: TToolButton;
    tbOpen: TToolButton;
    tbReload: TToolButton;
    tbSave: TToolButton;
    ToolButton4: TToolButton;
    tbDebugLog: TToolButton;
    tbAbout: TToolButton;
    ilToolBarDisabled: TImageList;
    ilToolBar: TImageList;
    tbPreview: TToolButton;
    ToolButton2: TToolButton;
    miOpen: TMenuItem;
    miView: TMenuItem;
    miHelp: TMenuItem;
    miDEBUG: TMenuItem;
    miDEBUG_TEST1: TMenuItem;
    miSave: TMenuItem;
    odOpen: TOpenDialog;
    sdSave: TSaveDialog;
    N1: TMenuItem;
    miQuit: TMenuItem;
    miDebugLog: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure miOpenClick(Sender: TObject);
    procedure miDEBUG_TEST1Click(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure lvSubsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure mNewSubChange(Sender: TObject);
    procedure miQuitClick(Sender: TObject);
  private
    { Déclarations privées }  
    fSelectedSubtitleUI: TListItem;
    fSelectedSubtitle: TNozomiMotorcycleSequenceSubtitleItem;
    fDebugLogVisible: Boolean;
    procedure Clear;
    procedure DebugLogExceptionEvent(Sender: TObject; E: Exception);
    procedure DebugLogMainFormToFront(Sender: TObject);
    procedure DebugLogVisibilityChange(Sender: TObject; const Visible: Boolean);
    procedure DebugLogWindowActivated(Sender: TObject);
    function GetSelectedSubtitle: string;
    function GetStatusText: string;
    procedure InitDebugLog;
    procedure LoadFile(FileName: TFileName);
    procedure SetSelectedSubtitle(const Value: string);
    procedure SetStatusText(const Value: string);
    procedure SetDebugLogVisible(const Value: Boolean);
    procedure SetControlsStateFileOperations(State: Boolean);
  public
    { Déclarations publiques }
    function IsSubtitleSelected: Boolean;
    property DebugLogVisible: Boolean read fDebugLogVisible
      write SetDebugLogVisible;
    property SelectedSubtitle: string read GetSelectedSubtitle
      write SetSelectedSubtitle;
    property StatusText: string read GetStatusText write SetStatusText;
  end;

var
  frmMain: TfrmMain;
  SequenceEditor: TNozomiMotorcycleSequenceEditor;
  DebugLog: TDebugLogHandlerInterface;
  
implementation

{$R *.dfm}

uses
  Config, UITools;
  
procedure TfrmMain.Clear;
begin
  lvSubs.Clear;
end;

procedure TfrmMain.DebugLogExceptionEvent(Sender: TObject; E: Exception);
begin
  //  BugsHandler.Execute(Sender, E);  
end;

procedure TfrmMain.DebugLogMainFormToFront(Sender: TObject);
begin
  BringToFront;  
end;

procedure TfrmMain.DebugLogVisibilityChange(Sender: TObject;
  const Visible: Boolean);
begin
  fDebugLogVisible := Visible;
  miDebugLog.Checked := Visible;
  tbDebugLog.Down := Visible;  
end;

procedure TfrmMain.DebugLogWindowActivated(Sender: TObject);
begin
  StatusText := '';
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title + ' v' + GetApplicationVersion;

  InitDebugLog;
  
  SequenceEditor := TNozomiMotorcycleSequenceEditor.Create;

  // Load charset
  SequenceEditor.Charset.LoadFromFile('data\chrlist1.csv');
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  SequenceEditor.Free;
end;

function TfrmMain.GetSelectedSubtitle: string;
begin
  Result := fSelectedSubtitle.Text;
end;

function TfrmMain.GetStatusText: string;
begin
  Result := sbMain.Panels[2].Text;
end;

procedure TfrmMain.InitDebugLog;
begin
  DebugLog := TDebugLogHandlerInterface.Create;
  with DebugLog do begin
    // Setting up events
    OnException := DebugLogExceptionEvent;
    OnMainWindowBringToFront := DebugLogMainFormToFront;
    OnVisibilityChange := DebugLogVisibilityChange;
    OnWindowActivated := DebugLogWindowActivated;
  end;

  // Setting up the properties
  DebugLog.Configuration := Configuration; // in this order!
end;

function TfrmMain.IsSubtitleSelected: Boolean;
begin
  Result := Assigned(fSelectedSubtitle);
end;

procedure TfrmMain.LoadFile(FileName: TFileName);
var
  i, j: Integer;
  UpdateUI: Boolean;
  ListItem: TListItem;

begin
  // Extending filenames
  FileName := ExpandFileName(FileName);
  UpdateUI := SameText(FileName, SequenceEditor.SourceFileName);

  // Checking the file
  if not FileExists(FileName) then begin
    DebugLog.Report(ltWarning, 'The file "' + FileName + '" doesn''t exists.',
      'FullFileName: ' + FileName);
    Exit;
  end;

  // Updating UI
  StatusText := 'Loading file...';
  Clear(UpdateUI);  

  // Loading the file
  if SequenceEditor.LoadFromFile(FileName) then begin

    // Filling the UI with the IWAD content
    if SequenceEditor.Loaded then begin

      // Adding entries
      for i := 0 to SequenceEditor.Subtitles.Count - 1 do begin
        ListItem := nil;

        // Checking if we must update the current view...
        if UpdateUI then
          ListItem := lvSubs.FindData(0, Pointer(i), True, False); // finding the correct index

        (*  If we ListItem = nil, it says that we don't have found the correct
            Item index, or we opened a new file. So we'll create a new item
            and prepare it to be updated. *)
        if not Assigned(ListItem) then begin
          ListItem := lvSubs.Items.Add;
          ListItem.Caption := '';
          j := 0;
          repeat
            ListItem.SubItems.Add('');
            Inc(j);
          until j = 6;
        end;

        // Updating the current item with the new values
        with ListItem do
          with SequenceEditor.Items[i] do begin
            Data := Pointer(i);
            Caption := IntToStr(i);
            SubItems[0] := BR(SequenceEditor.Subtitles[i].Text);
          end;
      end;

      // Updating UI
      if not UpdateUI then begin
//        SetWindowTitleCaption(LcdEditor.SourceFileName);
        DebugLog.AddLine(ltInformation, 'Load successfully done for "'
          + SequenceEditor.SourceFileName + '".');
      end;
      SetControlsStateFileOperations(True);

      // Refreshing the view
(*      if Assigned(SelectedContentUI) then
        lvIwadContentSelectItem(Self, SelectedContentUI, True);
*)
    end else begin
      StatusText := 'IWAD empty ! Loading aborted...';
      DebugLog.Report('This file contains a valid IWAD section, but the section itself is empty.',
        'FileName: ' + FileName, 'Nothing to edit in this file', ltInformation);
    end;

  end else
    DebugLog.Report('This file isn''t a valid IWAD file.',
      'FileName: ' + FileName, 'Warning', ltWarning);


  StatusText := '';
end;

procedure TfrmMain.lvSubsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then begin
    // Setting the variables to store the selected item
    fSelectedSubtitleUI := Item;
    fSelectedSubtitle := SequenceEditor.Subtitles[Integer(Item.Data)];

    // Refresh the view
    mOldSub.Text := SelectedSubtitle;
    mNewSub.Text := SelectedSubtitle;
  end;
end;

procedure TfrmMain.miDEBUG_TEST1Click(Sender: TObject);
{$IFDEF DEBUG}
var
  i: Integer;

begin
  SequenceEditor.LoadFromFile('PAL_DISC4.scn');
(*  SequenceEditor.Items[0].Text := 'This''s how we do!';
  SequenceEditor.Items[1].Text := 'BLAH!<br>MOTHA FUCKA!!!!';
  SequenceEditor.Items[2].Text := 'éa!';
  SequenceEditor.Items[3].Text := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ........<br>0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ........';
  SequenceEditor.Items[5].Text := 'MAPINFO HACKED HUH?! SEE?';
  SequenceEditor.Items[7].Text := 'Woohoo! This''s the lastest SiZiOUS hack.<br>Enjoy this GREAT exploit!';
  SequenceEditor.Items[8].Text := 'Woohoo! This''s the lastest SiZiOUS hack.<br>Enjoy this GREAT exploit!'; *)

  for i := 0 to SequenceEditor.Subtitles.Count - 1 do
    SequenceEditor.Subtitles[i].Text :=
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqr<br>abcdefghijklmnopqrABCDEFGHIJKLMNOPQRSTUVWXYZ';

  SequenceEditor.SaveToFile('PAL_DISC4.HAK');
{$ELSE}
begin
{$ENDIF}
end;

procedure TfrmMain.miOpenClick(Sender: TObject);
begin
  with odOpen do
    if Execute then
      LoadFile(FileName);
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miSaveClick(Sender: TObject);
begin
  StatusText := 'Saving file...';
  if SequenceEditor.Save then
    DebugLog.AddLine(ltInformation, Format('Save successfully done on the ' +
      'disk for "%s".', [SequenceEditor.SourceFileName])
    )
  else
    DebugLog.Report('Unable to save the file on the disk!',
      Format('Unable to save on disk for "%s".', [SequenceEditor.SourceFileName]),
      ltWarning
    );
  LoadFile(SequenceEditor.SourceFileName);
end;

procedure TfrmMain.mNewSubChange(Sender: TObject);
begin
  SelectedSubtitle := mNewSub.Text;
end;

procedure TfrmMain.SetControlsStateFileOperations(State: Boolean);
begin
(*  miClose.Enabled := State;
  miImport.Enabled := State;
  miImport2.Enabled := State;
  tbImport.Enabled := State;
  miExport.Enabled := State;
  miExport2.Enabled := State;
  tbExport.Enabled := State;
  miExportAll.Enabled := State;
  miExportAll2.Enabled := State;
  tbExportAll.Enabled := State;
  miReload.Enabled := State;
  tbReload.Enabled := State; *)
end;

procedure TfrmMain.SetDebugLogVisible(const Value: Boolean);
begin
  DebugLog.Active := Value;
end;

procedure TfrmMain.SetSelectedSubtitle(const Value: string);
begin
  if IsSubtitleSelected then begin
    fSelectedSubtitleUI.SubItems[0] := BR(Value);
    fSelectedSubtitle.Text := Value;
  end;
end;

procedure TfrmMain.SetStatusText(const Value: string);
begin
  sbMain.Panels[2].Text := Value;
end;

procedure TfrmMain.tbMainCustomDraw(Sender: TToolBar; const ARect: TRect;
  var DefaultDraw: Boolean);
begin
  ToolBarCustomDraw(Sender);
end;

end.
