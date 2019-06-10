#!/bin/sh
sshpass -p wjh sftp cean@10.10.6.91 <<!

put $1 /usr/share/nginx/html/snapav/

!
