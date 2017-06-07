################################################################################
#                                                                              #
# win-pgina - installs and configures pgina                                    #
#                                                                              #
# Currently, this supports the following                                       #
# - general configuration of PGina                                             #
# - LocalMachine plugin configuration                                          #
# - LDAP plugin configuration                                                  #
#                                                                              #
# Configures PGina through setting registry values from pillar data. Uses      #
# dictionaries that define properties of the registry keys pertaining to each  #
# of the PGina plugins that are currently supported.                           #
#                                                                              #
################################################################################

# MS Visuall C++ is always required for pGina
ms-vcpp-2012-redist_x86:
  pkg.installed

# If it's a 64bit system, also install ms-vcpp-2012-redist_x64
{% if grains['cpuarch'] == "AMD64" %}
ms-vcpp-2012-redist_x64:
  pkg.installed
{% endif %}

pgina:
  pkg.installed:
    - require:
      - pkg: ms-vcpp-2012-redist_x86
      {% if grains['cpuarch'] == "AMD64" %}
      - pkg: ms-vcpp-2012-redist_x64
      {% endif %}

#
# Loads the registry key meta information for PGina's plugins that are
# configurable through salt.
#
# Currently, this supports the following
# - general configuration of PGina
# - LocalMachine plugin configuration
# - LDAP plugin configuration
#
{% from 'win-pgina/pgina_general_meta.sls' import pgina_general_meta with context %}
{% from 'win-pgina/pgina_local_meta.sls' import pgina_local_meta with context %}
{% from 'win-pgina/pgina_ldap_meta.sls' import pgina_ldap_meta with context %}

{% set plugin_uuids = [
  "0f52390b-c781-43ae-bd62-553c77fa4cf7",
  "12FA152D-A2E3-4C8D-9535-5DCD49DFCB6D",
  "a89df410-53ca-4fe1-a6ca-4479b841ca19",
  "b68cf064-9299-4765-ac08-acb49f93f892",
  "16fc47c0-f17b-4d99-a820-edbf0b0c764a",
  "d73131d7-7af2-47bb-bbf4-4f8583b44962",
  "81f8034e-e278-4754-b10c-7066656de5b7",
  "ec3221a6-621f-44ce-b77b-e074298d6b4e",
  "350047a0-2d0b-4e24-9f99-16cd18d6b142",
  "98477b3a-830d-4bee-b270-2d7435275f9c",
]%}

#
# First for loop to iterate over the different supported plugins that can be
# configured through salt so far. Not 100% sure if this is the right place to
# put this data, but it works for now, and should be relatively easy to extend
# as more plugins are setup to be configured through salt
#
{% for pillar_name, meta_name in {
  'pgina_general':pgina_general_meta,
  'pgina_local':pgina_local_meta,
  'pgina_ldap':pgina_ldap_meta }.iteritems() %}

#
# Iterates over the registry keys with values defined in the pillar that need
# to be configured
#
{% for reg_key, reg_value in salt['pillar.get'](pillar_name, {}).iteritems() %}

#
# The LDAP plugin has a value for a registry key that needs to be encrypted
# (using window's System.Security.Cryptography.ProtectedData Protect method in
# the LocalMachine scope) and encoded in BASE64 before being stored in the
# registry. Future-proofing this in case other registry items need to be
# encrypted in this fashion in the future (but they probably won't)
#
# Windows is nice enough to provide some sort of salt or something that results
# in a different encrypted result everytime anything is passed through the
# ProtectedData::Protect method, even if it happens to be the same thing being
# encrypted twice. In order to not trigger a changed value each time this salt
# state is run, we want to unencrypt the value stored in the registry and verify
# that doesn't match what's being set. If it does, then we skip setting the
# registry entry.
{% set run_reg_present = True %}
{% if meta_name.properties[reg_key].encrypted %}
  #
  # Verify that the encrypted registry entry doesn't match what we're trying to
  # set
  #
  {% set currentkey = salt['reg.read_value'](
      'HKEY_LOCAL_MACHINE',
      meta_name.base_path,
      reg_key).vdata %}

  {% if currentkey == None or salt['cmd.script'](
    'salt://win-pgina/powershell/decrypt.ps1',
    args=(' ' + currentkey), shell="powershell").stdout != salt['pillar.get'](
    'pgina_ldap',{}).SearchPW %}

    {% set final_reg_value = salt['cmd.script'](
      'salt://win-pgina/powershell/encrypt.ps1',
    args=(' ' + reg_value), shell="powershell").stdout %}
  {% else %}
    #
    # Do not set the registry value if what's in there already represents the
    # value
    #
    {% set run_reg_present = False %}
  {% endif %}
#
# transform certain registry keys from a normalized, human(-ish) readable format
# provided here into what will be placed in the registry
#
{% elif reg_key == "GroupAuthzRules" %}
  {% set final_reg_value = salt[
    'pgina_helper.format_auth_rules'](reg_value) %}
{% elif reg_key == "GroupGatewayRules" %}
  {% set final_reg_value = salt[
    'pgina_helper.format_gateway_rules'](reg_value) %}
{% elif reg_key in plugin_uuids %}
  {% set final_reg_value = salt[
    'pgina_helper.format_plugin_features'](reg_value) %}
{% else %}
  {% set final_reg_value = reg_value %}
{% endif %}

#
# Sets the registry keys to the configured values
#
{% if run_reg_present %}
{% set reg_name = "HKEY_LOCAL_MACHINE\\" + meta_name.base_path %}
{{ reg_name }}\\{{ reg_key }}-present:
  reg.present:
    - name: {{ reg_name }}
    - vname: {{ reg_key }}
    # The strings 'True' and 'False' get automatically coerced into boolean
    # values unless you wrap the jinja in single quotes. Since some of the
    # values are arrays, wrapping in single quotes for array values causes
    # YAML parse issues. We want to wrap jinja in single quotes only when the
    # value is a string (REG_SZ)
    {% if meta_name.properties[reg_key].type == "REG_SZ" %}
    - vdata: '{{ final_reg_value }}'
    # The YAML here is pretty terrible. newlines get replaced by spaces in
    # certain scenarios, and the multi value registry entries for pgina require
    # the newlines to be present, thus the need for this complication.
    {% elif meta_name.properties[reg_key].type == "REG_MULTI_SZ" %}
    - vdata:
      {% for item in final_reg_value %}
      - |-
          {{ item | indent(10) }}
      {% endfor %}
    {% else %}
    - vdata: {{ final_reg_value }}
    {% endif %}
    - vtype: {{ meta_name.properties[reg_key].type }}
    - use_32bit_registry: False

{% endif %}
{% endfor %}
{% endfor %}
