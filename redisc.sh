#!/bin/bash
source ./common.sh
check_root

dnf remove redis\* -y &>> ${log_file}
validate $? "Disabling Old Redis Module"
dnf install epel-release -y && dnf install https://rpms.remirepo.net/enterprise/remi-release-9.rpm -y
 &>> ${log_file}
sudo dnf module reset redis -y
sudo dnf module enable redis:remi-7.2 -y &>> ${log_file}
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

dnf install epel-release -y && dnf install https://rpms.remirepo.net/enterprise/remi-release-9.rpm -y then dnf module enable redis:7/remi -y && dnf install redis -y