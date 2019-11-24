{% from "grub/map.jinja" import grub with context %}

grub-pkg:
  pkg.installed:
    - name: {{ grub.pkg }}
