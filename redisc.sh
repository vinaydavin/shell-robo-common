#!/bin/bash
source ./common.sh
check_root

dnf module disable redis -y &>> ${log_file}
validate $? "Disabling Old Redis Module"
dnf module enable redis:7 -y &>> ${log_file}
validate $? "Enabling Redis 7 Module"
dnf install redis -y &>> ${log_file}
validate $? "Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>> ${log_file}
validate $? "Updating Redis Configuration"  
systemctl enable redis &>> ${log_file}
validate $? "Enabling Redis Service"
systemctl start redis &>> ${log_file}
validate $? "Starting Redis Service"

print_total_time