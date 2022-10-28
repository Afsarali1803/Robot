#!/bin/bash

USERID=$(id -u)
COMPONENT=frontend
LOGFILE=/tmp/$COMPONENT.log
source components/common.sh 

echo -n " Installing the nginx:"
yum install redis-6.2.7 -y  &>> $LOGFILE
stat $?

echo -n " Downloading the component:"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
stat $?
