#!/bin/bash

USERID=$(id -u)
COMPONENT=cart
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
curl -s -L -o /tmp/cart.zip "https://github.com/stans-robot-project/cart/archive/main.zip"
stat $?

echo -n " Moving the component to cart:"
cd /home/roboshop
stat $?

echo -n "remove catalog"
rm -rf cart cart-main
stat $?

echo -n " UNZIP the catalog:"
unzip /tmp/cart.zip &>> LOGFILE
stat $?

mv cart-main cart
cd /home/roboshop/cart

echo -n " npm install:"
npm install &>> LOGFILE
stat $?

echo -n "Changing permission:"
chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT
stat $?

echo -n "Adding redisip in system.service file:"
sed -i -e 's/REDIS_ENDPOINT/172.31.94.35/' /home/roboshop/$COMPONENT/systemd.service 
stat $?

echo -n "Adding redisip in system.service file:"
sed -i -e 's/CATALOGUE_ENDPOINT/172.31.89.172/' /home/roboshop/$COMPONENT/systemd.service 
stat $?

mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service

echo -n "daemon-reload:"
systemctl daemon-reload
echo $?
echo -n "daemon-start:"
systemctl start cart
echo $?
echo -n "daemon-enable:"
systemctl enable cart
echo $?
echo -n "daemon-status:"
systemctl status cart -l &>> LOGFILE
echo $?






