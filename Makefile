boardtype :=snapav51
appversion :=106
dspversion :=100
deletedatabase :=false
all:
	 echo ${boardtype}
	./build.sh kernel $(boardtype)
	rm  ../nuc970_buildroot/output/target/etc/network/interfaces
	cp ../nuc970_buildroot/board/nuvoton/hs_rootfs/etc/network/interfaces.bk ../nuc970_buildroot/output/target/etc/network/interfaces
	./build.sh rootfs $(boardtype) ${appversion} ${dspversion}
	./build.sh fw $(boardtype) ${appversion}.${dspversion}_`date "+%Y%m%d"` ${deletedatabase}


	#sudo cp ../image/boot.img /usr/share/nginx/html/snapav/
