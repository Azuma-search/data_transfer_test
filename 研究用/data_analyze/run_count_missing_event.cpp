#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <TGraph.h>
#include <TCanvas.h>
#include <TFile.h>
#include <TLegend.h>

struct EventData {
    std::string boardID;
    long dataSize;
    int missingEvents;
};

std::vector<EventData> readEventData(const std::string& filename) {
    std::vector<EventData> eventDataList;
    std::ifstream file(filename);

    if (!file.is_open()) {
        std::cerr << "Error: Could not open file " << filename << std::endl;
        return eventDataList;
    }

    std::string line;
    while (std::getline(file, line)) {
        std::stringstream ss(line);
        EventData eventData;
        ss >> eventData.boardID >> eventData.dataSize >> eventData.missingEvents;
        eventDataList.push_back(eventData);
    }

    file.close();
    return eventDataList;
}

void plotMissingEvents(const std::vector<EventData>& eventDataList) {
    // 基板IDごとにデータを分ける
    std::map<std::string, std::vector<std::pair<long, int>>> boardData;

    for (const auto& data : eventDataList) {
        boardData[data.boardID].emplace_back(data.dataSize, data.missingEvents);
    }

    // キャンバスを作成
    TCanvas* canvas = new TCanvas("canvas", "Missing Events per Board", 800, 600);

    // 複数のグラフを描画するためにLegendを作成
    TLegend* legend = new TLegend(0.7, 0.7, 0.9, 0.9);

    // 各基板IDごとにグラフを作成
    int color = 1;  // 色のインデックス
    for (const auto& board : boardData) {
        std::vector<double> dataSizes;
        std::vector<double> missingEvents;

        for (const auto& entry : board.second) {
            dataSizes.push_back(entry.first);  // dataSize (横軸)
            missingEvents.push_back(entry.second);  // missingEvents (縦軸)
        }

        // TGraphを作成して描画
        TGraph* graph = new TGraph(dataSizes.size(), &dataSizes[0], &missingEvents[0]);
        graph->SetTitle(("Board " + board.first).c_str());
        graph->SetMarkerStyle(20);  // マーカーのスタイル
        graph->SetMarkerColor(color);  // 色を設定
        graph->SetLineColor(color);  // 線の色を設定
        graph->Draw(color == 1 ? "AP" : "P");  // 最初のグラフだけ軸を描画

        // 基板IDごとの色分け
        legend->AddEntry(graph, board.first.c_str(), "p");

        // 次の基板用に色を変更
        color++;
    }

    legend->Draw();
    canvas->Update();

    // 結果をファイルに保存
    canvas->SaveAs("missing_events_per_board.png");

    // クリーンアップ
    delete legend;
    delete canvas;
}

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <input_file>" << std::endl;
        return 1;
    }

    const std::string inputFile = argv[1];

    // 入力ファイルからデータを読み込む
    std::vector<EventData> eventDataList = readEventData(inputFile);
    if (eventDataList.empty()) {
        std::cerr << "No data to process." << std::endl;
        return 1;
    }

    // 抜け数のプロット
    plotMissingEvents(eventDataList);

    return 0;
}

