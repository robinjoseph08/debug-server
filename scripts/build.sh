#!/bin/bash -e

NOW=$(date +'%s')
REPO="robinjoseph08/debug-server"
TAG="$(git rev-parse --short HEAD)"
[[ -z $(git status -s) ]] || TAG="${TAG}-dirty-${NOW}"

echo
echo -e "\033[1;32m==> Building ${TAG}...\033[0m"
echo

DOCKER_BUILDKIT=1 docker build -t ${REPO}:${TAG} .

if [ "$1" == "--push" ]; then
  echo
  echo -e "\033[1;32m==> Pushing ${TAG} to ${REPO}...\033[0m"
  echo

  docker push ${REPO}:${TAG}
fi
