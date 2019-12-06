# Root Makefile for Nuvoton Platform

# execute `source build/envsetup.sh` before make
# to select corrrect target product

# sample:
# launch snapav51 appversion dspversion

PWD=$(shell pwd)

# By default, build app
.PHONY:app
app:
	@echo '====== Building the Kernel ======'
	make -C app5.1/ -f Makefile.linux


.PHONY:kernel
kernel:
	@echo '====== Building the Kernel ======'
	make -C linux3.10/ -j 8 CROSS_COMPILE=$(PWD)/prebuilt/arm9-nuvoton/usr/bin/arm-linux-

###### Rootfs ######
.PHONY:rootfs
rootfs:
	@echo '====== Building the Rootfs ======'
	@echo $(PWD)