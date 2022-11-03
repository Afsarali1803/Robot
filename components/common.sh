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