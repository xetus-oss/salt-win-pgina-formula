# salt-win-pgina-formula
---

The salt state for installing and configuring [pGina](http://pgina.org/) on windows systems.

This currently supports general configuration of pGina and configuration of the following two plugins.

1. Local Authentication
2. LDAP

## Available States

#### win-pgina.installed

Installs the pgina package and required c++ dependencies.

#### win-pgina.configured

Ensures the pGina package and required dependencies are installed, and configures the installed instace per the pillar configuration.

## Prerequisites
---

#### (1) win_repo

salt must be configured to use win_repo to install windows packages and you must include the pgina installer

#### (2) salt-winrepo.git

you will want to grab a copy of the [salt-winrepo](https://github.com/saltstack/salt-winrepo.git) git repository. This provides the following

1. ms-vcpp-2012-redist - both 64 and 32 bit versions, pgina dependency
2. pgina - the pgina installer

#### (3) Pillar data

There are three different pillar data example files, one for data pertaining to the general pGina configuration, and two for configuring the currently supported plugins.

File Name | Contents
----------|---------
pgina_general_pillar.example | General pGina pillar data
pgina_local_pillar.example | Local authentication plugin pillar data
pgina_ldap_pillar.example | LDAP plugin pillar data

## Quick Start
---

Installing pgina on a windows system is just a matter of running the salt command

```
salt 'win_system' state.apply win-pgina.configured
```

If you do not include any pillar data, pgina will remain in the default configuration that is applied after installation.

## Configuration
---

The pillar example files enumerate all the available configuration options available for the win-pGina salt formula. The pillar example files include more detailed information about the configuration options. There are three separate pillar example files:

File Name | Contents
----------|---------
pgina_general_pillar.example | General pGina pillar data
pgina_local_pillar.example | Local authentication plugin pillar data
pgina_ldap_pillar.example | LDAP plugin pillar data


The final pillar configuration can be supplied in one pillar file if desired.

## Examples
---

1. LDAP configuration pillar file

```
pgina.general:
  # LDAP plugin
  0f52390b-c781-43ae-bd62-553c77fa4cf7:
    authentication: True
    authorization: True
    gateway: True
  # Local Authentication
  12FA152D-A2E3-4C8D-9535-5DCD49DFCB6D:
    authentication: True
    authorization: True
    gateway: True
  IPluginAuthentication_Order:
    - '0f52390b-c781-43ae-bd62-553c77fa4cf7'
    - '12FA152D-A2E3-4C8D-9535-5DCD49DFCB6D'
  IPluginAuthorization_Order:
    - '0f52390b-c781-43ae-bd62-553c77fa4cf7'
    - '12FA152D-A2E3-4C8D-9535-5DCD49DFCB6D'
  IPluginAuthenticationGateway_Order:
    - '0f52390b-c781-43ae-bd62-553c77fa4cf7'
    - '12FA152D-A2E3-4C8D-9535-5DCD49DFCB6D'

pgina.local:
  AlwaysAuthenticate: 'False'
  AuthzLocalAdminsOnly: 'False'
  AuthzLocalGroupsOnly: 'False'
  AuthzApplyToAllUsers: 'True'
  MirrorGroupsForAuthdUsers: 'True'
  GroupCreateFailIsFail: 'True'
  BackgroundTimerSeconds: '60'

pgina.ldap:
  LdapHost:
    - 'ldap.server.com'
  SearchDN: 'uid=user,cn=common,dc=example,dc=com'
  SearchPW: 'searchpassword'
  GroupDnPattern: 'cn=%g,cn=groups,dc=example,dc=com'
  GroupMemberAttrib: 'member'
  DnPattern: 'uid=%u,cn=users,cn=accounts,dc=exmaple,dc=com'
  SearchFilter: '(memberOf=cn=ldapusers,cn=groups,cn=accounts,dc=example,dc=com)'
  GroupAuthzRules:
    ldap_group_rules:
      - ldap_group: 'group1'
        is_member: True
        authorize: True
      - ldap_group: 'group2'
        is_member: False
        authorize: False
    always:
      authorize: False
  GroupGatewayRules:
    gateway_rules:
      - ldap_group: 'ldapgroup1'
        member: True
        local_group: 'localgroup1'
      - ldap_group: 'ldapgroup2'
        member: True
        local_group: 'localgroup2'
    always:
      local_group: 'Users'

```


## NOTES
---

This salt state has been tested on a Windows Server 2012 and Windows 8.1.
