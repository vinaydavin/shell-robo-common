#! /bin/bash

source ./common.sh

check_root

cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo &>> ${log_file}
validate $? "Adding Mongo Repo"

dnf install mongodb-org -y &>> ${log_file}
validate $? "INSTALLING MongoDB"

systemctl enable mongod &>> ${log_file}
validate $? "Enabling MongoDB Service"

systemctl start mongod 
validate $? "Starting MongoDB Service"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 
validate $? "Allowing Remote Connections to mongodb"

systemctl restart mongod 
validate $? "Restarting MongoDB Service"  

print_total_time
