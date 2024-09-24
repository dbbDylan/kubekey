#!/bin/bash

# envs
PROJECT_DIR="/Users/dyl/GoProjects"
PROJECT_NAME="kubekey"
PROJECT="${PROJECT_DIR}/${PROJECT_NAME}"
REMOTE_DIR="/tmp/"
REMOTE_PROJECT="${REMOTE_DIR}/${PROJECT_NAME}"

REMOTE_HOST="139.198.121.174"
REMOTE_PORT=30001
REMOTE_USER="root"

REGISTRY="docker.io/doublebiao"
TAG="v1-$(date +'%Y%m%d')"

printf "正在同步本地项目到远程服务器...\n"
rsync -avz \
  --delete \
  --exclude 'vendor' \
  --exclude 'kubeconfig' \
  --exclude '.*' \
  --exclude '_*' \
  -e "ssh -p ${REMOTE_PORT}" \
  "${PROJECT}/" ${REMOTE_USER}@${REMOTE_HOST}:"${REMOTE_PROJECT}/"

printf "\n\n正在远程服务器打包镜像...\n"
ssh -p 30001 root@139.198.121.174 "\
  cd ${REMOTE_PROJECT} && \
  REGISTRY=${REGISTRY} TAG=${TAG} make docker-build-kk
"