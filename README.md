# Overview

The salt state for installing and configuring [pGina](http://pgina.org/) on windows systems. 

This currently supports general configuration of pGina and configuration of the following two plugins.

1. Local Authentication
2. LDAP

## Prerequisites

#### (1) win_repo

salt must be configured to use win_repo to install windows packages and you must include the pgina installer

#### (2) salt-winrepo.git

you will want to grab a copy of the [salt-winrepo](https://github.com/saltstack/salt-winrepo.git) git repository. This provides the following

1. ms-vcpp-2012-redist - pgina dependency
2. ms-vcpp-2012-redist_x86 - pgina dependency
3. pgina - the pgina installer

#### (3) Pillar data

There are three different pillar data example files, one for data pertaining to the general pGina configuration, and two for configuring the currently supported plugins.

File Name | Contents
----------|---------
pgina_general_pillar.example | General pGina pillar data
pgina_local_pillar.example | Local authentication plugin pillar data
pgina_ldap_pillar.example | LDAP plugin pillar data

## NOTES

This salt state has been tested on a Windows Server 2012 and Windows 8.1.