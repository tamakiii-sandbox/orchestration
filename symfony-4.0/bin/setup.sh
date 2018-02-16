#!/bin/sh

ROOT_DIR="$(realpath $(cd $(dirname $0) && pwd)/..)"
REPOSITORY_DIR="${ROOT_DIR}/repository"

if [ ! -d "${REPOSITORY_DIR}/symfony-4.0" ] ; then
  git clone git@github.com:tamakiii/symfony-4.0.git "${REPOSITORY_DIR}/symfony-4.0";
fi

