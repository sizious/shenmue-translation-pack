unit pakfutil;

// Function TransformImage: This flag will leave the temp images file onto disk
// {$DEFINE DEBUG_TRANSFORMIMAGE}

interface

uses
  Windows, SysUtils, ScnfUtil;

function ConvertFaceTexture(const OutputDir, PVRSourceFileName: TFileName): Boolean;
procedure ExtractFacesPatch(const GameVersion: TGameVersion);
function IsValidFaceImage(const JPEGFileName: TFileName): Boolean;
  
implementation

uses
  ExtCtrls, Graphics, Img2Png, Common, SysTools, LzmaDec, ImgTools;

//------------------------------------------------------------------------------

procedure ExtractFacesPatch(const GameVersion: TGameVersion);
var
  PatchFileName: TFileName;
  
begin
  PatchFileName := '';
  case GameVersion of
    gvShenmueJ:
      PatchFileName := 'shenmue.ptc';
    gvShenmue:
      PatchFileName := 'shenmue.ptc';
  end;

  // no patch for this game
  if PatchFileName = '' then
    Exit;

  PatchFileName := GetFacesSystemDirectory + PatchFileName;
  SevenZipExtract(PatchFileName, GetFacesImagesDirectory(GameVersion));
end;

//------------------------------------------------------------------------------

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
