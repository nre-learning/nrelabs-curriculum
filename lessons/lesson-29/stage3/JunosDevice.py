from jnpr.junos import Device

class JunosDevice(object):

    def __init__(self):
        self.device = None

    def connect_device(self,host, user, password):
        self.device = Device(host, user=user, password=password)
        self.device.open()

    def gather_device_info(self):
        df = dict(self.device.facts)
        device_facts =  {
            "os_version": df["version"],
            "serialnumber": df["serialnumber"],
            "model": df["model"],
            "hostname": df["hostname"]
        }
        return device_facts

    def close_device(self):
        self.device.close()

    def get_hostname(self):
        facts = self.gather_device_info()
        return facts["hostname"]

    def get_model(self):
        facts = self.gather_device_info()
        return facts["model"]
    