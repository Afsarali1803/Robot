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
rm -rf catalogue catalog-main
stat $?
echo -n " UNZIP the catalog:"
unzip /tmp/catalogue.zip &>> LOGFILE
stat $?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo -n " npm install:"
npm install &>> LOGFILE
stat $?

echo -n "Changing permission:"
chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT
stat $?

echo -n "Adding mongoip in system.service file:"
sed -e 's/MONGO_DNSNAME/172.31.81.39/' systemd.service &>> LOGFILE
stat $?

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service

echo -n "daemon-reload:"
systemctl daemon-reload
echo $?
echo -n "daemon-start:"
systemctl start catalogue
echo $?
echo -n "daemon-enable:"
systemctl enable catalogue
echo $?
echo -n "daemon-status:"
systemctl status catalogue -l &>> LOGFILE
echo $?



