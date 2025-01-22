#include <iostream> // 標準エラー出力用
#include <vector>
#include <string>
#include <TGraph.h>
#include <TCanvas.h>
#include <TFile.h>
#include <TPaveText.h>  // テキストを表示するために追加

void run_display_graphs(const std::vector<TGraph*>& graphs, const std::vector<std::string>& titles) {
    if (graphs.size() != titles.size()) {
        std::cerr << "Error: Graphs and titles size mismatch." << std::endl;
        return;
    }

    TCanvas* canvas = new TCanvas("canvas", "Multiple Graphs", 800, 600);
    canvas->Divide(1, graphs.size()); // グラフの数だけ分割

    // グラフに色を設定
    for (size_t i = 0; i < graphs.size(); ++i) {
        // 色の設定（赤と青の例）
        if (i == 0) {
            graphs[i]->SetLineColor(kRed);   // 1つ目のグラフを赤
            graphs[i]->SetMarkerColor(kRed); // 1つ目のマーカーを赤
        } else {
            graphs[i]->SetLineColor(kBlue);  // 2つ目のグラフを青
            graphs[i]->SetMarkerColor(kBlue); // 2つ目のマーカーを青
        }

        canvas->cd(i + 1); // サブキャンバスを選択
        graphs[i]->SetTitle(titles[i].c_str());
        graphs[i]->Draw("AP");
    }

    canvas->Update();
    canvas->SaveAs("multiple_graphs.pdf"); // 必要に応じて保存
}

int main(int argc, char** argv) {
    // コマンドライン引数が足りない場合のエラーチェック
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <input_file1> <input_file2> ..." << std::endl;
        return 1;
    }

    std::vector<TGraph*> graphs;
    std::vector<std::string> titles;

    // 引数で指定されたファイルを順番に処理
    for (int i = 1; i < argc; ++i) {
        const char* inputFile = argv[i];

        // ROOTファイルを開く
        TFile* file = TFile::Open(inputFile);
        if (!file) {
            std::cerr << "Error opening file: " << inputFile << std::endl;
            return 1;
        }

        // 実際のグラフ名を指定（仮の名前、変更が必要な場合もあります）
        const char* graphName = "Detected_Missing_Events";  // 修正: 実際のグラフ名を指定

        // ここでグラフを作成
        TGraph* graph = (TGraph*)file->Get(graphName);  
        if (!graph) {
            std::cerr << "Error: Graph '" << graphName << "' not found in the file!" << std::endl;
            file->Close();
            continue;
        }

        // グラフのエントリー数を取得
        int nEntries = graph->GetN();
        std::cout << "Number of entries in the graph: " << nEntries << std::endl;

        // グラフのタイトルを保存
        titles.push_back(inputFile); // ファイル名をタイトルに設定
        graphs.push_back(graph);     // グラフをリストに追加

        file->Close();  // ファイルを閉じる
    }

    // 複数のグラフを表示
    run_display_graphs(graphs, titles);

    // 終了処理
    for (TGraph* graph : graphs) {
        delete graph;  // グラフを削除
    }

    return 0;
}

