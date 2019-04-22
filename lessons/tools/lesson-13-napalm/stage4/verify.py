import napalm
driver = napalm.get_network_driver("junos")
device = driver(hostname="vqfx1", username="antidote", password="antidotepassword")
device.open()
assert device.get_interfaces()['em1.0']['description'] == 'Hello, World!'
