#!/bin/sh
echo $0

if [ `cat checksum.txt | grep u-boot.bin | wc -l` = '1' ];then
	dd if=u-boot.bin of=/dev/mtdblock0 bs=1k count=512 seek=1024
fi
if [ `cat checksum.txt | grep env.img | wc -l` = '1' ];then
	dd if=env.img of=/dev/mtdblock0 bs=1k count=128 seek=512
fi
cp S99setbootflag /media/userdata/


