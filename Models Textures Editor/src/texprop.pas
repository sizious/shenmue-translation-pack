unit texprop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, img2png;

type
  TfrmTexProp = class(TForm)
    lvTexturesProperties: TListView;
  private
    { Déclarations privées }
    procedure AddProp(const Name: string; Value: string); overload;
    procedure AddProp(const Name: string; Value: Integer); overload;
    procedure AddProp(const Name: string; Value: Boolean); overload;
    procedure AddProp_TextureType(TextureType: TTextureType);
    procedure AddProp_PixelFormat(PixelFormat: TPixelFormat);
    procedure AddProp_FileFormat(FileFormat: TFileFormat);
    procedure AddProp_FileType(FileType: TFileType);
  public
    { Déclarations publiques }
    procedure Clear;
    procedure UpdateProperties(PVRConverter: TPVRConverter);
  end;

var
  frmTexProp: TfrmTexProp;

implementation

uses
  TypInfo;
  
{$R *.dfm}

{ TfrmTexProp }

procedure TfrmTexProp.AddProp(const Name: string; Value: string);
begin
  with lvTexturesProperties.Items.Add do begin
    Caption := Name;
    SubItems.Add(Value);
  end;
end;

procedure TfrmTexProp.AddProp(const Name: string; Value: Integer);
begin
  AddProp(Name, IntToStr(Value));
end;

procedure TfrmTexProp.AddProp(const Name: string; Value: Boolean);
var
  V: string;

begin
  if Value then V := 'Yes' else V := 'No';  
  AddProp(Name, V);
end;

procedure TfrmTexProp.AddProp_FileFormat(FileFormat: TFileFormat);
begin
  case FileFormat of
    ffUnknow    : AddProp('File format', 'Unknow');
    ffPVR       : AddProp('File format', 'PVR');
    ffDDS       : AddProp('File format', 'DDS');
    ffPVRX      : AddProp('File format', 'PVR-X');
    ffGBIXPVRX  : AddProp('File format', 'GBIX / PVRX');
  end;
end;                                 

procedure TfrmTexProp.AddProp_FileType(FileType: TFileType);
var
  Value: string;
  
begin
  Value := GetEnumName(TypeInfo(TFileType), Ord(FileType));
  Value := Copy(Value, 3, Length(Value) - 2);
  AddProp('File plateform type', Value);
end;

procedure TfrmTexProp.AddProp_PixelFormat(PixelFormat: TPixelFormat);
var
  Value: string;
  
begin
  Value := GetEnumName(TypeInfo(TPixelFormat), Ord(PixelFormat));
  Value := Copy(Value, 3, Length(Value) - 2);
  AddProp('Pixel format', Value);
end;

procedure TfrmTexProp.AddProp_TextureType(TextureType: TTextureType);
var
  Value: string;

begin
  if TextureType = ttNotApplicable then
    Value := '(Not applicable)'
  else begin
    Value := GetEnumName(TypeInfo(TTextureType), Ord(TextureType));
    Value := Copy(Value, 3, Length(Value) - 2);
  end;
  AddProp('Encoding', Value);
end;

procedure TfrmTexProp.Clear;
begin
  lvTexturesProperties.Clear;
end;

procedure TfrmTexProp.UpdateProperties(PVRConverter: TPVRConverter);
begin
  lvTexturesProperties.Clear;

  AddProp('Data size', PVRConverter.DataSize);
  AddProp_TextureType(PVRConverter.Encoding);
  AddProp_FileFormat(PVRConverter.FileFormat);
  AddProp_FileType(PVRConverter.FileType);
  AddProp('Global index', PVRConverter.GlobalIndex);
  AddProp('Height', PVRConverter.Height);
  if PVRConverter.FileType = ftDreamcast then
    AddProp('MipMap', PVRConverter.MipMap)
  else
    AddProp('MipMap', '(Don''t know)');
  AddProp_PixelFormat(PVRConverter.PixelFormat);
  AddProp('Width', PVRConverter.Width);
end;

end.
