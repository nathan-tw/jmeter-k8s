working_dir=`pwd`


jmx="$1"
[ -n "$jmx" ] || read -p 'Enter path to the jmx file ' jmx

if [ ! -f "$jmx" ];
then
    echo "Test script file was not found in PATH"
    echo "Kindly check and input the correct file path"
    exit
fi

influxdb_pod=`kubectl get po --kubeconfig=$KUBE_CONFIG -n jmeter | grep influxdb-jmeter | awk '{print $1}'`
influxdbToken=`kubectl exec --kubeconfig=$KUBE_CONFIG -i -n jmeter $influxdb_pod -- influx auth list | awk '$0 ~ /jmeter-token/{print $3}'`

echo $1 $2 $3 $4 $5 $6 $7 $8 $influxdbToken

sed -i 's/$influxdbToken/$influxdbToken/g' test-plan.jmx
sed -i 's/$influxdbUrl/http://jmeter-influxdb:8086/api/v2/write?org=jmeter-org&amp;bucket=jmeter-bucket/g' test-plan.jmx

test_name="$(basename "$jmx")"
master_pod=`kubectl get po  --kubeconfig=$KUBE_CONFIG -n jmeter | grep jmeter-master | awk '{print $1}'`
kubectl cp --kubeconfig=$KUBE_CONFIG -n jmeter "$jmx" "$master_pod:/$test_name"
kubectl exec  --kubeconfig=$KUBE_CONFIG -i -n jmeter $master_pod -- /bin/bash /load_test "$test_name" $2 $3 $4 $5 $6 $7 $8 $influxdbToken
