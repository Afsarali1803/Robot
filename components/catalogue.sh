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

echo -n "Creating user"
useradd $APPUSER
stat $?

echo -n "Download the $COMPONENT:"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
stat $?





