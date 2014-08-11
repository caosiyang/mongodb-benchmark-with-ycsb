# default options
# they are same to values in workload template
host="localhost"
port=27017
recordcount=10000
operationcount=10000
recordlength=1024
fieldlength=$((recordlength/8))
readproportion=1
updateproportion=0
target=1000


usage() {
    echo "Usage: $0 [OPTION VALUE] ..."
    echo "OPTIONS:"
    echo "  --host              default localhost"
    echo "  --port              default 27017"
    echo "  --recordcount       default 10000"
    echo "  --operationcount    default 10000"
    echo "  --recordlength      default 1024"
    echo "  --readproportion    default 1"
    echo "  --updateproportion  default 0"
    echo "  --target            default 1000"
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
    echo "Command options:"
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
