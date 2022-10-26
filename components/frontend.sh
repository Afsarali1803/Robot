#!/bin/bash

USERID=$(id -u)
COMPONENT=frontend
LOGFILE=/tmp/$COMPONENT.log
source components/common.sh 

echo -n " Installing the nginx:"
yum install nginx -y  &>> $LOGFILE
stat $?

echo -n " Downloading the component:"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
rm -rf /usr/share/nginx/html/*  &>> $LOGFILE
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> $LOGFILE
stat $?

mv frontend-main/* .
mv static/* .
echo -n "Perform cleanup:"
rm -rf frontend-main README.md &>> $LOGFILE
stat $?

mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx &>> $LOGFILE
systemctl start nginx  &>> $LOGFILE