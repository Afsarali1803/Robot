#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ] ; then
    echo -e "Run as a root user"
    exit 1
fi
echo " Installing the nginx:"
yum install nginx -y  &>> /tmp/frontend.log
if [ $? -eq 0 ] then
    echo -e " Installed successfully" 
fi

echo " Downloading the component"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
rm -rf /usr/share/nginx/html/*  &>> /tmp/frontend.log
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> /tmp/frontend.log

if [ $? -eq 0 ] then
    echo -e "downloading successful"
fi

mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md &>> /tmp/frontend.log
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx &>> /tmp/frontend.log
systemctl start nginx  &>> /tmp/frontend.log

