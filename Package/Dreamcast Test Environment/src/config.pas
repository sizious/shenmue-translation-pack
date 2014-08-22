unit Config;

interface

uses
  Windows, SysUtils, Forms;

procedure LoadConfig;  
procedure SaveConfig;

implementation

uses
  Graphics, SysTools, XMLConf, Main;

var
  ConfigFile: TXMLConfigurationFile;
  sAppConfigFile: TFileName;
  sAppConfigID: string;

// GetDefaultFileName
function GetDefaultFileName(const FileName: TFileName): TFileName;
begin
  Result := FileName;
  if not FileExists(Result) then Result := '';
end;

// Load Config
procedure LoadConfig;
var
  i, c: Integer;
  Buf, Def: string;

begin
  with ConfigFile do
  begin
    if FirstConfiguration then
      frmMain.Position := poScreenCenter
    else begin
      frmMain.Position := poDesigned;
      ReadFormAttributes(frmMain);
    end;
    frmMain.edtSourceDir.Text := ReadString('main', 'inputdir', frmMain.edtSourceDir.Text);
    frmMain.edtDestDir.Text := ReadString('main', 'outputdir', GetCurrentDir);
    frmMain.edtEULA.Text := ReadString('main', 'eula',
      GetDefaultFileName('.\data\eula.rtf'));

    // Pictures Banners
    frmMain.edtSkinTop.Text := ReadString('skin', 'top',
      GetDefaultFileName('.\data\skin\top.bmp'));
    frmMain.edtSkinBottom.Text := ReadString('skin', 'bottom',
      GetDefaultFileName('.\data\skin\bottom.bmp'));

    // Pictures Center
    for i := 0 to 9 do
    begin
      Buf := 'left' + Format('%0.2d', [i+1]);
      Def :=  GetDefaultFileName('.\data\skin\' + Buf + '.bmp');
      frmMain.LeftImages[i] := ReadString('skin', Buf, Def);
    end;

    // Colors
    frmMain.clbTop.Selected := ReadInteger('colors', 'top', clMaroon);
    frmMain.pnlColorsPreviewTop.Color := frmMain.clbTop.Selected;
    frmMain.clbBottom.Selected := ReadInteger('colors', 'bottom', clMaroon);
    frmMain.pnlColorsPreviewBottom.Color := frmMain.clbBottom.Selected;
    frmMain.clbLeft.Selected := ReadInteger('colors', 'left', clMaroon);
    frmMain.pnlColorsPreviewLeft.Color := frmMain.clbLeft.Selected;
    frmMain.clbCenter.Selected := ReadInteger('colors', 'center', clCream);
    frmMain.pnlColorsPreviewCenter.Color := frmMain.clbCenter.Selected;
    frmMain.clbText.Selected := ReadInteger('colors', 'text', clBlack);
    frmMain.lblColorsPreviewTitle.Font.Color := frmMain.clbText.Selected;
    frmMain.lblColorsPreviewText.Font.Color := frmMain.clbText.Selected;
    frmMain.clbLinks.Selected := ReadInteger('colors', 'linksnormal', clBlue);
    frmMain.lblColorsPreviewLinks.Font.Color := frmMain.clbLinks.Selected;
    frmMain.clbLinksClicked.Selected := ReadInteger('colors', 'linksclicked', clPurple);
    frmMain.clbLinksHot.Selected := ReadInteger('colors', 'linkshot', clRed);
    frmMain.clbWarning.Selected := ReadInteger('colors', 'warningtext', clRed);
    frmMain.lblColorsPreviewWarning.Font.Color := frmMain.clbWarning.Selected;

    // Media Keys
    c := ReadInteger('keys', 'count', 0);
    for i := 0 to c - 1 do
    begin
      frmMain.AddMediaKey(
        ReadString('keys', 'key' + IntToStr(i) + '_value', ''),
        ReadString('keys', 'key' + IntToStr(i) + '_source', '')
      );
    end;

    frmMain.edtAuthor.Text := ReadString('info', 'author', frmMain.edtAuthor.Text);
    frmMain.edtGameName.Text := ReadString('info', 'gamename', frmMain.edtGameName.Text);
    frmMain.edtWebURL.Text := ReadString('info', 'weburl', frmMain.edtWebURL.Text);
    frmMain.cbxProtocolWebURL.ItemIndex :=
      ReadInteger('info', 'weburlprotocol', frmMain.cbxProtocolWebURL.ItemIndex);
    frmMain.edtVersion.Text := ReadString('info', 'version', frmMain.edtVersion.Text);
    frmMain.cbxShowAppName.Checked := ReadBool('info', 'wintitleshow', frmMain.cbxShowAppName.Checked);    
    frmMain.edtWizardTitle.Text := ReadString('info', 'wintitle', frmMain.edtWizardTitle.Text);
    frmMain.edtReleaseDate.Date := StrToDateDef(ReadString('info', 'rlzdate', ''), Now);
    frmMain.UpdateShowAppTitleCheckBox;

    // Language
    frmMain.SelectedLanguagePack := ReadString('main', 'languagepackstandard', '');
    if (frmMain.cbxLangStandard.ItemIndex = -1)
      and (frmMain.cbxLangStandard.Items.Count > 0) then
        frmMain.cbxLangStandard.ItemIndex := 0;    
    frmMain.edtLangCustom.Text := ReadString('main', 'languagepackcustom',
      frmMain.edtLangCustom.Text);    
    if ReadBool('main', 'applangiscustom', False) then
      frmMain.rbnLangCustom.Checked := True
    else
      frmMain.rbnLangStandard.Checked := True;
  end;
end;

// Save Config
procedure SaveConfig;
var
  i: Integer;

begin
  with ConfigFile do
  begin
    WriteFormAttributes(frmMain);
    WriteString('main', 'inputdir', frmMain.edtSourceDir.Text);
    WriteString('main', 'outputdir', frmMain.edtDestDir.Text);
    WriteString('main', 'eula', frmMain.edtEULA.Text);
    WriteBool('main', 'applangiscustom', frmMain.rbnLangCustom.Checked);
    WriteString('main', 'languagepackcustom', frmMain.edtLangCustom.Text);

    i := frmMain.cbxLangStandard.ItemIndex;
    if i <> -1 then    
      WriteString('main', 'languagepackstandard', LowerCase(frmMain.cbxLangStandard.Items[i]));
    
    WriteString('skin', 'top', frmMain.edtSkinTop.Text);
    WriteString('skin', 'bottom', frmMain.edtSkinBottom.Text);

    for i := 0 to 9 do
      WriteString('skin', 'left' + Format('%0.2d', [i+1]), frmMain.LeftImages[i]);

    // Colors
    WriteInteger('colors', 'top', frmMain.clbTop.Selected);
    WriteInteger('colors', 'bottom', frmMain.clbBottom.Selected);
    WriteInteger('colors', 'left', frmMain.clbLeft.Selected);
    WriteInteger('colors', 'center', frmMain.clbCenter.Selected);
    WriteInteger('colors', 'text', frmMain.clbText.Selected);
    WriteInteger('colors', 'linksnormal', frmMain.clbLinks.Selected);
    WriteInteger('colors', 'linksclicked', frmMain.clbLinksClicked.Selected);
    WriteInteger('colors', 'linkshot', frmMain.clbLinksHot.Selected);
    WriteInteger('colors', 'warningtext', frmMain.clbWarning.Selected);

    // Media Keys
    WriteInteger('keys', 'count', frmMain.MediaHashKeys.Count);
    for i := 0 to frmMain.MediaHashKeys.Count - 1 do
    begin
      WriteString('keys', 'key' + IntToStr(i) + '_source', frmMain.lvDiscKeys.Items[i].SubItems[0]);
      WriteString('keys', 'key' + IntToStr(i) + '_value', frmMain.MediaHashKeys[i]);
    end;

    WriteString('info', 'author', frmMain.edtAuthor.Text);
    WriteString('info', 'gamename', frmMain.edtGameName.Text);
    WriteString('info', 'weburl', frmMain.edtWebURL.Text);
    WriteInteger('info', 'weburlprotocol', frmMain.cbxProtocolWebURL.ItemIndex);
    WriteString('info', 'version', frmMain.edtVersion.Text);
    WriteString('info', 'wintitle', frmMain.edtWizardTitle.Text);
    WriteBool('info', 'wintitleshow', frmMain.cbxShowAppName.Checked);
    WriteString('info', 'rlzdate', DateToStr(frmMain.edtReleaseDate.Date));
  end;
end;

initialization
  sAppConfigFile := GetApplicationDirectory + 'config.xml';
  sAppConfigID := Get
  ConfigFile := TXMLConfigurationFile.Create(sAppConfigFile, sAppConfigID);

finalization
  ConfigFile.Free;

end.

