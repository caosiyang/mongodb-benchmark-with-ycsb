#!/bin/sh

# filename: distribute_benchmark.sh
# summary: run distribute benchmark
# author: caosiyang <csy3228@gmail.com>
# date: 2013/06/20

. utils.sh

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

hostconf="host.conf"
clicnt=0

option_parse "$@"
option_check
option_echo

if ! [ -f "$hostconf" ] ; then
    echo "$hostconf not found"
    exit 1
fi

# get client count
while read remotehost
do
    clicnt=$((clicnt+1))
done <"$hostconf"

ops=$((target*clicnt))

# running workload
while read remotehost
do
    ssh -o StrictHostKeyChecking=no root@$remotehost "cd /home/caosiyang/ycsb-0.1.4 && mkdir -p result && ./mongodb_run.sh --host $host --port $port --recordcount $recordcount --operationcount $operationcount --recordlength $recordlength --readproportion $readproportion --updateproportion $updateproportion --target $target >result/run_stat_${recordlength}_${ops}_${readproportion}_${updateproportion} 2>&1" </dev/null &
done <"$hostconf"

# wait
wait_all_done

exit 0
