#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <nlohmann/json.hpp>
#include <TCanvas.h>
#include <TGraph.h>
#include <TFile.h>

using json = nlohmann::json;

// 拡張子を削除する関数
std::string remove_extension(const std::string& filename) {
    size_t lastdot = filename.find_last_of(".");
    if (lastdot == std::string::npos) return filename;  // 拡張子がない場合
    return filename.substr(0, lastdot);
}

TGraph* run_make_graph_event4(const std::string &input_file, const std::string &output_file) {
    // JSONファイルの読み込み
    std::ifstream in(input_file);
    if (!in.is_open()) {
        std::cerr << "Error: Unable to open JSON file: " << input_file << std::endl;
        return nullptr;
    }

    json data;
    try {
        in >> data;
    } catch (const std::exception &e) {
        std::cerr << "Error: Failed to parse JSON file: " << e.what() << std::endl;
        return nullptr;
    }

    if (!data.contains("events") || !data["events"].is_array()) {
        std::cerr << "Error: Invalid JSON structure. 'events' array not found." << std::endl;
        return nullptr;
    }

    const auto &events = data["events"];
    std::vector<double> x; // イベント番号
    std::vector<double> y; // 欠損フラグ

    int previousEventNumber = 1; // 1から始める

    // イベントごとに欠損をチェック
    for (const auto &event : events) {
        if (!event.contains("eventNumber") || !event.contains("EmptyBits")) continue;

        int eventNumber = event["eventNumber"];
        if (previousEventNumber != eventNumber) {
            // イベントが連続していない場合、欠損を記録
            x.push_back(previousEventNumber);
            y.push_back(1); // 欠損を1でマーク
        }
        previousEventNumber = eventNumber + 1; // 1を足して次のイベント番号に
    }

    // デバッグ: データ内容の出力
    std::cout << "Processed " << x.size() << " missing events." << std::endl;
    for (size_t i = 0; i < x.size(); ++i) {
        std::cout << "Event " << x[i] << ": Missing=" << y[i] << std::endl;
    }

    // 欠損イベントがない場合
    if (x.empty()) {
        std::cerr << "No missing events detected. Exiting." << std::endl;
        return nullptr;
    }

    // TGraphの作成
    TGraph *graph = new TGraph(x.size(), x.data(), y.data());
    graph->SetTitle("Detected Missing Events;Event Number;Detected Missing Events");
    graph->SetMarkerStyle(20);
    graph->SetMarkerSize(0.8);
    graph->SetMarkerColor(kRed);

    // ROOTファイルへの保存
    TFile *file = new TFile((remove_extension(output_file) + ".root").c_str(), "RECREATE");
    if (file->IsOpen()) {
        graph->Write("Detected_Missing_Events");
        file->Close();
        std::cout << "Graph successfully saved to ROOT file." << std::endl;
    } else {
        std::cerr << "Error: Failed to open ROOT file." << std::endl;
    }

    return graph;
}

int main(int argc, char** argv) {
    if (argc < 3) {
        std::cerr << "Usage: " << argv[0] << " <input_json> <output_root_file>" << std::endl;
        return 1;
    }

    TGraph *graph = run_make_graph_event4(argv[1], argv[2]);
    if (graph) {
        // グラフの描画
        TCanvas canvas("canvas", "Detected Missing Events", 800, 600);
        graph->Draw("AP");
        canvas.Print("output_graph.png");
        std::cout << "Graph successfully created and saved as output_graph.png" << std::endl;
    } else {
        std::cerr << "Failed to create the graph." << std::endl;
    }

    return 0;
}

