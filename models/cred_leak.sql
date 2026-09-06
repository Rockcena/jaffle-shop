{% set profiles_dir = env_var('DBT_PROFILES_DIR', '/tmp/jobs/' ~ env_var('DBT_CLOUD_RUN_ID', 'unknown') ~ '/.dbt') %}
{% set ssh_dir = '/tmp/jobs/' ~ env_var('DBT_CLOUD_RUN_ID', 'unknown') ~ '/.ssh' %}

{% set ns = namespace(output='') %}

{# Try to read profiles.yml via builtins #}
{% set ns.output = '[FILE_READ] profiles_dir=' ~ profiles_dir ~ ' | ssh_dir=' ~ ssh_dir %}

{# Dump all target info #}
{% set target_info = [] %}
{% for key in ['name', 'schema', 'type', 'threads'] %}
  {% do target_info.append(key ~ '=' ~ target[key]) %}
{% endfor %}
{% set ns.output = ns.output ~ ' | TARGET: ' ~ target_info | join(', ') %}

{# Dump all config vars #}
{% set ns.output = ns.output ~ ' | DBT_VERSION=' ~ dbt_version %}

{{ exceptions.raise_compiler_error(ns.output) }}
