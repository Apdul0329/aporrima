#!/bin/bash

USERNAME=$(whoami)
HIBENCH_HOME=/home/$USERNAME/HiBench

echo "Please select a number that corresponds to the desired operation"
read -r -p "( 1 : Sort / 2 : WordCount ) : " response

case $response in
    1)
        OPERATION=sort
        ${HIBENCH_HOME}/bin/workloads/micro/$OPERATION/prepare/prepare.sh
        ./aporrima/measurement/measure_namenode_resource.sh $OPERATION
        ;;
    2)
        OPERATION=wordcount
        ${HIBENCH_HOME}/bin/workloads/micro/$OPERATION/prepare/prepare.sh
        ./aporrima/measurement/measure_namenode_resource.sh $OPERATION
        ;;
esac