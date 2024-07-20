program TimerThread;

uses
  Vcl.Forms,
  API.Controls.Hack in 'API\API.Controls.Hack.pas',
  API.ThreadTimer in 'API\API.ThreadTimer.pas',
  API.Helpers in 'API\API.Helpers.pas',
  Main.View.pas in 'Main.View.pas.pas' {MainView},
  API.Logger in 'API\API.Logger.pas';

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := True;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
