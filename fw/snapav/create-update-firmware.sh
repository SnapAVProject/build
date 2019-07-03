model=EA-RSP-2D-200
dir=snapav-firmware
fwname=${model}_${1}

if [ $# -le 0  ];then
	echo "Usage:$0  dir"
	exit
fi
rm ../$fwname.zip
cd $dir
md5sum boot.img > checksum.txt
md5sum rootfs.img >> checksum.txt
cd -

zip -r $fwname.dat $dir
echo "cp $fwname.zip /usr/share/nginx/html/snapav/"
cp $fwname.dat /usr/share/nginx/html/snapav/
mv $fwname.dat ../
