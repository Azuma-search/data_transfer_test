import json
import re

def process_raw_data(raw_data):
    event_data = []
    event_info = {}

    for line in raw_data:
        line = line.strip()

        if "+++++++++++++START fillEventBuf() ++++++++++++++++++++++++++++" in line:
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

    if event_info and event_info.get('IsLastData') == 1:
        event_data.append(event_info)

    return event_data

def remove_duplicate_events(event_data):
    seen_event_numbers = set()
    unique_event_data = []

    for event in event_data:
        if event['eventNumber'] not in seen_event_numbers:
            unique_event_data.append(event)
            seen_event_numbers.add(event['eventNumber'])

    return unique_event_data

def find_missing_events(event_data):
    event_numbers = sorted(event['eventNumber'] for event in event_data)
    all_event_numbers = list(range(event_numbers[0], event_numbers[-1] + 1))
    missing_events = list(set(all_event_numbers) - set(event_numbers))
    return missing_events

def main(input_file, output_json):
    try:
        with open(input_file, 'r') as file:
            raw_data = file.readlines()

        event_data = process_raw_data(raw_data)

        event_data = remove_duplicate_events(event_data)

        missing_events = find_missing_events(event_data)

        output_data = {
            "events": event_data,
            "missing_events": missing_events,
            "missing_event_count": len(missing_events)
        }

        with open(output_json, 'w') as json_file:
            json.dump(output_data, json_file, indent=4)

        for event in event_data:
            print(event)
        print(f"Missing events: {missing_events}")

    except Exception as e:
        print(f"エラーが発生しました: {e}")

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 3:
        print("Usage: python process_emptybits1.py <input_file> <output_json_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_json = sys.argv[2]
    main(input_file, output_json)

