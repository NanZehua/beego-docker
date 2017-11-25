#!/usr/bin/env bash

echo "b-1.set using path"
BUILD_NAME="hello"
PATH_BUILD=$(cd "$(dirname "$0")"; pwd)
PATH_ROOT=${PATH_BUILD}/../
PATH_BIN=${PATH_BUILD}/bin
PATH_SRC=${PATH_ROOT}/src/${BUILD_NAME}
PROJECT_NAME="hello"

echo "b-2.check go version"
go_version=`go version|awk '{print $3}'`
if [[ ${go_version/go} < 1.4 ]]; then
  echo "go version should equal or great then 1.4, current version is ${go_version/go/}"
  exit
fi

setup_libs() {
  echo "..set thirdparty libs.."
}

build_project() {
  export GOPATH=${PATH_ROOT}
  cd ${PATH_SRC}
  # Mac下进行交叉编译至Linux64
  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build
  #bee pack -be=GOOS=linux -exs=.md:.go:.DS_Store:.tmp:.zip:.exe.exe~ -exp=.:swagger:static:runtime
  # Mac下进行交叉编译至Windows64
  #CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build
  #CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build
  # shell下编译
  #go build

  if [ -f ./${BUILD_NAME} ] ; then
      mkdir -p ${PATH_BIN}
      //echo viewspath = /var/paas/project-hello/views >> ./conf
      tar -zcvf ${PATH_BIN}/${PROJECT_NAME}.tgz ./${BUILD_NAME} ./views ./conf ./static
      #mv ${PROJECT_NAME}.tar.gz ${PATH_BIN}
      echo "project-hello build successfully."
  else
      echo "project-hello build failed."
  fi

  #clean build file
  rm ./${BUILD_NAME}
}

echo "b-3.set thirdparth libs"
setup_libs

echo "b-4.build go project"
build_project "project-hello"

exit $?