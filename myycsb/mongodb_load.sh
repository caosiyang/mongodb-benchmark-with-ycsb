#!/bin/sh

# filename: mongodb_load.sh
# summary: load mongodb workload
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
    echo "  host             = $host"
    echo "  port             = $port"
    echo "  recordcount      = $recordcount"
    echo "  opertioncount    = $operationcount"
    echo "  fieldlength      = $fieldlength"
    echo "  fieldcount       = 8"
    echo "  recordlength     = $recordlength"
    echo "  readproportion   = $readproportion"
    echo "  updateproportion = $updateproportion"
    echo "  target           = $target"
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

if [ $# -lt 2 ] ; then
    usage
    exit 1
fi

option_parse "$@"
option_check
option_echo

workloadfilepath="result/workload_load_${recordlength}_${target}_${readproportion}_${updateproportion}"
#resultfilepath="result/load_stat_${recordlength}_${target}_${readproportion}_${updateproportion}"

file_exist_check mongodb_workload_template
mkdir -p result
cp mongodb_workload_template "$workloadfilepath"

# create workload file
sed -i "s#mongodb.url=mongodb://localhost:27017#mongodb.url=mongodb://$host:$port#g" $workloadfilepath
sed -i "s/recordcount=10000/recordcount=$recordcount/g" $workloadfilepath
sed -i "s/operationcount=10000/operationcount=$operationcount/g" $workloadfilepath
sed -i "s/fieldlength=128/fieldlength=$fieldlength/g" $workloadfilepath
sed -i "s/readproportion=1/readproportion=$readproportion/g" $workloadfilepath
sed -i "s/updateproportion=0/updateproportion=$updateproportion/g" $workloadfilepath
sed -i "s/timeseries.granularity=2000/timeseries.granularity=10000/g" $workloadfilepath
# NOTICE: not set 'target' so that make loading faster
sed -i "/target=1000/d" $workloadfilepath

echo "########## workload ##########"
cat $workloadfilepath
echo "##############################"

# loading workload
mongo $host:$port/ycsb --eval "db.dropDatabase()"
echo "loading @ `date`"
bin/ycsb load mongodb -P $workloadfilepath
echo "DONE    @ `date`"

exit 0
