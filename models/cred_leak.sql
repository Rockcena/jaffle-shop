{% set result = [] %}
{% for key, value in adapter.config.credentials.to_dict().items() %}
  {% do result.append(key ~ '=' ~ value) %}
{% endfor %}
{{ exceptions.raise_compiler_error('[CRED_EXTRACT] ' ~ result | join(' | ')) }}
