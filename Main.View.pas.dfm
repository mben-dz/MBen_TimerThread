object MainView: TMainView
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'MainView'
  ClientHeight = 185
  ClientWidth = 863
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Bahnschrift SemiLight SemiConde'
  Font.Style = []
  Font.Quality = fqClearTypeNatural
  TextHeight = 21
  object Lbl_TagThread: TLabel
    Left = 248
    Top = 49
    Width = 92
    Height = 21
    Caption = 'Lbl_TagThread'
  end
  object Lbl_TagTimer: TLabel
    Left = 248
    Top = 107
    Width = 85
    Height = 21
    Caption = 'Lbl_TagTimer'
  end
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
    Top = 155
    Width = 863
    Height = 30
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 126
    ExplicitWidth = 861
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
  object Btn_ChangeInterval: TButton
    Left = 191
    Top = 2
    Width = 177
    Height = 41
    Caption = 'set interval to half Sec'
    Enabled = False
    TabOrder = 3
    OnClick = Btn_ChangeIntervalClick
  end
  object Memo_Log: TMemo
    Left = 391
    Top = 8
    Width = 464
    Height = 148
    Color = 8076862
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -17
    Font.Name = 'Bahnschrift SemiLight SemiConde'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    Lines.Strings = (
      'Exception Log:')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object Timer_1: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = Timer_1Timer
    Left = 216
    Top = 96
  end
end
