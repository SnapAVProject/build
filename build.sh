#!/bin/bash
printuse(){

	echo Usage:$0 all/uboot/kernel/rootfs

}




buildkernel(){
	echo $0

	cd ../linux3.10/
	make dtbs
	cp arch/arm/boot/dts/nuc972-evb.dtb ../image/
	make uImage -j8
	cp ../image/970uimage /home/tftp/970uImage
	cd -

}
builduboot(){
	echo $0
	cd ../uboot/
	make ARCH=arm CROSS_COMPILE=arm-linux-
	cd -
}

buildrootfs(){
	echo $0
	cd ../Rootfs/
	./buildjffs2img.sh
	cp rootfs.img ../image/
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
		buildrootfs
		;;
	"all")
		buildall
		;;
esac
