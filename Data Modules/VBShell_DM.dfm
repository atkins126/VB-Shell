inherited VBShellDM: TVBShellDM
  object cdsSystemUser: TFDMemTable
    ActiveStoredUsage = [auDesignTime]
    FilterOptions = [foCaseInsensitive]
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    FormatOptions.AssignedValues = [fvDataSnapCompatibility]
    FormatOptions.DataSnapCompatibility = True
    ResourceOptions.AssignedValues = [rvSilentMode, rvStorePrettyPrint]
    ResourceOptions.StorePrettyPrint = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvGeneratorName, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.GeneratorName = 'SYSTEM_USER_ID_GEN'
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    UpdateOptions.UpdateTableName = 'SYSTEM_USER'
    Left = 120
    Top = 10
    object cdsSystemUserID: TIntegerField
      Alignment = taLeftJustify
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsSystemUserFIRST_NAME: TStringField
      DisplayLabel = 'First Name'
      FieldName = 'FIRST_NAME'
      Origin = 'FIRST_NAME'
      Required = True
      Size = 30
    end
    object cdsSystemUserLAST_NAME: TStringField
      DisplayLabel = 'Last Name'
      FieldName = 'LAST_NAME'
      Origin = 'LAST_NAME'
      Required = True
      Size = 30
    end
    object cdsSystemUserLOGIN_NAME: TStringField
      DisplayLabel = 'Login Name'
      FieldName = 'LOGIN_NAME'
      Origin = 'LOGIN_NAME'
      Required = True
    end
    object cdsSystemUserEMAIL_ADDRESS: TStringField
      DisplayLabel = 'Email'
      FieldName = 'EMAIL_ADDRESS'
      Origin = 'EMAIL_ADDRESS'
      Size = 100
    end
    object cdsSystemUserPASSWORD: TStringField
      DisplayLabel = 'PW'
      FieldName = 'PASSWORD'
      Origin = '"PASSWORD"'
      Required = True
      Size = 100
    end
    object cdsSystemUserACCOUNT_ENABLED: TIntegerField
      DisplayLabel = 'Enabled'
      FieldName = 'ACCOUNT_ENABLED'
      Origin = 'ACCOUNT_ENABLED'
      Required = True
    end
    object cdsSystemUserCHANGE_PW_NEXT_LOGIN: TIntegerField
      Alignment = taLeftJustify
      DisplayLabel = 'PW'
      FieldName = 'CHANGE_PW_NEXT_LOGIN'
      Origin = 'CHANGE_PW_NEXT_LOGIN'
    end
  end
  object dtsSystemUser: TDataSource
    DataSet = cdsSystemUser
    Left = 120
    Top = 60
  end
  object cdsDBInfo: TFDMemTable
    ActiveStoredUsage = [auDesignTime]
    FilterOptions = [foCaseInsensitive]
    CachedUpdates = True
    ConstraintsEnabled = True
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    FormatOptions.AssignedValues = [fvDataSnapCompatibility]
    FormatOptions.DataSnapCompatibility = True
    ResourceOptions.AssignedValues = [rvSilentMode, rvStorePrettyPrint]
    ResourceOptions.StorePrettyPrint = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    UpdateOptions.UpdateTableName = 'DB_INFO'
    Left = 200
    Top = 10
    object cdsDBInfoDB_VERSION: TIntegerField
      DisplayLabel = 'DB Version'
      FieldName = 'DB_VERSION'
    end
  end
  object dtsDBInfo: TDataSource
    Left = 200
    Top = 60
  end
end
