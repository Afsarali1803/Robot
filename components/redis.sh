#!/bin/bash

USERID=$(id -u)
COMPONENT=frontend
LOGFILE=/tmp/$COMPONENT.log
source components/common.sh 



echo -n " Downloading the component:"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> LOGFILE
stat $?


echo -n " Installing the nginx:"
yum install redis-6.2.7 -y  &>> $LOGFILE
stat $?

echo -n "whitelisting redis:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
stat $?

echo -n "Starting service"
systemctl daemon-reload
systemctl start redis
systemctl status redis -l &>> LOGFILE
echo $?
