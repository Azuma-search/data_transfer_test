#include <TCanvas.h>
#include <TGraph.h>
#include <TLine.h>
#include <TAxis.h>  
#include <iostream>
#include <fstream>
#include <vector>
#include <cstdlib>  

void plot_mode_graph(const std::vector<std::string>& filenames) {
    TCanvas *canvas = new TCanvas("canvas", "Data Plot", 800, 600);

    int colors[] = {kRed, kBlue, kGreen, kMagenta, kCyan, kOrange, kViolet, kBlack, kGray, kAzure};

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
        graph->SetMarkerColor(colors[i % 10]);  
        graph->SetLineColor(colors[i % 10]); 
        graph->GetYaxis()->SetRangeUser(0, 120);  
        graph->GetXaxis()->SetRangeUser(0, 2150000);  
        if (i == 0) {
            graph->SetMarkerSize(1.5);  
            graph->Draw("AP");
        } else {
            graph->SetMarkerSize(1.0);  
            graph->Draw("P");  
        }
    }
    TLine *line_10G = new TLine(0, 0, 2150000, 42);  
        line_10G->SetLineColor(kGreen);
        line_10G->SetLineStyle(1);
        line_10G->Draw();

    TLine *line_1G = new TLine(0, 0, 2150000, 84);  
        line_1G->SetLineColor(kBlack);
        line_1G->SetLineStyle(1);
        line_1G->Draw();
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

    plot_mode_graph(filenames);

    return 0;
}

