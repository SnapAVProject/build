boardtype :=snapav8d
appversion :=249
dspversion :=106
deletedatabase :=false
all:
	 echo ${boardtype}
	./build.sh kernel $(boardtype)
	rm  /home/cean/work/nuvoton/NUC970_Buildroot/output/target/etc/network/interfaces
	cp /home/cean/work/nuvoton/NUC970_Buildroot/board/nuvoton/hs_rootfs/etc/network/interfaces.bk /home/cean/work/nuvoton/NUC970_Buildroot/output/target/etc/network/interfaces
	./build.sh rootfs $(boardtype) ${appversion} ${dspversion}
	./build.sh fw $(boardtype) ${appversion}.${dspversion}_`date "+%Y%m%d"` ${deletedatabase}


	#sudo cp ../image/boot.img /usr/share/nginx/html/snapav/
