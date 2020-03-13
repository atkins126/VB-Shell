inherited ChangePasswordFrm: TChangePasswordFrm
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'ChangePasswordFrm'
  ClientHeight = 248
  ClientWidth = 430
  ExplicitWidth = 436
  ExplicitHeight = 277
  PixelsPerInch = 96
  TextHeight = 13
  inherited layMain: TdxLayoutControl
    Width = 300
    Height = 170
    ExplicitWidth = 300
    ExplicitHeight = 170
    object edtNewPassword: TcxTextEdit [0]
      Left = 121
      Top = 67
      AutoSize = False
      BeepOnEnter = False
      ParentFont = False
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = 'l'
      Style.Font.Charset = SYMBOL_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Wingdings'
      Style.Font.Style = []
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      TabOrder = 2
      Height = 19
      Width = 168
    end
    object edtConfirmPassword: TcxTextEdit [1]
      Left = 121
      Top = 92
      AutoSize = False
      BeepOnEnter = False
      ParentFont = False
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = 'l'
      Style.Font.Charset = SYMBOL_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Wingdings'
      Style.Font.Style = []
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      TabOrder = 3
      Height = 19
      Width = 168
    end
    object edtCurrentPassword: TcxTextEdit [2]
      Left = 121
      Top = 11
      AutoSize = False
      BeepOnEnter = False
      ParentFont = False
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = 'l'
      Properties.OnChange = edtCurrentPasswordPropertiesChange
      Style.Font.Charset = SYMBOL_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Wingdings'
      Style.Font.Style = []
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      TabOrder = 0
      Height = 19
      Width = 168
    end
    object btnOK: TcxButton [3]
      Left = 133
      Top = 129
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnOKClick
    end
    object btnCancel: TcxButton [4]
      Left = 214
      Top = 129
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object btnContinue: TcxButton [5]
      Left = 11
      Top = 36
      Width = 75
      Height = 25
      Caption = 'Continue'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnContinueClick
    end
    inherited layMainGroup_Root: TdxLayoutGroup
      ItemIndex = 2
    end
    object grpNewPassword: TdxLayoutGroup
      Parent = layMainGroup_Root
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      ShowBorder = False
      Index = 2
    end
    object litCurrentPassword: TdxLayoutItem
      Parent = layMainGroup_Root
      CaptionOptions.Text = 'Current Password'
      Control = edtCurrentPassword
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object litNewPassword: TdxLayoutItem
      Parent = grpNewPassword
      CaptionOptions.Text = 'Confirm Password'
      Control = edtConfirmPassword
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object litConfirmPassword: TdxLayoutItem
      Parent = grpNewPassword
      CaptionOptions.Text = 'New Password'
      Control = edtNewPassword
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object litOK: TdxLayoutItem
      Parent = grpButtons
      AlignHorz = ahRight
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btnOK
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object litCancel: TdxLayoutItem
      Parent = grpButtons
      AlignHorz = ahRight
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object grpButtons: TdxLayoutGroup
      Parent = layMainGroup_Root
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 4
    end
    object sep1: TdxLayoutSeparatorItem
      Parent = layMainGroup_Root
      CaptionOptions.Text = 'Separator'
      Index = 3
    end
    object litContinue: TdxLayoutItem
      Parent = layMainGroup_Root
      AlignHorz = ahLeft
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btnContinue
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
  end
  inherited styRepository: TcxStyleRepository
    PixelsPerInch = 96
  end
  inherited lafLayoutList: TdxLayoutLookAndFeelList
    inherited lafCustomSkin: TdxLayoutSkinLookAndFeel
      PixelsPerInch = 96
    end
  end
  inherited img16: TcxImageList
    FormatVersion = 1
  end
  inherited img32: TcxImageList
    FormatVersion = 1
  end
end
