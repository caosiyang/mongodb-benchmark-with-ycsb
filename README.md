# MongoDB benchmark with YCSB


## Usage

```
# sh mongodb_load.sh --help
Usage: mongodb_load.sh [OPTION VALUE] ...
OPTIONS:
--host              host of mongodb instance, default: localhost
--port              port of mongodb instance, default: 27017
--recordcount       amount of records, default: 10000
--operationcount    number of operations to perform, default: 10000
--recordlength      length of record, default: 1024 bytes, 8 fields
--readproportion    what proportion of operations should be reads, default: 1
--updateproportion  what proportion of operations should be updates, default: 0
--threadcount       amount of threads, default: 40
--target            target throughput, default: not set
-h, --help          usage information


# sh mongodb_run.sh --help
Usage: mongodb_run.sh [OPTION VALUE] ...
OPTIONS:
--host              host of mongodb instance, default: localhost
--port              port of mongodb instance, default: 27017
--recordcount       amount of records, default: 10000
--operationcount    number of operations to perform, default: 10000
--recordlength      length of record, default: 1024 bytes, 8 fields
--readproportion    what proportion of operations should be reads, default: 1
--updateproportion  what proportion of operations should be updates, default: 0
--threadcount       amount of threads, default: 40
--target            target throughput, default: not set
-h, --help          usage information
```


## Note

Workload will be generated on collection `ycsb.ycsb` of the mongo instance.
You need to drop database `ycsb` before you generate a new workload.
