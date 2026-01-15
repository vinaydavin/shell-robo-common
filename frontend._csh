#! /bin/bash

source ./common.sh
app_name=user
check_root

rm -rf /usr/share/nginx/html/*  &>> ${log_file}
validate $? "Cleaning Nginx HTML Directory"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> ${log_file}
validate $? "Downloading Frontend Content"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip

cp $script_dir/nginx.conf etc/nginx/nginx.conf &>> ${log_file}

nginx_setup

systemctl daemon-reload
systemctl restart nginx 

print_total_time