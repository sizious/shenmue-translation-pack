unit Config;

interface

uses
  Windows, SysUtils, Forms;

procedure LoadConfig;  
procedure SaveConfig;

implementation

uses
  SysTools, XMLConf, Main;

const
  CONFIG_ID = 'rlzmaker';
  
var
  ConfigFile: TXMLConfigurationFile;
  sAppConfigFile: TFileName;

procedure LoadConfig;
var
  i, c: Integer;

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
    frmMain.edtDestDir.Text := ReadString('main', 'outputdir', frmMain.edtDestDir.Text);
    frmMain.edtAppConfig.Text := ReadString('main', 'appconfig', frmMain.edtAppConfig.Text);
    frmMain.edtEULA.Text := ReadString('main', 'eula', frmMain.edtEULA.Text);
    frmMain.edtSkinTop.Text := ReadString('skin', 'top', frmMain.edtSkinTop.Text);
    frmMain.edtSkinBottom.Text := ReadString('skin', 'bottom', frmMain.edtSkinBottom.Text);
    for i := 0 to 9 do
      frmMain.LeftImages[i] := ReadString('skin', 'center' + Format('%0.2d', [i+1]), '');

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
  end;
end;

procedure SaveConfig;
var
  i: Integer;

begin
  with ConfigFile do
  begin
    WriteFormAttributes(frmMain);
    WriteString('main', 'inputdir', frmMain.edtSourceDir.Text);
    WriteString('main', 'outputdir', frmMain.edtDestDir.Text);
    WriteString('main', 'appconfig', frmMain.edtAppConfig.Text);
    WriteString('main', 'eula', frmMain.edtEULA.Text);
    WriteString('skin', 'top', frmMain.edtSkinTop.Text);
    WriteString('skin', 'bottom', frmMain.edtSkinBottom.Text);
    for i := 0 to 9 do
      WriteString('skin', 'center' + Format('%0.2d', [i+1]), frmMain.LeftImages[i]);

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
  ConfigFile := TXMLConfigurationFile.Create(sAppConfigFile, CONFIG_ID);

finalization
  ConfigFile.Free;

end.
