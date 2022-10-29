#!/bin/bash

USERID=$(id -u)
COMPONENT=user
LOGFILE=/tmp/$COMPONENT.log
source components/common.sh 
APPUSER=roboshop

echo -n "Configuring Node:"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
stat $?

echo -n "Install the node js Application"
yum install nodejs -y &>> LOGFILE
stat $?

id $APPUSER &>> LOGFILE
if [ $? -ne 0 ]; then
    echo -n "Create app user"
    useradd roboshop
    stat $?
fi

echo -n "Download the $COMPONENT:"
curl -s -L -o /tmp/user.zip "https://github.com/stans-robot-project/user/archive/main.zip"
stat $?

echo -n " Moving the component to catalogue:"
cd /home/roboshop
stat $?

echo -n "unzip user.zip"
unzip /tmp/user.zip
stat $?

mv mv user-main user
cd /home/roboshop/user

echo -n " npm install:"
npm install &>> LOGFILE
stat $?

