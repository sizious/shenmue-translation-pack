unit pvr2png_intf;

interface

uses
  Windows, SysUtils, Classes, Pvr2Png;

function RetrieveTextureInfo(const Index: Integer): TPVRConverter;

implementation

uses
  Common, Main;
  
type
  TPVRConverterThread = class(TThread)
  private
    fTargetIndex: Integer;
  protected
    procedure Execute; override;
  public
    property TargetIndex: Integer read fTargetIndex write fTargetIndex;
  end;

function RetrieveTextureInfo(const Index: Integer): TPVRConverter;
var
  PVRThread: TPVRConverterThread;

begin

end;

{ TPVRConverterThread }

procedure TPVRConverterThread.Execute;
begin
  { Placez le code du thread ici }
(*  TPVRConverter.Create;
      TmpPvr := ModelEditor.Textures[i].ExportToFolder(GetWorkingDirectory);
      if TPVRConverter(Data).LoadFromFile(TmpPvr) then
        DeleteFile(TmpPvr); *)
end;



end.
