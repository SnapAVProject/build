#!/bin/sh
boardtype=$2

if [ $boardtype = 'snapav2d' ];then
sshpass -p wjh sftp cean@10.10.6.91 <<!
put $1 /usr/share/nginx/html/snapav/
!
elif [ $boardtype = 'snapav8d' ];then
sshpass -p wjh sftp cean@10.10.6.91 <<!
put $1 /usr/share/nginx/html/snapav8d/
!

fi

