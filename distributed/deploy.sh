#!/bin/sh

# filename: deploy.sh
# summary: deploy YCSB on remote host 
# author: caosiyang <csy3228@gmail.com>
# date: 2013/06/25

test -f host.conf || exit 1

# zip
test -f ycsb-0.1.4.zip && rm -f ycsb-0.1.4.zip
zip ycsb-0.1.4.zip -r ycsb-0.1.4 -x ycsb-0.1.4/result/*

# dispatch ycsb-0.1.4.zip
while read remotehost
do
    echo "Deploy on $remotehost..."
    ssh -n -o StrictHostKeyChecking=no root@$remotehost "mkdir -p /home/caosiyang && rm -rf /home/caosiyang/ycsb-0.1.4*"
    scp ycsb-0.1.4.zip root@$remotehost:/home/caosiyang/
    ssh -n -o StrictHostKeyChecking=no root@$remotehost "cd /home/caosiyang && unzip -oq ycsb-0.1.4.zip"
done <host.conf

rm -f ycsb-0.1.4.zip
