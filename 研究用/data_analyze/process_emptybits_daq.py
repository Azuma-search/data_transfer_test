import json

# イベントデータを処理する関数
def process_raw_data(raw_data):
    event_data = {}

    for line in raw_data:
        line = line.strip()

        # データを空白で分割
        parts = line.split()
        if len(parts) == 2:
            try:
                event_number = int(parts[0])
                empty_bits = int(parts[1])

                # イベント番号ごとに EmptyBits を格納
                if event_number not in event_data:
                    event_data[event_number] = []
                event_data[event_number].append(empty_bits)
            except ValueError:
                print(f"警告: 無効なデータ形式が検出されました: {line}")

    # イベントデータをリストに変換
    formatted_event_data = [{'eventNumber': key, 'EmptyBits': value} for key, value in event_data.items()]

    return formatted_event_data


# 重複したイベントを排除（EmptyBitsが異なる場合でもすべて保持）
def remove_duplicate_events(event_data):
    event_data_dict = {}

    for event in event_data:
        event_number = event['eventNumber']
        if event_number not in event_data_dict:
            event_data_dict[event_number] = event['EmptyBits']
        else:
            event_data_dict[event_number].extend(event['EmptyBits'])

    # 重複排除後のデータ (EmptyBitsはそのまま保持)
    unique_event_data = [{'eventNumber': key, 'EmptyBits': value} for key, value in event_data_dict.items()]

    return unique_event_data


# 抜けたイベント番号を特定
def find_missing_events(event_data):
    event_numbers = sorted(set(event['eventNumber'] for event in event_data))
    if event_numbers:
        all_event_numbers = list(range(event_numbers[0], event_numbers[-1] + 1))
        missing_events = list(set(all_event_numbers) - set(event_numbers))
        return missing_events
    return []  # データがない場合は空リストを返す


def main(input_file, output_json):
    try:
        # ファイルを読み込む
        with open(input_file, 'r') as file:
            raw_data = file.readlines()

        # データの処理
        event_data = process_raw_data(raw_data)

        # 重複したイベントを排除
        event_data = remove_duplicate_events(event_data)

        # 抜けたイベント番号を特定
        missing_events = find_missing_events(event_data)

        # JSON形式で保存
        output_data = {
            "events": event_data,
            "missing_events": missing_events,
            "missing_event_count": len(missing_events)
        }

        with open(output_json, 'w') as json_file:
            json.dump(output_data, json_file, indent=4)

        # 加工後のデータを表示
        for event in event_data:
            print(event)
        print(f"Missing events: {missing_events}")

    except Exception as e:
        print(f"エラーが発生しました: {e}")


if __name__ == "__main__":
    import sys
    if len(sys.argv) != 3:
        print("Usage: python process_emptybits.py <input_file> <output_json_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_json = sys.argv[2]
    main(input_file, output_json)

