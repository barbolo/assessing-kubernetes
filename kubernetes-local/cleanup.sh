#!/bin/bash
kubectl delete services web worker db
kubectl delete deployments web worker db
