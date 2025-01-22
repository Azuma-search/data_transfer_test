#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <nlohmann/json.hpp> // JSONライブラリ
#include <TCanvas.h>
#include <TGraph.h>

using json = nlohmann::json;

void run_make_graph_event4(const std::string &input_file, const std::string &output_file, const std::string &histogram_file) {
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

    // データ格納用ベクトル
    std::vector<double> x; // イベント番号
    std::vector<double> y; // 抜けたイベントの数

    int missingCount = 0;
    int previousEventNumber = -1; // 最初の前のイベント番号は無効に設定

    for (const auto &event : events) {
        if (!event.contains("eventNumber") || !event.contains("EmptyBits")) {
            std::cerr << "Warning: Missing 'eventNumber' or 'EmptyBits' in event. Skipping." << std::endl;
            continue;
        }

        int eventNumber = event["eventNumber"];

        // イベント番号が前の番号と飛んでいるか確認
        if (previousEventNumber != -1 && eventNumber != previousEventNumber + 1) {
            // 番号が飛んでいる場合、抜けたイベントとしてカウント
            missingCount++;
        }

        // データをベクトルに追加
        x.push_back(eventNumber);
        y.push_back(missingCount);

        // 現在のイベント番号を前の番号として保存
        previousEventNumber = eventNumber;
    }

    // 点グラフ（TGraph）の作成
    TGraph *graph = new TGraph(x.size(), x.data(), y.data());
    graph->SetTitle("Missing Events;Event Number;Missing Event Count");
    graph->SetMarkerStyle(20); // 点スタイル
    graph->SetMarkerSize(0.8);
    graph->SetMarkerColor(kBlue);

    // グラフを描画
    TCanvas *c = new TCanvas("c", "Missing Events Graph", 800, 600);
    graph->Draw("AP"); // "AP" は軸 (Axis) と点 (Point) を描画

    // グラフを保存
    std::cout << "Saving graph to: " << histogram_file << std::endl;
    c->SaveAs(histogram_file.c_str());

    // 出力ファイルに情報を保存
    std::ofstream out(output_file);
    if (!out) {
        std::cerr << "Error: Unable to open output file: " << output_file << std::endl;
        return;
    }

    out << "Event Number, Missing Count" << std::endl;
    for (size_t i = 0; i < x.size(); ++i) {
        out << x[i] << ", " << y[i] << std::endl;
    }
    std::cout << "Output saved to: " << output_file << std::endl;

    // メモリの解放
    delete graph;
    delete c;
}

int main(int argc, char** argv) {
    if (argc < 4) {
        std::cerr << "Usage: " << argv[0] << " <input_file> <output_file> <histogram_file>" << std::endl;
        return 1;
    }

    // 引数からファイル名を取得
    const char* inputFile = argv[1];
    const char* outputFile = argv[2];
    const char* histogramFile = argv[3];

    // グラフ作成
    run_make_graph_event4(inputFile, outputFile, histogramFile);

    return 0;
}

