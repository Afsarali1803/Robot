#!/bin/bash

USERID=$(id -u)
COMPONENT=catalogue
source components/common.sh 
LOGFILE=/tmp/$COMPONENT.log
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
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
stat $?

echo -n " Moving the component to catalogue:"
cd /home/roboshop
stat $?
echo -n "remove catalog"
rm -rf catalogue
stat $?
echo -n " UNZIP the catalog:"
unzip /tmp/catalogue.zip &>> LOGFILE
stat $?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo -n " npm install:"
npm install &>> LOGFILE
stat $?




