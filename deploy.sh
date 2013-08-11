#!/bin/sh

# filename: deploy.sh
# summary: deploy ycsb on remote host 
# author: caosiyang <csy3228@gmail.com>
# date: 2013/06/25

test -f host.conf || exit 1

# zip
test -f myycsb.zip && rm -f myycsb.zip
zip myycsb.zip -r myycsb -x myycsb/result/*

# dispatch myycsb.zip
while read remotehost
do
    echo "deploying $remotehost..."
    ssh -n -o StrictHostKeyChecking=no root@$remotehost "mkdir -p /home/caosiyang && rm -rf /home/caosiyang/myycsb*"
    scp myycsb.zip root@$remotehost:/home/caosiyang
    ssh -n -o StrictHostKeyChecking=no root@$remotehost "cd /home/caosiyang && unzip -oq myycsb.zip"
done <host.conf

rm -f myycsb.zip
