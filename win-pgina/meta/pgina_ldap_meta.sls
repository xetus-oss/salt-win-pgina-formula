{%- load_yaml as pgina_ldap_meta %}
base_path: 'SOFTWARE\\pGina3\\Plugins\\0f52390b-c781-43ae-bd62-553c77fa4cf7'
properties:
  LdapHost:
    encrypted: False
    type: REG_MULTI_SZ
  LdapPort:
    encrypted: False
    type: REG_DWORD
  LdapTimeout:
    encrypted: False
    type: REG_DWORD
  UseSsl:
    encrypted: False
    type: REG_SZ
  RequireCert:
    encrypted: False
    type: REG_SZ
  ServerCertFile:
    encrypted: False
    type: REG_SZ
  SearchDN:
    encrypted: False
    type: REG_SZ
  SearchPW:
    encrypted: True
    type: REG_SZ
  GroupDnPattern:
    encrypted: False
    type: REG_SZ
  GroupMemberAttrib:
    encrypted: False
    type: REG_SZ
  AllowEmptyPasswords:
    encrypted: False
    type: REG_SZ
  DnPattern:
    encrypted: False
    type: REG_SZ
  DoSearch:
    encrypted: False
    type: REG_SZ
  SearchFilter:
    encrypted: False
    type: REG_SZ
  SearchContexts:
    encrypted: False
    type: REG_MULTI_SZ
  GroupAuthzRules:
    encrypted: False
    type: REG_MULTI_SZ
  AuthzRequireAuth:
    encrypted: False
    type: REG_SZ
  AuthzAllowOnError:
    encrypted: False
    type: REG_SZ
  GroupGatewayRules:
    encrypted: False
    type: REG_MULTI_SZ
{%- endload %}