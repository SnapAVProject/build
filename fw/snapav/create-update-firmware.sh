
dir=snapav-firmware
fwname=snapav_2d_fw_${1}

if [ $# -le 0  ];then
	echo "Usage:$0  dir"
	exit
fi
rm ../$fwname.zip
cd $dir
md5sum boot.img > checksum.txt
md5sum rootfs.img >> checksum.txt
cd -

zip -r $fwname.zip $dir
echo "cp $fwname.zip /usr/share/nginx/html/snapav/"
cp $fwname.zip /usr/share/nginx/html/snapav/
mv $fwname.zip ../
