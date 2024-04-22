#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
NC="\e[0m"

REDBGR='\033[0;41m'
NCBGR='\033[0m'

########## CONFIG ##########
component="scheduler"
OPTION=$1
############################

logSuccess() { echo -e "$GREEN-----$message-----$NC";}
logError() { echo -e "$RED-----$message-----$NC";}
logInfo() { echo -e "$YELLOW###############---$message---###############$NC";}

koBuild() {
    message="ko build image" && logInfo
    export KO_DOCKER_REPO="ko.local"
    ko build ./cmd/scheduler/
    if [ "$?" -ne "0" ]; then
        message="ko build error" && logError
        exit 1
    else
        message="ko build successfully" && logSuccess
    fi
}

convertImage() {
    message="change image from docker to crictl" && logInfo
    image=$(docker images | grep ko.local | grep scheduler | grep latest | awk '{print $1}'):latest
    docker rmi -f bonavadeur/michinori-scheduler:latest
    docker image tag $image docker.io/bonavadeur/michinori-scheduler:latest
    docker rmi $image
    image=$(docker images | grep ko.local | grep scheduler | awk '{print $1}'):$(docker images | grep ko.local | grep scheduler | awk '{print $2}')
    docker rmi $image
    docker save -o michinori-scheduler.tar docker.io/bonavadeur/michinori-scheduler:latest
    # docker push docker.io/bonavadeur/michinori-scheduler:latest
    message="Saved atarashi-imeji to .tar file" && logSuccess
    sudo crictl rmi docker.io/bonavadeur/michinori-scheduler:latest
    sudo ctr -n=k8s.io images import michinori-scheduler.tar
    message="Untar atarashi-imeji" && logSuccess
    rm -rf michinori-scheduler.tar
    ssh node3 "rm -rf /root/michinori-scheduler.tar"
}

deployNewVersion() {
    message="remove current Pod" && logInfo
    pods=($(kubectl -n default get pod | grep "scheduler" | awk '{print $1}'))
    for pod in ${pods[@]}
    do
        kubectl -n default delete pod/$pod &
    done
}

logPod() {
    sleep 1
    pods=($(kubectl -n default get pod -o wide | grep scheduler | grep Running | awk '{print $1}'))
    while [ "${pods[0]}" == "" ];
    do
        sleep 1
        pods=($(kubectl -n default get pod -o wide | grep scheduler | grep Running | awk '{print $1}'))
    done

    kubectl -n default wait --for=condition=ready pod ${pods[0]} > /dev/null 2>&1
    clear
    endTime=`date +%s`
    echo Build time was `expr $endTime - $startTime` seconds.
    message="scheduler logs" && logInfo
    echo "pod:"${pods[0]}
    kubectl -n default logs ${pods[0]} -f
}

clear



echo -e "$REDBGR このスクリプトはボナちゃんによって書かれています $NCBGR"


startTime=`date +%s`
if [ $OPTION == "ko" ]; then
    image=$(docker images | grep ko.local | grep scheduler | awk '{print $3}')
    docker rmi -f $image
    koBuild
elif [ $OPTION == "dep" ]; then
    convertImage
    deployNewVersion
    logPod
elif [ $OPTION == "log" ]; then
    deployNewVersion
    logPod
elif [ $OPTION == "ful" ]; then
    koBuild
    if [ $? -eq "0" ]; then
        convertImage
        deployNewVersion
        logPod
    else
        exit 1
    fi
elif [ $OPTION == "debug" ]; then
    koBuild
    convertImage
elif [ $OPTION == "clean" ]; then
    go clean -cache
    ./hack/update-deps.sh --upgrade
    ./hack/update-codegen.sh
    clear
    koBuild
    convertImage
    deployNewVersion
    logPod
fi
