#!/bin/bash

userid=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

logs_dir="/var/log/shell-script"
mkdir -p ${logs_dir}
start_time=$(date +%s)
script_name=$(basename "$0" .sh)
script_dir=$PWD
log_file="${logs_dir}/${script_name}.log"

echo "Script started at: $(date)" | tee -a ${log_file}

check_root(){
  if [ $userid -ne 0 ]; then
  echo -e "${Y}You must be root to run this script.${N}" | tee -a ${log_file}
  exit 1
  fi
}

validate(){
  if [ $1 -ne 0 ]; then
    echo -e "$2 ${R}FAILED${N}" | tee -a ${log_file}
    exit 1
  else
    echo -e "${G}$2 ...${N}" | tee -a ${log_file}
  fi
}

nodejs_setup(){
  dnf remove nodejs -y &>> ${log_file}
  validate $? "Disabling Nodejs Module"

  curl -fsSL https://rpm.nodesource.com/setup_20.x &>> ${log_file}
  validate $? "Enabling Nodejs 20 Module"

  dnf install nodejs -y &>> ${log_file}
  validate $? "Installing Nodejs"

  npm install &>> ${log_file}
  validate $? "Installing Nodejs Dependencies"
}

app_setup(){
  mkdir -p /app 

  curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>> ${log_file}
  validate $? "Downloading C$app_name App Content"

  cd /app 
  rm -rf /app/* &>> ${log_file}
  validate $? "Cleaning /app Directory"

  unzip /tmp/$app_name.zip &>> ${log_file}
}

systemd_setup(){
  cp $script_dir/$app_name.service /etc/systemd/system/$app_name.service &>> ${log_file}
  validate $? "Copy systemctl service file"
  systemctl daemon-reload &>> ${log_file}
  validate $? "Reloading systemctl daemon"
  systemctl enable $app_name &>> ${log_file}
  validate $? "Enabling $app_name service"
  systemctl start $app_name &>> ${log_file}
  validate $? "Starting $app_name service"
}

print_total_time(){
  end_time=$(date +%s)
  total_time=$(($end_time - $start_time))
  echo -e "${G}Total time taken to install Ris: ${total_time} seconds${N}" | tee -a ${log_file}
}





















