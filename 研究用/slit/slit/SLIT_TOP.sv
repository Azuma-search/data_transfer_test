/*******************************************************************************
*                                                                              *
* System      : Slit128A Evaluation Board                                      *
* Block       : ----                                                           *
* Module      : Slit128A Evaluation, Ver. 0                                    *
* Version     : v 0.0.2 2015/12/16                                             *
*                                                                              *
* Description : Top module                                                     *
*                                                                              *
*                Copyright (c) 2015 Tomohisa Uchida                            *
*                All rights reserved                                           *
*                                                                              *
*******************************************************************************/
module SLIT_TOP #(
    parameter FPGA_REV = 32'h2024_1008,
    parameter FPGA_VER = 8'h01,
    parameter INDEX = 0    
)(
    // clock and reset
    input   SystemClk,
    input   TcpRstBar,
    input   SystemRstBar,
    // RBCP
    input           RBCP_ACT,
    input   [31:0]  RBCP_ADDR,
    input           RBCP_WE,
    input   [7:0]   RBCP_WD,
    input           RBCP_RE,
    output  [7:0]   RBCP_RD,
    output          RBCP_ACK,
    // TCP_TX
    output          TCP_TX_WR,
    output  [7:0]   TCP_TX_DATA,
    input           TCP_TX_FULL,
    input   [31:0]  MY_IP_ADDR,
    input           NIM_IN,
    output          NIM_OUT
);
    
    wire    TcpRst;
    wire    SystemRst;
    assign  TcpRst      =   ~TcpRstBar;
    assign  SystemRst   =   ~SystemRstBar;
//------------------------------------------------------------------------------
//  Slow control
//------------------------------------------------------------------------------
    wire                RegWrTrg;
    wire    [7:0]       RegDataNumber;
    wire                RegReadyEnb;
    wire    [6:0]       TargetFlowDisableRate;

    SLIT_REG #(
        .FPGA_REV   (FPGA_REV),
        .FPGA_VER   (FPGA_VER)
    ) SLIT_REG(
        .CLK                    (SystemClk                  ),   // in   : Clock
        .RST                    (SystemRst                  ),
        // SiTCP RBCP I/F
        .LOC_ACT                (RBCP_ACT                   ),   // in    : Request
        .LOC_ADDR               (RBCP_ADDR[31:0]            ),   // in   : Address[31:0]
        .LOC_WD                 (RBCP_WD[7:0]               ),   // in   : Data[7:0]
        .LOC_WE                 (RBCP_WE                    ),   // in   : Write enable
        .LOC_RE                 (RBCP_RE                    ),   // in   : Read enable
        .LOC_ACK                (RBCP_ACK                   ),   // out  : Access acknowledge
        .LOC_RD                 (RBCP_RD[7:0]               ),   // out  : Read data[7:0]
        .RegWrTrg               (RegWrTrg                   ),   // out  
        .RegDataNumber          (RegDataNumber[7:0]         ),   // out  
        .RegReadyEnb            (RegReadyEnb                ),   // out  
        .TargetFlowDisableRate  (TargetFlowDisableRate[6:0] )   // out
           
    );
 
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Dummy Data Generator
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    TEST_FIFO TEST_FIFO(
        .CLK                    (SystemClk),
        .RST                    (TcpRst),
        .TCP_TX_WR              (TCP_TX_WR),
        .TCP_TX_DATA            (TCP_TX_DATA),
        .TCP_TX_FULL            (TCP_TX_FULL),
        .RegWrTrg               (RegWrTrg),         //VIO_WR_TRG
        .RegDataNumber          (RegDataNumber),    //VIO_DATA_LENGTH,
        .RegReadyEnb            (RegReadyEnb),      //VIO_RADY_ENB,
        .TargetFlowDisableRate  (TargetFlowDisableRate),
        .MY_IP_ADDR             (MY_IP_ADDR[31:0]),
        .Nim_in                 (NIM_IN),
        .Nim_out                (NIM_OUT)
        );
//------------------------------------------------------------------------------
endmodule