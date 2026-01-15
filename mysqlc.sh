#! /bin/bash
app_name=mysql
source ./common.sh
check_root
app_setup
dnf install mysql-server -y &>> ${log_file}
validate $? "Installing MySQL"


validate $? "Setting MySQL Root Password"   
systemd_setup
mysql_secure_installation --set-root-pass RoboShop@1 &>> ${log_file}
app_restart

print_total_time