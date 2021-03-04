# Packagin the whole software release


PWD=`pwd`
RELDIR="${PWD}/out/images"
IMGDIR="${PWD}/image"
KERNELIMG="${PWD}/linux3.10/arch/arm/boot/uImage"

GREEN='\033[0;32m'
STD='\033[0;0m'

TARGET_PACKAGE=$BOARDTYPE-`date '+%Y-%m-%d'`.zip

ROOTFS_RAWIMG="rootfs.jffs2"
ROOTFS_IMG="rootfs.img"

echo $RELDIR


function plot_final_release_info()
{
    echo -e "\n\nCongratulations!\n Package is created from $RELDIR.\n Enjoy it!"
    echo '==========================='
    echo -e "Package: ${GREEN}$TARGET_PACKAGE${STD}"
    echo '==========================='
    sleep 3
}

function gen_md5sum()
{
    cd ${RELDIR}
    for line in `ls`
    do
        echo "the file: ${line}"
	    md5sum $line >> checksum.txt
    done
}

function zip_package_file()
{
    # zip -D would only zip the non-directory file!
    echo "zip -D $TARGET_PACKAGE ./"
    cd $RELDIR && zip -r $TARGET_PACKAGE ./ && mv $TARGET_PACKAGE ../

    # Try archive it if possible
    if [ `hostname` == 'sw1' ] ; then
        cp $RELDIR/../$TARGET_PACKAGE /opt/autocicd/dailybuild/
    fi
}

function copy_image()
{

    cp $IMGDIR/* $RELDIR

    if [ -e $RELDIR/uImage ] ; then
        rm $RELDIR/uImage
    fi 
    if [ -e $RELDIR/u-boot-spl.bin ] ; then
        rm $RELDIR/u-boot-spl.bin
    fi 
    if [ -e $RELDIR/970image ] ; then
        rm $RELDIR/970image
    fi

    if [ -e $RELDIR/rootfs.tar ] ; then
        rm $RELDIR/rootfs.tar
    fi

    if [ -e $RELDIR/$ROOTFS_RAWIMG ] ; then
        mv $RELDIR/$ROOTFS_RAWIMG $RELDIR/$ROOTFS_IMG
    fi

    if [ -e $RELDIR/u-boot.bin ] ; then
		rm $RELDIR/u-boot.bin
    fi
	if [ "$BOARDTYPE" = "ams8v2"  ];then
		echo 'control4-8' >$RELDIR/boardtype
	elif [ "$BOARDTYPE" = "ams16" ];then
		echo 'control4-16' >$RELDIR/boardtype
	else
		echo $BOARDTYPE >$RELDIR/boardtype
	fi
    echo [$BOARDTYPE]
    # TODO - below SHOULD be done via a config-able way
    echo 'true' > $RELDIR/deleteDb.config

    echo '#!/bin/sh' > $RELDIR/setup.sh
    echo 'echo $0' >> $RELDIR/setup.sh
    echo 'cp S99setbootflag /media/userdata/' >> $RELDIR/setup.sh
	cp build/fw_printenv out/images/fw_setenv
	cp build/fw_env.config out/images/
	echo './fw_setenv fstype squashfs,jffs2 -c ./fw_env.config' >> $RELDIR/setup.sh
    echo 'exit;' >> $RELDIR/setup.sh
    chmod 755 $RELDIR/setup.sh

    echo '#!/bin/sh' > $RELDIR/S99setbootflag
    echo 'case "$1" in' >> $RELDIR/S99setbootflag
    echo '  start)' >> $RELDIR/S99setbootflag
    echo '	echo "Starting setbootflag..."' >> $RELDIR/S99setbootflag
    echo '	/usr/bin/ota_upgrade -s' >> $RELDIR/S99setbootflag
    echo '	;;' >> $RELDIR/S99setbootflag
    echo '  *)' >> $RELDIR/S99setbootflag
    echo '	exit 1' >> $RELDIR/S99setbootflag
    echo 'esac' >> $RELDIR/S99setbootflag
    chmod 755 $RELDIR/S99setbootflag
}

function prepare_location()
{
    if [ ! -d $RELDIR ] ; then
        echo "Error: failed to find $RELDIR"
        exit 1
    fi

    if [ -e $RELDIR/checksum.txt ] ; then
        rm $RELDIR/checksum.txt
    fi
}

function release_package()
{
    prepare_location
    copy_image
    gen_md5sum
    zip_package_file

    plot_final_release_info
}

function gen_bootimg()
{
    echo 'Packing the kernel image...'
    cp ${KERNELIMG} ${IMGDIR}
    cp ${KERNELIMG} ${IMGDIR}/boot.img
    sizeo=`du $IMGDIR/boot.img -b | awk '{print $1}'`
    size=`expr 4 \* 1024 \* 1024 - $sizeo`
    dd if=/dev/zero of=${IMGDIR}/boot.img.tmp   bs=1 count=$size
    cat $IMGDIR/boot.img.tmp >> ${IMGDIR}/boot.img

    rm $IMGDIR/boot.img.tmp
}

case "$1" in
  'kernel')
    gen_bootimg
  ;;
  'release')
    echo 'packing the release files...'
    release_package
  ;;
esac
