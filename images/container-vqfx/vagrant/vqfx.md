```
mwiget@xeon:~/Dropbox/git/vqfx10k-vagrant/full-1qfx$ vagrant ssh vqfx
--- JUNOS 18.1R1.9 built 2018-03-23 20:37:00 UTC
{master:0}
vagrant@vqfx-re> start shell
% ifconfig em1
em1:    encaps: ether; framing: ether
    flags=0x3/0x8000 <PRESENT|RUNNING>
    curr media: i802 8:0:27:18:42:3f
em1.0:    flags=0xc000 <UP|MULTICAST>
    inet primary mtu 9486 local=169.254.0.2 dest=169.254.0.0/24 bcast=169.254.0.255
% ifconfig em0
em0:    encaps: ether; framing: ether
    flags=0x3/0x8000 <PRESENT|RUNNING>
    curr media: i802 8:0:27:e0:cd:51
em0.0:    flags=0x4008000 <UP|MULTICAST>
    inet mtu 1500 local=10.0.2.15 dest=10.0.2.0/24 bcast=10.0.2.255
%
```

```
mwiget@xeon:~/Dropbox/git/vqfx10k-vagrant/full-1qfx$ vagrant ssh vqfx-pfe
localhost:~$ sudo su -

root@localhost:~# ifconfig
eth0      Link encap:Ethernet  HWaddr 08:00:27:a9:d0:c4
          inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:fea9:d0c4/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:272 errors:0 dropped:0 overruns:0 frame:0
          TX packets:213 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:25403 (24.8 KiB)  TX bytes:32180 (31.4 KiB)

eth1      Link encap:Ethernet  HWaddr 08:00:27:28:9c:1c
          inet addr:169.254.0.1  Bcast:169.254.0.255  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:fe28:9c1c/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:995644 errors:0 dropped:0 overruns:0 frame:0
          TX packets:302635 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:96945224 (92.4 MiB)  TX bytes:21995916 (20.9 MiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


root@localhost:~# netstat -atn
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 0.0.0.0:3000            0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:3001            0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.1:953           0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:1534            0.0.0.0:*               LISTEN
tcp        0      0 169.254.0.1:53          0.0.0.0:*               LISTEN
tcp        0      0 10.0.2.15:53            0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.1:53            0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp        0      0 169.254.0.1:3000        169.254.0.2:61625       ESTABLISHED
tcp        0      0 10.0.2.15:22            10.0.2.2:34896          ESTABLISHED
tcp        0      0 169.254.0.1:3000        169.254.0.2:59005       ESTABLISHED
tcp        0      0 169.254.0.1:3001        169.254.0.2:55656       ESTABLISHED
tcp        0      0 169.254.0.1:3000        169.254.0.2:51019       ESTABLISHED
tcp6       0      0 :::22                   :::*                    LISTEN

```

cosim seems to have a fixed IP 169.254.0.1
YES

```
root@localhost:/etc# grep -r 169.254.0.1 *
network/interfaces:address 169.254.0.1
```

vqfx has a fix address of 169.254.0.2/24

