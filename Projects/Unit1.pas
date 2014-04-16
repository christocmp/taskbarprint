unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, ShellAPI,
  Vcl.AppEvnts, Vcl.FileCtrl, TlHelp32;



type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Memo1: TMemo;
    ListBox1: TListBox;
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure ListFileDir(Path: string; FileList: TStrings);
    procedure printFiles();
    //function shellMoveFile(FormHandle : THandle; StrFrom, StrTo : string; BlnSilent : Boolean = False) : Boolean;
    //function shellDeleteFile(FormHandle : THandle; StrFile : String; BlnSilent : Boolean = False; BlnConfirmation : Boolean = True; BlnUndo : Boolean = True) : Boolean;
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function processExists(exeFileName: string) : Integer;
    procedure ApplicationEvents1Minimize(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{
function TForm1.shellDeleteFile(FormHandle : THandle; StrFile : String; BlnSilent : Boolean = False; BlnConfirmation : Boolean = True; BlnUndo : Boolean = True) : Boolean;
var
  F : TShFileOpStruct;
begin
  F.Wnd:= Handle;
  F.wFunc:=FO_DELETE;
  F.pFrom:=PChar(StrFile);
  if BlnUndo then
    F.fFlags := FOF_ALLOWUNDO;
  if not BlnConfirmation then
    F.fFlags := FOF_NOCONFIRMATION;
  if BlnSilent then
    F.fFlags := F.fFlags or FOF_SILENT;
  if ShFileOperation(F) <> 0 then
    result:=False
  else
    result:=True;
end;
}

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  //memo1.Lines.Add('Reading print directory...');
  Timer1.Enabled := false;
  listbox1.Clear;
  listbox1.Items.Clear;
  ListFileDir('p:\', ListBox1.items);
  listbox1.Refresh;
  printfiles();
  listbox1.Clear;
  listbox1.Items.Clear;
  //memo1.Lines.Add('Done...');
  Timer1.Enabled := true;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  memo1.Clear;
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  { Hide the tray icon and show the window,
  setting its state property to wsNormal. }
  form1.Show();
  form1.WindowState := wsNormal;
  Application.BringToFront();
  TrayIcon1.Visible := False;
end;

procedure TForm1.ApplicationEvents1Minimize(Sender: TObject);
begin
  { Hide the window and set its state variable to wsMinimized. }
  form1.Hide();
  form1.WindowState := wsMinimized;
      { Set up a hint message and the animation interval. }
  TrayIcon1.Hint := 'AnimedClient';
  TrayIcon1.AnimateInterval := 50;

  { Set up a hint balloon. }
  TrayIcon1.BalloonTitle := 'Animed';
  TrayIcon1.BalloonHint :=  'Animed client ready to print.';
  TrayIcon1.BalloonFlags := bfInfo;

  { Show the animated tray icon and also a hint balloon. }
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if ( processExists('Animedclient.exe') > 1) then
  begin
    application.Terminate;
  end;
      TrayIcon1.Hint := 'AnimedClient';

    { Set up a hint balloon. }
    TrayIcon1.BalloonTitle := 'Animed';
    TrayIcon1.BalloonHint :=  'Animedclient ready to print';
    TrayIcon1.ShowBalloonHint;
    TrayIcon1.BalloonFlags := bfInfo;

end;

procedure TForm1.ListFileDir(Path: string; FileList: TStrings);
var
  SR: TSearchRec;
begin
  if FindFirst(Path + '*.pdf', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
      begin
        FileList.Add(SR.Name);
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TForm1.printFiles();
var
  i : integer;
  MyHandle: THandle;
  windowName : String;
begin
  windowName := '';
  For i := listbox1.Items.Count - 1 Downto 0 Do

  begin
    memo1.Lines.Add('Sending print to adobe p:\' + listbox1.Items[i]);
    ShellExecute(0, 'open', 'acrord32', PChar('/p /h ' + 'p:\' + listbox1.Items[i]), nil, SW_HIDE); //remove /p to prevent printing
 //   ShellExecute(0, 'open', 'acrord32', PChar('/h ' + 'p:\' + listbox1.Items[i]), nil, SW_HIDE);
    TrayIcon1.Hint := 'AnimedClient';

    { Set up a hint balloon. }
    TrayIcon1.BalloonTitle := 'Animed';
    TrayIcon1.BalloonHint :=  'Printing ' + listbox1.Items[i];
    TrayIcon1.ShowBalloonHint;
    TrayIcon1.BalloonFlags := bfInfo;

    sleep(2000);
    windowName := PWideChar(listbox1.Items[i]) + ' - Adobe Reader';
    MyHandle := FindWindow(nil, PChar(windowName));
    memo1.Lines.Add('Sending close to adobe p:\' + PWideChar(listbox1.Items[i]) + ' - Adobe Reader');
    SendMessage(MyHandle, WM_CLOSE, 0, 0);
    sleep(1000);
    MyHandle := FindWindow(nil, 'Adobe Reader');
    memo1.Lines.Add('Sending close to Adobe Reader');
    SendMessage(MyHandle, WM_CLOSE, 0, 0);
    sleep(1000);


  end;

  For i := listbox1.Items.Count - 1 Downto 0 Do
  begin
    repeat
      memo1.Lines.Add('checking closed: ' + windowName);
      sleep(500);
    until FindWindow(PChar('Adobe Reader'), NIL) = 0;
    repeat
      memo1.Lines.Add('checking closed: ' + 'Adobe Reader');
      sleep(500);
    until FindWindow(PChar(windowName), NIL) = 0;
    sleep(1000);
    //shellDeleteFile(Form1.Handle, 'c:\pdfs\' + listbox1.Items[i], true, False);  Christo 21/08/2013 does not work properly on windows XP possible null termination on string gave up and resorted to the code below
    ShellExecute(0, nil, 'cmd.exe', '/C del p:\ /Q', nil, SW_HIDE);
    sleep(2000);

    TrayIcon1.Hint := 'AnimedClient';

    { Set up a hint balloon. }
    TrayIcon1.BalloonTitle := 'Animed';
    TrayIcon1.BalloonHint :=  'Printing complete';
    TrayIcon1.ShowBalloonHint;
    TrayIcon1.BalloonFlags := bfInfo;
  end;


end;

function TForm1.processExists(exeFileName: string): Integer;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  total : integer;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  //Result := False;
  total := 0;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      total := total + 1;
      //Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
  Result := total;
end;



end.
