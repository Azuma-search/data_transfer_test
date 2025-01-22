#include <iostream> 
#include <vector>
#include <string>
#include <TGraph.h>
#include <TCanvas.h>
#include <TFile.h>
#include <TPaveText.h>  

void run_display_graphs(const std::vector<TGraph*>& graphs, const std::vector<std::string>& titles) {
    if (graphs.size() != titles.size()) {
        std::cerr << "Error: Graphs and titles size mismatch." << std::endl;
        return;
    }

    TCanvas* canvas = new TCanvas("canvas", "Multiple Graphs", 800, 600);
    canvas->Divide(1, graphs.size()); 

    for (size_t i = 0; i < graphs.size(); ++i) {
        if (i == 0) {
            graphs[i]->SetLineColor(kRed);   
            graphs[i]->SetMarkerColor(kRed); 
        } else {
            graphs[i]->SetLineColor(kBlue);  
            graphs[i]->SetMarkerColor(kBlue); 
        }

        canvas->cd(i + 1); 
        graphs[i]->SetTitle(titles[i].c_str());
        graphs[i]->Draw("AP");
    }

    canvas->Update();
    canvas->SaveAs("multiple_graphs.pdf"); 
}

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <input_file1> <input_file2> ..." << std::endl;
        return 1;
    }

    std::vector<TGraph*> graphs;
    std::vector<std::string> titles;

    for (int i = 1; i < argc; ++i) {
        const char* inputFile = argv[i];

        TFile* file = TFile::Open(inputFile);
        if (!file) {
            std::cerr << "Error opening file: " << inputFile << std::endl;
            return 1;
        }

        const char* graphName = "Detected_Missing_Events";  

        TGraph* graph = (TGraph*)file->Get(graphName);  
        if (!graph) {
            std::cerr << "Error: Graph '" << graphName << "' not found in the file!" << std::endl;
            file->Close();
            continue;
        }

        int nEntries = graph->GetN();
        std::cout << "Number of entries in the graph: " << nEntries << std::endl;

        titles.push_back(inputFile); 
        graphs.push_back(graph);     

        file->Close();  
    }

    run_display_graphs(graphs, titles);

    for (TGraph* graph : graphs) {
        delete graph;  
    }

    return 0;
}

