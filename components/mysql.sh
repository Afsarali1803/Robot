#!/bin/bash

USERID=$(id -u)
COMPONENT=cart
source components/common.sh 
LOGFILE=/tmp/$COMPONENT.log
APPUSER=roboshop

echo -n "Configuring Node:"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo  &>> $LOGFILE
stat $?

echo -n "Installing $COMPONENT:"
yum install mysql-community-server -y &>> $LOGFILE 
stat $? 

echo -n "Starting $COMPONENT service: "
systemctl enable mysqld && systemctl start mysqld
stat $?