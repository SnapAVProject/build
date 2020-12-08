#!/bin/sh
echo $0
cp S99setbootflag /media/userdata/

#which nandwrite
checkfstype=`./fw_printenv -c ./fw_env.config  | grep fstype=squashfs | wc -l`
if [ $checkfstype != 0  ] ;then 
	# if $? == 0 means that there is no nandwrite tool ,it is	old rootfs
	part=`cat /proc/cmdline | cut -d ' ' -f 4`
	if [ $part = "root=/dev/mtdblock4" ] ;then
		./flash_erase /dev/mtd1 0 0
		./nandwrite -p /dev/mtd1 ./boot.img

		./flash_erase /dev/mtd3 0 0
		./nandwrite -p /dev/mtd3 ./rootfs.img
		
	else
		./flash_erase /dev/mtd2 0 0
		./nandwrite -p /dev/mtd2 ./boot.img

		./flash_erase /dev/mtd4 0 0
		./nandwrite -p /dev/mtd4 ./rootfs.img
	fi
	ln -s fw_printenv fw_setenv
	./fw_setenv fstype jffs2 -c ./fw_env.config

fi

exit;

if [ `cat checksum.txt | grep u-boot.bin | wc -l` = '1' ];then
	dd if=u-boot.bin of=/dev/mtdblock0 bs=1k count=512 seek=1024
fi
if [ `cat checksum.txt | grep env.img | wc -l` = '1' ];then
	dd if=env.img of=/dev/mtdblock0 bs=1k count=128 seek=512
fi


