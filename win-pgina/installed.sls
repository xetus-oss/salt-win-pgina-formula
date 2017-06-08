{% from slspath + "/map.jinja" import config, constants with context %}

# MS Visuall C++ is always required for pGina
{{ config['cpp-pkg-version'] }}_x86:
  pkg.installed

# If it's a 64bit system, also install ms-vcpp-2012-redist_x64
{% if grains['cpuarch'] == "AMD64" %}
{{ config['cpp-pkg-version'] }}_x64:
  pkg.installed
{% endif %}

pgina:
  pkg.installed:
    - require:
      - pkg: {{ config['cpp-pkg-version'] }}_x86
      {% if grains['cpuarch'] == "AMD64" %}
      - pkg: {{ config['cpp-pkg-version'] }}_x64
      {% endif %}