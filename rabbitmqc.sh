#! /bin/bash

source ./common.sh
check_root

cp $script_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> ${log_file}
dnf install rabbitmq-server -y &>> ${log_file}
validate $? "Installing RabbitMQ Server"
systemctl enable rabbitmq-server &>> ${log_file}
validate $? "Enabling RabbitMQ Service" 
systemctl start rabbitmq-server &>> ${log_file}
validate $? "Starting RabbitMQ Service"
rabbitmqctl add_user roboshop roboshop123 &>> ${log_file}
validate $? "Adding RabbitMQ User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
print_total_time