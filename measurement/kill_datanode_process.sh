#!/bin/bash

NAMENODE_USERNAME=$1
NAMENODE_IP=$2
HOST_IP=$(hostname -I | tr -d ' ')
PID_FILE="pid.txt"
TOP_PID_FILE="top_pid.txt"
DATANODE_OUTPUT_FILE="datanode_top.log"
NODEMANAGER_OUTPUT_FILE="nodemanager_top.log"
EXECUTORBACKEND_OUTPUT_FILE="yarnexecutorbackend_top.log"
EXECUTORLAUNCHER_OUTPUT_FILE="executorlauncher_top.log"

RESULT_PATH=$3
DATANODE_CSV_PATH="./$RESULT_PATH/${HOST_IP}_datanode_result.csv"
NODEMANAGER_CSV_PATH="./$RESULT_PATH/${HOST_IP}_nodemanager_result.csv"
EXECUTORBACKEND_CSV_PATH="./$RESULT_PATH/${HOST_IP}_executorbackend_result.csv"
EXECUTORLAUNCHER_CSV_PATH="./$RESULT_PATH/${HOST_IP}_executorlauncher_result.csv"

DATANODE_PID=$(grep "DataNode" "$PID_FILE" | awk '{print $1}')
NODEMANAGER_PID=$(grep "NodeManager" "$PID_FILE" | awk '{print $1}')
EXECUTORBACKEND_PID=$(grep "YarnCoarseGrainedExecutorBackend" "$PID_FILE" | awk '{print $1}')
EXECUTORLAUNCHER_PID=$(grep "ExecutorLauncher" "$PID_FILE" | awk '{print $1}')

while IFS= read -r PID; do
    kill "$PID"
done < $TOP_PID_FILE

mkdir -p $RESULT_PATH

DATANODE_CPU_USAGE=$(grep -oP "^\s*$DATANODE_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$DATANODE_OUTPUT_FILE")
DATANODE_CPU_USAGE=$(echo "$DATANODE_CPU_USAGE" | sed 's/%CPU//g')
DATANODE_CPU_ARRAY=($DATANODE_CPU_USAGE)

DATANODE_MEM_USAGE=$(grep -oP "^\s*$DATANODE_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$DATANODE_OUTPUT_FILE")
DATANODE_MEM_USAGE=$(echo "$DATANODE_MEM_USAGE" | sed 's/%MEM//g')
DATANODE_MEM_ARRAY=($DATANODE_MEM_USAGE)

echo "%CPU,%MEM" > $DATANODE_CSV_PATH
for ((i = 0; i < ${#DATANODE_CPU_ARRAY[@]}; i++)); do
  echo "${DATANODE_CPU_ARRAY[i]},${DATANODE_MEM_ARRAY[i]}" >> $DATANODE_CSV_PATH
done

NODEMANAGER_CPU_USAGE=$(grep -oP "^\s*$NODEMANAGER_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$NODEMANAGER_OUTPUT_FILE")
NODEMANAGER_CPU_USAGE=$(echo "$NODEMANAGER_CPU_USAGE" | sed 's/%CPU//g')
NODEMANAGER_CPU_ARRAY=($NODEMANAGER_CPU_USAGE)

NODEMANAGER_MEM_USAGE=$(grep -oP "^\s*$NODEMANAGER_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$NODEMANAGER_OUTPUT_FILE")
NODEMANAGER_MEM_USAGE=$(echo "$NODEMANAGER_MEM_USAGE" | sed 's/%MEM//g')
NODEMANAGER_MEM_ARRAY=($NODEMANAGER_MEM_USAGE)

echo "%CPU,%MEM" > $NODEMANAGER_CSV_PATH
for ((i = 0; i < ${#NODEMANAGER_CPU_ARRAY[@]}; i++)); do
  echo "${NODEMANAGER_CPU_ARRAY[i]},${NODEMANAGER_MEM_ARRAY[i]}" >> $NODEMANAGER_CSV_PATH
done

EXECUTORBACKEND_CPU_USAGE=$(grep -oP "^\s*$EXECUTORBACKEND_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$EXECUTORBACKEND_OUTPUT_FILE")
EXECUTORBACKEND_CPU_USAGE=$(echo "$EXECUTORBACKEND_CPU_USAGE" | sed 's/%CPU//g')
EXECUTORBACKEND_CPU_ARRAY=($EXECUTORBACKEND_CPU_USAGE)

EXECUTORBACKEND_MEM_USAGE=$(grep -oP "^\s*$EXECUTORBACKEND_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$EXECUTORBACKEND_OUTPUT_FILE")
EXECUTORBACKEND_MEM_USAGE=$(echo "$EXECUTORBACKEND_MEM_USAGE" | sed 's/%MEM//g')
EXECUTORBACKEND_MEM_ARRAY=($EXECUTORBACKEND_MEM_USAGE)

echo "%CPU,%MEM" > $EXECUTORBACKEND_CSV_PATH
for ((i = 0; i < ${#EXECUTORBACKEND_CPU_ARRAY[@]}; i++)); do
  echo "${EXECUTORBACKEND_CPU_ARRAY[i]},${EXECUTORBACKEND_MEM_ARRAY[i]}" >> $EXECUTORBACKEND_CSV_PATH
done

if [ -f "$EXECUTORLAUNCHER_OUTPUT_FILE" ]; then
    EXECUTORLAUNCHER_CPU_USAGE=$(grep -oP "^\s*$EXECUTORLAUNCHER_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$EXECUTORLAUNCHER_OUTPUT_FILE")
    EXECUTORLAUNCHER_CPU_USAGE=$(echo "$EXECUTORLAUNCHER_CPU_USAGE" | sed 's/%CPU//g')
    EXECUTORLAUNCHER_CPU_ARRAY=($EXECUTORLAUNCHER_CPU_USAGE)

    EXECUTORLAUNCHER_MEM_USAGE=$(grep -oP "^\s*$EXECUTORLAUNCHER_PID\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\K\S+" "$EXECUTORLAUNCHER_OUTPUT_FILE")
    EXECUTORLAUNCHER_MEM_USAGE=$(echo "$EXECUTORLAUNCHER_MEM_USAGE" | sed 's/%MEM//g')
    EXECUTORLAUNCHER_MEM_ARRAY=($EXECUTORLAUNCHER_MEM_USAGE)

    echo "%CPU,%MEM" > $EXECUTORLAUNCHER_CSV_PATH
    for ((i = 0; i < ${#EXECUTORLAUNCHER_CPU_ARRAY[@]}; i++)); do
        echo "${EXECUTORLAUNCHER_CPU_ARRAY[i]},${EXECUTORLAUNCHER_MEM_ARRAY[i]}" >> $EXECUTORLAUNCHER_CSV_PATH
    done
fi

scp -o StrictHostKeyChecking=no $RESULT_PATH/* $NAMENODE_USERNAME@$NAMENODE_IP:/home/$NAMENODE_USERNAME/$RESULT_PATH/

rm $PID_FILE
rm $TOP_PID_FILE
rm $DATANODE_OUTPUT_FILE
rm $NODEMANAGER_OUTPUT_FILE
rm $EXECUTORBACKEND_OUTPUT_FILE
if [ -f "$EXECUTORLAUNCHER_OUTPUT_FILE" ]; then
  rm $EXECUTORLAUNCHER_OUTPUT_FILE
fi
rm -r result
rm -rf aporrima