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
TOOLS_SRC=tools
OUTDIR=out

# below is standard Linux fs layout
ROOTFS_SRC=rootfs20190207
# below is for Hansong-specific tools
# in Linux rootfs
HANSONGTOOLS=build/hsrootfs

$(shell mkdir -p image $(OUTDIR))

ifndef BOARDTYPE
$(error You MUST choose correct board type.) else
$(info keep going)
endif


# By default, build the whole system
all: $(TARGET)
ifeq ($(BOARDTYPE), spa25)
$(TARGET): uboot rootfs kernel app tools web dirac
else
$(TARGET): uboot rootfs kernel app tools web
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
	make -C linux3.10/ uImage -j 8 CROSS_COMPILE=$(PWD)/prebuilt/arm9-nuvoton/usr/bin/arm-linux-
	make -C linux3.10/ modules -j 8 CROSS_COMPILE=$(PWD)/prebuilt/arm9-nuvoton/usr/bin/arm-linux-
	bash build/package.sh kernel


##### tools #####
.PHONY:tools
tools:
	@echo "====== Building the tools... ======="
	make -C tools/ CROSS_COMPILE=$(PWD)/prebuilt/arm9-nuvoton/usr/bin/arm-linux- TARGETDIR=${PWD}/${OUTDIR}


###### Rootfs ######
.PHONY:rootfs
rootfs:
	@echo '====== Building the Rootfs ======'
#@ln -sf $(PWD)/${TOOLS_SRC} $(HANSONGTOOLS)/package
	@cp build/buildrootconfig/${BOARDTYPE}_defconfig ${ROOTFS_SRC}/configs/${BOARDTYPE}_defconfig
	make -C rootfs20190207/ O=${PWD}/${OUTDIR} ${BOARDTYPE}_defconfig
	make -C rootfs20190207/ O=${PWD}/${OUTDIR} BR_NO_CHECK_HASH_FOR=linux-3.10.10.tar.xz -j8
	@cp $(PWD)/prebuilt/arm9-nuvoton/usr/arm-buildroot-linux-gnueabi/lib/libstdc++.so.6.0.24 ${PWD}/${OUTDIR}/target/lib/
	cd ${OUTDIR}/target/lib/ && ln -sf libstdc++.so.6.0.24 libstdc++.so.6 && ln -sf libstdc++.so.6.0.24 libstdc++.so
#	@cp ${OUTDIR}/images/rootfs.squashfs image/rootfs.img


###### web pages ######

.PHONY:web
web:
	cp -rf ${PWD}/web/src/*  ${PWD}/${OUTDIR}/target/usr/html
	install -D --mode=0755 ${PWD}/web/S50nginx  ${PWD}/${OUTDIR}/target/etc/init.d/
	install -D --mode=0644 ${PWD}/web/nginx.conf  ${PWD}/${OUTDIR}/target/etc/nginx/



###### Dirac ######
.PHONY:dirac
dirac:
	@echo '====== Building the dirac ======'
	@echo $(PWD)
	make -C dirac/ -f Makefile.linux -j8 TARGETDIR=${PWD}/${OUTDIR}

###### SW Release ######
.PHONY:release
release: rootfs
	@echo '====== Releasing ======'
	@echo $(PWD)
	bash build/package.sh release

###### Just for Debug ######
.PHONY:dbg
dbg:mydbg
	echo "Try the debug code here"
mydbg:
	echo "Mydbg"
