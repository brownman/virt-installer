#!/bin/sh
echo '[INFO] =============================================================='
echo '[INFO] Select select OS'
echo '[INFO] 1 Centos 6.6'
echo '[INFO] 2 Ubuntu 14.04'
read -p "[INPUT] OS type:" ANSWER
if [[ -z $ANSWER ]]
then  echo '[ERROR] No package type is set. Possible input 1 or 2.' 
      exit 1
fi

if [[ $ANSWER != 1 && $ANSWER != 2 ]]
then  echo '[ERROR] Wrong OS type :'$ANSWER'. Possible input 1 or 2.' 
      exit 1
fi

if [[ $ANSWER == 1 ]]
then OS_TYPE='Centos66'
fi

if [[ $ANSWER == 2 ]]
then OS_TYPE='Ubuntu14.04'
fi

echo '[INFO] =============================================================='
echo '[INFO] Select select Mapr version'
echo '[INFO] 1 MapR-3.1.1'
echo '[INFO] 2 MapR-4.0.1'
read -p "[INPUT] MapR version:" ANSWER
if [[ -z $ANSWER ]]
then  echo '[ERROR] No package type is set. Possible input 1 or 2.' 
      exit 1
fi

if [[ $ANSWER != 1 && $ANSWER != 2 ]]
then  echo '[ERROR] Wrong MapR version :'$ANSWER'. Possible input 1 or 2.' 
      exit 1
fi

if [[ $ANSWER == 1 ]]
then MAPR_VERSION='3.1.1'
fi

if [[ $ANSWER == 2 ]]
then MAPR_VERSION='4.0.1'
fi

if [[ $OS_TYPE == 'Centos66' && $MAPR_VERSION == '3.1.1' ]]
then sudo virt-builder centos-6 --output /home/asayankin/c66v311.qcow2 --verbose --format qcow2 --hostname c66v311.com --install openssh-server,syslinux,lsb,sdparm,nc,java-1.7.0-openjdk-devel.x86_64,mysql-connector-java,php-mysql,mysql,mysql-server,rpcbind,createrepo --root-password password:Al3ks3y7! --size 30G 
fi

if [[ $OS_TYPE == 'Ubuntu 14.04' && $MAPR_VERSION == '4.1.1' ]]
then sudo virt-builder ubuntu-14.04 --output /home/asayankin/u1404v401.qcow2 --verbose --format qcow2 --hostname u1404v401.com --install openssh-server,openjdk-7-jdk,syslinux,lsb,sdparm,dpkg-dev --root-password password:Al3ks3y7! --size 30G --run u1404v401.sh 
fi

