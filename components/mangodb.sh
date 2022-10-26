#!/bin/bash

USERID=$(id -u)
COMPONENT=mangodb
LOGFILE=/tmp/$COMPONENT.log
source components/common.sh



echo -n " Downloading the mangodb from IA:"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n " Installing the nginx:"
yum install mongodb-org -y  &>> $LOGFILE
stat $?

systemctl enable nginx &>> $LOGFILE
systemctl start nginx  &>> $LOGFILE

echo -n " Downloading the component:"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?


cd /tmp
unzip mongodb.zip 
cd mongodb-main
mongo < catalogue.js
mongo < users.js





