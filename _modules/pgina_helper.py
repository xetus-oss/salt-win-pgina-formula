from __future__ import print_function
import sys

def format_auth_rules(rules):
  '''
  Converts the normalized ldap group authorization rules dictionary from pillar
  data into the format recognized by the windows registry to use with pgina.

  The dictionary should be in the following format:
  {
    ldap_group_rules: [{
      ldap_group: <string>,
      is_member: <boolean>,
      authorize: <boolean>,
    }, ...],
    always: {
      authorize: <boolean>
    }
  }

  - ldap_group_rules contains the group rules list
  - ldap_group is the ldap group to apply the rule for 
  - is_member should be true if the rule is for when the user is part of the
  ldap_group and false when the user is NOT part of the ldap_group
  - authorize should be true if you wish to authorize the user when the above
  conditions are met and false if you deny authorization if the above conditions
  are met
  - always is the default case of whether or not to authorize the user if none
  of the authorization rules are met. THIS IS REQUIRED

  The following is a breakdown of format for the registry value for future
  reference:
  A GroupAuthzRule should be configured the following way:
  {LDAP Group}\n{GroupCondition}\n{Deny|Allow}
  {LDAP Group} 
    - The name of the LDAP group
  {GroupCondition} 
    - 0 if the user is part of the group
    - 1 if the user is not part of the group
    - 2 The default case if none of the rules match (MUST COME LAST)
  {DENY|ALLOW}
    - 0 for deny
    - 1 for allow
  '''
  ruleRegStrings = []
  for group in rules.get('ldap_group_rules', []):
    regString = group['ldap_group'] + '\n'
    regString += ( '0\n' if group['is_member'] else '1\n')
    regString += ( '1' if group['authorize'] else '0')
    ruleRegStrings.append(regString)

  if rules.get('always', {'authorize':False}).get('authorize', False):
    ruleRegStrings.append('\n2\n0') 
  else:
    ruleRegStrings.append('\n2\n1')

  return ruleRegStrings

def format_gateway_rules(rules):
  '''
  Converts a normalized ldap gateway rules dictionary from pillar data into the
  format recognized by the windows registry to use with pgina.

  The dictionary should be in the following format:
  {
    gateway_rules: [{
      ldap_group: <string>,
      member: <boolean>,
      local_group: <string>,
    }, ...],
    always: {
      local_group: <string>
    }
  }

  - gateway_rules contains the gateway rules list
  - ldap_group is the ldap group to apply the rule for 
  - member should be true if the rule is for when the user is part of the
  ldap_group and false when the user is NOT part of the ldap_group
  - local_group is the local group to assign the user to if the previous two 
  conditions are met.
  - always is the default case if you wish to always assign a user that doesn't
  meet any of the other gateway rules to a local group. 

  The following is a breakdown of format for the registry value for future
  reference:
  {LDAP Group}\n{Group Condition}\n{Local Group}
  {LDAP Group}
    - The name of the LDAP group
  {GroupCondition} 
    - 0 if the user is part of the group
    - 1 if the user is not part of the group
    - 2 The default case if none of the rules match (MUST COME LAST)
  {Local Group}
    - The group on the local machine to assign the user in the ldap group to
  
  Note that the final list item does not include an LDAP group, so it should
  start with a newline (\n) and 2. There doesn't have to be a default rule
  for this item

  '''
  gateRegStrings = []
  for rule in rules['gateway_rules']:
    regString = rule['ldap_group'] + '\n'
    regString += ( '0\n' if rule['member'] else '1\n')
    regString += rule['local_group']
    gateRegStrings.append(regString)

  if 'always' in rules and 'local_group' in rules['always']:
    gateRegStrings.append('\n2\n' + rules['always']['local_group'])

  return gateRegStrings


def format_plugin_features(plugin):
  '''
  Converts a normalized plugin to enabled feature dictionary from pillar data 
  into the appropriate DWORD representation for storing in the registry.

  The dictionary should contain only the following keys:
  - authentication
  - authorization
  - gateway
  - notification

  The value for each dictionary item should be True or False, to indicate 
  whether that feature should be enabled or not. If the key is not
  specified, the ommitted feature is defaulted to False.

  Some plugins do not support some of the features. Use the pgina configuration
  utility to determine which features are supported by which plugins.

  Here's the breakdown for the registry values:
  The registry value is in the form of a DWORD. Each option takes the place of
  a binary bit in an 8-bit value as follows:
  Authentication: 2   (0b00000010)
  Authorization:  4   (0b00000100)
  Gateway:        8   (0b00001000)
  Notification:   16  (0b00010000)

  For example, if you want to enable Authentication and Authorization, your 
  final DWORD value would be:
  2 (Authentication) + 4 (Authorization) = 6
  '''
  dword = 0
  dword += (2 if plugin.get('authentication', False) else 0)
  dword += (4 if plugin.get('authorization', False) else 0)
  dword += (8 if plugin.get('gateway', False) else 0)
  dword += (16 if plugin.get('notification', False) else 0)

  return dword