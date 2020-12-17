boardtype :=snapav51
appversion :=108
dspversion :=100
deletedatabase :=false
app:=snapavapp
apppath:=hs_rootfs_51

ifeq ($(boardtype), snapav16d)
	apptype:= "CONFIG+=SNAPAV_SIXTEEN"
	apppath:=hs_rootfs_16d
else ifeq ($(boardtype), snapav12d)
	apptype:= "CONFIG+=SNAPAV_TWELVE"
	apppath:=hs_rootfs_12d
else ifeq ($(boardtype), snapav8d)
	apptype:= "CONFIG+=SNAPAV_EIGHT"
	apppath:=hs_rootfs_8d
else ifeq ($(boardtype), snapav2d)
	apptype:= "CONFIG+=SNAPAV_TWO"
	apppath:=hs_rootfs
else 
	apptype:= "CONFIG+=SNAPAV_FIVENONE"
	app:=snapavapp51
endif
apptype:=CONFIG+=SNAPAV_SIXTEEN
all:
	echo ${boardtype}
	cd ../snapav_app/;qmake -makefile snapavapp.pro -o Makefile $(apptype) && make;cp $(app)  ../nuc970_buildroot/board/nuvoton/$(apppath)/root/snapav/;cd -
	./build.sh kernel $(boardtype)
	rm  ../nuc970_buildroot/output/target/etc/network/interfaces
	cp ../nuc970_buildroot/board/nuvoton/hs_rootfs_common/etc/network/interfaces.bk ../nuc970_buildroot/output/target/etc/network/interfaces
	./build.sh rootfs $(boardtype) ${appversion} ${dspversion}
	./build.sh fw $(boardtype) ${appversion}.${dspversion}_`date "+%Y%m%d"` ${deletedatabase}


app:


