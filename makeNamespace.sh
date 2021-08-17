#!/bin/bash

NAMESPACE_NAME=$1

NS=$(kubectl get namespace $NAMESPACE_NAME --ignore-not-found)
if [[ "$NS" ]]; then
  echo "Skipping creation of namespace $NAMESPACE_NAME - already exists"
else
  echo "Creating namespace $NAMESPACE_NAME"
  kubectl create namespace $NAMESPACE_NAME
fi
