boardtype :=snapav2d
appversion :=143
dspversion :=105
deletedatabase :=false
all:
	 echo ${boardtype}
	./build.sh kernel $(boardtype)
	./build.sh rootfs $(boardtype) ${appversion} ${dspversion}
	./build.sh fw $(boardtype) ${appversion}.${dspversion}_`date "+%Y%m%d"` ${deletedatabase}


	#sudo cp ../image/boot.img /usr/share/nginx/html/snapav/
