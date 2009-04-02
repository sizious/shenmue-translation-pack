unit fileinfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, JvExComCtrls, JvListView, ScnfEdit,
  Menus, Common;

type
  TDisplayType = (dtHex, dtDec);

  TfrmFileInfo = class(TForm)
    pcFileInfo: TPageControl;
    tsGeneral: TTabSheet;
    tsSubsInfo: TTabSheet;
    lvSubs: TJvListView;
    Panel1: TPanel;
    Bevel1: TBevel;
    bClose: TButton;
    bProperties: TButton;
    pmSubs: TPopupMenu;
    Savetofile1: TMenuItem;
    sdSubsExport: TSaveDialog;
    tsIpac: TTabSheet;
    lvHeader: TJvListView;
    tsCharsIdDecode: TTabSheet;
    lvCharsId: TJvListView;
    lvIpac: TJvListView;
    N1: TMenuItem;
    Display1: TMenuItem;
    Hex1: TMenuItem;
    Dec1: TMenuItem;
    procedure bCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bPropertiesClick(Sender: TObject);
    procedure Savetofile1Click(Sender: TObject);
    procedure Hex1Click(Sender: TObject);
    procedure Dec1Click(Sender: TObject);
  private
    fDisplayValuesFormat: TDisplayType;
    fHeaderListSorted: Boolean;
    { Déclarations privées }
    procedure AddSubtitleEntry(SubEntry: TSubEntry);
    procedure AddIpacSectionEntry(Section: TSectionItem);
    procedure AddHeaderEntry(Name: string; Value: Integer); overload;
    procedure AddHeaderEntry(Name, Value: string); overload;
    procedure AddCharIDEntry(Entry: TSCNFCharsDecodeTableItem);
    procedure Clear;
    procedure SaveSubtitlesToFile(const FileName: TFileName);
    procedure SetDisplayValuesFormat(DisplayType: TDisplayType);
    property HeaderListSorted: Boolean read fHeaderListSorted write fHeaderListSorted;
  public
    { Déclarations publiques }
    procedure LoadFileInfo;
    property DisplayValuesFormat: TDisplayType read fDisplayValuesFormat write SetDisplayValuesFormat;
  end;

var
  frmFileInfo: TfrmFileInfo;

implementation

uses
  Main, Utils;
  
{$R *.dfm}

procedure TfrmFileInfo.SaveSubtitlesToFile(const FileName: TFileName);
var
  i: Integer;
  List: TStringList;
  Sub: TSubEntry;

begin
  List := TStringList.Create;
  try
    List.Add('Index;Code Offset;Text Offset;Patch;VoiceID;CharID;Code;Subtitle');
    for i := 0 to ScnfEditor.Subtitles.Count - 1 do begin
      Sub := ScnfEditor.Subtitles[i];
      List.Add(IntToStr(i + 1) + ';' + IntToStr(Sub.CodeOffset) + ';' + IntToStr(Sub.TextOffset) + ';' +
        IntToStr(Sub.CurrentPatchValue) + ';' + Sub.VoiceID + ';' + Sub.CharID +
        ';' + Sub.Code + ';' + StringReplace(Sub.Text, #13#10, '<br>', [rfReplaceAll]));
    end;
    List.SaveToFile(FileName);
  finally
    List.Free;
  end;
end;

procedure TfrmFileInfo.Savetofile1Click(Sender: TObject);
begin
  with sdSubsExport do begin
    FileName := ChangeFileExt(ExtractFileName(SCNFEditor.GetLoadedFileName), '.csv');
    if Execute then SaveSubtitlesToFile(FileName);
    //if Execute then lvSubs.SaveToCSV(FileName);
  end;
end;

procedure TfrmFileInfo.SetDisplayValuesFormat(DisplayType: TDisplayType);
var
  i: Integer;

begin
  if Self.fDisplayValuesFormat = DisplayType then Exit;
  
  Self.fDisplayValuesFormat := DisplayType;
  Hex1.Checked := (DisplayType = dtHex);
  Dec1.Checked := (DisplayType = dtDec);

  if lvSubs.Items.Count > 0 then begin
    case DisplayType of
      dtHex:  for i := 0 to lvSubs.Items.Count - 1 do begin
                lvSubs.Items[i].Caption := IntToHex(StrToInt(lvSubs.Items[i].Caption), 8);
                lvSubs.Items[i].SubItems[0] := IntToHex(StrToInt(lvSubs.Items[i].SubItems[0]), 8);
              end;
      dtDec:  for i := 0 to lvSubs.Items.Count - 1 do begin
                lvSubs.Items[i].Caption := IntToStr(HexToInt(lvSubs.Items[i].Caption));
                lvSubs.Items[i].SubItems[0] := IntToStr(HexToInt(lvSubs.Items[i].SubItems[0]));
              end;
    end;
  end;
end;

procedure TfrmFileInfo.AddHeaderEntry(Name: string; Value: Integer);
begin
  with lvHeader.Items.Add do begin
    Caption := Name;
    SubItems.Add(IntToStr(Value));
  end;
end;

procedure TfrmFileInfo.AddCharIDEntry(Entry: TSCNFCharsDecodeTableItem);
begin
  with lvCharsId.Items.Add do begin
    Caption := string(Entry.Code);
    SubItems.Add(Entry.CharID);
  end;
end;

procedure TfrmFileInfo.AddHeaderEntry(Name, Value: string);
begin
    with lvHeader.Items.Add do begin
    Caption := Name;
    SubItems.Add(Value);
  end;
end;

procedure TfrmFileInfo.AddIpacSectionEntry(Section: TSectionItem);
begin
  with lvIpac.Items.Add do begin
    Caption := Section.CharID;
    SubItems.Add(IntToStr(Section.UnknowValue));
    SubItems.Add(Section.Name);
    SubItems.Add(IntToStr(Section.Offset));
    SubItems.Add(IntToStr(Section.Size));
  end;
end;

procedure TfrmFileInfo.AddSubtitleEntry(SubEntry: TSubEntry);
begin
  with lvSubs.Items.Add do begin
    case DisplayValuesFormat of
      dtHex:  begin
                Caption := IntToHex(SubEntry.CodeOffset, 8);
                SubItems.Add(IntToHex(SubEntry.TextOffset, 8));
              end;
      dtDec:  begin
                Caption := IntToStr(SubEntry.CodeOffset);
                SubItems.Add(IntToStr(SubEntry.TextOffset));
              end;
    end;

    SubItems.Add(IntToStr(SubEntry.CurrentPatchValue));
    SubItems.Add(SubEntry.VoiceID);
    SubItems.Add(SubEntry.CharID);
    SubItems.Add(SubEntry.Code);
    SubItems.Add(StringReplace(SubEntry.Text, #13#10, '<br>', [rfReplaceAll]));
  end;
end;

procedure TfrmFileInfo.bCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFileInfo.bPropertiesClick(Sender: TObject);
begin
  ShellOpenPropertiesDialog(SCNFEditor.GetLoadedFileName);
end;

procedure TfrmFileInfo.Clear;
begin
  lvSubs.Clear;
  lvHeader.Clear;
  lvIpac.Clear;
  lvCharsId.Clear;
end;

procedure TfrmFileInfo.Dec1Click(Sender: TObject);
begin
  DisplayValuesFormat := dtDec;
end;

procedure TfrmFileInfo.FormCreate(Sender: TObject);
begin
  pcFileInfo.TabIndex := 0;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
  HeaderListSorted := False;
end;

procedure TfrmFileInfo.FormShow(Sender: TObject);
begin
  LoadFileInfo;
end;

procedure TfrmFileInfo.Hex1Click(Sender: TObject);
begin
  DisplayValuesFormat := dtHex;
end;

procedure TfrmFileInfo.LoadFileInfo;
var
  i: Integer;

begin
  Clear;

  with SCNFEditor do begin
    // Header
    AddHeaderEntry('VoiceID', VoiceFullID);
    AddHeaderEntry('VoiceID (short)', VoiceShortID);
    case GameVersion of
      gvWhatsShenmue: AddHeaderEntry('Game version', 'What''s Shenmue');
      gvShenmue: AddHeaderEntry('Game version', 'Shenmue I');
      gvShenmue2: AddHeaderEntry('Game version', 'Shenmue II (DC)');
      gvShenmue2X: AddHeaderEntry('Game version', 'Shenmue II (XBOX)');
    end;
    AddHeaderEntry('Main CharID', CharacterID);
    AddHeaderEntry('Footer offset', FooterOffset);
    AddHeaderEntry('SCNF ChrID header size', ScnfChrIDHeaderOffset);
    AddHeaderEntry('String table header offset', StrTableHeaderOffset);
    AddHeaderEntry('String table body offset', StrTableBodyOffset);

    // SORTING...
    if not HeaderListSorted then begin
      for i := 1 to 3 do
        lvHeader.ColClick(lvHeader.Columns[0]);
      HeaderListSorted := True;
    end else begin
      for i := 1 to 2 do
        lvHeader.ColClick(lvHeader.Columns[0]);
    end;
  
    // Subtitles
    for i := 0 to Subtitles.Count - 1 do
      AddSubtitleEntry(Subtitles[i]);

    // Sections
    for i := 0 to Sections.Count - 1 do
      AddIpacSectionEntry(Sections[i]);

    // CharsID table
    for i := 0 to Subtitles.CharsIdDecodeTable.Count - 1 do begin
      AddCharIDEntry(Subtitles.CharsIdDecodeTable[i]);
    end;
  end;
  
end;

end.
