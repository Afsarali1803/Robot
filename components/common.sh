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
