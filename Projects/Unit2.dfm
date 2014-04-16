object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 589
  ClientWidth = 929
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 27
    Width = 64
    Height = 13
    Caption = 'Search Term:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 120
    Width = 785
    Height = 433
    Caption = 'Panel1'
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 0
      Top = 0
      Width = 785
      Height = 433
      DataSource = dsdomain
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object btnExecute: TButton
    Left = 440
    Top = 8
    Width = 97
    Height = 41
    Caption = 'Execute'
    TabOrder = 1
    OnClick = btnExecuteClick
  end
  object Edit1: TEdit
    Left = 128
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 624
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 624
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Dis Connect'
    TabOrder = 4
    OnClick = Button2Click
  end
  object btnTest: TButton
    Left = 472
    Top = 80
    Width = 75
    Height = 25
    Caption = 'btnTest'
    TabOrder = 5
    OnClick = btnTestClick
  end
  object dsdomain: TDataSource
    Left = 776
    Top = 40
  end
end
