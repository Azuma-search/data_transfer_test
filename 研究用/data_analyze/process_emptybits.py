import json
import re

def process_raw_data(raw_data):
    event_data = []
    event_info = {}

    for line in raw_data:
        line = line.strip()

        if "+++++++++++++START fillEventBuf() ++++++++++++++++++++++++++++" in line:
            # IsLastDataが1のイベントのみ追加
            if event_info and event_info.get('IsLastData') == 1:
                event_data.append(event_info)
            event_info = {'eventNumber': None, 'EmptyBits': None, 'IsLastData': None}

        if "Empty bits(footer)" in line:
            match = re.search(r'Empty bits\(footer\)\s*=\s*(\d+)', line)
            if match:
                event_info['EmptyBits'] = int(match.group(1))

        if "isLastData" in line:
            match = re.search(r'isLastData\s*=\s*(\d+)', line)
            if match:
                event_info['IsLastData'] = int(match.group(1))

        if "eventNumber" in line:
            match = re.search(r'eventNumber\s*=\s*(\d+)', line)
            if match:
                event_info['eventNumber'] = int(match.group(1))

    # 最後のイベントを追加（IsLastDataが1の場合のみ）
    if event_info and event_info.get('IsLastData') == 1:
        event_data.append(event_info)

    return event_data

def remove_duplicate_events(event_data):
    event_dict = {}

    # イベント番号で重複を排除し、IsLastDataが1のものを保持
    for event in event_data:
        event_num = event['eventNumber']
        if event_num not in event_dict or event['IsLastData'] == 1:
            event_dict[event_num] = event

    return list(event_dict.values())

def main(input_file, output_json):
    with open(input_file, 'r') as file:
        raw_data = file.readlines()

    event_data = process_raw_data(raw_data)

    # 重複したイベントを排除
    event_data = remove_duplicate_events(event_data)

    # JSON形式で保存
    with open(output_json, 'w') as json_file:
        json.dump({"events": event_data}, json_file, indent=4)

    # 加工後のデータを表示
    for event in event_data:
        print(event)

if __name__ == "__main__":
    import sys
    input_file = sys.argv[1]
    output_json = sys.argv[2]
    main(input_file, output_json)

