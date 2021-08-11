#! /bin/bash

working_dir=`pwd`


## Create jmeter database automatically in Influxdb
influxdb_pod=`kubectl get po --kubeconfig=$KUBE_CONFIG -n jmeter | grep influxdb-jmeter | awk '{print $1}'`
kubectl exec --kubeconfig=$KUBE_CONFIG -i -n jmeter $influxdb_pod -- influx setup --org jmeter-org --bucket jmeter-bucket --username admin123 --password admin123 --force
bucket_id=`kubectl exec --kubeconfig=$KUBE_CONFIG -i -n jmeter $influxdb_pod -- influx bucket list -n jmeter-bucket | awk 'NR!=1{print $1}'`
kubectl exec --kubeconfig=$KUBE_CONFIG -i -n jmeter $influxdb_pod -- influx auth create -o jmeter-org -d jmeter-token --read-bucket $bucket_id \
--read-dashboards --read-tasks --read-telegrafs --read-user

sleep 5
## Create the influxdb datasource in Grafana

# echo "Creating the Influxdb data source"
# grafana_pod=`kubectl get po -n jmeter | grep jmeter-grafana | awk '{print $1}'`
# master_pod=`kubectl get po -n jmeter | grep jmeter-master | awk '{print $1}'`
# kubectl exec -ti -n jmeter $master_pod -- cp -r /load_test /jmeter/load_test
# kubectl exec -ti -n jmeter $master_pod -- chmod 755 /jmeter/load_test

##kubectl cp $working_dir/influxdb-jmeter-datasource.json -n jmeter $grafana_pod:/influxdb-jmeter-datasource.json
# kubectl exec -ti -n jmeter $grafana_pod -- curl 'http://admin:admin@127.0.0.1:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"jmeterdb","type":"influxdb","url":"http://jmeter-influxdb:8086","access":"proxy","isDefault":true,"database":"jmeter","user":"admin","password":"admin"}'
