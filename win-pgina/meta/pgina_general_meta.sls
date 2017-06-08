{%- load_yaml as pgina_general_meta %}
base_path: 'SOFTWARE\\pGina3'
properties:
  PluginDirectories:
    type: REG_MULTI_SZ
    encrypted: False
  ServicePipeName:
    type: REG_SZ
    encrypted: False
  MaxClients:
    type: REG_DWORD
    encrypted: False
  TraceMsgTraffic:
    type: REG_SZ
    encrypted: False
  SessionHelperExe:
    type: REG_SZ
    encrypted: False
  EnableMotd:
    type: REG_SZ
    encrypted: False
  Motd:
    type: REG_SZ
    encrypted: False
  GinaPassthru:
    type: REG_SZ
    encrypted: False
  ChainedGinaPath:
    type: REG_SZ
    encrypted: False
  EnableSpecialActionButton:
    type: REG_SZ
    encrypted: False
  SpecialAction:
    type: REG_SZ
    encrypted: False
  ShowServiceStatusInLogonUi:
    type: REG_SZ
    encrypted: False
  CredentialProviderFilters:
    type: REG_MULTI_SZ
    encrypted: False
  CredentialProviderDefaultTile:
    type: REG_SZ
    encrypted: False
  IPluginAuthentication_Order:
    type: REG_MULTI_SZ
    encrypted: False
  IPluginAuthenticationGateway_Order:
    type: REG_MULTI_SZ
    encrypted: False
  12FA152D-A2E3-4C8D-9535-5DCD49DFCB6D:
    type: REG_DWORD
    encrypted: False
  UseOriginalUsernameInUnlockScenario:
    type: REG_SZ
    encrypted: False
  LogonProgressMessage:
    type: REG_SZ
    encrypted: False
  0f52390b-c781-43ae-bd62-553c77fa4cf7:
    type: REG_DWORD
    encrypted: False
  a89df410-53ca-4fe1-a6ca-4479b841ca19:
    type: REG_DWORD
    encrypted: False
  b68cf064-9299-4765-ac08-acb49f93f892:
    type: REG_DWORD
    encrypted: False
  16fc47c0-f17b-4d99-a820-edbf0b0c764a:
    type: REG_DWORD
    encrypted: False
  d73131d7-7af2-47bb-bbf4-4f8583b44962:
    type: REG_DWORD
    encrypted: False
  81f8034e-e278-4754-b10c-7066656de5b7:
    type: REG_DWORD
    encrypted: False
  ec3221a6-621f-44ce-b77b-e074298d6b4e:
    type: REG_DWORD
    encrypted: False
  350047a0-2d0b-4e24-9f99-16cd18d6b142:
    type: REG_DWORD
    encrypted: False
  98477b3a-830d-4bee-b270-2d7435275f9c:
    type: REG_DWORD
    encrypted: False
  IPluginAuthorization_Order:
    type: REG_MULTI_SZ
    encrypted: False
  IPluginEventNotifications_Order:
    type: REG_MULTI_SZ
    encrypted: False
  TileImage:
    type: REG_SZ
    encrypted: False

{%- endload %}