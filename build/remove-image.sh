#!/usr/bin/env bash

if [ $(docker images | grep "${PROJECT_NAME}" | wc -l) != 0 ]; then
    docker images | grep "${PROJECT_NAME}"|while read -r line ; do
        res=$line
        tag=`echo "${res}"|awk '{print $2}'`
        if [ ${tag} != "latest" ] && [ ${tag} != "TAG" ] && [ ${tag} != "<none>" ]; then
           # docker rmi -f "${PROJECT_NAME}:${tag}"
           echo $0
        fi
    done
fi
