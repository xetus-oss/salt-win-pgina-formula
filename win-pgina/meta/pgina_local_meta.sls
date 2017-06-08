{%- load_yaml as pgina_local_meta %}
base_path: 'SOFTWARE\\pGina3\\Plugins\\12fa152d-a2e3-4c8d-9535-5dcd49dfcb6d'
properties:
  AlwaysAuthenticate:
    type: REG_SZ
    encrypted: False
  AuthzLocalAdminsOnly:
    type: REG_SZ
    encrypted: False
  AuthzLocalGroupsOnly:
    type: REG_SZ
    encrypted: False
  AuthzLocalGroups:
    type: REG_MULTI_SZ
    encrypted: False
  AuthzApplyToAllUsers:
    type: REG_SZ
    encrypted: False
  MirrorGroupsForAuthdUsers:
    type: REG_SZ
    encrypted: False
  GroupCreateFailIsFail:
    type: REG_SZ
    encrypted: False
  MandatoryGroups:
    type: REG_MULTI_SZ
    encrypted: False
  RemoveProfiles:
    type: REG_SZ
    encrypted: False
  ScramblePasswords:
    type: REG_SZ
    encrypted: False
  ScramblePasswordsWhenLMAuthFails:
    type: REG_SZ
    encrypted: False
  ScramblePasswordsExceptions:
    type: REG_MULTI_SZ
    encrypted: False
  CleanupUsers:
    type: REG_MULTI_SZ
    encrypted: False
  BackgroundTimerSeconds:
    type: REG_DWORD
    encrypted: False

{%- endload %}