{
                    * * * [b i g _ f u r y ] S i Z i O U S * * *
        _____________    _____________    _____________________________________
       /            /   /            /   /           /    /      /            /
      /     _______/___/_______     /___/           /    /      /     _______/
     /     /      /   /            /   /     /     /    /      /     /      /
    /            /   /            /   /     /     /    /      /            /
   /________/   /   /     _______/   /     /     /    /__    /_________/  /
  /            /   /            /   /           /           /            /
 /____________/___/____________/___/___________/___________/____________/
 
  OldSkool Font par [big_fury]SiZiOUS, bas� sur le commentaire de f0xi �crit le
  29/11/2006 03:04:21 sur http://www.delphifr.com/

  Version..: 2.0
  Date.....: 18 Octobre 2007 @17:46
  URL......: http://sbibuilder.shorturl.com/
  Auteur...: Quasiment pour la totalit�, f0xi. Pour le reste, moi-m�me.

  Description :

  Cette unit� permet de cr�er des chaines de caract�res dessin�es avec une
  grille de lettres bitmap. Il s'agit d'un remake de la source que j'avais
  post�, mais avec bien plus d'avantages :

  - Polyvalence : Elle permet d'utiliser des fontes bitmaps diff�rentes plus ou
    moins compl�tes et une utilisation plus large sur les traitements graphique
    en aval avec la gdi, gdi+, DirectX ou OpenGL, gr�ce � son ind�pendance
    compl�te par rapport a ces derniers.

  - Performance : routines de traitements d'indexation et mapping plus simples,
    tout est pr�-calcul� avant les lourds traitements graphiques et reste stock�
    jusqu'a la fermeture du programme. Les ressources sont plus leg�res avec une
    consomation de 255 octets seulement pour chaque table d'index et un
    traitement rapide du mapping de chaine.

  - Ludique : un d�butant saura l'utiliser et l'impl�menter sans difficult�es
    avec un minimum d'indications, un infographiste comprendra imm�diatement
    comment construire l'image de la fonte, un d�veloppeur comprendra �galement
    tr�s vite qu'il peut enregistrer dans un fichier la chaine de base pour
    l'indexation (CharsEnum) et cela pour chaque fonte, ce qui permet de
    construire des programmes plus �labor�s et plus souples niveau customisation
    ou mise � jour.

  Comment tester l'unit� :

  procedure TForm1.Button1Click(Sender: TObject);
  var
    CharsMap: TCharsMap;
    MapStr: TMappedString;
    i, NullIndex: Integer;
    string_to_map: string;
  
  begin
    // tout d'abord on initialise le tableau d'index faisant la correspondance
    // vrai caract�re ASCII <-> index dans l'image
    NullIndex := 0;
    CreateCharsMap(' !"****''()'+
                   '**,-. 0123'+
                   '456789:*<='+
                   '>**ABCDEFG'+
                   'HIJKLMNOPQ'+
                   'RSTUVWXYZ*', NullIndex, CharsMap);
    CharsMap['*'] := NullIndex; // "*" indique tous les trous
    CopyUpIndexToLo(CharsMap);

    // on cr�e la chaine mapp�e
    string_to_map := 'Hello World!';
    CreateMappedStr(string_to_map, CharsMap, MapStr);

    // on affiche le tableau r�sultant
    for i := 0 to Length(string_to_map) - 1 do
      ShowMessage(IntToStr(MapStr[i]));
  end;
}
unit oldskool_font_mapper;

interface

uses
  Types;

type
  // contient les index des caract�res dans l'image
  TCharsMap     = array[Char] of Byte;
  // permet de stocker une chaine "mapp�e"
  TMappedString = array of Byte;

procedure CreateCharsMap(const CharsEnum: string; const NullIndex: Byte; var CharsMap: TCharsMap);
procedure CreateMappedStr(const S : string; const CharsMap: TCharsMap; var MappedString: TMappedString);
procedure CopyUpIndexToLo(var CharsMap: TCharsMap);
procedure CopyLoIndexToUp(var CharsMap: TCharsMap);

implementation

//------------------------------------------------------------------------------

// Proc�dure � appeler en premier
// CharsEnum correspond aux lettres presente dans l'image
// dans l'ordre (gauche haut > droite bas) d'apparition
// NullIndex correspond a l'index "vide" pour les caracteres non presents (0 par exemple)
procedure CreateCharsMap(const CharsEnum: string; const NullIndex: Byte; var CharsMap: TCharsMap);
var
  N: integer;

begin
  // on remplit avec NullIndex
  FillChar(CharsMap, 256, NullIndex);
  
  // pour chaque caracteres pr�sent on assigne l'index dans l'image
  for N := 1 to Length(CharsEnum) do
     CharsMap[CharsEnum[N]] := N-1;
end;

//------------------------------------------------------------------------------

// proc�dure permettant de transposer les index des caract�res majuscule au caract�res minuscule
procedure CopyUpIndexToLo(var CharsMap : TCharsMap);
var
  pS, pD: ^Char;

begin
  pS := @CharsMap;
  pD := @CharsMap;
  Inc(pS, $41); {'A'}
  Inc(pD, $61); {'a'}
  Move(pS^, pD^, 26); {de 'A'..'Z' a 'a'..'z'}
end;

//------------------------------------------------------------------------------

// proc�dure permettant de transposer les index des caract�res minuscule au caract�res majuscule
procedure CopyLoIndexToUp(var CharsMap : TCharsMap);
var
  pS, pD: ^Char;
  
begin
  pS := @CharsMap;
  pD := @CharsMap;
  Inc(pS, $61); {'a'}
  Inc(pD, $41); {'A'}
  Move(pS^, pD^, 26); {de 'a'..'z' a 'A'..'Z'}
end;

//------------------------------------------------------------------------------

// Permet d'effectuer le mapping d'une chaine
// S est la chaine a mapper
// CharsMap est la table d'index a utiliser pour le mapping
// MappedString est la table d'index resultante
procedure CreateMappedStr(const S: string; const CharsMap: TCharsMap; var MappedString: TMappedString);
var
  N: integer;
  
begin
  SetLength(MappedString, Length(S));
  for N := 1 to Length(S) do
    MappedString[N-1] := CharsMap[S[N]];
end;

//------------------------------------------------------------------------------

end.
