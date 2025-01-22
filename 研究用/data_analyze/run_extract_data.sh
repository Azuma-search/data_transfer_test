#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

LOGFILE=$1
OUTPUTFILE=$2

if [[ ! -f ${LOGFILE} ]]; then
    echo "Error: Input file ${LOGFILE} does not exist."
    exit 1
fi

TMP_EVENT="tmp_event.dat"
TMP_EMPTY="tmp_empty.dat"

grep -A 4 -B 1 "isLastData                = 1" ${LOGFILE}  | grep -v "isEnableAsic" | grep -v "dataMode" | grep "event" | awk '{print $3}' > ${TMP_EVENT}
grep -A 4 -B 1 "isLastData                = 1" ${LOGFILE}  | grep -v "isEnableAsic" | grep -v "dataMode" | grep "Empty" | awk '{print $4}' > ${TMP_EMPTY}

num_event=$(wc -l < ${TMP_EVENT})
num_empty=$(wc -l < ${TMP_EMPTY})

if [[ ${num_event} -ne ${num_empty} ]]; then
    echo "Error: Line count mismatch between events (${num_event}) and EmptyBits (${num_empty})."
    exit 1
fi

paste ${TMP_EVENT} ${TMP_EMPTY} > ${OUTPUTFILE}

rm -f ${TMP_EVENT} ${TMP_EMPTY}

echo "Data extracted successfully to ${OUTPUTFILE}"

