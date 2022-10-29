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

echo -n "remove catalog:"
rm -rf user user-main
stat $?

echo -n "unzip user.zip:"
unzip /tmp/user.zip &>>LOGFILE
stat $?

mv  user-main user
cd /home/roboshop/user

echo -n " npm install:"
npm install &>> LOGFILE
stat $?

echo -n "Changing permission:"
chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT
stat $?

echo -n "Adding mongoip in system.service file:"
sed -i -e 's/MONGO_ENDPOINT/172.31.81.39/' /home/roboshop/$COMPONENT/systemd.service 
stat $?

echo -n "Adding redisip in system.service file:"
sed -i -e 's/REDIS_ENDPOINT/172.31.94.35/' /home/roboshop/$COMPONENT/systemd.service 
stat $?

mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service

echo -n "daemon-reload:"
systemctl daemon-reload
echo $?
echo -n "daemon-start:"
systemctl start user 
echo $?
echo -n "daemon-enable:"
systemctl enable user
echo $?
echo -n "daemon-status:"
systemctl status user -l &>> LOGFILE
echo $?

