unit USRFEntry;

interface

uses
  Classes, SysUtils;

type
  TSRFEntry = class
    CharID: String;
    Subtitle: String;
    NonEditable: Integer;
    FixedBlocks: TMemoryStream;
  end;

implementation

end.
