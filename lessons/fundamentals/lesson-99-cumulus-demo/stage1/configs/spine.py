import paramiko
import os
from scp import SCPClient

host=os.environ['SYRINGE_TARGET_HOST']

def createSSHClient(server, port, user, password):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(server, port, user, password)
    return client

ssh=createSSHClient(host,22,"root","antidotepassword")
scp=SCPClient(ssh.get_transport())

scp.put('/antidote/stage1/configs/spine/interfaces', '/etc/network/interfaces')
scp.put('/antidote/stage1/configs/spine/daemons', '/etc/frr/daemons')
scp.put('/antidote/stage1/configs/spine/frr.conf', '/etc/frr/frr.conf')

ssh.exec_command('systemctl restart frr.service')
ssh.exec_command('ifreload -a')


scp.close()
ssh.close()



