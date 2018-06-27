#!/bin/bash
docker build -t kube:$1 .
docker tag kube:$1 localhost:5000/kube:$1
docker push localhost:5000/kube:$1
