#include <iostream>
#include <fstream>
#include <nlohmann/json.hpp>
#include <TH1F.h>
#include <TCanvas.h>
#include <TStyle.h>
#include <algorithm>
#include <vector>

using json = nlohmann::json;

void run_make_graph_log(const std::string& inputFileName, const std::string& outputFileName, const std::string& histogramFileName) {
    // JSONファイルの読み込み
    std::ifstream file(inputFileName);
    if (!file.is_open()) {
        std::cerr << "Error opening file: " << inputFileName << std::endl;
        return;
    }

    json event_data;
    file >> event_data;
    file.close();

    // EmptyBitsの抽出
    std::vector<double> emptyBitsValues;
    for (const auto& event : event_data["events"]) {
        if (event.contains("EmptyBits") && event["EmptyBits"] != nullptr) {
            emptyBitsValues.push_back(event["EmptyBits"].get<int>() * 512 * 6.67 / 1000000.0);
        }
    }

    if (emptyBitsValues.empty()) {
        std::cerr << "No EmptyBits data found in file." << std::endl;
        return;
    }

    // 最小値と最大値の取得
    double minValue = *std::min_element(emptyBitsValues.begin(), emptyBitsValues.end());
    double maxValue = *std::max_element(emptyBitsValues.begin(), emptyBitsValues.end());

    // ヒストグラムの設定（ビン幅調整）
    int numBins = 100;  // ビン数を任意に設定
    TH1F* hist = new TH1F("emptyBitsHist", "Empty Bits Distribution;Empty Bits (Scaled);Frequency", numBins, 0, maxValue+1);

    for (double bits : emptyBitsValues) {
        hist->Fill(bits);
    }

    // 描画設定
    TCanvas* c = new TCanvas("c", "Histogram", 800, 600);
    gStyle->SetOptStat(1111);

    // 対数スケールに設定
    c->SetLogy();  // Y軸を対数スケールに設定

    // 横軸の範囲を手動で設定
    hist->GetXaxis()->SetRangeUser(0, maxValue+10);
    hist->Draw();

    // ヒストグラムを画像として保存
    c->SaveAs(histogramFileName.c_str());

    // 出力ファイルにEmptyBitsの値を書き込む
    std::ofstream outputFile(outputFileName);
    for (double bits : emptyBitsValues) {
        outputFile << bits << std::endl;
    }
    outputFile.close();

    std::cout << "ヒストグラム解析と保存が完了しました。" << std::endl;
    std::cout << "出力ファイル: " << outputFileName << std::endl;
    std::cout << "ヒストグラムが保存されました: " << histogramFileName << std::endl;
}

