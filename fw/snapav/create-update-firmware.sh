model=`cat ../../../nuc970_buildroot/output/target/etc/hostname`
dir=snapav-firmware
fwname=${model}_${1}

if [ $# -le 0  ];then
	echo "Usage:$0  dir"
	exit
fi
rm ../$fwname.dat
cd $dir
rm checksum.txt
for line in `ls `
do
	md5sum $line >> checksum.txt
	#md5sum rootfs.img >> checksum.txt
done 
cd -
#cat ../../../NUC970_Buildroot/output/target/etc/hostname > snapav-firmware/boardtype
echo $model > snapav-firmware/boardtype

zip -r $fwname.dat $dir
#echo "cp $fwname.dat /usr/share/nginx/html/snapav8d/"
#cp $fwname.dat /usr/share/nginx/html/snapav8d/
mv $fwname.dat ../
cd ../
echo "======================================"
echo -e "\033[32m FW build success:\033[0m"
echo -e "\033[32m `pwd`/$fwname.dat \033[0m"
echo "======================================"
