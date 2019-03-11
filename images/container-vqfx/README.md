# container-vQFX

This project aims to run vQFX10K with the cosim based PFE in a Docker Container, similar to https://github.com/juniper/OpenJNPR-Container-vMX, so it can be used jointly to build up datacenter topologies via docker-compose. Cosim (PFE) runs natively in the Docker container. No need for a PFE Virtual Machine!

## Requirements

- Baremetal server running Linux kernel 4.12 or newer (requires a macvtap fix [tap: Refactoring macvtap.c](https://github.com/torvalds/linux/commit/a8e04698732736f59fefe72c675791a006b76e1d)
- vQFX RE disk image. Download latest (18.1) vQFX10K RE Disk Image from https://www.juniper.net/us/en/dm/free-vqfx-trial/
- cosim.tgz file from the PFE disk image. Use script [vagrant/extract_pfe_files.sh](vagrant/extract_pfe_files.sh) to download and extract the file into the [src](src) directory from which the container image will be built.
- Vagrant (only to extract cosim.tgz)
- Docker and docker-compose

## Example run

Makefile is used to extract cosim.tgz from the plublic vagrant box and build of the docker container. The users public SSH (rsa) key is copied into the current directory and used to update the vQFX configuration to allow password-less access, once the devices are running.

Update [docker-compose.yml](docker-compose.yml) with the vQFX RE image and config file. The management port (em0) IP address and user account with ssh public key will be  automatically added to the Junos config file at runtime. The example launches 2 vQFX running 18.1R1, interconnected via xe-0/0/0:

```
$ make
docker-compose up -d
WARNING: Some networks were defined but are not used by any service: net-b, net-c
Creating network "container-vqfx_mgmt" with the default driver
Creating network "container-vqfx_net-a" with the default driver
Creating container-vqfx_vqfx1_1 ... done
Creating container-vqfx_vqfx2_1 ... done
sudo scripts/lldp_passthru.sh
enabling LLDP passthru the docker linux bridges ...
br-56beb307cc34 br-863de74e4d69 br-b660dc877241
done.
```

Use 'make ps' to check the status of the containers:

```
$ make ps
docker-compose ps
WARNING: Some networks were defined but are not used by any service: net-b, net-c
Name             Command     State                       Ports
-------------------------------------------------------------------------------------------
container-vqfx_vqfx1_1   /launch.sh   Up      0.0.0.0:33267->22/tcp, 0.0.0.0:33266->830/tcp
container-vqfx_vqfx2_1   /launch.sh   Up      0.0.0.0:33271->22/tcp, 0.0.0.0:33270->830/tcp
scripts/getpass.sh
vQFX container-vqfx_vqfx2_1 (192.168.128.3) 18.1R1.9 iexohqu2exie9ohQuaidaipu ready
vQFX container-vqfx_vqfx1_1 (192.168.128.2) 18.1R1.9 ohquaeba9ohcaS3quee0Jipi ...

. . .

$ make ps
docker-compose ps
WARNING: Some networks were defined but are not used by any service: net-b, net-c
Name             Command     State                       Ports
-------------------------------------------------------------------------------------------
container-vqfx_vqfx1_1   /launch.sh   Up      0.0.0.0:33267->22/tcp, 0.0.0.0:33266->830/tcp
container-vqfx_vqfx2_1   /launch.sh   Up      0.0.0.0:33271->22/tcp, 0.0.0.0:33270->830/tcp
scripts/getpass.sh
vQFX container-vqfx_vqfx2_1 (192.168.128.3) 18.1R1.9 iexohqu2exie9ohQuaidaipu ready
vQFX container-vqfx_vqfx1_1 (192.168.128.2) 18.1R1.9 ohquaeba9ohcaS3quee0Jipi ready
```

Both vQFX are ready. Log into either of them using the shown IP address. No password is 
required, because your ssh rsa public key was added to the vqfx junos config during launch.

```
$ ssh 192.168.128.2
The authenticity of host '192.168.128.2 (192.168.128.2)' can't be established.
ECDSA key fingerprint is SHA256:naeUjnXl/A3juWVSkLX5CDH4Lmabc3jIOdEz1ydqWpQ.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.128.2' (ECDSA) to the list of known hosts.
--- JUNOS 18.1R1.9 built 2018-03-23 20:37:00 UTC
{master:0}
mwiget@container-vqfx_vqfx1_1> show lldp neighbors
Local Interface    Parent Interface    Chassis Id          Port info          System Name
xe-0/0/0           -                   02:05:86:71:db:00   xe-0/0/0           container-vqfx_vqfx2_1

{master:0}
mwiget@container-vqfx_vqfx1_1> show chassis fpc
                     Temp  CPU Utilization (%)   CPU Utilization (%)  Memory    Utilization (%)
Slot State            (C)  Total  Interrupt      1min   5min   15min  DRAM (MB) Heap     Buffer
  0  Online           Testing   1         0        0      0      0    1024        0         71
  1  Empty
  2  Empty
  3  Empty
  4  Empty
  5  Empty
  6  Empty
  7  Empty
  8  Empty
  9  Empty

{master:0}
mwiget@container-vqfx_vqfx1_1>
mwiget@container-vqfx_vqfx1_1> show interfaces terse xe-0/0/0
Interface               Admin Link Proto    Local                 Remote
xe-0/0/0                up    up
xe-0/0/0.0              up    up   inet     192.168.1.101/24

{master:0}
mwiget@container-vqfx_vqfx1_1> ping 192.168.1.102
PING 192.168.1.102 (192.168.1.102): 56 data bytes
64 bytes from 192.168.1.102: icmp_seq=0 ttl=64 time=306.115 ms
64 bytes from 192.168.1.102: icmp_seq=1 ttl=64 time=102.766 ms
^C
--- 192.168.1.102 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max/stddev = 102.766/204.441/306.115/101.674 ms

{master:0}
mwiget@container-vqfx_vqfx1_1> show arp
MAC Address       Address         Name                      Interface               Flags
32:71:d7:15:d6:8b 169.254.0.1     169.254.0.1               em1.0                   none
02:42:c0:a8:90:03 192.168.1.102   192.168.1.102             xe-0/0/0.0              none
02:42:e0:0e:9a:6c 192.168.128.1   192.168.128.1             em0.0                   none
Total entries: 3

{master:0}
mwiget@container-vqfx_vqfx1_1> quit

Connection to 192.168.128.2 closed.
```

Docker stats showing the resource usage:

```
$ docker stats
CONTAINER ID        NAME                     CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
2f6321ecf9af        container-vqfx_vqfx2_1   6.73%               1.135GiB / 125.8GiB   0.90%               49kB / 21.6kB       363kB / 2.66GB      6
d980370c0af8        container-vqfx_vqfx1_1   6.96%               1.135GiB / 125.8GiB   0.90%               80.8kB / 42.8kB     359kB / 1.8GB       6
^C
```

### Known Issues

- Kernel 4.15.0-29-generic from Ubuntu 18.04.1 experiences packet forwarding delays thru vQFX > 1 second. Upgrading to kernel 4.15.0-44-generic and newer solved this.
- MTU > 1500 doesn't work. Under investigation.

### Images

Temporary links:

- https://www.dropbox.com/s/e16ze8jrs4on3g3/jinstall-vqfx-10-f-18.1R1.9.img?dl=0
- https://www.dropbox.com/s/p776lvt2emhrgq4/jinstall-vqfx-10-f-18.4R1.8.img?dl=0
- Container image: marcelwiget/xfqv:latest

