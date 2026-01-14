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

print_total_time(){
  end_time=$(date +%s)
  total_time=$(($end_time - $start_time))
  echo -e "${G}Total time taken to install Ris: ${total_time} seconds${N}" | tee -a ${log_file}
}





















