working_dir=`pwd`
tenant=jmeter


jmx="$1"
[ -n "$jmx" ] || read -p 'Enter path to the jmx file ' jmx

if [ ! -f "$jmx" ];
then
    echo "Test script file was not found in PATH"
    echo "Kindly check and input the correct file path"
    exit
fi

test_name="$(basename "$jmx")"
master_pod=`kubectl.exe get po -n $tenant | grep jmeter-master | awk '{print $1}'`
kubectl.exe cp "$jmx" -n $tenant "$master_pod:/$test_name"
kubectl.exe exec -ti -n $tenant $master_pod -- /bin/bash /load_test "$test_name"
