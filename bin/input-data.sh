#!/bin/sh

function get_input_from_console(){

echo '[INFO] Select OS'
echo '[INFO] 1 Centos 6.6'
echo '[INFO] 2 Ubuntu 14.04'
while true; do
read -p "[INPUT] OS type ["$OS_TYPE"]:" ANSWER
if [[ -n $ANSWER ]]
then
    if [[ $ANSWER != 1 && $ANSWER != 2 ]]
    then  echo '[ERROR] Wrong OS type :'$ANSWER'. Possible input 1 or 2.'
    fi

    if [[ $ANSWER == 1 ]]
    then OS_TYPE='Centos66'
         break
    fi

    if [[ $ANSWER == 2 ]]
    then OS_TYPE='Ubuntu14.04'
         break
    fi
else break
fi
done

echo '[INFO] Select Mapr version'
echo '[INFO] 1 MapR-3.1.1'
echo '[INFO] 2 MapR-4.0.1'
echo '[INFO] 3 MapR-4.0.2'
while true; do
read -p "[INPUT] MapR version ["$MAPR_VERSION"]:" ANSWER
if [[ -n $ANSWER ]]
then
    if [[ $ANSWER != 1 && $ANSWER != 2 && $ANSWER != 3 ]]
    then  echo '[ERROR] Wrong MapR version :'$ANSWER'. Possible input 1, 2 or 3.'
    fi

    if [[ $ANSWER == 1 ]]
    then MAPR_VERSION='3.1.1'
         break
    fi

    if [[ $ANSWER == 2 ]]
    then MAPR_VERSION='4.0.1'
         break
    fi

    if [[ $ANSWER == 3 ]]
    then MAPR_VERSION='4.0.2'
        break
    fi
else break
fi
done


read -p "[INPUT] Image dir ["$OS_IMAGE_DIR"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_DIR=$ANSWER
fi


while true; do
read -p "[INPUT] Image format ["$OS_IMAGE_FORMAT"]: " ANSWER
if [[ -n $ANSWER ]]
then
    if [[ $ANSWER != raw && $ANSWER != qcow2 ]]
    then  echo '[ERROR] Wrong image format :'$ANSWER'. Possible input raw or qcow2.'
          continue
    fi
    OS_IMAGE_FORMAT=$ANSWER
    break
else break
fi
done



read -p "[INPUT] Image root password ["$OS_IMAGE_ROOT_PASSWD"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_ROOT_PASSWD=$ANSWER
fi

while true; do
read -p "[INPUT] Image size (GB) ["$OS_IMAGE_SIZE"]: " ANSWER
if [[ -n $ANSWER ]]
then
    if [[ -n ${ANSWER//[0-9]/} ]]
    then echo '[ERROR] Wrong image size :'$ANSWER'. Possible input must be an integer.'
         continue
    fi

    if [[ $ANSWER -le 0 ]]
    then echo '[ERROR] Wrong image size :'$ANSWER'. Possible input must be greater than 0.'
         continue
    fi
    OS_IMAGE_SIZE=$ANSWER
    break
else break
fi
done


while true; do
read -p "[INPUT] Image RAM size (MB) ["$OS_IMAGE_MEMORY"]: " ANSWER
if [[ -n $ANSWER ]]
then
    if [[ -n ${ANSWER//[0-9]/} ]]
    then echo '[ERROR] Wrong image RAM size :'$ANSWER'. Possible input must be an integer.'
         continue
    fi

    if [[ $ANSWER -le 0 ]]
    then echo '[ERROR] Wrong image RAM size :'$ANSWER'. Possible input must be greater than 0.'
         continue
    fi
    OS_IMAGE_MEMORY=$ANSWER
    break
else break
fi
done


while true; do
read -p "[INPUT] Image virtual CPU count ["$OS_IMAGE_VIRT_CPU"]: " ANSWER
if [[ -n $ANSWER ]]
then
    if [[ -n ${ANSWER//[0-9]/} ]]
    then echo '[ERROR] Wrong image virtual CPU count :'$ANSWER'. Possible input must be an integer.'
         continue
    fi

    if [[ $ANSWER -le 0 ]]
    then echo '[ERROR] Wrong image virtual CPU count :'$ANSWER'. Possible input must be greater than 0.'
         continue
    fi
    OS_IMAGE_VIRT_CPU=$ANSWER
    break
else break
fi
done


OS_IMAGE_HOST_NAME=$(build_token $OS_TYPE $MAPR_VERSION).com

read -p "[INPUT] Image hostname ["$OS_IMAGE_HOST_NAME"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_HOST_NAME=$ANSWER
fi

OS_IMAGE_HOST_ALIAS=$(build_token $OS_TYPE $MAPR_VERSION)

read -p "[INPUT] Image host alias ["$OS_IMAGE_HOST_ALIAS"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_HOST_ALIAS=$ANSWER
fi

OS_IMAGE_FILE_NAME=$(build_token $OS_TYPE $MAPR_VERSION).$OS_IMAGE_FORMAT

read -p "[INPUT] Image filename ["$OS_IMAGE_FILE_NAME"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_FILE_NAME=$ANSWER
fi


read -p "[INPUT] MapR cluster name ["$OS_IMAGE_CLUSTER_NAME"]: " ANSWER
if [[ -n $ANSWER ]]
then OS_IMAGE_CLUSTER_NAME=$ANSWER
fi


echo '[INFO] Select Hbase version'
echo '[INFO] 1 0.94.21'
echo '[INFO] 2 0.98.4'
while true; do
read -p "[INPUT] Hbase version ["$HBASE_VERSION"]:" ANSWER
if [[ -n $ANSWER ]]
then
    if [[ $ANSWER != 1 && $ANSWER != 2 ]]
    then  echo '[ERROR] Wrong Hbase version :'$ANSWER'. Possible input 1 or 2.'
    fi

    if [[ $ANSWER == 1 ]]
    then HBASE_VERSION='0.94.21'
         break
    fi

    if [[ $ANSWER == 2 ]]
    then HBASE_VERSION='0.98.4'
         break
    fi
else break
fi
done


read -p "[INPUT] Lets rock'n'roll (1 - yes, 0 - no)? ["$LETS_ROCK_N_ROLL"]: " ANSWER
if [[ -n $ANSWER ]]
then LETS_ROCK_N_ROLL=$ANSWER
fi

export OS_IMAGE_DIR=$OS_IMAGE_DIR
export OS_IMAGE_FORMAT=$OS_IMAGE_FORMAT
export OS_IMAGE_SIZE=$OS_IMAGE_SIZE
export OS_IMAGE_ROOT_PASSWD=$OS_IMAGE_ROOT_PASSWD
export OS_TYPE=$OS_TYPE
export MAPR_VERSION=$MAPR_VERSION
export LETS_ROCK_N_ROLL=$LETS_ROCK_N_ROLL
export HBASE_VERSION=$HBASE_VERSION
export OS_IMAGE_CLUSTER_NAME=$OS_IMAGE_CLUSTER_NAME
export OS_IMAGE_HOST_NAME=$OS_IMAGE_HOST_NAME
export OS_IMAGE_HOST_ALIAS=$OS_IMAGE_HOST_ALIAS
export OS_IMAGE_FILE_NAME=$OS_IMAGE_FILE_NAME
export OS_IMAGE_MEMORY=$OS_IMAGE_MEMORY
export OS_IMAGE_VIRT_CPU=$OS_IMAGE_VIRT_CPU

}