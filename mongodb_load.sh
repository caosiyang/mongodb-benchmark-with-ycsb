#!/bin/sh

# filename: mongodb_load.sh
# summary: load mongodb workload
# author: caosiyang <csy3228@gmail.com>
# date: 2013/06/20

source ./utils.sh

set -e
set -u

if ! [ -f mongodb_workload_template ] ; then
    echo 'mongodb_workload_template not found'
    exit 1
fi

option_parse "$@"
option_check
option_echo

workloadfilepath="result/workload_load_${recordlength}_${target}_${readproportion}_${updateproportion}"
#resultfilepath="result/load_stat_${recordlength}_${target}_${readproportion}_${updateproportion}"

test -f  mongodb_workload_template || exit 1
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
ycsb-0.1.4/bin/ycsb load mongodb -P $workloadfilepath
echo "DONE    @ `date`"

exit 0
