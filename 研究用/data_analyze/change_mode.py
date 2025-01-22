import json
from collections import Counter
import sys
import re

def convert_empty_bits_to_ms(empty_bits):
    return [(bit * 512 * 6.67 * 1 / 1000) for bit in empty_bits]  

def get_most_frequent(empty_bits):
    count = Counter(empty_bits)
    return count.most_common(1)[0][0]  

def process_file(input_file, output_file):
    with open(input_file, 'r') as f:
        data = json.load(f)

    all_empty_bits = []  
    
    for event in data["events"]:
        all_empty_bits.extend(event["EmptyBits"])

    most_frequent = get_most_frequent(all_empty_bits)

    most_frequent_ms = convert_empty_bits_to_ms([most_frequent])[0]

    match = re.search(r'(\d+)\.json$', input_file)
    if match:
        data_size = match.group(1)  # 例: '100000'
    else:
        raise ValueError("ファイル名にデータ量の数値が見つかりません")

    with open(output_file, 'a') as f:
        f.write(f"{data_size} {most_frequent_ms:.2f}\n")  
    print(f"Data has been processed and appended to {output_file}")

if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    process_file(input_file, output_file)

