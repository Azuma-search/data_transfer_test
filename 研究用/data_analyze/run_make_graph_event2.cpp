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

// グラフを作成する関数
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

    // 欠損イベントを追跡
    std::vector<double> x; // イベント番号
    std::vector<double> y; // 欠損フラグ

    // `missing_events`が存在する場合、そのまま利用
    if (data.contains("missing_events") && data["missing_events"].is_array()) {
        for (const auto &missing : data["missing_events"]) {
            x.push_back(missing);
            y.push_back(1); // 欠損を1でマーク
        }
    } else {
        // `events`を直接解析して欠損を算出
        const auto &events = data["events"];
        if (!events.is_array()) {
            std::cerr << "Error: Invalid JSON structure. 'events' array not found." << std::endl;
            return nullptr;
        }

        int previousEventNumber = 1; // 最初のイベント番号（仮定）
        for (const auto &event : events) {
            if (!event.contains("eventNumber")) continue;

            int eventNumber = event["eventNumber"];
            while (previousEventNumber < eventNumber) {
                // 欠損を記録
                x.push_back(previousEventNumber);
                y.push_back(1);
                previousEventNumber++;
            }
            previousEventNumber = eventNumber + 1; // 次のイベント番号に
        }

        // 最後のイベント番号以降の欠損を確認
        int maxEventNumber = previousEventNumber; // 最大イベント番号を仮定
        for (int i = previousEventNumber; i <= maxEventNumber; ++i) {
            x.push_back(i);
            y.push_back(1);
        }
    }

    // デバッグ: データ内容の出力
    std::cout << "Processed " << x.size() << " missing events." << std::endl;
    for (size_t i = 0; i < x.size(); ++i) {
        std::cout << "Event " << x[i] << ": Missing=" << y[i] << std::endl;
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
        std::cout << "Graph successfully saved to ROOT file: " << output_file << std::endl;
    } else {
        std::cerr << "Error: Failed to open ROOT file for saving the graph." << std::endl;
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
        std::cerr << "Failed to create the graph. No data to plot." << std::endl;
    }

    return 0;
}

