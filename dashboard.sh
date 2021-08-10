#! /bin/bash

working_dir="C:\Users\linnathan\workspace\stresstestmultinode\k8s-jmeter-cluster"
tenant=jmeter

## Create jmeter database automatically in Influxdb

echo "Creating Influxdb jmeter Database"
influxdb_pod=`kubectl get po -n $tenant | grep influxdb-jmeter | awk '{print $1}'`
kubectl exec -it -n jmeter influxdb-jmeter-bd45d4c68-h46jd -- influx setup --org jmeter-org --bucket jmeter-bucket --username admin --password iLove163_ --force

## Create the influxdb datasource in Grafana

echo "Creating the Influxdb data source"
grafana_pod=`kubectl get po -n $tenant | grep jmeter-grafana | awk '{print $1}'`
master_pod=`kubectl get po -n $tenant | grep jmeter-master | awk '{print $1}'`
kubectl exec -ti -n $tenant $master_pod -- cp -r /load_test /jmeter/load_test
kubectl exec -ti -n $tenant $master_pod -- chmod 755 /jmeter/load_test

##kubectl cp $working_dir/influxdb-jmeter-datasource.json -n $tenant $grafana_pod:/influxdb-jmeter-datasource.json

kubectl exec -ti -n $tenant $grafana_pod -- curl 'http://admin:admin@127.0.0.1:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"jmeterdb","type":"influxdb","url":"http://jmeter-influxdb:8086","access":"proxy","isDefault":true,"database":"jmeter","user":"admin","password":"admin"}'
