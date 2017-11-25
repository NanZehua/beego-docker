#!/usr/bin/env bash

echo "0.checking input arguments"
if [ "$#" -ne 1 ]; then
    echo "Please input project image tag as arguments."
    exit 1
fi

echo "1.set using path"
PATH_BUILD=$(cd "$(dirname "$0")"; pwd -P)
PATH_ROOT=${PATH_BUILD}/..
PATH_BIN=${PATH_BUILD}/bin

PROJECT_NAME="hello"
PROJECT_TAG="$1"
IMAGE_NAME="centos"

echo "2.comping with build.sh"
bash ${PATH_BUILD}/build.sh
if [ ! -f ${PATH_BIN}/${PROJECT_NAME}.tgz ]; then
    echo "Compile project manager failed!"
    exit 1
fi

echo "3.remove docker image with similar name"
if [ $(docker ps|grep "${PROJECT_NAME}"|wc -l) != -1 ]; then
    docker ps | grep "${PROJECT_NAME}"|while read -r line;do
        resp=$line
        containId=`echo "${resp}"|awk '{print $1}'`
        if [ ${containId} != "CONTAINER ID" ] && [ ${containId} != "<none>" ]; then
            docker rm -f "${containId}"
        fi
    done
fi
if [ $(docker images | grep "${PROJECT_NAME}" | wc -l) != 0 ]; then
    docker images | grep "${PROJECT_NAME}"|while read -r line ; do
        res=$line
        tag=`echo "${res}"|awk '{print $2}'`
        if [ ${tag} != "$1" ] && [ ${tag} != "TAG" ]; then
           docker rmi -f "${PROJECT_NAME}:${tag}"
        fi
    done
fi

echo "4.load base centos"
if [ $(docker images|grep "${IMAGE_NAME}"|wc -l) -eq 0 ]; then
    echo "Loading centos for base images..."
    docker pull ${IMAGE_NAME}
fi

echo "5.make docker images of project"
## docker build只能使用当前上下文
mv ${PATH_BIN}/${PROJECT_NAME}.tgz ./
docker build -t ${PROJECT_NAME}:latest .
if [ $? -ne 0 ]; then
    echo "Docker build failed!"
    exit 2
fi
mv ${PROJECT_NAME}.tgz ${PATH_BIN}

echo "6.save docker image of project"
rm -rf ${PATH_BUILD}/${PROJECT_NAME}
mkdir ${PATH_BUILD}/${PROJECT_NAME}
mkdir ${PATH_BUILD}/${PROJECT_NAME}/images

docker tag ${PROJECT_NAME} "${PROJECT_NAME}:${PROJECT_TAG}"
docker save -o ${PATH_BUILD}/${PROJECT_NAME}/images/${PROJECT_NAME}-${PROJECT_TAG}.tar ${PROJECT_NAME}:${PROJECT_TAG}

if [ $? -ne 0 ] || [ ! -f ${PATH_BUILD}/${PROJECT_NAME}/images/${PROJECT_NAME}-${PROJECT_TAG}.tar ]; then
    echo "Docker save image failed!"
fi

exit $?