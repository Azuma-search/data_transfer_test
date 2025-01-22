#!/bin/bash

# 引数の確認
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

# 引数から入力ファイルと出力ファイルを取得
LOGFILE=$1
OUTPUTFILE=$2

# 入力ファイルの存在確認
if [[ ! -f ${LOGFILE} ]]; then
    echo "Error: Input file ${LOGFILE} does not exist."
    exit 1
fi

# 一時ファイル名を設定
TMP_EVENT="tmp_event.dat"
TMP_EMPTY="tmp_empty.dat"

# データ抽出処理
grep -A 4 -B 1 "isLastData                = 1" ${LOGFILE}  | grep -v "isEnableAsic" | grep -v "dataMode" | grep "event" | awk '{print $3}' > ${TMP_EVENT}
grep -A 4 -B 1 "isLastData                = 1" ${LOGFILE}  | grep -v "isEnableAsic" | grep -v "dataMode" | grep "Empty" | awk '{print $4}' > ${TMP_EMPTY}

# 行数の整合性を確認
num_event=$(wc -l < ${TMP_EVENT})
num_empty=$(wc -l < ${TMP_EMPTY})

if [[ ${num_event} -ne ${num_empty} ]]; then
    echo "Error: Line count mismatch between events (${num_event}) and EmptyBits (${num_empty})."
    exit 1
fi

# 結果を結合して出力ファイルに保存
paste ${TMP_EVENT} ${TMP_EMPTY} > ${OUTPUTFILE}

# 一時ファイルの削除
rm -f ${TMP_EVENT} ${TMP_EMPTY}

echo "Data extracted successfully to ${OUTPUTFILE}"

