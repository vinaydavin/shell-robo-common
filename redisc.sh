#!/bin/bash
source ./common.sh
check_root

dnf remove redis\* -y &>> ${log_file}
validate $? "Disabling Old Redis Module"
sudo dnf install -y \
  https://amazonlinux.us-east-1.amazonaws.com/amazon-linux-2023/extras/x86_64/os/Packages/amazon-linux-extras-2023*.rpm
 &>> ${log_file}
sudo dnf config-manager --set-enabled amzn2023-extras
validate $? "Enabling Redis 7 Module"
sudo dnf install -y redis7
validate $? "Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>> ${log_file}
validate $? "Updating Redis Configuration"  
systemctl enable redis &>> ${log_file}
validate $? "Enabling Redis Service"
systemctl start redis &>> ${log_file}
validate $? "Starting Redis Service"

print_total_time


