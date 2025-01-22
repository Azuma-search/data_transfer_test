#!/bin/bash

# タイムスタンプを生成
timestamp=$(date +"%Y%m%d_%H%M%S")

# グラフ作成バージョンの選択
echo "グラフ作成バージョンを選択してください:"
select graph_version in "Static" "Log" "Event"; do
    case $graph_version in
        "Static")
            graph_cpp="run_make_graph.cpp"
            output_binary1="run_make_graph"
            break
            ;;
        "Log")
            graph_cpp="run_make_graph_log.cpp"
            output_binary1="run_make_graph_log"
            break
            ;;
        "Event")
            graph_cpp="run_make_graph_event2.cpp"
            output_binary1="run_make_graph_event"
            output_binary2="run_display_graph"  # 2つのグラフを表示するため
            break
            ;;
        *)
            echo "無効な選択です。もう一度選んでください。"
            exit 1
            ;;
    esac
done

# 選択されたファイルをコンパイル
echo "コンパイル中: $graph_cpp"
g++ -o $output_binary1 $graph_cpp -I/home/azuma/SLiTDAQ/lib_daq/json `root-config --cflags --libs`

# コンパイルが成功したか確認
if [ $? -ne 0 ]; then
    echo "コンパイルに失敗しました: $graph_cpp"
    exit 1
fi
echo "コンパイル完了: 実行ファイル $output_binary1"

# 'Event'バージョンの処理の場合、別のバイナリをコンパイル
if [ "$graph_version" == "Event" ]; then
    echo "コンパイル中: $output_binary2"
    g++ -o $output_binary2 $output_binary2.cpp `root-config --cflags --libs`

    # コンパイルが成功したか確認
    if [ $? -ne 0 ]; then
        echo "コンパイルに失敗しました: $output_binary2"
        exit 1
    fi
    echo "コンパイル完了: 実行ファイル $output_binary2"
fi

# ファイルを1つ選択
echo "次のファイルの中から1つ選んでください:"
select file1 in data/test_SSD_10G_slit/*.dat; do
    if [ -n "$file1" ]; then
        NAME1=$(basename "$file1" .dat)
        echo "選択されたファイル: $file1"
        break
    else
        echo "無効な選択です。もう一度選んでください。"
    fi
done

# 2つ目のファイルを選択するかどうか
echo "2つ目のファイルを選択しますか? (y/n)"
read -r answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "2つ目のファイルを選択してください:"
    select file2 in data/test_SSD_10G_slit/*.dat; do
        if [ -n "$file2" ]; then
            NAME2=$(basename "$file2" .dat)
            echo "選択された2つ目のファイル: $file2"
            break
        else
            echo "無効な選択です。もう一度選んでください。"
        fi
    done
else
    file2=""
    NAME2=""
    echo "2つ目のファイルは選択されませんでした。"
fi

# EmptyBitsを収集
echo "EmptyBitsを収集します..."
./slitdecoder -m 3 "$file1" > "data/test_SSD_10G_slit/${NAME1}_${timestamp}_EmptyBits.txt" 2>> error.log
if [ $? -ne 0 ]; then
    echo "EmptyBits収集に失敗しました: ${NAME1}_EmptyBits.txt"
    exit 1
fi
echo "EmptyBits収集完了: data/test_SSD_10G_slit/${NAME1}_${timestamp}_EmptyBits.txt"

if [ -n "$file2" ]; then
    ./slitdecoder -m 3 "$file2" > "data/test_SSD_10G_slit/${NAME2}_${timestamp}_EmptyBits.txt" 2>> error.log
    if [ $? -ne 0 ]; then
        echo "EmptyBits収集に失敗しました: ${NAME2}_EmptyBits.txt"
        exit 1
    fi
    echo "EmptyBits収集完了: data/test_SSD_10G_slit/${NAME2}_${timestamp}_EmptyBits.txt"
fi

# Pythonスクリプトを使ってEmptyBits処理
python3 process_emptybits1.py "data/test_SSD_10G_slit/${NAME1}_${timestamp}_EmptyBits.txt" "${NAME1}_${timestamp}_event_data.json"
if [ $? -ne 0 ]; then
    echo "EmptyBits処理に失敗しました: ${NAME1}_event_data.json"
    exit 1
fi

if [ -n "$file2" ]; then
    python3 process_emptybits1.py "data/test_SSD_10G_slit/${NAME2}_${timestamp}_EmptyBits.txt" "${NAME2}_${timestamp}_event_data.json"
    if [ $? -ne 0 ]; then
        echo "EmptyBits処理に失敗しました: ${NAME2}_event_data.json"
        exit 1
    fi
fi

# グラフ作成
# JSONファイルの存在確認
if [ ! -f "${NAME1}_${timestamp}_event_data.json" ]; then
    echo "Error: JSONファイル '${NAME1}_${timestamp}_event_data.json' が存在しません。"
    exit 1
fi

# グラフ作成バイナリを実行
./${output_binary1} "${NAME1}_${timestamp}_event_data.json" "${NAME1}_${timestamp}_output.root"
if [ $? -ne 0 ]; then
    echo "Error: グラフ作成に失敗しました。JSONファイルまたはバイナリを確認してください。"
    exit 1
fi

# ROOTファイルの確認
if [ ! -f "${NAME1}_${timestamp}_output.root" ]; then
    echo "Error: ROOTファイル '${NAME1}_${timestamp}_output.root' が作成されませんでした。"
    exit 1
fi

echo "グラフ作成成功: 出力先 -> ${NAME1}_${timestamp}_output.root"

if [ -n "$file2" ]; then
    # JSONファイルの存在確認
    if [ ! -f "${NAME2}_${timestamp}_event_data.json" ]; then
        echo "Error: JSONファイル '${NAME2}_${timestamp}_event_data.json' が存在しません。"
        exit 1
    fi

    # グラフ作成バイナリを実行
    ./${output_binary1} "${NAME2}_${timestamp}_event_data.json" "${NAME2}_${timestamp}_output.root"
    if [ $? -ne 0 ]; then
        echo "Error: グラフ作成に失敗しました。JSONファイルまたはバイナリを確認してください。"
        exit 1
    fi

    # ROOTファイルの確認
    if [ ! -f "${NAME2}_${timestamp}_output.root" ]; then
        echo "Error: ROOTファイル '${NAME2}_${timestamp}_output.root' が作成されませんでした。"
        exit 1
    fi

    echo "グラフ作成成功: 出力先 -> ${NAME2}_${timestamp}_output.root"
fi

# グラフ表示
if [ -f "${NAME1}_${timestamp}_output.root" ] && [ -f "${NAME2}_${timestamp}_output.root" ]; then
    ./${output_binary2} "${NAME1}_${timestamp}_output.root" "${NAME2}_${timestamp}_output.root"  # 両方のグラフを表示
elif [ -f "${NAME1}_${timestamp}_output.root" ]; then
    ./${output_binary2} "${NAME1}_${timestamp}_output.root"  # 1つ目のグラフのみ表示
elif [ -f "${NAME2}_${timestamp}_output.root" ]; then
    ./${output_binary2} "${NAME2}_${timestamp}_output.root"  # 2つ目のグラフのみ表示
fi

# 出力結果を表示
echo "グラフ作成および表示完了。出力結果:"
echo "1つ目の出力: ${NAME1}_${timestamp}_output.root"
if [ -n "$file2" ]; then
    echo "2つ目の出力: ${NAME2}_${timestamp}_output.root"
fi

