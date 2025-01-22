#!/bin/bash

echo "次のファイルの中から選択してください:"
select file in data/test/*.dat; do
    if [ -n "$file" ]; then
        NAME=$(basename "$file" .dat)

        echo "選択されたファイル: $file"

        echo "出力ファイル名を入力してください（例: output.txt）:"
        read outputFileName

        echo "ヒストグラムを保存するファイル名を入力してください（例: histogram.png）:"
        read histogramFileName

        if [ -f "$file" ]; then
            # EmptyBitsを収集
            ./slitdecoder -m 3 "$file" >> "data/test/${NAME}_EmptyBits.txt" 2>> error.log
            echo "Empty Bitsの収集が完了しました。中間ファイル: data/${NAME}_EmptyBits.txt"

            # Pythonスクリプトを使ってイベントごとのEmptyBitsを処理
            python3 process_emptybits.py "data/test/${NAME}_EmptyBits.txt" "${NAME}_event_data.json"

            # ROOTでヒストグラム作成
	    root -l -b -q "run_make_graph_log.cpp(\"${NAME}_event_data.json\", \"$outputFileName\", \"$histogramFileName\")"

            echo "ヒストグラム解析と保存が完了しました。出力ファイル: $outputFileName"
            echo "ヒストグラムが保存されました: $histogramFileName"
        else
            echo "エラー: ファイルが存在しません: $file"
        fi
        break
    else
        echo "無効な選択です。もう一度試してください。"
    fi
done

