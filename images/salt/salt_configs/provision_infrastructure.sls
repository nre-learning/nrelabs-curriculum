Install the infrastructure services config:
  junos.install_config:
    - name: /srv/salt/infrastructure_config.conf
    - replace: True
    - timeout: 100
