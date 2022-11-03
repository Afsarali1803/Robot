#!/bin/bash

LOGFILE=/tmp/$COMPONENT.log
USERID=$(id -u) 

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
}

NODEJS() {
    echo -n "Configuring Node JS:"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash   &>> $LOGFILE
    stat $? 

    echo -n "Installing Nodejs: "
    yum install nodejs -y &>> $LOGFILE
    stat $? 
    
    # Calling create_user function
    CREATE_USER

    # Downloading the code
    DOWNLOAD_AND_EXTRACT 

    # Performs npm install 
    NPM_INSTALL

    # Configures Services
    CONFIGURE_SERVICE
}

MAVEN() {
    echo -n "Installing Maven:"
    yum install maven -y &>> $LOGFILE
    stat $? 

    # Calling create_user function
    CREATE_USER

    # Downloading the code
    DOWNLOAD_AND_EXTRACT 

    # Performs mvn install 
    MVN_INSTALL

    # Configures Services
    CONFIGURE_SERVICE
}

PYTHON() {
    echo -n "Installing Python3 and other dependencies:"
    yum install python36 gcc python3-devel -y &>> $LOGFILE
    stat $? 

    # Calling create_user function
    CREATE_USER    

    # Downloading the code
    DOWNLOAD_AND_EXTRACT 

    USERID=$(id -u roboshop)
    GROUPID=$(id -g roboshop)

    cd /home/$APPUSER/$COMPONENT/
    pip3 install -r requirements.txt &>> $LOGFILE
    
    echo -n "Updating the uid and gid with $APPUSER in $PAYMENT.ini : "
    sed -i -e "/^uid/ c uid=$USERID"  -e "/^gid/ c gid=$GROUPID" /home/$APPUSER/$COMPONENT/$COMPONENT.ini 
    stat $?

    # Configures Services
    CONFIGURE_SERVICE
}

CREATE_USER() {
    id $APPUSER &>> $LOGFILE 
    if [ $? -ne 0 ]; then
        echo -n "Creating App User:"
        useradd $APPUSER &>> $LOGFILE
        stat $?
    fi
} 

OWNLOAD_AND_EXTRACT() {
    echo -n "Downloading the $COMPONENT:"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    stat $? 

    echo -n "Performing Cleanup:"
    rm -rf /home/$APPUSER/$COMPONENT
    cd /home/$APPUSER/ 
    unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE && mv $COMPONENT-main $COMPONENT  &>> $LOGFILE 
    stat $? 

    echo -n "Changing permissions to $APPUSER"
    chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT &&  chmod -R 775 /home/roboshop/$COMPONENT 
    stat $?
}

NPM_INSTALL() {
    echo -n "Installing $COMPONENT Dependencies: "
    cd $COMPONENT 
    npm install &>> $LOGFILE
    stat $?
}

MVN_INSTALL() {
    echo -n "Installing $COMPONENT Dependencies: "
    cd $COMPONENT 
    mvn clean package &>> $LOGFILE
     mv target/$COMPONENT-1.0.jar $COMPONENT.jar
    stat $?
}

CONFIGURE_SERVICE() {
    echo -n "Configuring $COMPONENT Service:"
    sed -i -e 's/AMQPHOST/rabbitmq.robot.internal/' -e 's/USERHOST/user.robot.internal/' -e 's/CARTHOST/cart.robot.internal/' -e 's/DBHOST/mysql.robot.internal/' -e 's/CARTENDPOINT/cart.robot.internal/' -e 's/REDIS_ENDPOINT/redis.robot.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.robot.internal/' -e 's/MONGO_DNSNAME/mongodb.robot.internal/' -e 's/MONGO_ENDPOINT/mongodb.robot.internal/' -e 's/REDIS_ENDPOINT/redis.robot.internal/' /home/roboshop/$COMPONENT/systemd.service
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $? 

    echo -n "Starting $COMPONENT Service:"
    systemctl daemon-reload &>> $LOGFILE
    systemctl enable $COMPONENT
    systemctl restart $COMPONENT &>> $LOGFILE
    stat $? 
}