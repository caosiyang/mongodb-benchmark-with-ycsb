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
option_print

workloadfile="workload/workload_load_${recordlength}_${operationcount}_${target}_r${readproportion}_w${updateproportion}"

test -f  mongodb_workload_template || exit 1
mkdir -p workload
cp mongodb_workload_template "$workloadfile"

# create workload file
sed -i "s#mongodb.url=mongodb://localhost:27017#mongodb.url=mongodb://$host:$port#g" $workloadfile
sed -i "s/recordcount=10000/recordcount=$recordcount/g" $workloadfile
sed -i "s/operationcount=10000/operationcount=$operationcount/g" $workloadfile
sed -i "s/fieldlength=128/fieldlength=$fieldlength/g" $workloadfile
sed -i "s/readproportion=1/readproportion=$readproportion/g" $workloadfile
sed -i "s/updateproportion=0/updateproportion=$updateproportion/g" $workloadfile
sed -i "s/timeseries.granularity=2000/timeseries.granularity=10000/g" $workloadfile
sed -i "s/threadcount=40/threadcount=$threadcount/g" $workloadfile
# NOTICE: not set 'target' so that make loading faster
if [ -n "$target" ] ; then
    sed -i "/^target=/d" $workloadfile
    echo "target=$target" >> $workloadfile
fi

echo "########## workload ##########"
cat $workloadfile
echo "##############################"

# loading workload
#echo "drop database 'ycsb'"
#mongo $host:$port/ycsb --eval "db.dropDatabase()"
echo "loading @ `date`"
ycsb-0.1.4/bin/ycsb load mongodb -P $workloadfile
echo "DONE    @ `date`"

exit 0
