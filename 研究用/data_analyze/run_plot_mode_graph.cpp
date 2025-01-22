#include <TCanvas.h>
#include <TGraph.h>
#include <TLine.h>
#include <TAxis.h>  // TAxisのインクルードを追加
#include <iostream>
#include <fstream>
#include <vector>
#include <cstdlib>  // std::randを使用するためにインクルード

void plot_mode_graph(const std::vector<std::string>& filenames) {
    TCanvas *canvas = new TCanvas("canvas", "Data Plot", 800, 600);

    // 色を設定（色の数を増やしたバージョン）
    int colors[] = {kRed, kBlue, kGreen, kMagenta, kCyan, kOrange, kViolet, kBlack, kGray, kAzure};

    // ファイルごとにグラフを描画
    for (size_t i = 0; i < filenames.size(); ++i) {
        std::ifstream file(filenames[i]);
        std::vector<double> x, y;
        double x_val, y_val;

        // ファイルを読み込み、データをベクトルに格納
        while (file >> x_val >> y_val) {
            x.push_back(x_val);
            y.push_back(y_val);
        }

        // グラフの作成
        TGraph *graph = new TGraph(x.size(), &x[0], &y[0]);
        graph->SetTitle(filenames[i].c_str());
        graph->SetMarkerStyle(20);  // 点のスタイル

        // 色を設定（ランダムまたは増やした色配列から選択）
        graph->SetMarkerColor(colors[i % 10]);  // 0～9の範囲で色を繰り返し設定
        graph->SetLineColor(colors[i % 10]);  // 0～9の範囲で線の色を繰り返し設定

        graph->GetYaxis()->SetRangeUser(0, 120);  // 縦軸範囲を 0～1600 に設定
        graph->GetXaxis()->SetRangeUser(0, 2150000);  // 縦軸範囲を 0～1600 に設定
        // 最初のグラフにマーカーを大きく、後のグラフは通常サイズに設定
        if (i == 0) {
            graph->SetMarkerSize(1.5);  // 最初のグラフのマーカーサイズを大きく設定
            graph->Draw("AP");  // 'ALP' は線と点の両方を描画（最初のグラフ）
        } else {
            graph->SetMarkerSize(1.0);  // 後のグラフのマーカーサイズを通常サイズに設定
            graph->Draw("P");  // 'LP' は点だけの描画（後のグラフ）
        }
    }
    // 横軸10Gラインを描画
    TLine *line_10G = new TLine(0, 0, 2150000, 42);  // 横軸の1500ライン
        line_10G->SetLineColor(kGreen);
        line_10G->SetLineStyle(1);
        line_10G->Draw();

    // 横軸1Gラインを描画
    TLine *line_1G = new TLine(0, 0, 2150000, 84);  // 横軸の1500ライン
        line_1G->SetLineColor(kBlack);
        line_1G->SetLineStyle(1);
        line_1G->Draw();
    // キャンバスの更新
    canvas->Update();

    // 目安となる1500ラインを引いたあとに保存
    canvas->SaveAs("output_graph.png");
}

int main(int argc, char **argv) {
    if (argc < 2) {
        std::cerr << "Please provide at least one file as argument." << std::endl;
        return 1;
    }

    std::vector<std::string> filenames;
    for (int i = 1; i < argc; ++i) {
        filenames.push_back(argv[i]);
    }

    plot_mode_graph(filenames);

    return 0;
}

