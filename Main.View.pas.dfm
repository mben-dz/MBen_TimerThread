object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 164
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Bahnschrift SemiLight SemiConde'
  Font.Style = []
  Font.Quality = fqClearTypeNatural
  TextHeight = 21
  object Btn_StartStop: TButton
    Left = 24
    Top = 24
    Width = 161
    Height = 49
    Cursor = crHandPoint
    Caption = 'Start Thread Timer'
    TabOrder = 0
    OnClick = Btn_StartStop_Click
  end
  object Pnl_Status: TPanel
    Left = 0
    Top = 134
    Width = 362
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 126
    ExplicitWidth = 360
  end
  object Btn_StartDelphiTimer: TButton
    Left = 24
    Top = 88
    Width = 161
    Height = 49
    Cursor = crHandPoint
    Caption = 'Start Delphi Timer'
    TabOrder = 2
    OnClick = Btn_StartDelphiTimer_Click
  end
  object Timer_1: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = Timer_1Timer
    Left = 216
    Top = 96
  end
end
