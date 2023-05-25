#!/bin/bash

get_namenode_pid() {
  local NAMENODE_PID=$(jps | awk '$2 == "NameNode" {print $1}')
  echo "$NAMENODE_PID"
}


get_resourcemanager_pid() {
  local RESOURCEMANAGER_PID=$(jps | grep ResourceManager | awk '{print $1}')
  echo "$RESOURCEMANAGER_PID"
}


get_datanode_pid() {
  local DATANODE_PID=$(jps | awk '$2 == "DataNode" {print $1}')
  echo "$DATANODE_PID"
}


get_nodemanager_pid() {
  local NODEMANAGER_PID=$(jps | grep NodeManager | awk '{print $1}')
  echo "$NODEMANAGER_PID"
}


get_sparksubmit_pid() {
  local SPARKSUBMIT_PID
  
  while [[ -z $SPARKSUBMIT_PID ]]; do
    SPARKSUBMIT_PID=$(jps | grep SparkSubmit | awk '{print $1}')
    sleep 1
  done
  
  echo "$SPARKSUBMIT_PID"
}


get_yarnexecutorbackend_pid() {
  local EXECUTORBACKEND_PID
  
  while [[ -z $EXECUTORBACKEND_PID ]]; do
    EXECUTORBACKEND_PID=$(jps | grep YarnCoarseGrainedExecutorBackend | awk '{print $1}')
    sleep 1
  done
  
  echo "$EXECUTORBACKEND_PID"
}

get_executorlauncher_pid() {
  local EXECUTORLAUNCHER_PID
  
  while [[ -z $EXECUTORLAUNCHER_PID ]]; do
    EXECUTORLAUNCHER_PID=$(jps | grep ExecutorLauncher | awk '{print $1}')
    sleep 1
  done
  
  echo "$EXECUTORLAUNCHER_PID"
}

