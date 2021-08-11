#!/usr/bin/env bash
#Script writtent to stop a running jmeter master test
#Kindly ensure you have the necessary kubeconfig

working_dir=`pwd`

master_pod=`kubectl get po --kubeconfig=$KUBE_CONFIG -n jmeter | grep jmeter-master | awk '{print $1}'`

#kubectl -n $tenant exec -ti $master_pod bash /jmeter/apache-jmeter-5.0/bin/stoptest.sh

kubectl -n $tenant exec -it $master_pod -- bash -c "./jmeter/apache-jmeter-5.0/bin/stoptest.sh"                               
