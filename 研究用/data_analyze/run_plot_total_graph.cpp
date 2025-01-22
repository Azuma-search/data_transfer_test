#include <TCanvas.h>
#include <TGraph.h>
#include <TLine.h>
#include <TAxis.h>
#include <iostream>
#include <fstream>
#include <vector>

void plot_root_graph(const std::vector<std::string>& filenames) {
    TCanvas *canvas = new TCanvas("canvas", "Data Plot", 800, 600);

    // 色を設定
    int colors[] = {kRed, kBlue, kGreen, kMagenta, kCyan};

    for (size_t i = 0; i < filenames.size(); ++i) {
        std::ifstream file(filenames[i]);
        std::vector<double> x, y;
        double x_val, y_val;

        while (file >> x_val >> y_val) {
            x.push_back(x_val);
            y.push_back(y_val);
        }

        TGraph *graph = new TGraph(x.size(), &x[0], &y[0]);
        graph->SetTitle(filenames[i].c_str());
        graph->SetMarkerStyle(20);
        graph->SetMarkerColor(colors[i % 5]);
        graph->SetLineColor(colors[i % 5]);

        // 最初のグラフに軸を描画し、それ以降は追加で描画
        graph->Draw(i == 0 ? "ALP" : "LP");  // 'ALP' は線と点の両方を描画

        if (i == 0) {  // 最初のグラフに対して範囲設定
            graph->GetXaxis()->SetRangeUser(0, 2100000);
            graph->GetYaxis()->SetRangeUser(0, 1600);
        }
    }

    TLine *line_horizontal = new TLine(0, 1500, 2100000, 1500);
    line_horizontal->SetLineColor(kBlack);
    line_horizontal->SetLineStyle(2);
    line_horizontal->Draw();

    //TLine *line_vertical = new TLine(1500, 0, 1500, 1600);
    //line_vertical->SetLineColor(kBlack);
    //line_vertical->SetLineStyle(2);
    //line_vertical->Draw();

    canvas->Update();

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

    plot_root_graph(filenames);

    return 0;
}

