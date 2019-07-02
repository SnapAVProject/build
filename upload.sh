#!/bin/sh
boardtype=$2
echo $boardtype
if [ $boardtype = 'snapav2d' ];then
cp $1 fw/snapav/snapav-firmware/boot.img
#sshpass -p wjh sftp cean@10.10.6.91 <<!
#put $1 /usr/share/nginx/html/snapav/
#!
elif [ $boardtype = 'snapav8d' ];then
cp $1 fw/snapav8d/snapav-firmware/boot.img
#sshpass -p wjh sftp cean@10.10.6.91 <<!
#put $1 /usr/share/nginx/html/snapav8d/
#!

fi

