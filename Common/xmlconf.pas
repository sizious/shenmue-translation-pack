unit xmlconf;

interface

uses
  Windows, SysUtils;
  
type
  TNodeInfo = class
  public
    function ReadString(): Boolean;
  end;

  TXmlConfigurationFile = class
  private

  protected

  public
    constructor Create;
    destructor Destroy; override;
    function GetNode(const Name: string): TNodeInfo;
  end;
  
implementation

end.
