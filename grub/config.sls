{% from "grub/map.jinja" import grub with context %}

{% for feature, varnames in salt['pillar.get']('grub:config:default', {}).items() %}
  {%- for varname, verbs in varnames.items() %}
    {%- for verb, values in verbs.items() %}
      {%- if values | is_list %}
        {%- for value in values %}
grub-default-config-{{ feature }}-{{ varname.upper() }}-{{ verb }}-{{ value }}:
  augeas.change:
    - uncomment: true
    - context: /files{{ grub.configfile }}
    - name: grub-default-config-{{ feature }}-{{ values| join("-") }}-{{ verb }}-in-{{ varname.upper() }}
    - lens: Shellvars_list.lns
    - changes:
          {%- if verb == "absent" %}
      - del {{ varname.upper() }}/value[.=\'{{ value }}\'] {{ value }}
          {%- elif verb == "present" %}
      - set {{ varname.upper() }}/value[.=\'{{ value }}\'] {{ value }}
          {%- endif %}
        {%- endfor %}
        {%- if verb == "set" %}
      - set {{ varname.upper() }} {{ value | join(" ") }}
        {% endif %}
      {% else %}
grub-default-config-{{ feature }}-{{ varname.upper() }}-{{ verb }}-{{ values }}:
  augeas.change:
    - uncomment: true
    - context: /files{{ grub.configfile }}
    - name: grub-default-config-{{ feature }}-{{ values }}-{{ verb }}-in-{{ varname.upper() }}
    - lens: Shellvars.lns
    - changes:
        {%- if verb == "absent" %}
      - del {{ varname.upper() }}/value[.=\'{{ values }}\'] {{ values }}
        {%- elif verb == "present" %}
      - set {{ varname.upper() }}/value[.=\'{{ values }}\'] {{ values }}
        {%- elif verb == "set" %}
      - set {{ varname.upper() }} '"{{ values }}"'
        {% endif %}
      {%- endif %}
    {%- endfor %}
  {%- endfor %}
{%- endfor %}