#!/bin/bash

boardtype=$2
app=$3
dsp=$4

printuse(){

	echo Usage:$0 all/uboot/kernel/rootfs

}


buildkernel(){
	echo buildkernel
	cd ../linux3.10/

	#echo "cp ../build/kernelconfig/${boardtype}_config .config"
	cp ../build/kernelconfig/${boardtype}_config .config
	#make dtbs
	#cp arch/arm/boot/dts/nuc972-evb.dtb ../image/

	make uImage -j8
	make modules -j8

	#cp ../image/970uimage /home/tftp/970uImage

	#dd if=/dev/zero of=../image/boot.img bs=1M count=6

	if [ $boardtype = 'snapav2d'  ];then
	 cp drivers/input/keyboard/gpio_keys.ko ../nuc970_buildroot/board/nuvoton/hs_rootfs/lib/modules/3.10.108+/
	elif [ $boardtype = 'snapav8d' ];then
	 echo cp drivers/input/keyboard/gpio_keys.ko ../nuc970_buildroot/board/nuvoton/hs_rootfs_8d/lib/modules/3.10.108+/
	 cp drivers/input/keyboard/gpio_keys.ko ../nuc970_buildroot/board/nuvoton/hs_rootfs_8d/lib/modules/3.10.108+/
	elif [ $boardtype = 'snapav12d' ];then
	 cp drivers/input/keyboard/gpio_keys.ko ../nuc970_buildroot/board/nuvoton/hs_rootfs_12d/lib/modules/3.10.108+/
	elif [ $boardtype = 'snapav16d' ];then
	 cp drivers/input/keyboard/gpio_keys.ko ../nuc970_buildroot/board/nuvoton/hs_rootfs_16d/lib/modules/3.10.108+/
	elif [ $boardtype = 'snapav51' ];then
 	 cp drivers/input/keyboard/gpio_keys.ko ../nuc970_buildroot/board/nuvoton/hs_rootfs_51/lib/modules/3.10.108+/
	else
		echo "unsupport  board $boardtype"
	fi


	cat  arch/arm/boot/uImage > ../image/boot.img
	sizeo=`du ../image/boot.img -b | awk '{print $1}'`
	echo $sizeo
	size=`expr 4 \* 1024 \* 1024 - $sizeo`
	echo $size
	dd if=/dev/zero of=../image/boot.img.tmp   bs=1 count=$size 
	cat ../image/boot.img.tmp >> ../image/boot.img
	if [ 1 -eq 0 ];then
		cat arch/arm/boot/dts/nuc972-evb.dtb >>../image/boot.img
		sizeo=`du ../image/boot.img -b | awk '{print $1}'`
		echo $sizeo
		size=`expr 6 \* 1024 \* 1024 - $sizeo`
		echo $size
		dd if=/dev/zero of=../image/boot.img.tmp   bs=1 count=$size 
		cat ../image/boot.img.tmp >> ../image/boot.img
	fi
	rm ../image/boot.img.tmp

	cd -
	./upload.sh ../image/boot.img $boardtype

}
builduboot(){
	echo builduboot
	cd ../uboot/
	cp ../build/ubootconfig/defconfig .config
	make ARCH=arm CROSS_COMPILE=../host/usr/bin/arm-linux-
	cp u-boot.bin ../image/
	cd -
}

buildrootfs(){
	echo buildrootfs
	cd ../nuc970_buildroot/
	echo cp ../build/buildrootconfig/${boardtype}_buildroot_config .config
	cp ../build/buildrootconfig/${boardtype}_buildroot_config .config
	make BOARDTYPE=$boardtype SNAPAV_APP_VERSION=$app SNAPAV_DSP_VERSION=$dsp

	#cd ../Rootfs/
	#./buildjffs2img.sh
	#cp rootfs.img ../image/
	cd -
}
buildbootflag(){
	echo buildbootflag
	echo  "SNAPAV_OTA" >flag.img
	sizeo=`du flag.img -b | awk '{print $1}'`
	sizeo=`expr $sizeo - 1`
	echo $sizeo
	size=`expr 128 \* 1024 - $sizeo `
	echo $size
	dd if=/dev/zero of=flag.img   bs=1 count=$size seek=$sizeo
	#dd if=/dev/zero of=../image/boot.img.tmp   bs=1 count=$size 
	#cat ../image/boot.img.tmp >> ../image/flag.img

	if true; then	
	echo  "FACTORY_INFO" >>flag.img
	sizeo=`du flag.img -b | awk '{print $1}'`
	sizeo=`expr $sizeo - 1`
	echo $sizeo
	size=`expr 256 \* 1024 - $sizeo`
	echo $size
	dd if=/dev/zero of=flag.img   bs=1 count=$size seek=$sizeo

	#dd if=/dev/zero of=../image/boot.img.tmp   bs=1 count=$size  
	
	cat flag.img > ../image/flag.img
	fi
	rm flag.img


}
buildbootloader() {
	cat ../image/u-boot-spl.bin > ../image/bootloader.img
	sizeo=`du ../image/bootloader.img -b | awk '{print $1}'`
	echo $sizeo
	size=`expr 512 \* 1024 - $sizeo`
	echo $size
	dd if=/dev/zero of=../image/boot.img.tmp   bs=1 count=$size 
	cat ../image/boot.img.tmp >> ../image/bootloader.img

	cat ../image/env_nand.txt >> ../image/bootloader.img
	sizeo=`du ../image/bootloader.img -b | awk '{print $1}'`
	echo $sizeo
	size=`expr 1024 \* 1024 - $sizeo`
	echo $size
	dd if=/dev/zero of=../image/boot.img.tmp   bs=1 count=$size 
	cat ../image/boot.img.tmp >> ../image/bootloader.img

	cat ../image/u-boot.bin >> ../image/bootloader.img


	sizeo=`du ../image/bootloader.img -b | awk '{print $1}'`
	echo $sizeo
	size=`expr 1792 \* 1024 - $sizeo`
	echo $size
	dd if=/dev/zero of=../image/boot.img.tmp   bs=1 count=$size 
	cat ../image/boot.img.tmp >> ../image/bootloader.img

	cat ../image/flag.img >> ../image/bootloader.img

	return;
	sizeo=`du ../image/bootloader.img -b | awk '{print $1}'`
	echo $sizeo
	size=`expr 2048 \* 1024 - $sizeo`
	echo $size
	dd if=/dev/zero of=../image/boot.img.tmp   bs=1 count=$size 
	cat ../image/boot.img.tmp >> ../image/bootloader.img


}
buildfw(){
	echo build fw
	if [ $boardtype = 'snapav2d' ];then
		cd ./fw/snapav/
	elif [ $boardtype = 'snapav8d' ];then
		cd ./fw/snapav8d/
	elif [ $boardtype = 'snapav12d' ];then
		cd ./fw/snapav12d/
	elif [ $boardtype = 'snapav16d' ];then
		cd ./fw/snapav16d/
	elif [ $boardtype = 'snapav51' ];then
		cd ./fw/snapav51/
	fi
	echo $dsp > snapav-firmware/deleteDb.config

	./create-update-firmware.sh $app
	cd -
}
buildall(){
	builduboot
	buildkernel
	buildrootfs

}

if [ $# -le 0 ]
then
	printuse;
	exit;

fi



case $1 in
	"kernel")
		buildkernel;
		;;
	"uboot")
		builduboot;
		;;
	"rootfs")
		buildrootfs;
		;;
	"flag")
		buildbootflag;
		;;
	"boot")
		buildbootloader;
		;;
	"fw")
		buildfw;
		;;
	"all")
		buildall
		;;
esac
