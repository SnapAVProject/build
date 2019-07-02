boardtype :=snapav2d
appversion :=143
dspversion :=105
all:
	 echo ${boardtype}
	./build.sh kernel $(boardtype)
	./build.sh rootfs $(boardtype) ${appversion} ${dspversion}
	./build.sh fw $(boardtype) `date "+%Y%m%d"`.${appversion}.${dspversion}


	#sudo cp ../image/boot.img /usr/share/nginx/html/snapav/
