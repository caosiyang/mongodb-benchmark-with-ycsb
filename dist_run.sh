#!/bin/sh

# filename: distribute_benchmark.sh
# summary: run distribute benchmark
# author: caosiyang <csy3228@gmail.com>
# date: 2013/06/20

. myycsb/utils.sh

wait_all_done() {
    echo -n "waiting..."
    sleep 3
    while true
    do
        local alldone=true
        if ps aux | grep core-0.1.4.jar | grep -v grep >/dev/null 2>&1 ; then
            sleep 1
            echo -n "."
            continue
        fi
        while read remotehost
        do
            if ssh -o StrictHostKeyChecking=no root@$remotehost "ps aux | grep core-0.1.4.jar | grep -v grep" >/dev/null 2>&1 ; then
                alldone=false
                break
            fi
        done <host.conf
        if $alldone ; then
            echo "DONE"
            break
        else
            sleep 1
            echo -n "."
        fi
    done
}

set -e
set -u

# the default value of options are same to values in workload template
host="localhost"
port=27017
recordcount=10000
operationcount=10000
recordlength=1024
fieldlength=$((recordlength/8))
readproportion=1
updateproportion=0
target=1000
hostconf="host.conf"
clicnt=1

if [ $# -lt 2 ] ; then
    usage
    exit 1
fi

option_parse "$@"
option_check
option_echo

file_exist_check "$hostconf"

# get client count
while read remotehost
do
    clicnt=$((clicnt+1))
done <"$hostconf"

ops=$((target*clicnt))

# running workload
while read remotehost
do
    ssh -o StrictHostKeyChecking=no root@$remotehost "cd /home/caosiyang/myycsb && mkdir -p result && ./mongodb_run.sh --host $host --port $port --recordcount $recordcount --operationcount $operationcount --recordlength $recordlength --readproportion $readproportion --updateproportion $updateproportion --target $target >result/run_stat_${recordlength}_${ops}_${readproportion}_${updateproportion} 2>&1" </dev/null &
done <"$hostconf"
cd myycsb
mkdir -p result
./mongodb_run.sh --host $host --port $port --recordcount $recordcount --operationcount $operationcount --recordlength $recordlength --readproportion $readproportion --updateproportion $updateproportion --target $target >result/run_stat_${recordlength}_${ops}_${readproportion}_${updateproportion} 2>&1 &
cd ..

# wait
wait_all_done

exit 0
