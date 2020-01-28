import paramiko
import os
from scp import SCPClient

host=os.environ['SYRINGE_TARGET_HOST']

def createSSHClient(server, port, user, password):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(server, port, user, password)
    return client

ssh=createSSHClient(host,22,"antidote","antidotepassword")

# scp=SCPClient(ssh.get_transport())

# scp.put('/antidote/stage1/configs/leaf1/interfaces', '/home/antidote/interfaces')
# scp.put('/antidote/stage1/configs/leaf1/daemons', '/home/antidote/daemons')
# scp.put('/antidote/stage1/configs/leaf1/frr.conf', '/home/antidote/frr.conf')

ssh.exec_command('mkdir -p /home/antidote/myfirstrepo')
ssh.exec_command('cd /home/antidote/myfirstrepo && git init')
ssh.exec_command('cd /home/antidote/myfirstrepo && git config --global user.email "jane@nrelabs.io"')
ssh.exec_command('cd /home/antidote/myfirstrepo && git config --global user.name "Jane Doe"')

# scp.close()
ssh.close()



