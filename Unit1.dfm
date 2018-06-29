object Form1: TForm1
  Left = 935
  Top = 334
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Proxy Grabber'
  ClientHeight = 350
  ClientWidth = 399
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 271
    Width = 7
    Height = 16
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 288
    Top = 168
    Width = 105
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 288
    Top = 136
    Width = 105
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 288
    Top = 39
    Width = 105
    Height = 25
    Caption = #1057#1090#1086#1087
    TabOrder = 0
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 288
    Top = 8
    Width = 105
    Height = 25
    Caption = #1057#1090#1072#1088#1090
    TabOrder = 1
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 288
    Top = 70
    Width = 105
    Height = 25
    Caption = #1055#1072#1091#1079#1072
    TabOrder = 3
    OnClick = Button5Click
  end
  object dublikat: TButton
    Left = 288
    Top = 104
    Width = 105
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1091#1073#1083#1080#1082#1072#1090
    TabOrder = 5
    OnClick = dublikatClick
  end
  object memo1: TMemo
    Left = 8
    Top = 8
    Width = 273
    Height = 258
    ScrollBars = ssVertical
    TabOrder = 6
    OnClick = memo1Click
  end
  object chek: TButton
    Left = 288
    Top = 200
    Width = 105
    Height = 25
    Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1086#1082#1089#1080
    TabOrder = 7
    OnClick = chekClick
  end
  object RadioButton1: TRadioButton
    Left = 288
    Top = 228
    Width = 78
    Height = 17
    Caption = 'HTTP/S'
    Checked = True
    TabOrder = 8
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 288
    Top = 251
    Width = 78
    Height = 17
    Caption = 'SOCKS'
    TabOrder = 9
  end
  object btn1: TButton
    Left = 8
    Top = 288
    Width = 129
    Height = 25
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1086#1082#1089#1080
    TabOrder = 10
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 8
    Top = 320
    Width = 129
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1040#1087#1087#1083#1077#1090
    TabOrder = 11
    OnClick = btn2Click
  end
  object cb: TCheckBox
    Left = 143
    Top = 292
    Width = 185
    Height = 17
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1088#1086#1082#1089#1080'-'#1089#1077#1088#1074#1077#1088
    TabOrder = 12
    OnClick = cbClick
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 168
    Top = 176
  end
end
