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

scp=SCPClient(ssh.get_transport())

#Change hostname

ssh.exec_command("sudo sed -E -i 's/^(127\.0\.1\.1\s+).*/\\1branch-1/' /etc/hosts")  
ssh.exec_command("sudo printf '%s' 'branch-1' > /etc/hostname") 
ssh.exec_command("sudo hostname branch-1")

#Copy configuration files over
scp.put('/antidote/stage1/configs/branch-1/interfaces', '/home/antidote/interfaces')
scp.put('/antidote/stage1/configs/branch-1/daemons', '/home/antidote/daemons')
scp.put('/antidote/stage1/configs/branch-1/*.conf', '/home/antidote/*.conf')


ssh.exec_command('sudo cp /home/antidote/interfaces /etc/network/interfaces')
ssh.exec_command('sudo cp /home/antidote/daemons /etc/frr/daemons')
ssh.exec_command('sudo cp /home/antidote/*.conf /etc/frr/*.conf')


ssh.exec_command('sudo chown frr:frr /etc/frr/*.conf')
ssh.exec_command('sudo chown frr:frrvty /etc/frr/vtysh.conf')
ssh.exec_command('sudo chmod 640 /etc/frr/*.conf')

#Restart FRR and bump interfaces
ssh.exec_command('sudo systemctl restart frr.service')
ssh.exec_command('sudo ifreload -a')

scp.close()
ssh.close()



