MongoDB benchmark with YCSB
====

usage
----

```
# sh mongodb_load.sh -h
Usage: mongodb_load.sh [OPTION VALUE] ...
OPTIONS:
--host              default localhost
--port              default 27017
--recordcount       default 10000
--operationcount    default 10000
--recordlength      default 1024
--readproportion    default 1
--updateproportion  default 0
--target            default 1000
-h, --help


# sh mongodb_run.sh -h 
Usage: mongodb_run.sh [OPTION VALUE] ...
OPTIONS:
--host              default localhost
--port              default 27017
--recordcount       default 10000
--operationcount    default 10000
--recordlength      default 1024
--readproportion    default 1
--updateproportion  default 0
--target            default 1000
-h, --help
```
