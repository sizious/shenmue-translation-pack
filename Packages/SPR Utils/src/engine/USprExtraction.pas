//    This file is part of SPR Utils.
//
//    You should have received a copy of the GNU General Public License
//    along with SPR Utils.  If not, see <http://www.gnu.org/licenses/>.

unit USprExtraction;

interface

uses
  Classes, SysUtils, Math, Forms, ActiveX, UIntList, progress, USprStruct;

type
  TSprExtraction = class(TThread)
  private
    { Déclarations privées }
    fSrcFileName: TFileName;
    fOutDir: TFileName;
    fQueue: TIntList;
    SPRStruct: TSprStruct;
    WriteXMLList: Boolean;
    fTempName: TFileName;
    FProgressWindow: TfrmProgress;
    procedure CopyDataToFile(const Offset, Size: Integer; var F_src: File; var F_out: File);
    procedure UpdatePercentage;
    procedure UpdateCurrentFile;
    procedure UpdateDefaultFormValue;
    procedure SyncPercentage;
    procedure SyncCurrentFile(const FileName: TFileName);
    procedure SyncDefaultFormValue;
    procedure CancelBntClick(Sender: TObject);
    procedure CloseThread(Sender: TObject);
  protected
    procedure Execute; override;
  public
    ThreadTerminated: Boolean;
    constructor Create(const FileName, OutputDir: TFileName; var IndexList: TIntList; const WriteXML: Boolean);
  end;

implementation
uses xmlutils;
{ TSprExtraction }

constructor TSprExtraction.Create(const FileName, OutputDir: TFileName; var IndexList: TIntList; const WriteXML: Boolean);
begin
  FreeOnTerminate := True;
  inherited Create(False);

  fSrcFileName := FileName;
  fOutDir := OutputDir;
  fQueue := IndexList;
  WriteXMLList := WriteXML;
  FProgressWindow := TfrmProgress.Create(nil);
  OnTerminate := CloseThread;
end;

procedure TSprExtraction.Execute;
var
  F_spr, F_out: File;
  i, j: Integer; //, noNameCnt: Integer;
  fOutName: string; //, fFormat: String;
begin
  CoInitialize(nil);
//  noNameCnt := 0;

  //Opening SPR for reading
  AssignFile(F_spr, fSrcFileName);
  FileMode := fmOpenRead;
  {$I-}Reset(F_spr, 1);{$I+}
  if IOResult <> 0 then Terminate;

  //Loading SPR file infos
  SPRStruct := TSprStruct.Create;
  SPRStruct.LoadFromFile(fSrcFileName);

  SyncDefaultFormValue;

  for i := 0 to fQueue.Count - 1 do begin
    if not Terminated then begin
      j := fQueue[i];

      (*if SPRStruct.Items[j].TextureName = '' then begin
        fOutName := 'noname'+IntToStr(noNameCnt);
        Inc(noNameCnt);
      end
      else begin
        fOutName := CorrectTextureFileName(SPRStruct.Items[j].TextureName);
      end;

      fFormat := SPRStruct.Items[j].Format;
      if fFormat = 'DDS' then begin
        fOutName := fOutName + '.dds';
      end
      else if fFormat = 'PVR' then begin
        fOutName := fOutName + '.pvr';
      end
      else begin
        fOutName := fOutName + '.bin';
      end;*)

      fOutName := GenerateTextureFileName(SPRStruct.Items[j]);

      //Assigning output file
      AssignFile(F_out, fOutDir + fOutName);
      FileMode := fmOpenWrite;
      ReWrite(F_out, 1);

      //Updating progress window current file
      SyncCurrentFile(fOutName);

      //Data copy
      CopyDataToFile(SPRStruct.Items[j].Offset, SPRStruct.Items[j].Size, F_spr, F_out);
      CloseFile(F_out);

      //Updating progress window percentage
      SyncPercentage;
    end
    else begin
      Break;
    end;
  end;

  if WriteXMLList then begin
    SaveQueueToXML(fOutDir+ExtractFileName(fSrcFileName)+'.xml', SPRStruct, fQueue);
  end;

  CloseFile(F_spr);
  SPRStruct.Free;

  CoUnInitialize;
end;

procedure TSprExtraction.CopyDataToFile(const Offset, Size: Integer; var F_src: File; var F_out: File);
const
  WORK_BUFFER_SIZE = 16384;
var
  Buf: array[0..WORK_BUFFER_SIZE-1] of Byte;
  i, j, BufSize: Integer;
  _Last_BufSize_Entry: Integer;
begin
  //Seeking to file data
  Seek(F_src, Offset);

  //Calculating...
  BufSize := SizeOf(Buf);
  _Last_BufSize_Entry := Size mod BufSize;
  j := Size div BufSize;

  //Copying data
  for i := 0 to j - 1 do
  begin
    BlockRead(F_src, Buf, SizeOf(Buf), BufSize);
    BlockWrite(F_out, Buf, BufSize);
  end;
  BlockRead(F_src, Buf, _Last_BufSize_Entry, BufSize);
  BlockWrite(F_out, Buf, BufSize);
end;

procedure TSprExtraction.UpdatePercentage;
var
  i: Integer;
  floatBuf: Real;
begin
  with FProgressWindow do begin
    i := ProgressBar1.Position;
    ProgressBar1.Position := i + 1;
    floatBuf := SimpleRoundTo((100*(i+1))/ProgressBar1.Max, -2);
    Panel1.Caption := FloatToStr(floatBuf)+'%';
    Application.ProcessMessages;
  end;
end;

procedure TSprExtraction.UpdateCurrentFile;
begin
  FProgressWindow.lblCurrentTask.Caption := 'Current file: ' + fTempName;
end;

procedure TSprExtraction.UpdateDefaultFormValue;
var
  srcFileName: TFileName;
begin
  with FProgressWindow do begin
    srcFileName := fSrcFileName;
    Position := poMainFormCenter;
    Caption := 'Extraction in progress... ' + ExtractFileName(srcFileName);
    ProgressBar1.Max := fQueue.Count;
    Panel1.Caption := '0%';
    btCancel.OnClick := CancelBntClick;
    Show;
  end;
end;

procedure TSprExtraction.SyncPercentage;
begin
  Synchronize(UpdatePercentage);
end;

procedure TSprExtraction.SyncCurrentFile(const FileName: TFileName);
begin
  fTempName := FileName;
  Synchronize(UpdateCurrentFile);
end;

procedure TSprExtraction.SyncDefaultFormValue;
begin
  Synchronize(UpdateDefaultFormValue);
end;

procedure TSprExtraction.CancelBntClick(Sender: TObject);
begin
  Terminate;
end;

procedure TSprExtraction.CloseThread(Sender: TObject);
begin
  if Assigned(FProgressWindow) then begin
    FProgressWindow.Release;
  end;
  ThreadTerminated := True;
end;

end.
