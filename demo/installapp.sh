#!/bin/sh

# usage ./installapp.sh <kubeconfig>
# ex Remote installation
# ./installapp.sh --kubeconfig="/Users/chesterpressler/.kube/k8s-sv-demo-kubeconfig.yaml"

# ex Local Installation
# ./installapp

echo  Doing a install via this kubernetes config $1

kubectl  $1 version
kubectl  $1 get nodes
kubectl  $1 get pods
kubectl  $1 get services

kubectl  $1 apply -f deployment.yaml
kubectl  $1 apply -f service.yaml
kubectl  $1 apply -f traefik-middlewares.yaml
kubectl  $1 apply -f traefik-ingress-split.yaml

kubectl  $1 get nodes
kubectl  $1 get pods
kubectl  $1 get services
kubectl  $1 version