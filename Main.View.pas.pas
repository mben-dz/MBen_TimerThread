unit Main.View.pas;

interface

uses
  Winapi.Windows
, Winapi.Messages
, System.SysUtils
, System.Variants
, System.Classes
, Vcl.Graphics
, Vcl.Controls
, Vcl.Forms
, Vcl.Dialogs
, Vcl.StdCtrls
, Vcl.ExtCtrls

, API.ThreadTimer
, API.Logger

;

type
  TMainView = class(TForm)
    Btn_StartStop: TButton;
    Pnl_Status: TPanel;
    Timer_1: TTimer;
    Btn_StartDelphiTimer: TButton;
    Lbl_TagThread: TLabel;
    Lbl_TagTimer: TLabel;
    Btn_ChangeInterval: TButton;
    Memo_Log: TMemo;
    procedure Btn_StartStop_Click(Sender: TObject);
    procedure Timer_1Timer(Sender: TObject);
    procedure Btn_StartDelphiTimer_Click(Sender: TObject);
    procedure Btn_ChangeIntervalClick(Sender: TObject);

  private  { Private declarations }
    fTimer: I_TimerThread;
    fExceptLog: I_Log;
    function Get_Timer: I_TimerThread;
    function Get_ExceptLogger: I_Log;

    procedure DoStart(aSender: TObject);
    procedure Do_Start;
    procedure DoStop(aSender: TObject);
    procedure DoSomething;

  public { Public declarations }

    property Timer: I_TimerThread read Get_Timer;
    property ExceptLog: I_Log read Get_ExceptLogger;
  end;

var
  MainView: TMainView;

implementation

uses
  API.Helpers;

{$R *.dfm}

{ TForm1 }

function TMainView.Get_ExceptLogger: I_Log;
begin
  if not Assigned(fExceptLog) then
    fExceptLog := Create_Log(Memo_Log);

  Result := fExceptLog;
end;

function TMainView.Get_Timer: I_TimerThread;
begin
  if not Assigned(fTimer) then begin
    fTimer := Create_TimerThread(ExceptLog);

    fTimer
      .Init
      .Interval(3000) // Set interval to 3 seconds
      .OnTask(DoSomething);
  end;

  Result := fTimer;
end;

procedure TMainView.DoSomething;
var
  L_Str: TStringList;
begin
  Timer.IncTag;
  Lbl_TagThread.Caption := 'Timer Event: ' +Timer.Tag.ToString;
  L_Str.Add(Lbl_TagThread.Caption); // Try add bad code here !!
end;

procedure TMainView.DoStart(aSender: TObject);
begin
  Pnl_Status.Caption := ' Button event "Click" with Tag: ' +TComponent(aSender).Tag.ToString;
  Btn_StartStop.Caption := 'Stop Thread Timer';
  Timer
    .Enabled(True);

  Btn_ChangeInterval.Enabled := True;
end;

procedure TMainView.DoStop(aSender: TObject);
begin
  Timer.Enabled(False);
  Btn_ChangeInterval.Enabled := False;
  Pnl_Status.Caption := ' Button event "Click" with Tag: ' +TComponent(aSender).Tag.ToString;
  Btn_StartStop.Caption := 'Start Thread Timer';
end;

procedure TMainView.Btn_StartStop_Click(Sender: TObject);
begin
  TCaseTag.&For(Sender)
    .CaseOfEvent(0, 1, DoStart)
    .CaseOfEvent(1, 0, DoStop)
    .&End;

end;

procedure TMainView.Timer_1Timer(Sender: TObject);
var
  L_Str: TStringList;
begin
  Timer_1.Tag := Timer_1.Tag +1;
  Lbl_TagTimer.Caption := 'Timer Event: ' +Timer_1.Tag.ToString;
//  L_Str.Add(Lbl_TagThread.Caption); // Try add bad code here !!
end;

procedure TMainView.Do_Start;
begin
  Timer_1.Enabled := True;
end;

procedure Do_Stop;
begin
  TMainView(Application.MainForm).Timer_1.Enabled := False;
end;

procedure TMainView.Btn_ChangeIntervalClick(Sender: TObject);
begin
  Timer.Interval(500);
end;

procedure TMainView.Btn_StartDelphiTimer_Click(Sender: TObject);
begin
  TCaseTag.&For(Sender)
    .CaseOfProc(0, 1, Do_Start, 'Stop Delphi Timer')
    .CaseOfProc(1, 0, Do_Stop, 'Start Delphi Timer')
    .&End;
end;

end.
