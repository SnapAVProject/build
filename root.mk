# Root Makefile for Nuvoton Platform

# execute `source build/envsetup.sh` before make
# to select corrrect target product

# sample:
# launch snapav51 [appversion dspversion]
# make              - build the whole system
# make kernel       - build the kernel

TARGET=fullbuild
PWD=$(shell pwd)
KERNEL_SRC=linux3.10

$(shell mkdir -p image)

ifndef BOARDTYPE
$(error You MUST choose correct board type.)
else
$(info keep going)
endif


# By default, build the whole system
all: $(TARGET)
$(TARGET): uboot rootfs kernel app


.PHONY:app
app:
	@echo '====== Building the application ======'
	make -C app5.1/ -f Makefile.linux

###### uboot ######

.PHONY:uboot
uboot:
	@echo '====== Building the uboot ======'
	@cp build/ubootconfig/defconfig uboot/.config
	make -C uboot/ ARCH=arm CROSS_COMPILE=$(PWD)/prebuilt/arm9-nuvoton/usr/bin/arm-linux-
	@cp uboot/u-boot.bin image/
	@cp uboot/spl/u-boot-spl.bin image/

###### Kernel ######

.PHONY:kernel
kernel:
	@echo '====== Building the Kernel ======'
	@cp build/kernelconfig/${BOARDTYPE}_config ${KERNEL_SRC}/.config
	make -C linux3.10/ uImage -j 8 CROSS_COMPILE=$(PWD)/prebuilt/arm9-nuvoton/usr/bin/arm-linux-
	make -C linux3.10/ modules -j 8 CROSS_COMPILE=$(PWD)/prebuilt/arm9-nuvoton/usr/bin/arm-linux-


###### Rootfs ######
.PHONY:rootfs
rootfs:
	@echo '====== Building the Rootfs ======'
	@echo $(PWD)
	make -C rootfs20190207/ snapav51_defconfig
	make -C rootfs20190207/
