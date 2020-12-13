Install the infrastructure services config:
  junos.install_config:
   - name: salt:///infrastructure_config.conf
   - replace: True
   - timeout: 100
   - template_vars:
       foo: bar