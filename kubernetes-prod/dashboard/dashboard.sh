#!/bin/bash
# Copy the token
kubectl -n kube-system describe $(kubectl -n kube-system \
   get secret -n kube-system -o name | grep namespace) | grep token:
kubectl proxy
