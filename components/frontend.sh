#!/bin/bash

USERID=$(id -u)
COMPONENT=frontend
LOGFILE=/tmp/$COMPONENT.log

if [ $USERID -ne 0 ] ; then
    echo -e "Run as a root user"
    exit 1
fi

stat(){

if [ $1 -eq 0 ]; then
    echo -e "Success" 
else 
    echo -e "Failure"
fi

echo -n " Installing the nginx:"
yum install nginx -y  &>> $LOGFILE
stat $?

echo -n " Downloading the component:"
curl -s -L -o /tmp/&COMPONENT.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
rm -rf /usr/share/nginx/html/*  &>> $LOGFILE
cd /usr/share/nginx/html
unzip /tmp/&COMPONENT.zip &>> $LOGFILE
stat $?

mv &COMPONENT-main/* .
mv static/* .
echo -n "Perform cleanup:"
rm -rf &COMPONENT-main README.md &>> $LOGFILE
stat $?

mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx &>> $LOGFILE
systemctl start nginx  &>> $LOGFILE