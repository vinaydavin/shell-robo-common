#! /bin/bash

source ./common.sh
check_root
$app_name=rabbitmq
app_setup
cp $script_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> ${log_file}
dnf install rabbitmq-server -y &>> ${log_file}
validate $? "Installing RabbitMQ Server"
systemctl enable rabbitmq-server &>> ${log_file}
validate $? "Enabling RabbitMQ Service" 
systemctl start rabbitmq-server &>> ${log_file}
validate $? "Starting RabbitMQ Service"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
print_total_time