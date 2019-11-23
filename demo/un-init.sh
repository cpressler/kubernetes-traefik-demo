#!/bin/sh

# this is for a one time setup of the kubernetes cluster
# usage ./un-init.sh <kubeconfig>
# ex Remote installation
# ./un-init.sh --kubeconfig="/Users/chesterpressler/.kube/k8s-sv-demo-kubeconfig.yaml"

# ex Local Installation
# ./un-init

echo  Doing an un-init  via this kubernetes config $1. Removing all setup data.

kubectl  $1 version
kubectl  $1 get nodes
kubectl  $1 get pods
kubectl  $1 get services

kubectl  $1 delete -f prereqs.yaml
kubectl  $1 delete -f load-balancer.yaml

kubectl  $1 get nodes
kubectl  $1 get pods
kubectl  $1 get services
kubectl  $1 version