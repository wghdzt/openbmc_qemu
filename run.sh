#!/bin/bash
reset
clear

#QEMU_PATH="/home/wangr/openbmc/build/qemu/build/arm-softmmu/qemu-system-arm"
QEMU_PATH="/home/wangr/openbmc/build/qemu/build/arm-softmmu/qemu-system-arm"
#QEMU_PATH="/home/wangr/tools/qemu-system-arm"

PWD=`pwd`

MACHIN=`cat conf/local.conf | grep "MACHINE ??" | cut -d "\"" -f 2`

set_soc()
{
	QEMU_SOC="g220a-bmc"
	MACHIN=""
}

QEMU_LOCALHOST=" -net user,hostfwd=:127.0.0.1:2222-:22,hostfwd=:127.0.0.1:2443-:443,hostname=qemu"
QEMU_VIRT=",macaddr=10:aa:bb:00:00:02,model=ftgmac100 -net bridge,id=net0,helper=/usr/lib/qemu-bridge-helper,br=virbr0"

QEMU_NET=$QEMU_LOCALHOST

set_soc

IMAGE=$PWD/tmp/deploy/images/$MACHIN/obmc-phosphor-image-$MACHIN.static.mtd
BACK_IMAGE="$IMAGE.back"
rm -rf $BACK_IMAGE
cp $IMAGE $BACK_IMAGE

QEMU_CMD="-M $QEMU_SOC -nographic -drive file=$BACK_IMAGE,format=raw,if=mtd -net nic$QEMU_NET"

sudo $QEMU_PATH $QEMU_CMD
