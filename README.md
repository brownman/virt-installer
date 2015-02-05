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

**NOTE!** This project is used *only for testing purposes* and not for production mode.

REQUIREMENTS
------------

This module requires the following modules:

- xml2
- libxml2
- libguestfs-tools
- KVM (qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils). See https://help.ubuntu.com/community/KVM/Installation

You also need to cache templates for OS images before running virt-inst.sh:

```
    virt-builder --cache-all-templates
```

INSTALLATION
------------

To install project clone it from github:

```
git clone https://github.com/sayankin-aleksey/virt-installer.git
```

CONFIGURATION
-------------

Configure following parameters in $VIRT_INSTALLER_HOME/conf/env.sh

- OS_IMAGE_DIR
- OS_IMAGE_ROOT_PASSWD
- SSH_ID_RSA_PUB

USAGE
-----

To start virtual machine creation:

1) Execute in command line:

```
    bash virt-inst.sh
```

2) Enter needed parameters. Note you can see default value of parameter in brackets [],
   just press [ENTER] in input line to use it.


MAINTAINERS
-----------

Current maintainers:

* Oleksiy Sayankin
