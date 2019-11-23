#!/bin/sh

# this is for a one time setup of the kubernetes cluster
# usage ./init.sh <kubeconfig>
# ex Remote installation
# ./init.sh --kubeconfig="/Users/chesterpressler/.kube/k8s-sv-demo-kubeconfig.yaml"

# ex Local Installation
# ./init

echo  Doing an init  via this kubernetes config $1

kubectl  $1 version
kubectl  $1 get nodes
kubectl  $1 get pods
kubectl  $1 get services

kubectl  $1 apply -f prereqs.yaml
kubectl  $1 apply -f load-balancer.yaml

kubectl  $1 get nodes
kubectl  $1 get pods
kubectl  $1 get services
kubectl  $1 version