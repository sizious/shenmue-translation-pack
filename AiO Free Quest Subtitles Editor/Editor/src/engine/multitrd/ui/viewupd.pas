unit viewupd;

interface

uses
  Windows, SysUtils, Classes, ComCtrls, CharsLst;

type
  TNodesViewOperation = (nvoExpandAll, nvoCollapseAll, nvoDecodeText,
    nvoEncodeText);

  TMTViewUpdater = class(TThread)
  private
    fItemsCount: Integer;
    fCurrentIndex: Integer;
    fStrBuf: string;
    fOperation: TNodesViewOperation;
    fCharsList: TSubsCharsList;
  protected
    procedure Execute; override;
    procedure UpdatePercentage;
    procedure UpdateProgressOperation(const Operation: string);
    procedure SyncInitializeWindow;
    procedure SyncUpdateProgressOperation;
    procedure SyncUpdateNodesState;
    procedure SyncUpdateListView;
    procedure SyncUpdateTextFields;
  public
    constructor Create(OperationType: TNodesViewOperation);
    property CharsList: TSubsCharsList read fCharsList write fCharsList;
    property Operation: TNodesViewOperation read fOperation;
  end;
  
procedure GlobalTranslationUpdateView(const Operation: TNodesViewOperation);

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  ScnfUtil, Common, Main, Progress, TextData;

procedure GlobalTranslationUpdateView(const Operation: TNodesViewOperation);
begin
  MultiTranslationViewUpdater := TMTViewUpdater.Create(Operation);
  MultiTranslationViewUpdater.Priority := tpHigher;
  frmProgress.Mode := pmMultiViewUpdater;
  MultiTranslationViewUpdater.Resume;
  frmProgress.ShowModal;
end;

{ TMTUIUpdateNodesState }

constructor TMTViewUpdater.Create(OperationType: TNodesViewOperation);
begin
  FreeOnTerminate := True;
  fOperation := OperationType;
  inherited Create(True);
end;

procedure TMTViewUpdater.Execute;
var
  i: Integer;

begin
  Synchronize(SyncInitializeWindow);

  case Operation of
    nvoExpandAll:
      UpdateProgressOperation('Expanding all nodes...');
    nvoCollapseAll:
      UpdateProgressOperation('Collapsing all nodes...');
    nvoDecodeText:
      UpdateProgressOperation('Decoding subtitles...');
    nvoEncodeText:
      UpdateProgressOperation('Encoding subtitles...');
  end;

  // Expanding or Collapsing nodes...
  if (Operation = nvoExpandAll) or (Operation = nvoCollapseAll) then begin
    for i := 0 to fItemsCount - 1 do begin
      fCurrentIndex := i;
      if Terminated then Break;
      Synchronize(SyncUpdateNodesState);
      UpdatePercentage;
    end;
  end;

  // Encoding or decoding text with Chars List
  if (Operation = nvoDecodeText) or (Operation = nvoEncodeText) then begin
    CharsList := TSubsCharsList.Create;
    try

      for i := 0 to fItemsCount - 1 do begin
        fCurrentIndex := i;
        if Terminated then Break;
        Synchronize(SyncUpdateListView);
        UpdatePercentage;
      end;

      Synchronize(SyncUpdateTextFields);
    finally
      CharsList.Free;
    end;
  end;

end;

procedure TMTViewUpdater.SyncUpdateNodesState;
var
  Node: TTreeNode;
  NodeType: TMultiTranslationNodeType;
  
begin
  Node := frmMain.tvMultiSubs.Items[fCurrentIndex];
  NodeType := PMultiTranslationNodeType(Node.Data)^;
  if NodeType.NodeViewType = nvtSubtitleKey then begin
    case Operation of
      nvoExpandAll: Node.Expand(False);
      nvoCollapseAll: Node.Collapse(False);
    end;
  end;
end;

procedure TMTViewUpdater.SyncInitializeWindow;
begin
  fItemsCount := frmMain.tvMultiSubs.Items.Count;
  frmProgress.pbar.Max := fItemsCount;
  frmProgress.pbar.Position := 0;
end;

procedure TMTViewUpdater.SyncUpdateProgressOperation;
begin
  frmProgress.lInfos.Caption := fStrBuf;
end;

procedure TMTViewUpdater.SyncUpdateTextFields;
var
  NodeType: TMultiTranslationNodeType;
  
begin
  with frmMain do begin
    if Assigned(GlobalTranslation.SelectedHashKeySubNode) then begin
      NodeType :=
        PMultiTranslationNodeType(GlobalTranslation.SelectedHashKeySubNode.Data)^;
      CharsList.Active := CharsList.LoadFromFile(GetCorrectCharsList(NodeType.GameVersion));

      if CharsList.Active then begin
        mMTNewSub.OnChange := nil;
        case Operation of
          nvoDecodeText:
            begin
              mMTOldSub.Text := CharsList.DecodeSubtitle(mMTOldSub.Text);
              mMTNewSub.Text := CharsList.DecodeSubtitle(mMTNewSub.Text);
              mMTOldSub.Text := StringReplace(mMTOldSub.Text, '<br>', #13#10, [rfReplaceAll]);
              mMTNewSub.Text := StringReplace(mMTNewSub.Text, '<br>', #13#10, [rfReplaceAll]);
            end;
          nvoEncodeText:
            begin
              mMTOldSub.Text := CharsList.EncodeSubtitle(mMTOldSub.Text);
              mMTNewSub.Text := CharsList.EncodeSubtitle(mMTNewSub.Text);
              mMTOldSub.Text := StringReplace(mMTOldSub.Text, #13#10, TABLE_STR_CR, [rfReplaceAll]);
              mMTNewSub.Text := StringReplace(mMTNewSub.Text, #13#10, TABLE_STR_CR, [rfReplaceAll]);
            end;
        end;
        mMTNewSub.OnChange := mMTNewSubChange;
      end; // CharsList.Active

    end else // Assigned(MultiTranslationSelectedHashKeySubNode)
      case Operation of
        nvoDecodeText: AddDebug('WARNING: Unable to decode Old / New text fields!');
        nvoEncodeText: AddDebug('WARNING: Unable to encode Old / New text fields!');
      end;
  end;
end;

procedure TMTViewUpdater.SyncUpdateListView;
var
  Node: TTreeNode;
  SubsList: ISubtitleInfoList;
  NodeType: TMultiTranslationNodeType;

begin
  Node := frmMain.tvMultiSubs.Items[fCurrentIndex];
  NodeType := PMultiTranslationNodeType(Node.Data)^;

  // Load appropriate Chars List
  CharsList.Active :=
    CharsList.LoadFromFile(GetCorrectCharsList(NodeType.GameVersion));

  if CharsList.Active then begin
    // The node is the Subtitle Key
    if NodeType.NodeViewType = nvtSubtitleKey then begin

      with frmMain.GlobalTranslation.TextDataList do
        SubsList := GetSubtitleInfo(Subtitles[Node.Index]);

      if Assigned(SubsList) then begin
        case Operation of
          nvoDecodeText: Node.Text := CharsList.DecodeSubtitle(Node.Text);
          nvoEncodeText: Node.Text := CharsList.EncodeSubtitle(Node.Text);
        end;
      end;

    end else
      // The node is the Translated Text Node
      if NodeType.NodeViewType = nvtSubTranslated then begin
        if Node.Text <> MT_NOT_TRANSLATED_YET then
          case Operation of
            nvoDecodeText: Node.Text := CharsList.DecodeSubtitle(Node.Text);
            nvoEncodeText: Node.Text := CharsList.EncodeSubtitle(Node.Text);
          end;
      end; // NodeType.NodeViewType = nvtSubTranslated

  end; // CharsList.Active
end;

procedure TMTViewUpdater.UpdatePercentage;
begin
  Synchronize(frmProgress.UpdateProgressBar);
end;

procedure TMTViewUpdater.UpdateProgressOperation(const Operation: string);
begin
  fStrBuf := Operation;
  Synchronize(SyncUpdateProgressOperation);
end;

end.
