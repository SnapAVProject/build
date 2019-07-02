dir=snapav-firmware
fwname=snapav_8d_fw_${1}
if [ $# -le 0  ];then
	echo "Usage:$0  dir"
	exit
fi
rm ../$fwname.zip
cd $dir

md5sum boot.img > checksum.txt
md5sum rootfs.img >> checksum.txt

cd -


sudo zip -r $fwname.zip $dir
cp $fwname.zip /usr/share/nginx/html/snapav8d/
mv $fwname.zip ../
