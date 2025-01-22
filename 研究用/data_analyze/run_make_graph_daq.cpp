#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <nlohmann/json.hpp>
#include <TCanvas.h>
#include <TGraph.h>
#include <TFile.h>

using json = nlohmann::json;

std::string remove_extension(const std::string& filename) {
    size_t lastdot = filename.find_last_of(".");
    if (lastdot == std::string::npos) return filename; 
    return filename.substr(0, lastdot);
}

TGraph* run_make_graph_event4(const std::string &input_file, const std::string &output_file) {
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

    std::vector<double> x;
    std::vector<double> y; 

    const auto &events = data["events"];
    if (!events.is_array()) {
        std::cerr << "Error: Invalid JSON structure. 'events' array not found." << std::endl;
        return nullptr;
    }

    int previousEventNumber = 1; 
    for (size_t i = 0; i < events.size(); ++i) {
        const auto &event = events[i];
        if (!event.contains("eventNumber")) continue;

        int eventNumber = event["eventNumber"];
        while (previousEventNumber < eventNumber) {
            x.push_back(previousEventNumber);
            y.push_back(1);
            previousEventNumber++;
        }
        previousEventNumber = eventNumber + 1;    }

    if (events.size() > 0) {
        int lastEventNumber = events.back()["eventNumber"];
        if (previousEventNumber <= lastEventNumber) {
            x.push_back(previousEventNumber);
            y.push_back(1);
        }
    }

    std::cout << "Processed " << x.size() << " missing events." << std::endl;
    for (size_t i = 0; i < x.size(); ++i) {
        std::cout << "Event " << x[i] << ": Missing=" << y[i] << std::endl;
    }

    TGraph *graph = new TGraph(x.size(), x.data(), y.data());
    graph->SetTitle("Detected Missing Events;Event Number;Detected Missing Events");
    graph->SetMarkerStyle(20);
    graph->SetMarkerSize(0.8);
    graph->SetMarkerColor(kRed);

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
        TCanvas canvas("canvas", "Detected Missing Events", 800, 600);
        graph->Draw("AP");
        canvas.Print("output_graph.png");
        std::cout << "Graph successfully created and saved as output_graph.png" << std::endl;
    } else {
        std::cerr << "Failed to create the graph. No data to plot." << std::endl;
    }

    return 0;
}

