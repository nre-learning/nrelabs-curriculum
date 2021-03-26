import paramiko
from paramiko.sftp_attr import SFTPAttributes
from io import BytesIO
import os
import stat

# host=os.environ['ANTIDOTE_TARGET_HOST']
host="linux1"

def createSSHClient(server, port, user, password):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(server, port, user, password)
    return client

ssh=createSSHClient(host,22,"antidote","antidotepassword")

stdin, stdout, stderr = ssh.exec_command('/antidote/stage5/configs/catchup.sh')
exit_status = stdout.channel.recv_exit_status()
if exit_status != 0:
    raise Exception("Failed to run catchup script")

# Just some basic obfuscation against some regex-savvy github hunters.
# That said, this key is basically worthless. Just used for educational purposes.
start = "-----YEK ETAVIRP ASR NIGEB-----"[::-1]
end = "-----YEK ETAVIRP ASR DNE-----"[::-1]
privpath = "asr_di/hss./etoditna/emoh/"[::-1]
pubpath = "bup.asr_di/hss./etoditna/emoh/"[::-1]
pubstart = "asr-hss"[::-1]
pubend = ("1xunil%setoditna" % "@")[::-1]

priv_file = '''%s\nMIIEpgIBAAKCAQEAqn+ZuXH2+L+Abfgr5e39ru1KHqwZBNcH+K7nmBEZu02S18w4M5BiLE\nvdbaGFVE0Eu2Cg7SdXFyWa/JWUTgx2qdyYoCFECiXSkcLxBpkRPs02iGAhWwBVLhFI2G62\nfzdjkkLKrx2VXsLQMKSROWRh1GZdy3l8fK7G6FgEn0o1GK2+ibfhi1cd4HDsL6VTemt1M3\nOtPlDgcVhB1PC0Cx8nlt3DxgqaO59oGDqL14zQVss9asgKUr/xRRwcmjC9YfDi+JLbkZGM\n3AZKyvx1I1wGSpBvDaocTacoUfPLun55MXBqMlypqXH6zaZZvOzYVGepcm7exsfcoDuKY6\n09MEY0DQIDAQABAoIBAQClq4FzCcMiZ+picPAu5rdG/3mzHiTdaBht035ka9FmB/W0zNKb\ngCN0yW7qtTU5+fCsJjOY3U4pxre30ZyezkuLuDdx+YEEn0XhrtvHPnrcXEkt8MLYixU5wz\n/WVpXsPaT6HP6XdBaNUp07dt1KODk7SxC+w1hsSuQqJkSvh0rao3pacE67tHTQ20B49fzi\n6W/cZCsMITriUJylyWAEMcPakIU4RMrWMW/ZoSpSSkLc/q5NkfPW4Esb5IDBx5db5SHWqA\nPZL0yaegnjcqoUQ5NEKAzbRPPdObrhIYuuJ4lodGloCdqj6qVIDd8+oAvt0G7YnHM83N3l\nTUsHIgQ+0EhdAoGBANw94Ao6PEbNj86nol10Z5PROImrcEKiIOLFz6UojBwBsd4rIFWxsG\n82uD8FdlLjb708kojK0a7BfecGAmP7ew6O4Ptq2GegU/ZlEbFi4AGMygnFV3q/38yOXTR2\nMhwMcywRqreFgMh6CxOKJRuNEFzi8J9/Q8BS12LnCzq+EVGDAoGBAMYuMlwM5F/j9AQo9L\nf5gOV9JikfzHfMPEaiwcKK0V8ob52DwGkiHWtmQSvxZcfYKmxCnRrOwltnzADBILBGepk8\nGJwRLeNfso2nTwvgK/kyZBbvSap1HhDzoUfqnlFuHUuFSp25fIWyASMBRK2OK6zLx8xjsz\nr6gV3U/0LGgz8vAoGBAKq2r2VeFIDRL4oAuEL2Sp7ySn+zynVr1E/TAovDbS78RVGvXgXu\nkJLz+EapRjkjn+YwAGlVxMhPpPag2tODB7SWHV/kRs+0H8DaQKedu4KYDbcbJx63gZK+Ox\nLCFz9UiyV6oDhWnCdJKjLAHtlHM4q8QcVv0SVPUTKRYkvrLeNfAoGBAIl7EsR4zRUYdfdM\n0jeuhpStNQPiY13X+RinX/MtigGRc5y6AYjteas/zIZHeGwisYtYytQGCx6N6x+62opu2i\n3jWs8pu8O4Z42NO3DpmpfNNVITve7aQHlSCdhyElI7KWdymEjCnHfC/Lbj8ljT/8hntbs8\njuGjVotZb5tLS1FRAoGBAKYxnHqa/FwIAr0B/VRCYglHqCzz7m7roRlz25SlE0jo3ULhpC\nZ2RIYd2KzcekrjaLKV15R9xd9398BBtoXKlIUviywxxiv2sZR/wJa9QWRT+/nLo3O6vruW\nofDi+Udxp0wfdDpe+VUNVSCEqHfFpF/rbioEBvqShH9Atum6Jt4P\n%s''' % (start, end)
pub_file = '%s AAAAB3NzaC1yc2EAAAADAQABAAABAQCqf5m5cfb4v4Bt+Cvl7f2u7UoerBkE1wf4rueYERm7TZLXzDgzkGIsS91toYVUTQS7YKDtJ1cXJZr8lZRODHap3JigIUQKJdKRwvEGmRE+zTaIYCFbAFUuEUjYbrZ/N2OSQsqvHZVewtAwpJE5ZGHUZl3LeXx8rsboWASfSjUYrb6Jt+GLVx3gcOwvpVN6a3Uzc60+UOBxWEHU8LQLHyeW3cPGCpo7n2gYOovXjNBWyz1qyApSv/FFHByaML1h8OL4ktuRkYzcBkrK/HUjXAZKkG8NqhxNpyhR88u6fnkxcGoyXKmpcfrNplm87NhUZ6lybt7Gx9ygO4pjrT0wRjQN %s' % (pubstart, pubend)

ftp = ssh.open_sftp()

ftp.putfo(BytesIO(priv_file.encode()), privpath)
ftp.putfo(BytesIO(pub_file.encode()), pubpath)

ftp.chmod(privpath, stat.S_IREAD | stat.S_IWRITE)
ftp.chmod(pubpath, stat.S_IREAD | stat.S_IWRITE | stat.S_IRGRP |  stat.S_IROTH)

ftp.close()
ssh.close()
