unit tools;

interface

uses
  Windows, SysUtils;

function GetFullStringVersion: string;
function GetShortStringVersion: string;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  XMLDom, XMLIntf, MSXMLDom, XMLDoc, ActiveX, Variants, Main, ShellApi;

type
  TApplicationFileVersion = record
    Major,
    Minor,
    Release,
    Build: Integer;
  end;
  
var
  AppDir,
  ConfigFileName: TFileName;

//------------------------------------------------------------------------------
//
// Procédure de lecture du numéro de version de l'application
//    Par Nono40 et publiée sur nono40.developpez.com
//
// Si le numéro de version est trouvé, la réponse est du style '2.1.3.154'
// Si le numéro de version n'est pas trouvé, la réponse est ''
//
function GetApplicationFileVersion: TApplicationFileVersion;
const
  FRENCH_LANG_CODE = '100904E4';
  
Var
  Chaine:String;
  i     :Integer;

  function _FileVersion(LanguageCode: string): string;
  Var
    S         : String;
    Taille    : DWord;
    Buffer    : PChar;
    VersionPC : PChar;
    VersionL  : DWord;

  Begin
    Result:='';
    {--- On demande la taille des informations sur l'application ---}
    S := ParamStr(0);
    Taille := GetFileVersionInfoSize(PChar(S), Taille);
    Buffer := nil;
    If Taille>0
    Then Try
    {--- Réservation en mémoire d'une zone de la taille voulue ---}
      Buffer := AllocMem(Taille);
    {--- Copie dans le buffer des informations ---}
      GetFileVersionInfo(PChar(S), 0, Taille, Buffer);
    {--- Recherche de l'information de version ---}
      If VerQueryValue(Buffer, PChar('\StringFileInfo\' + LanguageCode
        + '\FileVersion'), Pointer(VersionPC), VersionL) Then
          Result:=VersionPC;
    Finally
      FreeMem(Buffer, Taille);
    End;
  end;

begin
  Chaine := _FileVersion(FRENCH_LANG_CODE);

  Result.Major := -1;
  Result.Minor := -1;
  Result.Release := -1;
  Result.Build := -1;

  If Chaine <> '' then Begin
    i:=Pos('.',Chaine);
    If i>1
    Then Begin
      Result.Major:=StrToIntDef(Copy(Chaine,1,i-1), -1);
      Chaine:=Copy(Chaine,i+1,Length(Chaine)-i);
      i:=Pos('.',Chaine);
      If i>1
      Then Begin
        Result.Minor:=StrToIntDef(Copy(Chaine,1,i-1), -1);
        Chaine:=Copy(Chaine,i+1,Length(Chaine)-i);
        i:=Pos('.',Chaine);
        If i>1
        Then Begin
          Result.Release:=StrToIntDef(Copy(Chaine,1,i-1), -1);
          Result.Build:=StrToIntDef(Copy(Chaine,i+1,Length(Chaine)-i), -1);
        End;
      End;
    End;
  End;
End;

//------------------------------------------------------------------------------

function GetFullStringVersion: string;
var
  Version: TApplicationFileVersion;

begin
  Version := GetApplicationFileVersion;
  Result := IntToStr(Version.Major) + '.' + IntToStr(Version.Minor) + '.' +
    IntToStr(Version.Release) + '.' + IntToStr(Version.Build);
end;

//------------------------------------------------------------------------------

function GetShortStringVersion: string;
var
  Version: TApplicationFileVersion;

begin
  Version := GetApplicationFileVersion;
  Result := IntToStr(Version.Major) + '.' + IntToStr(Version.Minor);
end;

//------------------------------------------------------------------------------

end.
