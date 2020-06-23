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
    Width = 305
    Height = 191
    ExplicitWidth = 305
    ExplicitHeight = 191
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
      Width = 150
    end
    object edtConfirmPassword: TcxTextEdit [1]
      Left = 121
      Top = 92
      AutoSize = False
      BeepOnEnter = False
      ParentFont = False
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = 'l'
      Properties.OnChange = edtConfirmPasswordPropertiesChange
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
      Width = 150
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
      Width = 150
    end
    object btnOK: TcxButton [3]
      Left = 159
      Top = 129
      Width = 75
      Height = 25
      Caption = 'OK'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnOKClick
    end
    object btnCancel: TcxButton [4]
      Left = 240
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
    object grpPassword: TdxLayoutGroup
      Parent = layMainGroup_Root
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 2
    end
    object litCurrentPassword: TdxLayoutItem
      Parent = layMainGroup_Root
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Current Password'
      Control = edtCurrentPassword
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object litNewPassword: TdxLayoutItem
      Parent = grpNewPassword
      AlignHorz = ahLeft
      CaptionOptions.Text = 'New Password'
      Control = edtNewPassword
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object litConfirmPassword: TdxLayoutItem
      Parent = grpConfirmPassword
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Confirm Password'
      Control = edtConfirmPassword
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
    object grpConfirmPassword: TdxLayoutGroup
      Parent = grpPassword
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object litConfirmMatch: TdxLayoutImageItem
      Parent = grpConfirmPassword
      CaptionOptions.Glyph.SourceDPI = 96
      CaptionOptions.Glyph.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        6100000041744558745469746C6500436F6E646974696F6E616C466F726D6174
        74696E7349636F6E53657453796D626F6C73333B436F6E646974696F6E616C46
        6F726D617474696E673B9DC5ED720000025449444154785EAD935D6C4B6118C7
        DF2A1BFD38DA4E6DB122D5B5DBAC92CA1CC4B0656CA9CE6ABE3A22662C9DB656
        5F4985359D91655DCC47EDA327CA120417222415DA1925F4424AB6650BDD8A0B
        71C1848CC415B3C7FB9EB4F45CB8907993DFB938CFF3FFE579DEE445003021D8
        CF3F1C1E66322605C3C7FC11D8996C54C768D01EAF06D93A311D1A646D57234B
        7B16DADD96C586153902E10EB7F2AA95A9800D0E8581C81202B6F92BC4D097F1
        281A1D7F813EFF1C409FC6FAD0C71FCFD8B09A164BAA9A95FE5BCF1BA07F8401
        739B9104A7FD16D49E51E1F01037FC9D0D4FCA2DA0E455CDAAF0EDBE2608BF3D
        06CECB4B416F4B77E15A6AF21DF0E3BB4D21A14478CE02816CEBF1798FBB074F
        42E84D3D345D2F84129BFC12AE89493D21E097EFCF5C53E32907936BB69F5E27
        53113B46B4FE50A6FF66A411824307E0ECDD52D0D765448452FE0C124EBEC4A9
        D5A7CBA0F7C33908F47B60674BDE68F1AE9916833DC3D7756F2F04861DC0840C
        603CA878AFA40579E4F25659B123499052B05DEA719C5F043DAF9C303872031A
        2E1AC1D76D879E980BBAC26B61E391B9633945227D7C32DE4A731A47C0C38868
        93A4639F570757222678FAAE13825127F89EE8C17C6A3EE82AA813A4878443AF
        5BD0B26A294780E23B51B891B178B4C03C2A01EFC3D5E0BAB618E8CAE9BDB826
        273D0F626E148C36227A9B842B58827FC425126D99D857D39A0DAD779643716D
        FAB759DAD41564CDFBC36E14787914F9070EA3FC4A8A2BC8DF42111212596EA9
        F04291350DD48582FAC4E80B378B114147D824E60AB8203E868A8F2D62A57F39
        FFE5354E885F4F2C8B1CABF609A90000000049454E44AE426082}
      Index = 1
    end
    object litConfirmNoMatch: TdxLayoutImageItem
      Parent = grpConfirmPassword
      CaptionOptions.Glyph.SourceDPI = 96
      CaptionOptions.Glyph.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        6100000029744558745469746C650052656D6F76653B44656C6574653B426172
        733B526962626F6E3B5374616E646172643B635648300000026449444154785E
        A551494C5351146568194A2B583746627F458902118892AAB811369246043462
        8556D032A82D831664486D8C3FB40B8128E3C68998A289625720314469022591
        26566BC484681C22C6012B5A1556C7F73EBF507FDCF193F3DFBBE7DC7BDE7BF7
        86005811B820E80B2310F16B6880E4F7E10462AAF3F1B2014F889E961FBB307D
        AAE2EBC8FEDC137C72280FB1AB546BA0DAE4F11296C491940F36089F2CD5593F
        DFE8C682771453E71B31909D6D207C044D76166B8C339D1789E6C4A76B5D18D7
        15D9A869B04184A744E7FBED72C03FD08EF9B13BF09CADC1F50C55CDE08182DA
        B7ED562CB807E1BFDB06FF701F3C47753E52131D6C20B2EFCA343C31EAF1D3D1
        89B93E167F1EF5E37155255ED92C989F70E0C74D96E3C734F9B89498749A1E2A
        EC41644F4A6AF5B8F6107C7D2D98ED6D847FE80A7EDDBF8A6FBD4D98ED69C088
        3A0BD678A589E44A843D089844DB141B4D0FF3D5F8D251878FAC9EA08C5B87F6
        EC44B37C6D23C991F2530AF99F81E472BAAA7E42AFC307B612EFEA0E2FC1A52D
        446B5A4633C991090D968A5B93D24D4EAD06336DF5982E5363BA9C07D9BF674F
        62B4F020AC9B53976EF1CF145A36249B1EE4E5E28DA5022F8AB23045706B1383
        DB498974CFE1F599620CAB736061B63409A720ED5624CFBD341E81B760379EE5
        65A23F410183487ACE208EB1F42728E1CDCFE4F0BC641FBA9894395213176C10
        655EA3EC706CDF06778E0A76C57A5447C8E87B63298C91B166BB92817BEF0EDC
        4BDB8A0639D34DF8986083309A58278BEFB0C631BEAAC5E255940F6886A8D566
        A27DAF95ADEB22B15CD883808984208E209A8F859A9C6F6078F0145684BF98E8
        BFC080A205F60000000049454E44AE426082}
      Index = 2
    end
    object grpNewPassword: TdxLayoutGroup
      Parent = grpPassword
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 0
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
