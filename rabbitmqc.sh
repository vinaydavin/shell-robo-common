#! /bin/bash

source ./common.sh
check_root
$app_name=rabbitmq
app_setup
systemd_setup
app_restart

print_total_time