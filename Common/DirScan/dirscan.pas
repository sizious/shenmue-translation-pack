(*
  Directory Scanner Module

  This module is here to allow the directory scanning. Open the dbgscan project
  to learn how to use it.
*)
unit DirScan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JvBaseDlg, JvBrowseFolder;

type
  // Events
  TDirectoryScannerInitializeEvent = procedure(Sender: TObject;
    MaxValue: Integer) of object;
  TDirectoryScannerFileProceed = procedure(Sender: TObject;
    FileName: TFileName; Result: Boolean) of object;
  TDirectoryScannerCompletedEvent = procedure(Sender: TObject;
    Canceled: Boolean) of object;
    
  TDirectoryScannerInterface = class;
  TDirectoryScannerThread = class;


  // Interface configuration
  TDirectoryScannerInterfaceProperties = class(TObject)
  private
    fMRUDirectoriesDatabase: TFileName;
    fTitle: TCaption;
    fCaption: TCaption;
  public
    constructor Create;
    property Caption: TCaption read fCaption write fCaption;
    property MRUDirectoriesDatabase: TFileName read fMRUDirectoriesDatabase
      write fMRUDirectoriesDatabase;
    property Title: TCaption read fTitle write fTitle;
  end;

  // Main class to use (Controller)
  TDirectoryScanner = class(TObject)
  private
    fScannerThread: TDirectoryScannerThread;
    fFilter: string;
    fFileProceed: TDirectoryScannerFileProceed;
    fInitialize: TDirectoryScannerInitializeEvent;
    fCompleted: TDirectoryScannerCompletedEvent;
    fSourceDirectory: TFileName;
    fInterfaceProperties: TDirectoryScannerInterfaceProperties;
    function ShowQueryDialog: Boolean;
    function GetActive: Boolean;
  protected
    function IsValidFile(const FileName: TFileName): Boolean; virtual;
    property ScannerThread: TDirectoryScannerThread read fScannerThread;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Abort;
    procedure Pause;
    function Execute: Boolean; overload;
    function Execute(const QuerySourceDirectory: Boolean): Boolean; overload;
    property Active: Boolean read GetActive;
    property Filter: string read fFilter write fFilter;
    property QueryProperties: TDirectoryScannerInterfaceProperties
      read fInterfaceProperties write fInterfaceProperties;
    property OnCompleted: TDirectoryScannerCompletedEvent read fCompleted
      write fCompleted;
    property OnFileProceed: TDirectoryScannerFileProceed read fFileProceed
      write fFileProceed;
    property OnInitialize: TDirectoryScannerInitializeEvent read fInitialize
      write fInitialize;
    property SourceDirectory: TFileName read fSourceDirectory
      write fSourceDirectory;  
  end;

  // Thread object (Model)
  TDirectoryScannerThread = class(TThread)
  private
    fSourceDirectory: TFileName;
    fFilter: string;
    fFileProceed: TDirectoryScannerFileProceed;
    fInitialize: TDirectoryScannerInitializeEvent;
    fCompleted: TDirectoryScannerCompletedEvent;
    fOwner: TDirectoryScanner;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TDirectoryScanner);
    property Filter: string read fFilter write fFilter;
    property SourceDirectory: TFileName read fSourceDirectory
      write fSourceDirectory;
    property OnInitialize: TDirectoryScannerInitializeEvent read fInitialize
      write fInitialize;
    property OnFileProceed: TDirectoryScannerFileProceed read fFileProceed
      write fFileProceed;
    property OnCompleted: TDirectoryScannerCompletedEvent read fCompleted
      write fCompleted;
    property Owner: TDirectoryScanner read fOwner;
  end;

  // Interface (View)
  TDirectoryScannerInterface = class(TForm)
    gbDirectory: TGroupBox;
    bBrowse: TButton;
    bOK: TButton;
    bCancel: TButton;
    bvDelimiter: TBevel;
    lInfo: TLabel;
    cbDirectory: TComboBox;
    bfd: TJvBrowseForFolderDialog;  
    procedure bBrowseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure bOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    fMRUDirectoriesDatabase: TFileName;
    function GetSelectedDirectory: TFileName;
    procedure SetSelectedDirectory(const Value: TFileName);
    procedure LoadMRUDirectories;
    procedure SaveMRUDirectories;
    function GetTitle: TCaption;
    procedure SetTitle(const Value: TCaption);
  public
    property MRUDirectoriesDatabase: TFileName read fMRUDirectoriesDatabase;  
    function MsgBox(const Text, Title: string; Flags: Integer): Integer;
    property SelectedDirectory: TFileName read GetSelectedDirectory
      write SetSelectedDirectory;
    property Title: TCaption read GetTitle write SetTitle;
  end;

implementation

{$R *.dfm}

{ TDirectoryScanner }

procedure TDirectoryScanner.Abort;
begin
  if Active then begin
    // Restart the thread if paused
    Execute;

    // Stop the thread execution
    ScannerThread.Terminate;
    try
      // Waiting for the thread end
      ScannerThread.WaitFor;
    finally
      // Destroying the thread
      ScannerThread.Free;
{$IFDEF DEBUG}
      WriteLn(sLineBreak, '*** DIRECTORY SCANNER FINISHED ***', sLineBreak);
{$ENDIF}
    end;
  end;
end;

constructor TDirectoryScanner.Create;
begin
  fFilter := '*.*';
  fScannerThread := nil;
  fInterfaceProperties := TDirectoryScannerInterfaceProperties.Create;
end;

destructor TDirectoryScanner.Destroy;
begin
  Abort;
  fInterfaceProperties.Free;
  inherited;
end;

function TDirectoryScanner.IsValidFile(const FileName: TFileName): Boolean;
begin
  // To override...
  Result := True;
end;

procedure TDirectoryScanner.Pause;
begin
  if Active then
    ScannerThread.Suspend;
end;

function TDirectoryScanner.ShowQueryDialog: Boolean;
var
  UI: TDirectoryScannerInterface;

begin
  UI := TDirectoryScannerInterface.Create(nil);
  with UI do 
    try
      // Initializing dialog
      SelectedDirectory := SourceDirectory;
      fMRUDirectoriesDatabase := QueryProperties.MRUDirectoriesDatabase;
      Caption := QueryProperties.Caption;
      Title := QueryProperties.Title;
      
      // Showing dialog
      ShowModal;

      // Getting result
      Result := ModalResult = mrOk;
      if Result then
        SourceDirectory := SelectedDirectory;
    finally
      Free;
    end;
end;

function TDirectoryScanner.Execute(const QuerySourceDirectory: Boolean): Boolean;
begin
  Result := False;
  if not Active then begin
    // Creating thread
    fScannerThread := TDirectoryScannerThread.Create(Self);
    
    // Show the UI
    if QuerySourceDirectory and not ShowQueryDialog then
      Exit;

    // Initializing parameters
    with ScannerThread do begin
      SourceDirectory := Self.SourceDirectory;
      Filter := Self.Filter;
      OnInitialize := Self.OnInitialize;
      OnFileProceed := Self.OnFileProceed;
      OnCompleted := Self.OnCompleted;
    end;

    // Running thread
    ScannerThread.Resume;
    Result := True;    
  end else begin
    // if paused then resume
    if ScannerThread.Suspended then begin
      ScannerThread.Resume;
      Result := True;
    end;
  end;
end;

function TDirectoryScanner.GetActive: Boolean;
begin
  Result := Assigned(ScannerThread);
end;

function TDirectoryScanner.Execute: Boolean;
begin
  Result := Execute(False);
end;

{ TDirectoryScannerThread }

constructor TDirectoryScannerThread.Create(AOwner: TDirectoryScanner);
begin
  inherited Create(True);
//  FreeOnTerminate := True;  // don't use here because we want to monitor the thread

  fFilter := '*.*';
  fSourceDirectory := '';
  fOwner := AOwner;
  fInitialize := nil;
  fFileProceed := nil;
  fCompleted := nil;
end;

procedure TDirectoryScannerThread.Execute;
var
  SR: TSearchRec;
  i: Integer;
  SL: TStringList;
  Done: Boolean;
  
begin
{$IFDEF DEBUG}
  WriteLn('*** DIRECTORY SCANNER STARTS ***', sLineBreak);
{$ENDIF}

  SourceDirectory := IncludeTrailingPathDelimiter(SourceDirectory);
  if not DirectoryExists(SourceDirectory) then Exit;

{$IFDEF DEBUG}
  WriteLn('SourceDirectory: "', SourceDirectory, '"');
{$ENDIF}

  SL := TStringList.Create;
  try
    if FindFirst(SourceDirectory + Filter, faAnyFile, SR) = 0 then
    begin
      // Scanning the whole directory
      repeat
        if ((SR.Attr and faDirectory) = 0) then        
          SL.Add(SourceDirectory + SR.Name);
      until Terminated or (FindNext(SR) <> 0);
      FindClose(SR); // Must free up resources used by these successful finds
    end;

{$IFDEF DEBUG}
  WriteLn('Files count: ', SL.Count);
{$ENDIF}

    // scanning all found files
    if Assigned(OnInitialize) then
      OnInitialize(Owner, SL.Count);
    
    // checking each file
    Done := SL.Count = 0;
    i := 0;
    while not Done do begin
      // Sending event
      if Assigned(OnFileProceed) then
        // Calling the IsValidFile method to check
        OnFileProceed(Owner, SL[i], Owner.IsValidFile(SL[i]));

      // Manage the loop
      Inc(i);
      Done := Terminated or (i >= SL.Count);
    end;

    // End event
    if Assigned(OnCompleted) then
      OnCompleted(Owner, Terminated);

  finally
    SL.Free;
  end;
end;

{ TDirectoryScannerInterface }

procedure TDirectoryScannerInterface.bBrowseClick(Sender: TObject);
begin
  with bfd do begin
    if DirectoryExists(SelectedDirectory) then
      Directory := SelectedDirectory;
    if Execute then begin
      SelectedDirectory := Directory;
      cbDirectory.SelectAll;
      cbDirectory.SetFocus;
    end;
  end;
end;

procedure TDirectoryScannerInterface.bOKClick(Sender: TObject);
begin
  if not DirectoryExists(SelectedDirectory) then begin
    MsgBox('Specified directory doesn''t exists.', 'Error', MB_ICONWARNING);
    ModalResult := mrNone;
  end else begin
    // Adding to the list
    if cbDirectory.Items.IndexOf(SelectedDirectory) = -1 then
      cbDirectory.Items.Add(SelectedDirectory);
  end;
end;

procedure TDirectoryScannerInterface.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveMRUDirectories;
end;

procedure TDirectoryScannerInterface.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Chr(VK_ESCAPE) then begin
    Key := #0;
    Close;
  end;
end;

procedure TDirectoryScannerInterface.FormShow(Sender: TObject);
begin
  LoadMRUDirectories;

  if SelectedDirectory = '' then  
    SelectedDirectory := IncludeTrailingPathDelimiter(ExpandFileName(GetCurrentDir));
  cbDirectory.SelectAll;
  cbDirectory.SetFocus;
end;

function TDirectoryScannerInterface.GetSelectedDirectory: TFileName;
begin
  if cbDirectory.Text <> '' then
    Result := IncludeTrailingPathDelimiter(cbDirectory.Text);
end;

function TDirectoryScannerInterface.GetTitle: TCaption;
begin
  Result := lInfo.Caption;
end;

procedure TDirectoryScannerInterface.LoadMRUDirectories;
var
  i: Integer;
  SL: TStringList;

begin
  if FileExists(MRUDirectoriesDatabase) then begin
    cbDirectory.Items.Clear;

    SL := TStringList.Create;
    try
      SL.LoadFromFile(MRUDirectoriesDatabase);
      for i := 0 to SL.Count - 1 do
        if DirectoryExists(SL[i]) then
          cbDirectory.Items.Add(SL[i]);
    finally
      SL.Free;
    end;
  end;
end;

function TDirectoryScannerInterface.MsgBox(const Text, Title: string;
  Flags: Integer): Integer;
begin
  Result := MessageBoxA(Handle, PChar(Text), PChar(Title), Flags);
end;

procedure TDirectoryScannerInterface.SaveMRUDirectories;
begin
  cbDirectory.Items.SaveToFile(MRUDirectoriesDatabase);
end;

procedure TDirectoryScannerInterface.SetSelectedDirectory(const Value: TFileName);
begin
  if Value <> '' then  
    cbDirectory.Text := IncludeTrailingPathDelimiter(Value);
end;

procedure TDirectoryScannerInterface.SetTitle(const Value: TCaption);
begin
  lInfo.Caption := Value;
end;

{ TDirectoryScannerInterfaceProperties }

constructor TDirectoryScannerInterfaceProperties.Create;
begin
  MRUDirectoriesDatabase := 'mrudirs.ini';
  Caption := 'Directory Scanner';
  Title := 'Please select the directory to open.';
end;

end.
