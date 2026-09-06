#!/bin/bash

app_name=catalogue
source ./common.sh
check_root
nodejs_setup
app_setup
dependencies_setup
systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Added mongo.repo"

dnf install mongodb-mongosh -y &>> $LOGS_FILE
VALIDATE $? "installing MongoDB"


INDEX=$(mongosh --host mongodb.mohammed.world --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ "$INDEX" -lt 0 ]; then
    mongosh --host mongodb.mohammed.world </app/db/master-data.js &>> $LOGS_FILE
    VALIDATE $? "Load products"
else
    echo -e "Products already loaded ...$Y SKIPPING $N"
fi

app_restart
print_total_time