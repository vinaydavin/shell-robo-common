#! /bin/bash

source ./common.sh
app_name=catalogue
check_root
app_setup
nodejs_setup
systemd_setup

cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo &>> ${log_file}
validate $? "Adding Mongodb Repo"
dnf install mongodb-mongosh -y &>> ${log_file}
validate $? "Installing Mongodb Client"

INDEX=$(mongosh mongodb.vdavin.online --quiet --eval "db.getMongo().getDBName().indexOf('catalogue')" &>> ${log_file})
if [ $INDEX -le 0 ]; then
mongosh --host mongodb.vdavin.online </app/db/master-data.js &>> ${log_file}
validate $? "Loading Catalogue Data" 
else
    echo -e "${Y}Catalogue Data already present. Skipping Catalogue Data Load.${N}" | tee -a ${log_file}
fi  

app_restart

print_total_time