#!/bin/bash

# Define an associative array with control names and their expected values
declare -A controls
controls["IP forwarding"]="0"
controls["ICMP redirects"]="0"
controls["permissions on /etc/crontab"]="0644"
controls["permissions on /etc/cron.hourly"]="0700"
controls["permissions on /etc/cron.daily"]="0700"
controls["permissions on /etc.cron.weekly"]="0700"
controls["permissions on /etc.cron.monthly"]="0700"
controls["permissions on /etc/passwd"]="0644"
controls["permissions on /etc/shadow"]="0400"
controls["permissions on /etc/group"]="0644"
controls["permissions on /etc/gshadow"]="0400"
controls["permissions on /etc/passwd-"]="0644"
controls["permissions on /etc/shadow-"]="0400"
controls["permissions on /etc/group-"]="0644"
controls["permissions on /etc/gshadow-"]="0400"
controls["legacy entries in /etc/passwd"]=""
controls["legacy entries in /etc/shadow"]=""
controls["legacy entries in /etc/group"]=""
controls["root UID"]="0"

# Function to check and remediate a control
check_control() {
  control_name="$1"
  expected_value="$2"
  actual_value="$3"
  remediation="$4"
  
  if [ "$actual_value" == "$expected_value" ]; then
    echo "Compliant. The $control_name value is as expected: $expected_value."
  else
    echo "Not compliant. The $control_name value should be: $expected_value and the current value is $actual_value."
    echo -e "Remediation\n$remediation"
  fi
}

# Function to check and remediate legacy entries
check_legacy_entries() {
  control_name="$1"
  actual_value="$2"
  remediation="$3"
  
  if [ -z "$actual_value" ]; then
    echo "Compliant. No legacy entries found in $control_name."
  else
    echo "Not compliant. Legacy entries found in $control_name."
    echo -e "Remediation\n$remediation"
  fi
}

# Check and remediate each control
check_control "IP forwarding" "${controls["IP forwarding"]}" "$(cat /proc/sys/net/ipv4/ip_forward)" "Edit /etc/sysctl.conf and set:\nnet.ipv4.ip_forward=1\nto\nnet.ipv4.ip_forward=0.\nThen run:\nsysctl -w net.ipv4.ip_forward=0"
check_control "ICMP redirects" "${controls["ICMP redirects"]}" "$(cat /proc/sys/net/ipv4/conf/all/accept_redirects)" "Edit /etc/sysctl.conf and set:\nnet.ipv4.conf.all.accept_redirects=1\nto\nnet.ipv4.conf.all.accept_redirects=0.\nThen run:\nsysctl -w net.ipv4.conf.all.accept_redirects=0"
check_control "permissions on /etc/crontab" "${controls["permissions on /etc/crontab"]}" "$(stat -c %a /etc/crontab)" "Run:\nchmod 0644 /etc/crontab"
check_control "permissions on /etc/cron.hourly" "${controls["permissions on /etc/cron.hourly"]}" "$(stat -c %a /etc/cron.hourly)" "Run:\nchmod 0700 /etc/cron.hourly"
check_control "permissions on /etc/cron.daily" "${controls["permissions on /etc/cron.daily"]}" "$(stat -c %a /etc/cron.daily)" "Run:\nchmod 0700 /etc/cron.daily"
check_control "permissions on /etc/cron.weekly" "${controls["permissions on /etc/cron.weekly"]}" "$(stat -c %a /etc/cron.weekly)" "Run:\nchmod 0700 /etc/cron.weekly"
check_control "permissions on /etc/cron.monthly" "${controls["permissions on /etc/cron.monthly"]}" "$(stat -c %a /etc/cron.monthly)" "Run:\nchmod 0700 /etc/cron.monthly"
check_control "permissions on /etc/passwd" "${controls["permissions on /etc/passwd"]}" "$(stat -c %a /etc/passwd)" "Run:\nchmod 0644 /etc/passwd"
check_control "permissions on /etc/shadow" "${controls["permissions on /etc/shadow"]}" "$(stat -c %a /etc/shadow)" "Run:\nchmod 0400 /etc/shadow"
check_control "permissions on /etc/group" "${controls["permissions on /etc/group"]}" "$(stat -c %a /etc/group)" "Run:\nchmod 0644 /etc/group"
check_control "permissions on /etc/gshadow" "${controls["permissions on /etc/gshadow"]}" "$(stat -c %a /etc/gshadow)" "Run:\nchmod 0400 /etc/gshadow"
check_control "permissions on /etc/passwd-" "${controls["permissions on /etc/passwd-"]}" "$(stat -c %a /etc/passwd-)" "Run:\nchmod 0644 /etc/passwd-"
check_control "permissions on /etc/shadow-" "${controls["permissions on /etc/shadow-"]}" "$(stat -c %a /etc/shadow-)" "Run:\nchmod 0400 /etc/shadow-"
check_control "permissions on /etc/group-" "${controls["permissions on /etc/group-"]}" "$(stat -c %a /etc/group-)" "Run:\nchmod 0644 /etc/group-"
check_control "permissions on /etc/gshadow-" "${controls["permissions on /etc/gshadow-"]}" "$(stat -c %a /etc/gshadow-)" "Run:\nchmod 0400 /etc/gshadow-"
check_legacy_entries "/etc/passwd" "$(grep -c '^\+' /etc/passwd)" "Remove any legacy '+' entries from /etc/passwd"
check_legacy_entries "/etc/shadow" "$(grep -c '^\+' /etc/shadow)" "Remove any legacy '+' entries from /etc/shadow"
check_legacy_entries "/etc/group" "$(grep -c '^\+' /etc/group)" "Remove any legacy '+' entries from /etc/group"
check_control "root UID" "${controls["root UID"]}" "$(id -u root)" "Review and update /etc/passwd to ensure that root is the only account with UID 0."
