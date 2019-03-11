# Extract cosim from vQFX PFE

Requires vagrant to download and boot vagrant box vqfx-pfe, then extract the required files.

```
$ make
vagrant up
Bringing machine 'vqfx-pfe' up with 'virtualbox' provider...
==> vqfx-pfe: Importing base box 'juniper/vqfx10k-pfe'...
==> vqfx-pfe: Matching MAC address for NAT networking...
==> vqfx-pfe: Setting the name of the VM: vagrant_vqfx-pfe_1544338735185_32330
==> vqfx-pfe: Fixed port collision for 22 => 2222. Now on port 2206.
==> vqfx-pfe: Clearing any previously set network interfaces...
==> vqfx-pfe: Preparing network interfaces based on configuration...
    vqfx-pfe: Adapter 1: nat
    vqfx-pfe: Adapter 2: intnet
==> vqfx-pfe: Forwarding ports...
    vqfx-pfe: 22 (guest) => 2206 (host) (adapter 1)
==> vqfx-pfe: Booting VM...
==> vqfx-pfe: Waiting for machine to boot. This may take a few minutes...
    vqfx-pfe: SSH address: 127.0.0.1:2206
    vqfx-pfe: SSH username: vagrant
    vqfx-pfe: SSH auth method: private key
==> vqfx-pfe: Machine booted and ready!
==> vqfx-pfe: Checking for guest additions in VM...
    vqfx-pfe: No guest additions were detected on the base box for this VM! Guest
    vqfx-pfe: additions are required for forwarded ports, shared folders, host only
    vqfx-pfe: networking, and more. If SSH fails on this machine, please install
    vqfx-pfe: the guest additions and repackage the box to continue.
    vqfx-pfe:
    vqfx-pfe: This is not an error message; everything may continue to work properly,
    vqfx-pfe: in which case you may ignore this message.
./extract_pfe_files.sh
downloading files from vagrant box vqfx-pfe (scp -P 2206 -i /home/mwiget/.vagrant.d/insecure_private_key vagrant@) ...
S99zhcosim                                                                                                              100%  269   474.5KB/s   00:00
cosim.tgz                                                                                                               100%  128MB  43.3MB/s   00:02
-rwxr-xr-x 1 mwiget mwiget       269 Dec  9 07:59 S99zhcosim
-rw-r--r-- 1 mwiget mwiget 134064658 Dec  9 07:59 cosim.tgz
vagrant destroy -f
==> vqfx-pfe: Forcing shutdown of VM...
==> vqfx-pfe: Destroying VM and associated drives...
```

The following files are now available to build the vqfx container:

```
$ ls -l S99zhcosim cosim.tgz
-rwxr-xr-x 1 mwiget mwiget       269 Dec  9 07:59 S99zhcosim
-rw-r--r-- 1 mwiget mwiget 134064658 Dec  9 07:59 cosim.tgz
```

