#!/bin/sh

# filename: mongodb_run.sh
# summary: run mongodb workload
# author: caosiyang <csy3228@gmail.com>
# date: 2013/06/20

source ./utils.sh

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

if [ $# -eq 1 ] ; then
    if [ $1 == '-h' ] || [ $1 == '--help' ] ; then
        usage
        exit 0
    fi
    usage
    exit 1
fi

if [ $# -lt 2 ] ; then
    usage
    exit 1
fi

option_parse "$@"
option_check
option_echo

workloadfilepath="result/workload_run_${recordlength}_${target}_${readproportion}_${updateproportion}"
#resultfilepath="result/run_stat_${recordlength}_${target}_${readproportion}_${updateproportion}"

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
sed -i "s/target=1000/target=$target/g" $workloadfilepath

echo "########## workload ##########"
cat $workloadfilepath
echo "##############################"

# running workload
echo "running @ `date`"
bin/ycsb run mongodb -P $workloadfilepath
echo "DONE    @ `date`"

exit 0
