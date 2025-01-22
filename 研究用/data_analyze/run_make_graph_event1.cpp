#include <iostream>
#include <fstream>
#include <string>
#include <nlohmann/json.hpp> // JSONライブラリ
#include <TCanvas.h>
#include <TH1F.h>

using json = nlohmann::json;

void run_make_graph_event1(const std::string &input_file, const std::string &output_file, const std::string &histogram_file) {
    // JSONファイルの読み込み
    std::ifstream in(input_file);
    if (!in) {
        std::cerr << "Error: Unable to open JSON file: " << input_file << std::endl;
        return;
    }

    json data;
    try {
        in >> data;
    } catch (const std::exception &e) {
        std::cerr << "Error: Failed to parse JSON file: " << e.what() << std::endl;
        return;
    }

    // イベントデータの確認
    if (!data.contains("events") || !data["events"].is_array()) {
        std::cerr << "Error: Invalid JSON structure. 'events' array not found." << std::endl;
        return;
    }

    const auto &events = data["events"];
    std::cout << "Successfully read JSON file: " << input_file << std::endl;
    std::cout << "Number of events: " << events.size() << std::endl;

    // ヒストグラムの作成
    TH1F *hist = new TH1F("EmptyBitsHist", "Empty Bits Distribution;Event Number;Empty Bits", events.size(), 0, events.size());
    
    for (const auto &event : events) {
        if (!event.contains("eventNumber") || !event.contains("EmptyBits")) {
            std::cerr << "Warning: Missing 'eventNumber' or 'EmptyBits' in event. Skipping." << std::endl;
            continue;
        }

        int eventNumber = event["eventNumber"];
        int emptyBits = event["EmptyBits"];
        std::cout << "Event: " << eventNumber << ", EmptyBits: " << emptyBits << std::endl;

        // ヒストグラムにデータをセット
        hist->SetBinContent(eventNumber, emptyBits);
    }

    // ヒストグラムの描画
    TCanvas *c = new TCanvas("c", "EmptyBits Histogram", 800, 600);
    hist->Draw();

    // ヒストグラムを保存
    std::cout << "Saving histogram to: " << histogram_file << std::endl;
    c->SaveAs(histogram_file.c_str());

    // 出力ファイルに情報を保存
    std::ofstream out(output_file);
    if (!out) {
        std::cerr << "Error: Unable to open output file: " << output_file << std::endl;
        return;
    }

    out << "Event Number, Empty Bits" << std::endl;
    for (const auto &event : events) {
        if (!event.contains("eventNumber") || !event.contains("EmptyBits")) {
            continue;
        }
        out << event["eventNumber"] << ", " << event["EmptyBits"] << std::endl;
    }
    std::cout << "Output saved to: " << output_file << std::endl;

    // メモリの解放
    delete hist;
    delete c;
}

