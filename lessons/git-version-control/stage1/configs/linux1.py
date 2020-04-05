import paramiko
import os
from scp import SCPClient

host=os.environ['ANTIDOTE_TARGET_HOST']

def createSSHClient(server, port, user, password):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(server, port, user, password)
    return client

ssh=createSSHClient(host,22,"antidote","antidotepassword")

ssh.exec_command('/antidote/stage1/configs/catchup.sh')

ssh.close()
