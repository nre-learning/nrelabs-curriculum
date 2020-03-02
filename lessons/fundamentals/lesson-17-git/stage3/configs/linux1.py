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

ssh.exec_command('rm -rf /home/antidote/myfirstrepo')
ssh.exec_command('mkdir -p /home/antidote/myfirstrepo')
ssh.exec_command('cd /home/antidote/myfirstrepo && git init')
ssh.exec_command('cd /home/antidote/myfirstrepo && git config --global user.email "jane@nrelabs.io"')
ssh.exec_command('cd /home/antidote/myfirstrepo && git config --global user.name "Jane Doe"')
ssh.exec_command('cd /home/antidote/myfirstrepo && cp /antidote/stage3/interface-config.txt . && git add interface-config.txt && git commit -m "Adding new interface configuration file"')
ssh.exec_command('cd /home/antidote/myfirstrepo && git checkout -b change-124 && sed -i s/10.12.0.11/10.12.0.12/ interface-config.txt && git add interface-config.txt && git commit -s -m "Updated em4 IP address"')
ssh.exec_command('cd /home/antidote/myfirstrepo && git checkout master')

ssh.close()
