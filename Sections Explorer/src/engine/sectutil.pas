unit SectUtil;

interface

uses
  Windows, SysUtils;
  
type
  TSectionInfo = record
    Name: string;
    Extension: string;
    Description: string;
  end;

function QuerySectionInfo(const SectionName: string;
  var SectionInfo: TSectionInfo): Boolean;

implementation

const
  SECTIONS_INFO: array[0..5] of TSectionInfo = (
    (Name: 'ATTR'; Extension: 'ATR'; Description: 'Attributes'),
    (Name: 'DYNA'; Extension: 'DYN'; Description: 'Dynamic Data'),
    (Name: 'LGHT'; Extension: 'LGT'; Description: 'Light Data'),
    (Name: 'SCN3'; Extension: 'SCN'; Description: 'Scene Data'),
    (Name: 'ECAM'; Extension: 'CAM'; Description: 'Camera Data'),
    (Name: 'END' ; Extension: 'END'; Description: 'File Footer Mark')
  );

function QuerySectionInfo(const SectionName: string;
  var SectionInfo: TSectionInfo): Boolean;
var
  i, MaxIndex: Integer;

begin
  Result := False;
  i := Low(SECTIONS_INFO);
  MaxIndex := High(SECTIONS_INFO);
  while not Result and (i < MaxIndex) do begin
    Inc(i);
    Result := SameText(SECTIONS_INFO[i].Name, SectionName);
  end;

  if Result then
    SectionInfo := SECTIONS_INFO[i];
end;

end.
