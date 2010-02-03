unit pakfutil;

// Function TransformImage: This flag will leave the temp images file onto disk
// {$DEFINE DEBUG_TRANSFORMIMAGE}

interface

uses
  Windows, SysUtils;

function ConvertFaceTexture(const OutputDir, PVRSourceFileName: TFileName): Boolean;
function IsValidFaceImage(const JPEGFileName: TFileName): Boolean;
function IsValueInArray(SourceArray: array of string;
  ValueToSearch: string; var ArrayIndexResult: Integer): Boolean;
  
implementation

uses
  Classes, ExtCtrls, Graphics, Math, JPEG, Img2Png, Common, SysTools;

// For Rotate90 (Thanks to Jean-Yves Quéinec)
type
  TRGBArray = ARRAY[0..0] OF TRGBTriple;   // élément de bitmap (API windows)
  pRGBArray = ^TRGBArray;     // type pointeur vers tableau 3 octets 24 bits

//==============================================================================

(*
  Module permettant d'effectuer un Redimensionnement par Interpolation BiLinéaire
  l'Image résultante est bien meilleur qu'avec un redimensionnement brute
  (problème d'Aliasing)

  Créé par MORLET Alexandre en Mai 2002
  Basé sur le Code Source en C de Christophe Boyanique et Emmanuel Pinard
  L'Interpolation BiLinéaire consiste à utiliser les 4 points les
  plus proches des cordonnées calculées dans l'image source en les pondérant par
  des cooefficients inversement proportionnels à la distance et dont la somme
  vaut 1.
*)
procedure BilinearResize(var BMP: TBitmap; const NewWidth, NewHeight: Integer);
TYPE
  TRGBArray = ARRAY[0..0] OF TRGBTriple;
  PRGBArray = ^TRGBArray;
  
VAR
  X, Y : integer; //coordonnées image source
  I, J : integer; //coordonnées image destination
  Diff : ARRAY[0..3] OF double; //distance pour l'interpolation bilinéaire
  DX, DY : ARRAY[0..3] OF double;  // Coordonnees image source (points voisins, reelles)
  IX, IY : ARRAY[0..3] OF integer;   // Coordonnees image source (points voisins, entieres)
  XR, YR : double; // Coordonnees image source (reelles)
  R, G, B : ARRAY[0..3] OF integer;
  TabScanlineBMP, TabScanlineBMPF : ARRAY OF PRGBArray;
  V : double;
  BMPF : TBitmap;

BEGIN
  BMP.pixelFormat := pf24bit;

  BMPF := TBitmap.Create;

  TRY
     WITH BMPF DO
          BEGIN
          Width := NewWidth;
          Height := NewHeight;
          pixelFormat := pf24bit;
          END;

     setLength(TabScanlineBMP, BMP.Height);
     setLength(TabScanlineBMPF, BMPF.Height);

     FOR X := 0 TO BMP.Height - 1 DO
         TabScanlineBMP[X] := BMP.Scanline[X];

     FOR X := 0 TO BMPF.Height - 1 DO
         TabScanlineBMPF[X] := BMPF.Scanline[X];

     FOR J := 0 TO BMPF.Height - 1 DO
         BEGIN
         FOR I := 0 TO BMPF.Width - 1 DO
       BEGIN
       X := Trunc( -0.5 + I * BMP.Width / BMPF.Width );
       Y := Trunc( -0.5 + J * BMP.Height / BMPF.Height );

       X := Min(X, BMP.Width - 1);
       Y := Min(Y, BMP.Height - 1);
       X := Max(X, 0);
       Y := Max(Y, 0);

       XR := -0.5 + I * BMP.Width / BMPF.Width;
       YR := -0.5 + J * BMP.Height / BMPF.Height;

       XR := Min(XR, BMP.Width - 1);
       YR := Min(YR, BMP.Height - 1);
       XR := Max(XR, 0);
       YR := Max(YR, 0);

       IF (X = XR) AND (Y = YR) THEN
                BEGIN
                TabScanlineBMPF[J,I].RGBTRed := TabScanlineBMP[Y,X].RGBTRed;
                TabScanlineBMPF[J,I].RGBTGreen := TabScanlineBMP[Y,X].RGBTGreen;
                TabScanlineBMPF[J,I].RGBTBlue := TabScanlineBMP[Y,X].RGBTBlue;
                END
             ELSE
          BEGIN
          DX[0] := XR - Floor(XR);
          DY[0] := YR - Floor(YR);
                IX[0] := Trunc(Floor(XR));
                IY[0] := Trunc(Floor(YR));

          DX[1] := 1.0 - DX[0];
          DY[1] := DY[0];
                IX[1] := IX[0] + 1;
                IY[1] := IY[0];

          DX[2] := DX[0];
          DY[2] := 1.0 - DY[0];
                IX[2] := IX[0];
                IY[2] := IY[0] + 1;

          DX[3] := DX[1];
          DY[3] := DY[2];
                IX[3] := IX[1];
                IY[3] := IY[2];

          IF (DX[0] = 0) THEN
       BEGIN
       Diff[0] := 1.0 / Sqrt( DX[0]*DX[0] + DY[0]*DY[0] );
       Diff[2] := 1.0 / Sqrt( DX[2]*DX[2] + DY[2]*DY[2] );
       V := Diff[0] + Diff[2];

       R[0] := TabScanlineBMP[IY[0],IX[0]].RGBTRed;
       G[0] := TabScanlineBMP[IY[0],IX[0]].RGBTGreen;
       B[0] := TabScanlineBMP[IY[0],IX[0]].RGBTBlue;

       R[2] := TabScanlineBMP[IY[2],IX[2]].RGBTRed;
       G[2] := TabScanlineBMP[IY[2],IX[2]].RGBTGreen;
       B[2] := TabScanlineBMP[IY[2],IX[2]].RGBTBlue;

       TabScanlineBMPF[J,I].RGBTRed := Trunc((R[0] * Diff[0] + R[2] * Diff[2]) / V);
       TabScanlineBMPF[J,I].RGBTGreen := Trunc((G[0] * Diff[0] + G[2] * Diff[2]) / V);
       TabScanlineBMPF[J,I].RGBTBlue := Trunc((B[0] * Diff[0] + B[2] * Diff[2]) / V);
       END
                ELSE IF (DY[0] = 0) THEN
                        BEGIN
            Diff[0] := 1.0 / Sqrt (DX[0]*DX[0] + DY[0]*DY[0]);
            Diff[1] := 1.0 / Sqrt (DX[1]*DX[1] + DY[1]*DY[1]);
            V := Diff[0] + Diff[1];

            R[0] := TabScanlineBMP[IY[0], IX[0]].RGBTRed;
            G[0] := TabScanlineBMP[IY[0], IX[0]].RGBTGreen;
            B[0] := TabScanlineBMP[IY[0], IX[0]].RGBTBlue;

                        R[1] := TabScanlineBMP[IY[1], IX[1]].RGBTRed;
            G[1] := TabScanlineBMP[IY[1], IX[1]].RGBTGreen;
            B[1] := TabScanlineBMP[IY[1], IX[1]].RGBTBlue;

            TabScanlineBMPF[J,I].RGBTRed := Trunc((R[0] * Diff[0] + R[1] * Diff[1]) / V);
            TabScanlineBMPF[J,I].RGBTGreen := Trunc((G[0] * Diff[0] + G[1] * Diff[1]) / V);
            TabScanlineBMPF[J,I].RGBTBlue := Trunc((B[0] * Diff[0] + B[1] * Diff[1]) / V);
                        END
                ELSE
            BEGIN
            Diff[0] := 1.0 / Sqrt( DX[0]*DX[0] + DY[0]*DY[0]);
            Diff[1] := 1.0 / Sqrt( DX[1]*DX[1] + DY[1]*DY[1]);
            Diff[2] := 1.0 / Sqrt( DX[2]*DX[2] + DY[2]*DY[2]);
            Diff[3] := 1.0 / Sqrt( DX[3]*DX[3] + DY[3]*DY[3]);
            V := Diff[0] + Diff[1] + Diff[2] + Diff[3];

            R[0] := TabScanlineBMP[IY[0], IX[0]].RGBTRed;
            G[0] := TabScanlineBMP[IY[0], IX[0]].RGBTGreen;
            B[0] := TabScanlineBMP[IY[0], IX[0]].RGBTBlue;

            R[1] := TabScanlineBMP[IY[1], IX[1]].RGBTRed;
            G[1] := TabScanlineBMP[IY[1], IX[1]].RGBTGreen;
            B[1] := TabScanlineBMP[IY[1], IX[1]].RGBTBlue;

            R[2] := TabScanlineBMP[IY[2], IX[2]].RGBTRed;
            G[2] := TabScanlineBMP[IY[2], IX[2]].RGBTGreen;
            B[2] := TabScanlineBMP[IY[2], IX[2]].RGBTBlue;

            R[3] := TabScanlineBMP[IY[3], IX[3]].RGBTRed;
            G[3] := TabScanlineBMP[IY[3], IX[3]].RGBTGreen;
            B[3] := TabScanlineBMP[IY[3], IX[3]].RGBTBlue;

            TabScanlineBMPF[J,I].RGBTRed :=
            Trunc((R[0] * Diff[0] + R[1] * Diff[1] + R[2] * Diff[2] + R[3] * Diff[3]) / V);

            TabScanlineBMPF[J,I].RGBTGreen :=
            Trunc((G[0] * Diff[0] + G[1] * Diff[1] + G[2] * Diff[2] + G[3] * Diff[3]) / V);

            TabScanlineBMPF[J,I].RGBTBlue :=
            Trunc((B[0] * Diff[0] + B[1] * Diff[1] + B[2] * Diff[2] + B[3] * Diff[3]) / V);
            END;
                END;
             END;
         END;
  BMP.Assign(BMPF);

  FINALLY BMPF.Free; TabScanlineBMP := nil ; TabScanlineBMPF := nil; END;
end;

//------------------------------------------------------------------------------

function IsValueInArray(SourceArray: array of string;
  ValueToSearch: string; var ArrayIndexResult: Integer): Boolean;
var
  i: Integer;

begin
  Result := False;
  i := Low(SourceArray);
  while (not Result) and (i <= High(SourceArray)) do begin
    Result := (Pos(SourceArray[i], ValueToSearch) > 0);
    if not Result then
      Inc(i);
  end;
  if Result then
    ArrayIndexResult := i
  else
    ArrayIndexResult := -1;
end;

//------------------------------------------------------------------------------

// Thanks to Jean-Yves Quéinec (Sample from Phidels.com)
Procedure Bmprot90(Bitmap : TBitmap; aa : integer);
type
  TManoRGB  = packed record
                 rgb    : TRGBTriple;
                 dummy  : byte;
               end;
var
  aStream : TMemorystream;          // zone mémoire
  header  : TBITMAPINFO;            // header bitmap
  dc      : hDC;                    // ressource pour GetDIBits
  P       : ^TManoRGB;              // pointeur vers 4 octets
  RowOut:  pRGBArray;               // pointeur vers 3 octets
  x,y,h,w: Integer;

BEGIN
  aStream := TMemoryStream.Create;                 // réservation mémoire
  aStream.SetSize(Bitmap.Height*Bitmap.Width * 4); // chaque pixel = 4 octets
  with header.bmiHeader do begin                   // bitmap mémoire
    biSize := SizeOf(TBITMAPINFOHEADER);
    biWidth := Bitmap.Width;
    biHeight := Bitmap.Height;
    biPlanes := 1;
    biBitCount := 32;              // 32 bits par pixel = 4 octets
    biCompression := 0;
    biSizeimage := aStream.Size;
    biXPelsPerMeter :=1;
    biYPelsPerMeter :=1;
    biClrUsed :=0;
    biClrImportant :=0;
  end;
  dc := GetDC(0);                  // folklore des ressources GDI windows
  P  := aStream.Memory;
  // copie du bitmap dans le flux (stream). Passe de 3 à 4 octets
  GetDIBits(dc,Bitmap.Handle,0,Bitmap.Height,P,header,dib_RGB_Colors);
  ReleaseDC(0,dc);                 // folklore des ressources GDI windows
  w := bitmap.Height;
  h := bitmap.Width;
  bitmap.Width  := w;              // permute largeur / hauteur
  bitmap.height := h;
  if aa = 90 then
  begin
    for y := 0 to (h-1) do     // boucle pilotée par y et x coodonnées sortie
    begin
      rowOut := Bitmap.ScanLine[y]; // sortie 3 octets = 24 bits par pixels
      P  := aStream.Memory;
      inc(p,y);                    // p = adresse ligne du stream
      for x := 0 to (w-1) do
      begin
        rowout[x] := p^.rgb;        // copie 3 octets sur les 4 du stream
        inc(p,h);                   // parcours de la ligne du stream
      end;
    end;
  end
  else
  begin
    for y := 0 to (h-1) do
    begin
      rowOut := Bitmap.ScanLine[(h-1)-y];
      P  := aStream.Memory;
      inc(p,y);
      for x := (w-1) downto 0 do
      begin
        rowout[x] := p^.rgb;
        inc(p,h);
      end;
    end;
  end;
  aStream.Free;
  //affiche;
end;

//------------------------------------------------------------------------------

// Thanks to Jean-Yves Quéinec (Sample from Phidels.com)
procedure Rotate90(RStyle : Integer; var Bitmap: TBitmap);
var
  ResultBitmap: TBitmap;
  
begin
  ResultBitmap := TBitmap.Create;
  try
    // bmp2 est le bitmap résultat
    ResultBitmap.Width  := Bitmap.Width;
    ResultBitmap.Height := Bitmap.Height;
    case RStyle of
      0 : ResultBitmap.Canvas.Draw(0, 0, Bitmap);   //  0° simple copie
      1, 3 :
          begin
            ResultBitmap.Canvas.Draw(0, 0, Bitmap);
            ResultBitmap.PixelFormat := pf24bit;
            if RStyle = 1 then
              Bmprot90(ResultBitmap, 90)
            else
              Bmprot90(ResultBitmap, 270);
          end;
      2 : ResultBitmap.Canvas
            .StretchDraw(Rect(Bitmap.Width - 1, Bitmap.Height - 1, -1, -1), Bitmap);
      4 : ResultBitmap.Canvas
            .StretchDraw(Rect(Bitmap.Width - 1, 0, -1, Bitmap.Height), Bitmap);
      5 : ResultBitmap.Canvas
            .StretchDraw(Rect(0, Bitmap.Height - 1, Bitmap.Width, -1), Bitmap);
    end;

    // On copie le Bitmap final dans le Bitmap source
    Bitmap.Assign(ResultBitmap);
  finally
    ResultBitmap.Free;
  end;
end;

//------------------------------------------------------------------------------

// Thanks to Zarko Gajic
function BitmapToJPEG(var Bitmap: TBitmap; JPEGOutputFile: TFileName): Boolean;
var
  JpegImg: TJpegImage;
  
begin
  Result := False;
  JpegImg := TJpegImage.Create;
  try
    try
      JpegImg.Assign(Bitmap);
      JpegImg.SaveToFile(JPEGOutputFile);
      Result := FileExists(JPEGOutputFile);
    except
      on E:Exception do begin
{$IFDEF DEBUG}
        WriteLn('BitmapToJPEG: "', StringReplace(E.Message, sLineBreak, ' ', [rfReplaceAll]),
          ' [ClassName: ', E.ClassName, ']');
{$ENDIF}
        raise Exception.Create('BitmapToJPEG: ' + E.Message);
      end;
    end;
  finally
    JpegImg.Free;
  end;
end;

//==============================================================================

function IsValidFaceImage(const JPEGFileName: TFileName): Boolean;
const
  ERRORNOUS_JPEG_SIZE = 809; // bytes
  
begin
  Result := FileExists(JPEGFileName) and (GetFileSize(JPEGFileName) > ERRORNOUS_JPEG_SIZE);
end;

//------------------------------------------------------------------------------

function TransformImage(const PNGInputFileName: TFileName): Boolean;
var
  TargetFileName: TFileName;
  Image: TImage;
  Bitmap: TBitmap;

begin
  Result := False;
  TargetFileName := ChangeFileExt(PNGInputFileName, '.JPG');
  
  Bitmap := TBitmap.Create;
  Image := TImage.Create(nil);
  try
    try
      // Load the raw PNG
      Image.Picture.LoadFromFile(PNGInputFileName);

      // Prepare Bitmap and FinalBitmap
      Bitmap.Height := Image.Picture.Height;
      Bitmap.Width := Image.Picture.Width;

      // Save the PNG to the Bitmap
      Bitmap.Canvas.Draw(0, 0, Image.Picture.Graphic);
{$IFDEF DEBUG}{$IFDEF DEBUG_TRANSFORMIMAGE}
      Bitmap.SaveToFile(ChangeFileExt(TargetFileName, '-Start.BMP'));
{$ENDIF}{$ENDIF}

      // Rotate the Bitmap by 180°      
      Rotate90(2, Bitmap);
{$IFDEF DEBUG}{$IFDEF DEBUG_TRANSFORMIMAGE}
      Bitmap.SaveToFile(ChangeFileExt(TargetFileName, '-Rotate.BMP'));
{$ENDIF}{$ENDIF}

      // Resize the 128x128 picture to FACE_WIDTH x FACE_HEIGHT
      BilinearResize(Bitmap, FACE_WIDTH, FACE_HEIGHT);
{$IFDEF DEBUG}{$IFDEF DEBUG_TRANSFORMIMAGE}
      Bitmap.SaveToFile(ChangeFileExt(TargetFileName, '-BilinearResize.BMP'));
{$ENDIF}{$ENDIF}

      // Save the final JPEG
      Result := BitmapToJPEG(Bitmap, TargetFileName);

      // Verifing the size of the JPEG
      Result := IsValidFaceImage(TargetFileName);

{$IFDEF DEBUG}
      if not Result then begin
        WriteLn('ResizeImage: Conversion FAILED! File: "',
          ExtractFileName(TargetFileName), '".');
{$IFDEF DEBUG_TRANSFORMIMAGE}
        Bitmap.SaveToFile(ChangeFileExt(TargetFileName, '.BMP'));
{$ENDIF}
      end;
{$ENDIF}

    except
      on E:Exception do begin
{$IFDEF DEBUG}
        WriteLn('ResizeImage: "', StringReplace(E.Message, sLineBreak, ' ', [rfReplaceAll]),
          ' [ClassName: ', E.ClassName, ']');
{$ENDIF}
        raise Exception.Create('ResizeImage: ' + E.Message);
      end;
    end;
  finally
    Image.Free;
    Bitmap.Free;
  end;
end;

//------------------------------------------------------------------------------

function ConvertFaceTexture(const OutputDir, PVRSourceFileName: TFileName): Boolean;
var
  PVRConverter: TPVRConverter;

begin
  Result := False;
  PVRConverter := TPVRConverter
    .Create(OutputDir{$IFDEF DEBUG}{$IFDEF DEBUG_TRANSFORMIMAGE}, False{$ENDIF}{$ENDIF});
  try
    if PVRConverter.LoadFromFile(PVRSourceFileName) then begin
      Result := TransformImage(PVRConverter.TargetFileName);
      if FileExists(PVRSourceFileName) then // Deleting PVR source file
        DeleteFile(PVRSourceFileName);
    end;
  finally
    PVRConverter.Free;
  end;
end;

//------------------------------------------------------------------------------

end.
