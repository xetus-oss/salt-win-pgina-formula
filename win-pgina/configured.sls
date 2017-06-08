{% from slspath + "/map.jinja" import config, constants with context %}
{% from slspath + "/macros.jinja" import reg_present_state with context %}

include:
  - {{ slspath }}.installed

#
# First for loop to iterate over the different supported plugins that can be
# configured through salt so far. Not 100% sure if this is the right place to
# put this data, but it works for now, and should be relatively easy to extend
# as more plugins are setup to be configured through salt
#
{% for meta_category in ["general", "local", "ldap"] %}
{% set meta = constants.meta[meta_category] %}

#
# Iterates over the registry keys with values defined in the pillar that need
# to be configured
#
{% for reg_key, new_value in config[meta_category].iteritems() %}

#
# Since Windows' encryption algorithm for registry values is not idemptotent
# (see the note in the pgina_helper.py's encrypt_value function), ensure
# reg.present states aren't generated if the registry value matches the 
# configured value.
#
{% if not meta.properties[reg_key].encrypted or salt['pgina_helper.registry_value_changed'](
        meta.base_path,
        reg_key,
        new_value
      ) %}

#
# The friendly format exposed to the pillar for each value may need to be 
# restructured into a less convenient format.
#
{% set transformed_value = salt['pgina_helper.transform_value_for_registry'](
      reg_key,
      salt['pgina_helper.encrypt_value'](new_value) if meta.properties[reg_key].encrypted else new_value,
      constants.plugin_uuids
   ) %}

{% set reg_name = "HKEY_LOCAL_MACHINE\\" + meta.base_path %}

{{ reg_name }}\\{{ reg_key }}-present:
  reg.present:
    - name: {{ reg_name }}
    - vname: {{ reg_key }}
    - vtype: {{ meta.properties[reg_key].type }}
    - use_32bit_registry: False

    # The strings 'True' and 'False' get automatically coerced into boolean
    # values unless you wrap the jinja in single quotes. Since some of the
    # values are arrays, wrapping in single quotes for array values causes
    # YAML parse issues. We want to wrap jinja in single quotes only when the
    # value is a string (REG_SZ)
    {% if meta.properties[reg_key].type == "REG_SZ" %}
    - vdata: '{{ transformed_value }}'

    # The YAML here is pretty terrible. newlines get replaced by spaces in
    # certain scenarios, and the multi value registry entries for pgina require
    # the newlines to be present, thus the need for this complication.
    {% elif meta.properties[reg_key].type == "REG_MULTI_SZ" %}
    - vdata:
      {% for item in transformed_value %}
      - |-
          {{ item | indent(10) }}
      {% endfor %}

    {% else %}
    - vdata: {{ transformed_value }}
    {% endif %}

{% endif %}

{% endfor %}
{% endfor %}