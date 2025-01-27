# プロジェクト名

## 概要

このリポジトリは、私が参加しているJ-PARC muon g-2/EDM実験に関連するプログラムの抜粋を掲載しています。

私はJ-PARC muon g-2/EDM実験にて実験で検出された素粒子のデータ収集におけるデータ収集システムの構築を行っています。
具体的にはデータ収集システムの構成案において現在の構成案に問題がないか、実験で実際に流されるデータを模した擬似的なダミーデータを生成し
それを自分で組み上げたデータ収集システムにて転送することで安定性を評価しています。
ここに全てを載せるにはライブラリなどが膨大で、また全て載せたとしても動かすためには環境構築に必要なものが多いため私が作成したものの一部を抜粋しています。
主に、ハードウェア（FPGA設計）とソフトウェア（データ解析）のコードを含み、以下のように分けられます。
- **ハードウェア:** データ収集用FPGAの制御および通信設計（Verilog）  
- **ソフトウェア:** 収集データの解析スクリプト（C++ / Python）  

具体的な構成としては以下の主要なコンポーネントで構成されています：
- **DAQMW:** DAQMWを用いたデータ収集システム関連のコード  
- **data_analyze:** 取得データの解析スクリプト（Python, C++）  
- **slit:** FPGA制御に関するファイル(本当に一部のみ)  
このリポジトリでは、環境構築が困難なため、主要なコードを抜粋して掲載し、  
その動作例や説明をREADMEにまとめています。
## ファイル構成
<pre>
/data_transfer
│-- /DAQMW                  # DAQMWを用いたデータ収集システム関連のコード
│   │-- reader-merger-conditionlogger.xml  # DAQMWの制御用コード
│   │-- README.md                          # DAQMWモジュールの説明
│
│-- /data_analyze           # データ解析用スクリプト
│   │-- run_setup.sh                       # 計測準備用
│   │-- run_wr_trg.sh                      # 計測開始用
│   │-- run_extract_data.sh                # 測定結果から必要なデータを抽出
│   │-- run_measure_data_parallel.sh       # 複数基板でデータ転送を開始、測定
│   │-- run_measure_data.sh                # 基板でデータ転送を開始、測定
│   │-- run_analyze_data_select.sh         # データ解析の一連の流れ(測定結果をデコードし、必要なデータを抽出)をマクロ化したもの
│   │-- process_emptybits_daq.py           # DAQMWの測定データから必要なデータを選択
│   │-- process_emptybits.py               # 通常の測定データから必要なデータを選択
│   │-- change_mode.py                     # データから最頻値を計算し出力
│   │-- run_plot_total_graph.cpp           # イベントの抜けのグラフを作成
│   │-- run_plot_mode_graph.cpp            # 転送時間の推移のグラフを作成
│   │-- sampledata.txt                     # サンプルデータ
│   │-- sampleresult.png                   # サンプル画像
│   │-- README.md                          # モジュールの説明
│
│-- /slit                   # FPGA制御に関するファイル
│   │-- SLIT_TOP.sv                        # FPGA全体の制御部分
│   │-- SLIT_REG.sv                        # FPGAのレジスタ設定
│   │-- TEST_FIFO.sv                       # ダミーデータ生成部分
│   │-- FLOW_RATE_ADJUSTMENT.sv            # 流量調整部分
│   │-- README.md                          # FPGAモジュールの説明
│
│-- README.md                 # プロジェクトの概要と説明

</pre>
