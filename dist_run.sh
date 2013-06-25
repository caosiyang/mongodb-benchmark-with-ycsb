#!/bin/sh

# filename: distribute_benchmark.sh
# summary: run distribute benchmark
# author: caosiyang <csy3228@gmail.com>
# date: 2013/06/20

usage() {
    echo "Usage: $0 [OPTION VALUE] ..."
    echo "  --host"
    echo "  --port"
    echo "  --recordcount"
    echo "  --operationcount"
    echo "  --recordlength"
    echo "  --readproportion"
    echo "  --updateproportion"
    echo "  --target"
    echo "  -f"
    echo "  -h, --help"
}

option_parse() {
    until [ $# -eq 0 ]
    do
        if [ "$1" == "--host" ]; then
            host="$2"
        elif [ "$1" == "--port" ]; then
            port="$2"
        elif [ "$1" == "--recordcount" ]; then
            recordcount="$2"
        elif [ "$1" == "--operationcount" ]; then
            operationcount="$2"
        elif [ "$1" == "--recordlength" ]; then
            recordlength="$2"
            fieldlength=$((recordlength/8))
        elif [ "$1" == "--readproportion" ]; then
            readproportion="$2"
        elif [ "$1" == "--updateproportion" ]; then
            updateproportion="$2"
        elif [ "$1" == "--target" ]; then
            target="$2"
        elif [ "$1" == "-f" ] ; then
            hostconf="$2"
        elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
            usage
            exit 0
        else
            echo "WARNING: unknown option $1"
        fi
        shift 2
    done
}

option_check() {
    # TODO
    if [ "$fieldlength" -lt 8 ]; then
        echo "ERROR: recordlength cannot be less than 8"
        exit 1
    fi
}

option_echo() {
    echo "OPTIONS:"
    echo "  recordcount      = $recordcount"
    echo "  opertioncount    = $operationcount"
    echo "  fieldlength      = $fieldlength"
    echo "  fieldcount       = 8"
    echo "  recordlength     = $recordlength"
    echo "  readproportion   = $readproportion"
    echo "  updateproportion = $updateproportion"
    echo "  target           = $target"
}

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

file_exist_check() {
    if [ ! -f "$1" ]
    then
        echo "not found $1"
        exit 1
    fi
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

if [ $# -lt 2 ] ; then
    usage
    exit 1
fi

option_parse "$@"
option_check
option_echo

file_exist_check "$hostconf"

# running workload
while read remotehost
do
    ssh -o StrictHostKeyChecking=no root@$remotehost "cd /home/caosiyang/myycsb && mkdir -p result && ./mongodb_run.sh --host $host --port $port --recordcount $recordcount --operationcount $operationcount --recordlength $recordlength --readproportion $readproportion --updateproportion $updateproportion --target $target >result/run_stat_${recordlength}_${target}_${readproportion}_${updateproportion} 2>&1" </dev/null &
done <"$hostconf"
cd myycsb
mkdir -p result
./mongodb_run.sh --host $host --port $port --recordcount $recordcount --operationcount $operationcount --recordlength $recordlength --readproportion $readproportion --updateproportion $updateproportion --target $target >result/run_stat_${recordlength}_${target}_${readproportion}_${updateproportion} 2>&1 &
cd ..

# wait
wait_all_done

exit 0
