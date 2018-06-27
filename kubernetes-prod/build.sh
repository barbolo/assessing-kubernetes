#!/bin/bash
docker build -t kube .
cd kubernetes-prod
docker build -t gcr.io/assessing--kubernetes/kube:$1 .
gcloud docker -- push gcr.io/assessing--kubernetes/kube:$1
