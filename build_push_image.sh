#!/bin/bash

docker build -t item-app:v1 .

docker images

docker tag item-app:v1 ghcr.io/ikrar557/item-app:v1

echo $GITHUB_PAT | docker login ghcr.io -u ikrar557 --password-stdin

docker push ghcr.io/ikrar557/item-app:v1

