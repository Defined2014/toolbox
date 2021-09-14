#!/bin/bash
if [ $# != 1 ] ; then 
    echo "USAGE: $0 tid" 
    echo " e.g.: $0 1234" 
    exit 1;
fi

SOURCE="$0"
while [ -h "$SOURCE"  ]; do
    DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"

sudo perf record -e cpu-clock -g -t $1 sleep 15
perf script -i perf.data &> perf.unfold
$DIR/stackcollapse-perf.pl perf.unfold &> perf.folded
$DIR/flamegraph.pl perf.folded > perf.svg
