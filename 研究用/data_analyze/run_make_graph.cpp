#include <iostream>
#include <fstream>
#include <nlohmann/json.hpp>
#include <TH1F.h>
#include <TCanvas.h>
#include <TStyle.h>
#include <map>
#include <algorithm>

using json = nlohmann::json;

void run_make_graph(const std::string& inputFileName, const std::string& outputFileName, const std::string& histogramFileName) {
    // JSONファイルの読み込みと処理
    std::ifstream file(inputFileName);
    if (!file.is_open()) {
        std::cerr << "Error opening file: " << inputFileName << std::endl;
        return;
    }

    json event_data;
    file >> event_data;
    file.close();

    // EmptyBitsの抽出
    std::vector<int> emptyBitsValues;
    for (const auto& event : event_data["events"]) {
        if (event.contains("EmptyBits") && event["EmptyBits"] != nullptr) {
            emptyBitsValues.push_back(event["EmptyBits"]);
        }
    }

    if (emptyBitsValues.empty()) {
        std::cerr << "No EmptyBits data found in file." << std::endl;
        return;
    }

    // スケーリング定数
    const double scaleFactor = 512 * 6.67 / 1000000.0;

    // EmptyBitsをスケーリング
    std::vector<double> scaledEmptyBitsValues;
    for (int bits : emptyBitsValues) {
        scaledEmptyBitsValues.push_back(bits * scaleFactor);
    }

    // 最頻値の計算
    std::map<double, int> frequencyMap;
    for (double value : scaledEmptyBitsValues) {
        frequencyMap[value]++;
    }

    auto modeIt = std::max_element(
		    frequencyMap.begin(), frequencyMap.end(),
		    [](const std::pair<const double, int>& a, const std::pair<const double, int>& b) {return a.second < b.second;}
    );

    double modeValue = modeIt->first; // 最頻値

    // 範囲を最頻値 ± 1 に設定
    double minValue = modeValue - 0.2;
    double maxValue = modeValue + 0.2;

    // ビン数を設定
    int numBins = 40;

    // ヒストグラム作成
    TH1F* hist = new TH1F("emptyBitsHist", "Empty Bits Distribution;Scaled Empty Bits;Frequency", numBins, minValue, maxValue);

    // スケーリングされた値をヒストグラムに追加
    for (double scaledValue : scaledEmptyBitsValues) {
        hist->Fill(scaledValue);
    }

    // ROOTでヒストグラム描画
    TCanvas* c = new TCanvas("c", "Histogram", 800, 600);
    hist->GetXaxis()->SetRangeUser(minValue, maxValue); // 最頻値 ± 5 に設定
    hist->Draw();
    gStyle->SetOptStat(1111);

    // ヒストグラムを画像として保存
    c->SaveAs(histogramFileName.c_str());

    // 出力ファイルにEmptyBitsの値を書き込む
    std::ofstream outputFile(outputFileName);
    for (double scaledValue : scaledEmptyBitsValues) {
        outputFile << scaledValue << std::endl;
    }
    outputFile.close();

    std::cout << "ヒストグラム解析と保存が完了しました。" << std::endl;
    std::cout << "出力ファイル: " << outputFileName << std::endl;
    std::cout << "ヒストグラムが保存されました: " << histogramFileName << std::endl;
}

int main() {
    run_make_graph("20241112_145305_SSD_100000_5_3_event_data.json", "test.txt", "test.png");
    return 0;
}



