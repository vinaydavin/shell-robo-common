#! /bin/bash

source ./common.sh
app_name=shipping
check_root
app_setup
java_setup
systemd_setup
app_restart
dnf install mysql -y &>> ${log_file}
validate $? "Installing Mysql Client"

mysql -h mysql.vdavin.online -uroot -pRoboShop@1 -e 'use mysql'
if [ $? -ne 0 ]; then
    mysql -h mysql.vdavin.online -uroot -pRoboShop@1 < /app/db/schema.sql 
    mysql -h mysql.vdavin.online -uroot -pRoboShop@1 < /app/db/app-user.sql 
    mysql -h mysql.vdavin.online -uroot -pRoboShop@1 < /app/db/master-data.sql
else
    echo -e "${G}Shipping data is already loaded{N}" | tee -a ${log_file}
fi

app_restart
print_total_time