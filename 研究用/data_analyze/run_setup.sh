#!/bin/sh

BOARD_ID=$1
DATA_NUMBER=$2

# 繰り返し回数を16進数に変換し、上位バイトに分割する関数
convert_to_hex_parts() {
  hex_value=$(printf '%02x' $1) # 2桁の16進数に変換
  high_byte=${hex_value}   # 上位バイト
}

# データ量に対応する16進数の各部分を取得
convert_to_hex_parts $DATA_NUMBER

# レジスタに書き込み
# ./fpgacontroller -w --board "$BOARD_ID" 0x09 0x01
./fpgacontroller -w --board "$BOARD_ID" 0x0a 0x$high_byte

# BOARD_ID=$1

# ./fpgacontroller -w --board "$BOARD_ID" 0x09 0x01
# ./fpgacontroller -w --board "$BOARD_ID" 0x0a 0x00
# ./fpgacontroller -w --board "$BOARD_ID" 0x0b 0x03
# ./fpgacontroller -w --board "$BOARD_ID" 0x0c 0xe8

