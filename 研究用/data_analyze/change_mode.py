import json
from collections import Counter
import sys
import re

def convert_empty_bits_to_ms(empty_bits):
    # EmptyBitsの値に 512 × 6.67 × 1 / 1000 を掛けてmsに変換
    return [(bit * 512 * 6.67 * 1 / 1000) for bit in empty_bits]  # ミリ秒に変換

def get_most_frequent(empty_bits):
    # EmptyBitsの最頻値を求める
    count = Counter(empty_bits)
    return count.most_common(1)[0][0]  # 最頻値の取得

def process_file(input_file, output_file):
    with open(input_file, 'r') as f:
        data = json.load(f)

    all_empty_bits = []  # すべてのEmptyBitsを集めるリスト
    
    # 各イベントのEmptyBitsを全て集める
    for event in data["events"]:
        all_empty_bits.extend(event["EmptyBits"])

    # 全てのEmptyBitsから最頻値を取得
    most_frequent = get_most_frequent(all_empty_bits)

    # 最頻値に基づいてmsに変換
    most_frequent_ms = convert_empty_bits_to_ms([most_frequent])[0]

    # ファイル名からデータ量（100000の部分）を抽出
    match = re.search(r'(\d+)\.json$', input_file)
    if match:
        data_size = match.group(1)  # 例: '100000'
    else:
        raise ValueError("ファイル名にデータ量の数値が見つかりません")

    # 出力ファイルに1行ずつ追加して書き込み（'a' モードでファイルを開く）
    with open(output_file, 'a') as f:
        f.write(f"{data_size} {most_frequent_ms:.2f}\n")  # データ量と最頻値を出力

    print(f"Data has been processed and appended to {output_file}")

if __name__ == "__main__":
    # コマンドライン引数からファイル名を取得
    input_file = sys.argv[1]  # 入力ファイル
    output_file = sys.argv[2]  # 出力ファイル

    process_file(input_file, output_file)

