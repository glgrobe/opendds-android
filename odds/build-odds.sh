#!/bin/bash

echo "Building OpenDDS for Android ..."

cd /home/developer

echo "User Id: $(id)"
echo "PWD: $(pwd)"

/home/developer/acetaodds-build-x86_64.sh 

/home/developer/acetaodds-build-arm.sh 


