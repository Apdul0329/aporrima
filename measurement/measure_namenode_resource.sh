#!/bin/bash

source ./aporrima/measurement/get_pid.sh

USERNAME=$(whoami)
HOST_IP=$(hostname -I)
OPERATION=$1
NOW=$(date +%s)
HIBENCH_HOME=/home/$USERNAME/HiBench
HADOOP_HOME=/home/$USERNAME/hadoop
CMD="$HIBENCH_HOME/bin/workloads/micro/$OPERATION/spark/run.sh"

NAMENODE_PID=$(get_namenode_pid)
RESOURCEMANAGER_PID=$(get_resourcemanager_pid)

RESULT_PATH=result/$OPERATION/$NOW
NAMENODE_OUTPUT_FILE="namenode_top.log"
RESOURCEMANAGER_OUTPUT_FILE="resourcemanager_top.log"
SPARKSUBMIT_OUTPUT_FILE="sparksubmit_top.log"
NAMENODE_CSV_PATH="./$RESULT_PATH/namenode_result.csv"
RESOURCEMANAGER_CSV_PATH="./$RESULT_PATH/resourcemanager_result.csv"
SPARKSUBMIT_CSV_PATH="./$RESULT_PATH/sparksubmit_result.csv"

mkdir -p $RESULT_PATH

while IFS= read -r HOSTNAME; do
    IP=$(grep -w "$HOSTNAME" /etc/hosts | awk '{print $1}')
    
    if [[ -n $IP ]]; then
        ssh -o StrictHostKeyChecking=no "$USERNAME"@"$IP" "git clone https://github.com/Apdul0329/aporrima.git" &
        CLONE_PID=$!

        wait $CLONE_PID
    else
        echo "Unable to find IP address for HOSTNAME: $HOSTNAME"
    fi
done < ./hadoop/etc/hadoop/workers

top -b -d 1 -p $NAMENODE_PID > $NAMENODE_OUTPUT_FILE &
TOP_NAMENODE_PID=$!

top -b -d 1 -p $RESOURCEMANAGER_PID > $RESOURCEMANAGER_OUTPUT_FILE &
TOP_RESOURCEMANAGER_PID=$!

while IFS= read -r HOSTNAME; do
    IP=$(grep -w "$HOSTNAME" /etc/hosts | awk '{print $1}')
    
    if [[ -n $IP ]]; then
        ssh -o StrictHostKeyChecking=no "$USERNAME"@"$IP" "./aporrima/measurement/measure_datanode_resource.sh" &
    else
        echo "Unable to find IP address for HOSTNAME: $HOSTNAME"
    fi
done < ./hadoop/etc/hadoop/workers

$CMD > /dev/null &
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
        ssh -o StrictHostKeyChecking=no "$USERNAME"@"$IP" "./aporrima/measurement/kill_datanode_process.sh ${USERNAME} ${HOST_IP} ${RESULT_PATH}" &
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

rm $NAMENODE_OUTPUT_FILE
rm $RESOURCEMANAGER_OUTPUT_FILE
rm $SPARKSUBMIT_OUTPUT_FILE