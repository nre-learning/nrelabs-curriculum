# Ansible tower image 
Build and run an Ansible tower image by using packer for image creation and qemu container to run image.

## Requirements
- Packer installed 
- Docker environment
- [Ansible tower requirements](https://docs.ansible.com/ansible-tower/latest/html/installandreference/requirements_refguide.html)
- KVM kernel module must be loaded


# Steps to create and run image
1. Set values in inventory file 
2. Set tower host image root password
3. Build image using packer
4. Run image in qemu container

Change passwords in inventory and image file before proceeding with any other steps.

## Set values in inventory file
Open `inventory` file and change passwords.
 
```ini
[tower]
localhost ansible_connection=local

[database]

[all:vars]
admin_password='juniper123'

pg_host=''
pg_port=''

pg_database='awx'
pg_username='awx'
pg_password='juniper123'

rabbitmq_username='tower'
rabbitmq_password='juniper123'
rabbitmq_cookie=cookiemonster
```

## Set tower host image root password
Open file `tower.json`. Change root user password in following line:

```yaml
"ssh_password": "passwd",
```

## Create image
Ansible tower installer checks available RAM during installation. 
Packer creates installation environment according to minimum requirements regarding CPU and RAM.

Output while creating image:

```bash
mkfifo /tmp/qemu-serial.in /tmp/qemu-serial.out
```

```bash
cat /tmp/qemu-serial.out
```

Open new session e.g. ssh session to build host and run:

```bash
PACKER_LOG=1 packer build tower.json
```

Final image can be found in __build__ directory. 

## Run image
Qemu container is used to run Ansible tower by using `tianon/qemu` image. 
Change volume bind path option to fit environment `-v`.
 
```bash
docker run -it --rm \
    --privileged \
	--device /dev/kvm \
	--name ansible-tower-qemu \
	-v /home/juniper/packer-centos-8/build/centos-8-amd64-1589567398.qcow2:/tmp/hda.qcow2 \
	-e QEMU_HDA=/tmp/hda.qcow2 \
	-e QEMU_CPU=2 \
	-e QEMU_RAM=2048 \
	-e QEMU_PORTS='80 443' \
	-p 8888:80 -p 8443:443 \
    -p 2222:22 \
	tianon/qemu
```

# Conclusion
- Image size is at 4GB. while 3.1 GB used inside system 
- Container boot time is less than 1 min
- 2GB of RAM seems to be enough to run all the services
- License activation through WEB UI is broken since needed certificates are missing
- KVM kernel module needed
