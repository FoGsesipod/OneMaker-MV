#!/usr/bin/env bash
echo "Welcome. This requires docker."
echo "- Setting up Output directory"

mkdir -p output

echo "- Downloading Qt"
curl https://download.qt.io/new_archive/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.xz > qt.tar.xz

echo "- Building container. This will take ages."
docker build -t onemaker-compilation-environment .

echo "- Running container."
docker run --name onemaker-compilation-worker --volume ./output:/output -it onemaker-compilation-environment

echo "It should be ready."

echo "Cleaning up"
docker rm onemaker-compilation-worker

echo "if you want to clean up more:"
echo "run this:"
echo "- docker rmi onemaker-compilation-environment"
echo "- docker image prune"
echo "- docker system prune"
echo "enjoy."