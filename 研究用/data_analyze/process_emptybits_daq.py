import json

def process_raw_data(raw_data):
    event_data = {}

    for line in raw_data:
        line = line.strip()

        parts = line.split()
        if len(parts) == 2:
            try:
                event_number = int(parts[0])
                empty_bits = int(parts[1])

                if event_number not in event_data:
                    event_data[event_number] = []
                event_data[event_number].append(empty_bits)
            except ValueError:
                print(f"警告: 無効なデータ形式が検出されました: {line}")

    formatted_event_data = [{'eventNumber': key, 'EmptyBits': value} for key, value in event_data.items()]

    return formatted_event_data


def remove_duplicate_events(event_data):
    event_data_dict = {}

    for event in event_data:
        event_number = event['eventNumber']
        if event_number not in event_data_dict:
            event_data_dict[event_number] = event['EmptyBits']
        else:
            event_data_dict[event_number].extend(event['EmptyBits'])

    unique_event_data = [{'eventNumber': key, 'EmptyBits': value} for key, value in event_data_dict.items()]

    return unique_event_data


def find_missing_events(event_data):
    event_numbers = sorted(set(event['eventNumber'] for event in event_data))
    if event_numbers:
        all_event_numbers = list(range(event_numbers[0], event_numbers[-1] + 1))
        missing_events = list(set(all_event_numbers) - set(event_numbers))
        return missing_events
    return [] 


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
        print("Usage: python process_emptybits.py <input_file> <output_json_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_json = sys.argv[2]
    main(input_file, output_json)

