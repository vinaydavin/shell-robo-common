#!/bin/bash
source ./common.sh
check_root

dnf remove redis\* -y &>> ${log_file}
validate $? "Disabling Old Redis Module"
sudo dnf install -y amazon-linux-extras
 &>> ${log_file}
sudo amazon-linux-extras enable redis7
validate $? "Enabling Redis 7 Module"
dnf --enablerepo=remi install redis -y &>> ${log_file}
validate $? "Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>> ${log_file}
validate $? "Updating Redis Configuration"  
systemctl enable redis &>> ${log_file}
validate $? "Enabling Redis Service"
systemctl start redis &>> ${log_file}
validate $? "Starting Redis Service"

print_total_time


