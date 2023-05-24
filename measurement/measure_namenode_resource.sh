#!/bin/bash

source ./get_pid.sh

USERNAME="hadoop"
HIBENCH_HOME=/home/hadoop/HiBench
HADOOP_HOME=/home/hadoop/hadoop
WORDCOUNT_CMD="$HIBENCH_HOME/bin/workloads/micro/wordcount/spark/run.sh"

NAMENODE_PID=$(get_namenode_pid)
RESOURCEMANAGER_PID=$(get_resourcemanager_pid)

NAMENODE_OUTPUT_FILE="namenode_top.log"
RESOURCEMANAGER_OUTPUT_FILE="resourcemanager_top.log"
SPARKSUBMIT_OUTPUT_FILE="sparksubmit_top.log"
NAMENODE_CSV_PATH="./result/namenode_result.csv"
RESOURCEMANAGER_CSV_PATH="./result/resourcemanager_result.csv"
SPARKSUBMIT_CSV_PATH="./result/sparksubmit_result.csv"



top -b -d 1 -p $NAMENODE_PID > $NAMENODE_OUTPUT_FILE &
TOP_NAMENODE_PID=$!

top -b -d 1 -p $RESOURCEMANAGER_PID > $RESOURCEMANAGER_OUTPUT_FILE &
TOP_RESOURCEMANAGER_PID=$!

while IFS= read -r HOSTNAME; do
    IP=$(grep -w "$HOSTNAME" /etc/hosts | awk '{print $1}')
    
    if [[ -n $IP ]]; then
        ssh -o StrictHostKeyChecking=no "$USERNAME"@"$IP" "./measure_datanode_resource.sh" &
    else
        echo "Unable to find IP address for HOSTNAME: $HOSTNAME"
    fi
done < ./hadoop/etc/hadoop/workers

$WORDCOUNT_CMD > /dev/null &
LAST_PID=$!

SPARKSUBMIT_PID=$(get_sparksubmit_pid &)

while [[ -z $SPARKSUBMIT_PID ]]; do
  sleep 1
done

top -b -d 1 -p $SPARKSUBMIT_PID > $SPARKSUBMIT_OUTPUT_FILE &
TOP_SPARKSUBMIT_PID=$!

wait $LAST_PID

kill $TOP_NAMENODE_PID
kill $TOP_RESOURCEMANAGER_PID
kill $TOP_SPARKSUBMIT_PID

while IFS= read -r HOSTNAME; do
    IP=$(grep -w "$HOSTNAME" /etc/hosts | awk '{print $1}')
    
    if [[ -n $IP ]]; then
        ssh -o StrictHostKeyChecking=no "$USERNAME"@"$IP" "./kill_datanode_process.sh" &
    else
        echo "Unable to find IP address for HOSTNAME: $HOSTNAME"
    fi
done < ./hadoop/etc/hadoop/workers

NAMENODE_CPU_USAGE=$(grep -oP "^\s*$NAMENODE_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$NAMENODE_OUTPUT_FILE")
NAMENODE_CPU_USAGE=$(echo "$NAMENODE_CPU_USAGE" | sed 's/%CPU//g')
NAMENODE_CPU_ARRAY=($NAMENODE_CPU_USAGE)

NAMENODE_MEM_USAGE=$(grep -oP "^\s*$NAMENODE_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$NAMENODE_OUTPUT_FILE")
NAMENODE_MEM_USAGE=$(echo "$NAMENODE_MEM_USAGE" | sed 's/%MEM//g')
NAMENODE_MEM_ARRAY=($NAMENODE_MEM_USAGE)

echo "%CPU,%MEM" > $NAMENODE_CSV_PATH
for ((i = 0; i < ${#NAMENODE_CPU_ARRAY[@]}; i++)); do
  echo "${NAMENODE_CPU_ARRAY[i]},${NAMENODE_MEM_ARRAY[i]}" >> $NAMENODE_CSV_PATH
done

RESOURCEMANAGER_CPU_USAGE=$(grep -oP "^\s*$RESOURCEMANAGER_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$RESOURCEMANAGER_OUTPUT_FILE")
RESOURCEMANAGER_CPU_USAGE=$(echo "$RESOURCEMANAGER_CPU_USAGE" | sed 's/%CPU//g')
RESOURCEMANAGER_CPU_ARRAY=($RESOURCEMANAGER_CPU_USAGE)

RESOURCEMANAGER_MEM_USAGE=$(grep -oP "^\s*$RESOURCEMANAGER_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$RESOURCEMANAGER_OUTPUT_FILE")
RESOURCEMANAGER_MEM_USAGE=$(echo "$RESOURCEMANAGER_MEM_USAGE" | sed 's/%MEM//g')
RESOURCEMANAGER_MEM_ARRAY=($RESOURCEMANAGER_MEM_USAGE)

echo "%CPU,%MEM" > $RESOURCEMANAGER_CSV_PATH
for ((i = 0; i < ${#RESOURCEMANAGER_CPU_ARRAY[@]}; i++)); do
  echo "${RESOURCEMANAGER_CPU_ARRAY[i]},${RESOURCEMANAGER_MEM_ARRAY[i]}" >> $RESOURCEMANAGER_CSV_PATH
done
 
SPARKSUBMIT_CPU_USAGE=$(grep -oP "^\s*$SPARKSUBMIT_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$SPARKSUBMIT_OUTPUT_FILE")
SPARKSUBMIT_CPU_USAGE=$(echo "$SPARKSUBMIT_CPU_USAGE" | sed 's/%CPU//g')
SPARKSUBMIT_CPU_ARRAY=($SPARKSUBMIT_CPU_USAGE)

SPARKSUBMIT_MEM_USAGE=$(grep -oP "^\s*$SPARKSUBMIT_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$SPARKSUBMIT_OUTPUT_FILE")
SPARKSUBMIT_MEM_USAGE=$(echo "$SPARKSUBMIT_MEM_USAGE" | sed 's/%MEM//g')
SPARKSUBMIT_MEM_ARRAY=($SPARKSUBMIT_MEM_USAGE)

echo "%CPU,%MEM" > $SPARKSUBMIT_CSV_PATH
for ((i = 0; i < ${#SPARKSUBMIT_CPU_ARRAY[@]}; i++)); do
  echo "${SPARKSUBMIT_CPU_ARRAY[i]},${SPARKSUBMIT_MEM_ARRAY[i]}" >> $SPARKSUBMIT_CSV_PATH
done