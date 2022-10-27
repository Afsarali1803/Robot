#!/bin/bash

USERID=$(id -u)
COMPONENT=mangodb
LOGFILE=/tmp/$COMPONENT.log
source components/common.sh



echo -n " Downloading the mangodb from IA:"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n " Installing the nginx:"
yum install -y mongodb-org   &>> $LOGFILE
stat $?


echo -n "starting mangodb:"
systemctl enable mongod &>> $LOGFILE
systemctl start mongod  &>> $LOGFILE
stat $?

echo -n "updaing the mangodb config:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n " Downloading the component:"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Injecting the schemes"
cd /tmp
unzip -o mongodb.zip 
cd mongodb-main
mongo < catalogue.js
mongo < users.js
stat $?





