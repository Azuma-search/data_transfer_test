#!/bin/sh
RUN_SECONDS=$1
BOARD_ID1=$2
BOARD_ID2=$3

CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')
DATANUM_LIST=(100000 250000 500000 750000 1000000)
# データファイルの読み込みと処理
./fpgacontroller -w --boardid 3 0x09 0x00
for DATANUM in "${DATANUM_LIST[@]}"; do
	NUM=$((DATANUM / 10000))
	
	./run_wr_trg.sh &

	OUTPUT_NAME="${CURRENT_TIME}_HDD_${DATANUM}_"$RUN_SECONDS"_"
	#OUTPUT_NAME="data/${CURRENT_TIME}_SSD_${DATANUM}_"5"_"
	./run_setup.sh "$BOARD_ID1" "$NUM"
	./run_setup.sh "$BOARD_ID2" "$NUM"
	./slitreader -m 2 -t $((RUN_SECONDS + 1)) -o "$OUTPUT_NAME" -p "$BOARD_ID1" "$BOARD_ID2"
	#./slitreader -m 3 -t 6 -o "$OUTPUT_NAME" -p "$BOARD_ID1" "$BOARD_ID2"
	SLITREADER_PID=$!
	
	#sleep 1
	#./fpgacontroller -w --boardid 3 0x09 0x01
	
	wait $SLITREADER_PID
	SLITREADER_STATUS=$?
	
	if [ $SLITREADER_STATUS -ne 0 ]; then
		echo "Slitreader encountered an errir (status: $SLITREADER_STATUS)."
	fi

	./fpgacontroller -w --boardid 3 0x09 0x00
	#INTERVAL_TIME=$((RUN_SECONDS * 2))
	INTERVAL_TIME=120
	echo "Sleeping for $INTERVAL_TIME seconds..."
	sleep "$INTERVAL_TIME"

	#./fpgacontroller -w --boardid 3 0x09 0x00
	#RUN_SECONDS
done
	
#./run_setup.sh "$BOARD_ID1" 250000
#./run_setup.sh "$BOARD_ID2" 250000
#./slitreader -t 61 -o data/${CURRENT_TIME}_SSD_250000_60_ -p "$BOARD_ID1" "$BOARD_ID2"

#echo "Start of command"
#sleep 1
#echo "End of command"

#./fpgacontroller -w --boardid 3 0x09 0x01

#echo "Start of command"
#sleep 120
#echo "End of command"

#./fpgacontroller -w --boardid 3 0x09 0x00
#./run_setup.sh "$BOARD_ID1" 500000
#./run_setup.sh "$BOARD_ID2" 500000
#./slitreader -t 61 -o data/${CURRENT_TIME}_SSD_500000_60_ -p "$BOARD_ID1" "$BOARD_ID2"

#echo "Start of command"
#sleep 1
#echo "End of command"

#./fpgacontroller -w --boardid 3 0x09 0x01

#echo "Start of command"
#sleep 120
#echo "End of command"

#./fpgacontroller -w --boardid 3 0x09 0x00
#./run_setup.sh "$BOARD_ID1" 750000
#./run_setup.sh "$BOARD_ID2" 750000
#./slitreader -t 61 -o data/${CURRENT_TIME}_SSD_750000_60_ -p "$BOARD_ID1" "$BOARD_ID2"

#echo "Start of command"
#sleep 1
#echo "End of command"

#./fpgacontroller -w --boardid 3 0x09 0x01

#echo "Start of command"
#sleep 120
#echo "End of command"

#./fpgacontroller -w --boardid 3 0x09 0x00
#./run_setup.sh "$BOARD_ID1" 1000000
#./run_setup.sh "$BOARD_ID2" 1000000
#./slitreader -t 61 -o data/${CURRENT_TIME}_SSD_1000000_60_ -p "$BOARD_ID1" "$BOARD_ID2"

#echo "Start of command"
#sleep 1
#echo "End of command"

#./fpgacontroller -w --boardid 3 0x09 0x01

#echo "Start of command"
#sleep 120
#echo "End of command"

#./fpgacontroller -w --boardid 3 0x09 0x00

# ./slitreader -t "$RUN_SECONDS" data/SSD_"$NUMBER"_"$RUN_SECONDS" -p "$BOARD_ID1" "$BOARD_ID2"

# ./fpgacontroller -w --board "$BOARD_ID1" 0x09 0x01
# BOARD_ID=$1

# ./fpgacontroller -w --board "$BOARD_ID" 0x09 0x01
# ./fpgacontroller -w --board "$BOARD_ID" 0x0a 0x00
# ./fpgacontroller -w --board "$BOARD_ID" 0x0b 0x03
# ./fpgacontroller -w --board "$BOARD_ID" 0x0c 0xe8



#!/bin/sh
#NUMBER=$1
#RUN_SECONDS=$2
#BOARD_ID1=$3
#BOARD_ID2=$4

#CURRENT_TIME=$(date '+%Y%m%d_%H%M%S')

# データファイルの読み込みと処理
#./run_setup.sh "$BOARD_ID1" "$NUMBER"
#./run_setup.sh "$BOARD_ID2" "$NUMBER"
#./slitreader -t "$RUN_SECONDS" -o data/${CURRENT_TIME}_SSD_"$NUMBER"_"$RUN_SECONDS"_ -p "$BOARD_ID1" "$BOARD_ID2"
# ./slitreader -t "$RUN_SECONDS" data/SSD_"$NUMBER"_"$RUN_SECONDS" -p "$BOARD_ID1" "$BOARD_ID2"

# ./fpgacontroller -w --board "$BOARD_ID1" 0x09 0x01
# BOARD_ID=$1

# ./fpgacontroller -w --board "$BOARD_ID" 0x09 0x01
# ./fpgacontroller -w --board "$BOARD_ID" 0x0a 0x00
# ./fpgacontroller -w --board "$BOARD_ID" 0x0b 0x03
# ./fpgacontroller -w --board "$BOARD_ID" 0x0c 0xe8
