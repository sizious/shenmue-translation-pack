unit xmlconf;

interface

uses
  Windows, SysUtils;
  
type

  TXmlConfigurationFile = class
  private

  protected

  public
    constructor Create;
    destructor Destroy; override;
    function GetNode(const Name: string): string;
  end;
  
implementation

{ TXmlConfigurationFile }

constructor TXmlConfigurationFile.Create;
begin
  raise exception.create('todo');
end;

destructor TXmlConfigurationFile.Destroy;
begin

  inherited;
end;

function TXmlConfigurationFile.GetNode(const Name: string): string;
begin

end;

end.
