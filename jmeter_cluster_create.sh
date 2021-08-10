#! /bin/bash

export working_dir=`pwd`

kubectl create namespace jmeter
kubectl apply -f $working_dir/k8s