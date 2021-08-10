#! /bin/bash

export working_dir=`pwd`

kubectl create namespace jmeter
kubectl apply --kubeconfig=$KUBE_CONFIG -f $working_dir/k8s