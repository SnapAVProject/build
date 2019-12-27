# Root Makefile for Nuvoton Platform

# execute `source build/envsetup.sh` before make
# to select corrrect target product

# sample:
# launch snapav51 [appversion dspversion]
# make              - build the whole system
# make kernel       - build the kernel

TARGET=fullbuild
PWD=$(shell pwd)
APP_SRC=app
KERNEL_SRC=linux3.10
ROOTFS_SRC=rootfs20190207

$(shell mkdir -p image)

ifndef BOARDTYPE
$(error You MUST choose correct board type.)
else
$(info keep going)
endif


# By default, build the whole system
all: $(TARGET)
ifeq ($(BOARDTYPE), spa25)
$(TARGET): uboot rootfs kernel app dirac
else
$(TARGET): uboot rootfs kernel app
endif

.PHONY:app
app:
	@echo '====== Building the application ======'
	make -C $(APP_SRC) -f Makefile.linux

###### uboot ######

.PHONY:uboot
uboot:
	@echo '====== Building the uboot ======'
	@cp build/ubootconfig/defconfig uboot/.config
	make -C uboot/ ARCH=arm CROSS_COMPILE=$(PWD)/prebuilt/arm9-nuvoton/usr/bin/arm-linux-
	@cp uboot/u-boot.bin image/

###### Kernel ######

.PHONY:kernel
kernel:
	@echo '====== Building the Kernel ======'
	@cp build/kernelconfig/${BOARDTYPE}_config ${KERNEL_SRC}/.config
	make -n -C linux3.10/ uImage -j 8 CROSS_COMPILE=$(PWD)/prebuilt/arm9-nuvoton/usr/bin/arm-linux-
	make -n -C linux3.10/ modules -j 8 CROSS_COMPILE=$(PWD)/prebuilt/arm9-nuvoton/usr/bin/arm-linux-
	bash build/package.sh kernel

###### Rootfs ######
.PHONY:rootfs
rootfs:
	@echo '====== Building the Rootfs ======'
	@echo $(PWD)
	@cp build/buildrootconfig/${BOARDTYPE}_defconfig ${ROOTFS_SRC}/configs/${BOARDTYPE}_defconfig
	make -C rootfs20190207/ ${BOARDTYPE}_defconfig
	make -C rootfs20190207/
	@cp rootfs20190207/output/images/rootfs.squashfs image/rootfs.img

###### Dirac ######
.PHONY:dirac
dirac:
	@echo '====== Building the dirac ======'
	@echo $(PWD)
	make -C dirac/ -f Makefile.linux -j8


###### SW Release ######
.PHONY:release
release:
	@echo '====== Releasing ======'
	@echo $(PWD)
	bash build/package.sh release

###### Just for Debug ######
.PHONY:dbg
dbg:
	echo "Try the debug code here"