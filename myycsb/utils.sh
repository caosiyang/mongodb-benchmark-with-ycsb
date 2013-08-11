usage() {
    echo "Usage: $0 [OPTION VALUE] ..."
    echo "OPTIONS:"
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
