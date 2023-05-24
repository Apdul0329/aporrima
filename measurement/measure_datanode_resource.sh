#!/bin/bash

source ./get_pid.sh

DATANODE_PID=$(get_datanode_pid)
NODEMANAGER_PID=$(get_nodemanager_pid)

PID_FILE="pid.txt"
TOP_PID_FILE="top_pid.txt"
DATANODE_OUTPUT_FILE="datanode_top.log"
NODEMANAGER_OUTPUT_FILE="nodemanager_top.log"
EXECUTORBACKEND_OUTPUT_FILE="yarnexecutorbackend_top.log"
EXECUTORLAUNCHER_OUTPUT_FILE="executorlauncher_top.log"

top -b -d 1 -p $DATANODE_PID > $DATANODE_OUTPUT_FILE &
TOP_DATANODE_PID=$!
echo $TOP_DATANODE_PID > $TOP_PID_FILE
echo "${DATANODE_PID} DataNode" > $PID_FILE 

top -b -d 1 -p $NODEMANAGER_PID > $NODEMANAGER_OUTPUT_FILE &
TOP_NODEMANAGER_PID=$!
echo $TOP_NODEMANAGER_PID >> $TOP_PID_FILE
echo "${NODEMANAGER_PID} NodeManager" >> $PID_FILE 

EXECUTORBACKEND_PID=$(get_yarnexecutorbackend_pid &)

while [[ -z $EXECUTORBACKEND_PID ]]; do
  sleep 1
done

grep -q "${EXECUTORBACKEND_PID} YarnCoarseGrainedExecutorBackend" $PID_FILE || echo "${EXECUTORBACKEND_PID} YarnCoarseGrainedExecutorBackend" >> $PID_FILE

top -b -d 1 -p $EXECUTORBACKEND_PID > $EXECUTORBACKEND_OUTPUT_FILE &
TOP_EXECUTORBACKEND_PID=$!
echo $TOP_EXECUTORBACKEND_PID >> $TOP_PID_FILE

EXECUTORLAUNCHER_PID=$(get_executorlauncher_pid &)

while [[ -z $EXECUTORLAUNCHER_PID ]]; do
  sleep 1
done

grep -q "${EXECUTORLAUNCHER_PID} ExecutorLauncher" $PID_FILE || echo "${EXECUTORLAUNCHER_PID} ExecutorLauncher" >> $PID_FILE

top -b -d 1 -p $EXECUTORLAUNCHER_PID > $EXECUTORLAUNCHER_OUTPUT_FILE &
TOP_EXECUTORLAUNCHER_PID=$!
echo $TOP_EXECUTORLAUNCHER_PID >> $TOP_PID_FILE