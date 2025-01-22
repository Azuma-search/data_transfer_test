#!/bin/bash

# ファイル名の定義
CREATE_GRAPH_SRC="create_graph_from_file.cpp"
COMBINE_GRAPH_SRC="create_combined_graph.cpp"
CREATE_GRAPH_EXEC="create_graph_from_file"
COMBINE_GRAPH_EXEC="create_combined_graph"

# 入力ファイルと出力ファイル
INPUT_FILES=("SSD_1G_SliT.txt" "SSD_10G_SLiT.txt")
ROOT_FILES=()
OUTPUT_GRAPH="combined_graph.pdf"

# 必要なROOT環境の確認
if ! command -v root-config &> /dev/null; then
    echo "Error: ROOT environment is not set up. Please ensure root-config is in your PATH."
    exit 1
fi

# コンパイル
echo "Compiling ${CREATE_GRAPH_SRC}..."
g++ -o ${CREATE_GRAPH_EXEC} ${CREATE_GRAPH_SRC} `root-config --cflags --libs`
if [ $? -ne 0 ]; then
    echo "Error: Failed to compile ${CREATE_GRAPH_SRC}."
    exit 1
fi

echo "Compiling ${COMBINE_GRAPH_SRC}..."
g++ -o ${COMBINE_GRAPH_EXEC} ${COMBINE_GRAPH_SRC} `root-config --cflags --libs`
if [ $? -ne 0 ]; then
    echo "Error: Failed to compile ${COMBINE_GRAPH_SRC}."
    exit 1
fi

# テキストファイルからROOTファイルを生成
for INPUT_FILE in "${INPUT_FILES[@]}"; do
    ROOT_FILE="${INPUT_FILE%.txt}.root"
    ROOT_FILES+=("${ROOT_FILE}")
    echo "Generating ROOT file from ${INPUT_FILE}..."
    ./${CREATE_GRAPH_EXEC} ${INPUT_FILE} ${ROOT_FILE}
    if [ $? -ne 0 ]; then
        echo "Error: Failed to process ${INPUT_FILE}."
        exit 1
    fi
done

# ROOTファイルを統合してグラフを生成
echo "Creating combined graph..."
./${COMBINE_GRAPH_EXEC} ${ROOT_FILES[@]} ${OUTPUT_GRAPH}
if [ $? -ne 0 ]; then
    echo "Error: Failed to create combined graph."
    exit 1
fi

# 完了メッセージ
echo "All graphs have been processed and combined successfully. Output: ${OUTPUT_GRAPH}"

