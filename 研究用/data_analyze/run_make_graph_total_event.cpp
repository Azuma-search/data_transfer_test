#include <TCanvas.h>
#include <TGraph.h>
#include <TLegend.h>
#include <TAxis.h>
#include <TFile.h>
#include <TDirectory.h>
#include <fstream>
#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <map>

void create_graph_from_file(const char* input_file, const char* root_file_name) {
    // ファイルの読み込み
    std::ifstream file(input_file);
    if (!file.is_open()) {
        std::cerr << "Error: Unable to open file " << input_file << std::endl;
        return;
    }

    // データを基板IDごとに分類
    std::map<int, std::vector<std::pair<double, double>>> data_map; // key: board ID, values: (data size, event count)

    std::string line;
    while (std::getline(file, line)) {
        std::istringstream ss(line);
        double data_size, board_id, event_count;

        if (!(ss >> data_size >> board_id >> event_count)) {
            std::cerr << "Error: Invalid format in line: " << line << std::endl;
            continue;
        }
        data_map[static_cast<int>(board_id)].emplace_back(data_size, event_count);
    }

    file.close();

    // ROOTファイルに保存
    TFile* root_file = new TFile(root_file_name, "RECREATE");
    if (!root_file->IsOpen()) {
        std::cerr << "Error: Unable to create ROOT file " << root_file_name << std::endl;
        return;
    }

    // 基板ごとにグラフを作成して保存
    for (const auto& [board_id, values] : data_map) {
        TGraph* graph = new TGraph(values.size());

        for (size_t i = 0; i < values.size(); ++i) {
            graph->SetPoint(i, values[i].first, values[i].second); // (Data Size, Event Count)
        }

        graph->SetName(Form("Board_%d", board_id));
        graph->SetTitle(Form("Board ID: %d", board_id));
        graph->GetXaxis()->SetTitle("Data Size");
        graph->GetYaxis()->SetTitle("Event Count");
        graph->Write();

        delete graph;
    }

    root_file->Close();
    delete root_file;

    std::cout << "Graphs saved in " << root_file_name << std::endl;
}

void create_combined_graph(const std::vector<const char*>& root_files, const char* output_file) {
    // キャンバスの作成
    TCanvas* canvas = new TCanvas("combined_canvas", "Combined Event Count Graphs", 1200, 800);
    canvas->SetGrid();

    TLegend* legend = new TLegend(0.7, 0.7, 0.9, 0.9);
    int color_index = 1;
    bool first_graph = true;

    for (const char* root_file_name : root_files) {
        TFile* root_file = TFile::Open(root_file_name, "READ");
        if (!root_file || !root_file->IsOpen()) {
            std::cerr << "Error: Unable to open ROOT file " << root_file_name << std::endl;
            continue;
        }

        TIter next(root_file->GetListOfKeys());
        TObject* obj;
        while ((obj = next())) {
            TGraph* graph = dynamic_cast<TGraph*>(root_file->Get(obj->GetName()));
            if (!graph) continue;

            graph->SetLineColor(color_index);
            graph->SetMarkerColor(color_index);
            graph->SetMarkerStyle(20 + color_index);
            graph->SetLineWidth(2);

            if (first_graph) {
                graph->Draw("ALP");
                graph->GetXaxis()->SetTitle("Data Size");
                graph->GetYaxis()->SetTitle("Event Count");
                graph->SetTitle("Combined Event Count Graphs");
                first_graph = false;
            } else {
                graph->Draw("LP SAME");
            }

            legend->AddEntry(graph, Form("%s", obj->GetName()), "lp");
            color_index++;
        }

        root_file->Close();
        delete root_file;
    }

    legend->Draw();

    // グラフを保存
    canvas->SaveAs(output_file);
    delete canvas;

    std::cout << "Combined graph saved as " << output_file << std::endl;
}

