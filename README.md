virt-installer
==============

INTRODUCTION
------------

Virtual machines installer for  single node cluster. Following OS for cluster
 are supported:

- CentOS 6.6
- Ubuntu 14.04

Following versions of cluster are supported:

- 3.1.1
- 4.0.1
- 4.0.2
- 5.0.0

**NOTE!** This project is used *only for testing purposes* and not for production mode.

REQUIREMENTS
------------

This module requires the following modules:

- xml2
- libxml2
- libguestfs-tools
- KVM
- Virtual Machine Manager

You also need to cache templates for OS images before running virt-inst.sh:

```
    virt-builder --cache-all-templates
```

INSTALLATION
------------

To install project:
 
1.Check if your CPU supports virtualization

    sudo apt-get install cpu-checker
    sudo kvm-ok

2.Clone project from github:

    git clone https://github.com/sayankin-aleksey/virt-installer.git

3.Install additional packages:

 3.1.Install common packages 

    sudo apt-get install xml2 libxml2 flex bison

 3.2.Download and install supermin version 5.1.9
 
    http://www.ubuntuupdates.org/package/core/vivid/universe/base/supermin

4.Add repo and install new virt-manager
 
    wget -q -O - http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -  
    sudo sh -c 'echo "deb http://archive.getdeb.net/ubuntu vivid-getdeb apps" >> /etc/apt/sources.list.d/getdeb.list' 
    sudo apt-get install virt-manager
 
 5.Install libguestfs-tools
 
  5.1.Install libguestfs dependencies
  
    sudo apt-get build-dep libguestfs
  
  5.2.Download libguestfs version 1.28.10 to your /home/<username> folder. Replace <username> with your actual user name.
  
    cd /home/<username>  
    wget 'http://libguestfs.org/download/1.28-stable/libguestfs-1.28.10.tar.gz'
  
  5.3.Untar to /home/<username> folder
   
    tar -xvzf libguestfs-1.28.10.tar.gz
   
  5.4.Build libguestfs 
   
    cd ~/libguestfs-1.28.10/   
    ./configure  
    make

6.Install KVM

    sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

CONFIGURATION
-------------

Configure following parameters in $VIRT_INSTALLER_HOME/conf/env.sh

- OS_IMAGE_DIR
- OS_IMAGE_ROOT_PASSWD
- SSH_ID_RSA_PUB

Set LIBGUESTFS_HOME to libguestfs location

USAGE
-----

To start virtual machine creation:

1) Execute in command line:

    bash virt-inst.sh

2) Enter needed parameters. Note you can see default value of parameter in brackets [],
   just press [ENTER] in input line to use it.


MAINTAINERS
-----------

Current maintainers:

* Oleksiy Sayankin
