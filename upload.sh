#!/bin/sh
boardtype=$2
echo $boardtype
if [ $boardtype = 'snapav2d' ];then
cp $1 fw/snapav/snapav-firmware/boot.img
sshpass -p wjh sftp cean@10.10.6.91 <<!
put $1 /usr/share/nginx/html/snapav/
!
elif [ $boardtype = 'snapav8d' ];then
cp $1 fw/snapav8d/snapav-firmware/boot.img
sshpass -p wjh sftp cean@10.10.6.91 <<!
put $1 /usr/share/nginx/html/snapav8d/
!
elif [ $boardtype = 'snapav12d' ];then
cp $1 fw/snapav12d/snapav-firmware/boot.img
sshpass -p wjh sftp cean@10.10.6.91 <<!
put $1 /usr/share/nginx/html/snapav12d/
!
elif [ $boardtype = 'snapav16d' ];then
cp $1 fw/snapav16d/snapav-firmware/boot.img
sshpass -p wjh sftp cean@10.10.6.91 <<!
put $1 /usr/share/nginx/html/snapav16d/
!
elif [ $boardtype = 'snapav51' ];then
cp $1 fw/snapav51/snapav-firmware/boot.img

sshpass -p wjh sftp cean@10.10.6.91 <<!
put $1 /usr/share/nginx/html/snapav51/
!
fi

