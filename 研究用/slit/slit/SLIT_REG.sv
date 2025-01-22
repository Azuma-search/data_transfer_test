/*******************************************************************************
*                                                                              *
* System      : prototype FRBS                                                 *
* Block       : ----                                                           *
* Module      : SLIT_REG                                                       *
* Version     : v 0.0.2 2015/12/16                                             *
*                                                                              *
* Description : Local register file                                            *
*                                                                              *
*                Copyright (c) 2015 Tomohisa Uchida                            *
*                All rights reserved                                           *
*                                                                              *
*******************************************************************************/

module SLIT_REG#(
        parameter   FPGA_REV        =   32'h1604_1801,
        parameter   FPGA_VER        =   8'h00,
        parameter   PAR_NASIC       =   16
    )(
    input           CLK         ,   // in   : Clock
    input           RST         ,   // in   : System reset
    // SiTCP RBCP I/F
    input           LOC_ACT     ,
    input   [31:0]  LOC_ADDR    ,   // in   : Address[31:0]
    input   [7:0]   LOC_WD      ,   // in   : Data[7:0]
    input           LOC_WE      ,   // in   : Write enable
    input           LOC_RE      ,   // in   : Read enable
    output          LOC_ACK     ,   // out  : Access acknowledge
    output  [7:0]   LOC_RD      ,   // out  : Read data[7:0]
    // -------------------------------------------------------------------
    output  [15:0]  SlowCtrlSelect,
    output  [7:0]   IcTmpReadTrigger,
    output          RegWrTrg,
    output  [7:0]   RegDataNumber,
    output          RegReadyEnb,
    output  [7:0]   TargetFlowDisableRate
    
);

    wire    [31:0]  w_fpgaRev   ;
    wire    [7:0]   w_fpgaVer   ;

    assign  w_fpgaRev[31:0] = FPGA_REV;
    assign  w_fpgaVer[7:0]  = FPGA_VER;

//------------------------------------------------------------------------------
//  Input buffer
//------------------------------------------------------------------------------
    reg     [10:0]   regCs          ;
    reg     [3:0]   irAddr          ;
    reg             irWe            ;
    reg             irRe            ;
    reg     [7:0]   irWd            ;
    reg     [7:0]   irWdA           ;

    always @(posedge CLK) begin
        regCs[0]    <= (LOC_ADDR[31:4]==28'h8000_000);
        regCs[1]    <= (LOC_ADDR[31:4]==28'h8000_001);
        regCs[2]    <= (LOC_ADDR[31:4]==28'h8000_002);
        regCs[3]    <= (LOC_ADDR[31:4]==28'h8000_003);
        regCs[4]    <= (LOC_ADDR[31:4]==28'h8000_004);
        regCs[5]    <= (LOC_ADDR[31:4]==28'h8000_005);
        regCs[6]    <= (LOC_ADDR[31:4]==28'h8000_006);
        regCs[7]    <= (LOC_ADDR[31:4]==28'h8000_007);
        regCs[8]    <= (LOC_ADDR[31:4]==28'h8000_008);
        regCs[9]    <= (LOC_ADDR[31:4]==28'h8000_009);
        regCs[10]   <= (LOC_ADDR[31:4]==28'h8000_00A);

        irAddr[3:0]     <= LOC_ADDR[3:0];
        irWe            <= LOC_WE;
        irRe            <= LOC_RE;
        irWd[7:0]       <= LOC_WD[7:0];
        irWdA[7:0]      <= LOC_WD[7:0];
    end

//------------------------------------------------------------------------------
//  Receive
//------------------------------------------------------------------------------

//  reg     [7:0]   x00_Reg         ; // FPGA REV
//  reg     [7:0]   x01_Reg         ; // FPGA REV
//  reg     [7:0]   x02_Reg         ; // FPGA REV
//  reg     [7:0]   x03_Reg         ; // FPGA REV
//  reg     [7:0]   x04_Reg         ; // FPGA REV
    reg     [7:0]   x05_Reg         ; // slow control select
    reg     [7:0]   x06_Reg         ; // slow control select
    reg     [7:0]   x07_Reg         ; // IcTmpReadTrigger[7:0]

    reg     [7:0]   x08_Reg         ; // RegReadyEnb
    reg     [7:0]   x09_Reg         ; // RegWrTrg
    reg     [7:0]   x0A_Reg         ; // RegDataNumber
    reg     [7:0]   x0B_Reg         ; 
    reg     [7:0]   x0C_Reg         ; 
    reg     [7:0]   x0D_Reg         ; // TargetFlowDisableRate
    reg     [7:0]   x0E_Reg         ; 
    reg     [7:0]   x0F_Reg         ; 
    reg     [7:0]   x10_Reg         ;
    reg     [7:0]   x11_Reg         ; 
    reg     [7:0]   x12_Reg         ;
    reg     [7:0]   x13_Reg         ;
    reg     [7:0]   x14_Reg         ;
    reg     [7:0]   x15_Reg         ;
    reg     [7:0]   x16_Reg         ;
    reg     [7:0]   x17_Reg         ;
    reg     [7:0]   x18_Reg         ;
    reg     [7:0]   x19_Reg         ;
    reg     [7:0]   x1A_Reg         ;
    reg     [7:0]   x1B_Reg         ;
    reg     [7:0]   x1C_Reg         ;
    reg     [7:0]   x1D_Reg         ;
    reg     [7:0]   x1E_Reg         ;
    reg     [7:0]   x1F_Reg         ;

    reg     [7:0]   x20_Reg         ;
    reg     [7:0]   x21_Reg         ;
    reg     [7:0]   x22_Reg         ;
    reg     [7:0]   x23_Reg         ;
    reg     [7:0]   x24_Reg         ;
    reg     [7:0]   x25_Reg         ;
    reg     [7:0]   x26_Reg         ;
    reg     [7:0]   x27_Reg         ;
    reg     [7:0]   x28_Reg         ;
    reg     [7:0]   x29_Reg         ;
    reg     [7:0]   x2A_Reg         ;
    reg     [7:0]   x2B_Reg         ;
    reg     [7:0]   x2C_Reg         ;
    reg     [7:0]   x2D_Reg         ;
    reg     [7:0]   x2E_Reg         ;
    reg     [7:0]   x2F_Reg         ;

    reg     [7:0]   x30_Reg         ;
    reg     [7:0]   x31_Reg         ;
    reg     [7:0]   x32_Reg         ;
    reg     [7:0]   x33_Reg         ;
    reg     [7:0]   x34_Reg         ;
    reg     [7:0]   x35_Reg         ;
    reg     [7:0]   x36_Reg         ;
    reg     [7:0]   x37_Reg         ;
    reg     [7:0]   x38_Reg         ;
    reg     [7:0]   x39_Reg         ;
    reg     [7:0]   x3A_Reg         ;
    reg     [7:0]   x3B_Reg         ;
    reg     [7:0]   x3C_Reg         ;
    reg     [7:0]   x3D_Reg         ;
    reg     [7:0]   x3E_Reg         ;
    reg     [7:0]   x3F_Reg         ;

    reg     [7:0]   x40_Reg         ;
    reg     [7:0]   x41_Reg         ;
    reg     [7:0]   x42_Reg         ;
    reg     [7:0]   x43_Reg         ;
    reg     [7:0]   x44_Reg         ;
    reg     [7:0]   x45_Reg         ;
    reg     [7:0]   x46_Reg         ;
    reg     [7:0]   x47_Reg         ;
    reg     [7:0]   x48_Reg         ;
    reg     [7:0]   x49_Reg         ;
    reg     [7:0]   x4A_Reg         ;
    reg     [7:0]   x4B_Reg         ;
    reg     [7:0]   x4C_Reg         ;
    reg     [7:0]   x4D_Reg         ;
    reg     [7:0]   x4E_Reg         ;
    reg     [7:0]   x4F_Reg         ;

    reg     [7:0]   x50_Reg         ;
    reg     [7:0]   x51_Reg         ;
    reg     [7:0]   x52_Reg         ;
    reg     [7:0]   x53_Reg         ;
    reg     [7:0]   x54_Reg         ;
    reg     [7:0]   x55_Reg         ;
    reg     [7:0]   x56_Reg         ;
    reg     [7:0]   x57_Reg         ;
    reg     [7:0]   x58_Reg         ;
    reg     [7:0]   x59_Reg         ;
    reg     [7:0]   x5A_Reg         ;
    reg     [7:0]   x5B_Reg         ;
    reg     [7:0]   x5C_Reg         ;
    reg     [7:0]   x5D_Reg         ;
    reg     [7:0]   x5E_Reg         ;
    reg     [7:0]   x5F_Reg         ;

    reg     [7:0]   x60_Reg         ;
    reg     [7:0]   x61_Reg         ;
    reg     [7:0]   x62_Reg         ;
    reg     [7:0]   x63_Reg         ;
    reg     [7:0]   x64_Reg         ;
    reg     [7:0]   x65_Reg         ;
    reg     [7:0]   x66_Reg         ;
    reg     [7:0]   x67_Reg         ;
    reg     [7:0]   x68_Reg         ;
    reg     [7:0]   x69_Reg         ;
    reg     [7:0]   x6A_Reg         ;
    reg     [7:0]   x6B_Reg         ;
    reg     [7:0]   x6C_Reg         ;
    reg     [7:0]   x6D_Reg         ;
    reg     [7:0]   x6E_Reg         ;
    reg     [7:0]   x6F_Reg         ;

    reg     [7:0]   x70_Reg         ;
    reg     [7:0]   x71_Reg         ;
    reg     [7:0]   x72_Reg         ;
    reg     [7:0]   x73_Reg         ;
    reg     [7:0]   x74_Reg         ;
    reg     [7:0]   x75_Reg         ;
    reg     [7:0]   x76_Reg         ;
    reg     [7:0]   x77_Reg         ;
    reg     [7:0]   x78_Reg         ;
    reg     [7:0]   x79_Reg         ;
    reg     [7:0]   x7A_Reg         ;
    reg     [7:0]   x7B_Reg         ;
    reg     [7:0]   x7C_Reg         ;
    reg     [7:0]   x7D_Reg         ;
    reg     [7:0]   x7E_Reg         ;
    reg     [7:0]   x7F_Reg         ;

    reg     [7:0]   x80_Reg         ;
    reg     [7:0]   x81_Reg         ;
    reg     [7:0]   x82_Reg         ;
    reg     [7:0]   x83_Reg         ;
    reg     [7:0]   x84_Reg         ;
    reg     [7:0]   x85_Reg         ;
    reg     [7:0]   x86_Reg         ;
    reg     [7:0]   x87_Reg         ;
    reg     [7:0]   x88_Reg         ;
    reg     [7:0]   x89_Reg         ;
    reg     [7:0]   x8A_Reg         ;
    reg     [7:0]   x8B_Reg         ;
    reg     [7:0]   x8C_Reg         ;
    reg     [7:0]   x8D_Reg         ;
    reg     [7:0]   x8E_Reg         ;
    reg     [7:0]   x8F_Reg         ;

    reg     [7:0]   x90_Reg         ;
    reg     [7:0]   x91_Reg         ;
    reg     [7:0]   x92_Reg         ;
    reg     [7:0]   x93_Reg         ;
    reg     [7:0]   x94_Reg         ;
    reg     [7:0]   x95_Reg         ;
    reg     [7:0]   x96_Reg         ;
    reg     [7:0]   x97_Reg         ;
    reg     [7:0]   x98_Reg         ;
    reg     [7:0]   x99_Reg         ;
    reg     [7:0]   x9A_Reg         ;
    reg     [7:0]   x9B_Reg         ;
    reg     [7:0]   x9C_Reg         ;
    reg     [7:0]   x9D_Reg         ;
    reg     [7:0]   x9E_Reg         ;
    reg     [7:0]   x9F_Reg         ;
    
    reg     [7:0]   xA0_Reg         ;
    reg     [7:0]   xA1_Reg         ;
    reg     [7:0]   xA2_Reg         ;
    reg     [7:0]   xA3_Reg         ;
    reg     [7:0]   xA4_Reg         ;
    reg     [7:0]   xA5_Reg         ;
    reg     [7:0]   xA6_Reg         ;
    reg     [7:0]   xA7_Reg         ;
    reg     [7:0]   xA8_Reg         ;
    reg     [7:0]   xA9_Reg         ;
    reg     [7:0]   xAA_Reg         ;
    reg     [7:0]   xAB_Reg         ;
    reg     [7:0]   xAC_Reg         ;
    reg     [7:0]   xAD_Reg         ;
    reg     [7:0]   xAE_Reg         ;
    reg     [7:0]   xAF_Reg         ;
    
     always @(posedge CLK or posedge RST) begin
        if(RST)begin
//          x00_Reg[7:0]    <= 8'd0;
//          x01_Reg[7:0]    <= 8'd0;
//          x02_Reg[7:0]    <= 8'd0;
//          x03_Reg[7:0]    <= 8'd0;
//          x04_Reg[7:0]    <= 8'd0;
            x05_Reg[7:0]    <= 8'h00; // SLOW CONTROL SELECT
            x06_Reg[7:0]    <= 8'h01; // SLOW CONTROL SELECT
            x07_Reg[7:0]    <= 8'h00;
            x08_Reg[7:0]    <= 8'h00; // RegReadyEnb
            x09_Reg[7:0]    <= 8'h00; // RegWrTrg
            x0A_Reg[7:0]    <= 8'h00; // RegDataNumber = 
            x0B_Reg[7:0]    <= 8'h00; 
            x0C_Reg[7:0]    <= 8'h00; 
            x0D_Reg[7:0]    <= 8'h00; // TargetFlowDisableRate 
            x0E_Reg[7:0]    <= 8'h00; 
            x0F_Reg[7:0]    <= 8'h00;
            x10_Reg[7:0]    <= 8'h00;
            x11_Reg[7:0]    <= 8'h00; 
            x12_Reg[7:0]    <= 8'h00;
            x13_Reg[7:0]    <= 8'h00;
            x14_Reg[7:0]    <= 8'h00;
            x15_Reg[7:0]    <= 8'h00;
            x16_Reg[7:0]    <= 8'h00;
            x17_Reg[7:0]    <= 8'h00;
            x18_Reg[7:0]    <= 8'h00;
            x19_Reg[7:0]    <= 8'h00;
            x1A_Reg[7:0]    <= 8'h00;
            x1B_Reg[7:0]    <= 8'h00;
            x1C_Reg[7:0]    <= 8'h00;
            x1D_Reg[7:0]    <= 8'h00;
            x1E_Reg[7:0]    <= 8'h00;
            x1F_Reg[7:0]    <= 8'h00;

            x20_Reg[7:0]    <= 8'h00;
            x21_Reg[7:0]    <= 8'h00;
            x22_Reg[7:0]    <= 8'h00;
            x23_Reg[7:0]    <= 8'h00;
            x24_Reg[7:0]    <= 8'h00;
            x25_Reg[7:0]    <= 8'h00;
            x26_Reg[7:0]    <= 8'h00;
            x27_Reg[7:0]    <= 8'h00;
            x28_Reg[7:0]    <= 8'h00;
            x29_Reg[7:0]    <= 8'h00;
            x2A_Reg[7:0]    <= 8'h00;
            x2B_Reg[7:0]    <= 8'h00;
            x2C_Reg[7:0]    <= 8'h00;
            x2D_Reg[7:0]    <= 8'h00;
            x2E_Reg[7:0]    <= 8'h00;
            x2F_Reg[7:0]    <= 8'h00;

            x30_Reg[7:0]    <= 8'h00;
            x31_Reg[7:0]    <= 8'h00;
            x32_Reg[7:0]    <= 8'h00;
            x33_Reg[7:0]    <= 8'h00;
            x34_Reg[7:0]    <= 8'h00;
            x35_Reg[7:0]    <= 8'h00;
            x36_Reg[7:0]    <= 8'h00;
            x37_Reg[7:0]    <= 8'h00;
            x38_Reg[7:0]    <= 8'h00;
            x39_Reg[7:0]    <= 8'h00;
            x3A_Reg[7:0]    <= 8'h00;
            x3B_Reg[7:0]    <= 8'h00;
            x3C_Reg[7:0]    <= 8'h00;
            x3D_Reg[7:0]    <= 8'h00;
            x3E_Reg[7:0]    <= 8'h00;
            x3F_Reg[7:0]    <= 8'h00;

            x40_Reg[7:0]    <= 8'h00;
            x41_Reg[7:0]    <= 8'h00;
            x42_Reg[7:0]    <= 8'h00;
            x43_Reg[7:0]    <= 8'h00;
            x44_Reg[7:0]    <= 8'h00;
            x45_Reg[7:0]    <= 8'h00;
            x46_Reg[7:0]    <= 8'h00;
            x47_Reg[7:0]    <= 8'h00;
            x48_Reg[7:0]    <= 8'h00;
            x49_Reg[7:0]    <= 8'h00;
            x4A_Reg[7:0]    <= 8'h00;
            x4B_Reg[7:0]    <= 8'h00;
            x4C_Reg[7:0]    <= 8'h00;
            x4D_Reg[7:0]    <= 8'h00;
            x4E_Reg[7:0]    <= 8'h00;
            x4F_Reg[7:0]    <= 8'h00;

            x50_Reg[7:0]    <= 8'h00;
            x51_Reg[7:0]    <= 8'h00;
            x52_Reg[7:0]    <= 8'h00;
            x53_Reg[7:0]    <= 8'h00;
            x54_Reg[7:0]    <= 8'h00;
            x55_Reg[7:0]    <= 8'h00;
            x56_Reg[7:0]    <= 8'h00;
            x57_Reg[7:0]    <= 8'h00;
            x58_Reg[7:0]    <= 8'h00;
            x59_Reg[7:0]    <= 8'h00;
            x5A_Reg[7:0]    <= 8'h00;
            x5B_Reg[7:0]    <= 8'h00;
            x5C_Reg[7:0]    <= 8'h00;
            x5D_Reg[7:0]    <= 8'h00;
            x5E_Reg[7:0]    <= 8'h00;
            x5F_Reg[7:0]    <= 8'h00;

            x60_Reg[7:0]    <= 8'h00;
            x61_Reg[7:0]    <= 8'h00;
            x62_Reg[7:0]    <= 8'h00;
            x63_Reg[7:0]    <= 8'h00;
            x64_Reg[7:0]    <= 8'h00;
            x65_Reg[7:0]    <= 8'h00;
            x66_Reg[7:0]    <= 8'h00;
            x67_Reg[7:0]    <= 8'h00;
            x68_Reg[7:0]    <= 8'h00;
            x69_Reg[7:0]    <= 8'h00;
            x6A_Reg[7:0]    <= 8'h00;
            x6B_Reg[7:0]    <= 8'h00;
            x6C_Reg[7:0]    <= 8'h00;
            x6D_Reg[7:0]    <= 8'h00;
            x6E_Reg[7:0]    <= 8'h00;
            x6F_Reg[7:0]    <= 8'h00;

            x70_Reg[7:0]    <= 8'h00;
            x71_Reg[7:0]    <= 8'h00;
            x72_Reg[7:0]    <= 8'h00;
            x73_Reg[7:0]    <= 8'h00;
            x74_Reg[7:0]    <= 8'h00;
            x75_Reg[7:0]    <= 8'h01;
            x76_Reg[7:0]    <= 8'h00;
            x77_Reg[7:0]    <= 8'h00;
            x78_Reg[7:0]    <= 8'h00;
            x79_Reg[7:0]    <= 8'h00;
            x7A_Reg[7:0]    <= 8'h00;
            x7B_Reg[7:0]    <= 8'h00;
            x7C_Reg[7:0]    <= 8'h00;
            x7D_Reg[7:0]    <= 8'h00;
            x7E_Reg[7:0]    <= 8'h00;
            x7F_Reg[7:0]    <= 8'h00;

            x80_Reg[7:0]    <= 8'h00;
            x81_Reg[7:0]    <= 8'h00;
            x82_Reg[7:0]    <= 8'h00;
            x83_Reg[7:0]    <= 8'h00;
            x84_Reg[7:0]    <= 8'h00;
            x85_Reg[7:0]    <= 8'h00;
            x86_Reg[7:0]    <= 8'h00;
            x87_Reg[7:0]    <= 8'h00;
            x88_Reg[7:0]    <= 8'h00;
            x89_Reg[7:0]    <= 8'h00;
            x8A_Reg[7:0]    <= 8'h00;
            x8B_Reg[7:0]    <= 8'h00;
            x8C_Reg[7:0]    <= 8'h00;
            x8D_Reg[7:0]    <= 8'h00;
            x8E_Reg[7:0]    <= 8'h00;
            x8F_Reg[7:0]    <= 8'h00;

            x90_Reg[7:0]    <= 8'h00;
            x91_Reg[7:0]    <= 8'h00;
            x92_Reg[7:0]    <= 8'h00;
            x93_Reg[7:0]    <= 8'h00;
            x94_Reg[7:0]    <= 8'h00;
            x95_Reg[7:0]    <= 8'h00;
            x96_Reg[7:0]    <= 8'h00;
            x97_Reg[7:0]    <= 8'h00;
            x98_Reg[7:0]    <= 8'h00;
            x99_Reg[7:0]    <= 8'h00;
            x9A_Reg[7:0]    <= 8'h00;
            x9B_Reg[7:0]    <= 8'h00;
            x9C_Reg[7:0]    <= 8'h00;
            x9D_Reg[7:0]    <= 8'h00;
            x9E_Reg[7:0]    <= 8'h00;
            x9F_Reg[7:0]    <= 8'h00;

            xA0_Reg[7:0]    <= 8'h01;
            xA1_Reg[7:0]    <= 8'h00;
            xA2_Reg[7:0]    <= 8'h00;
            xA3_Reg[7:0]    <= 8'h00;
            xA4_Reg[7:0]    <= 8'h00;
            xA5_Reg[7:0]    <= 8'h00;
            xA6_Reg[7:0]    <= 8'h00;
            xA7_Reg[7:0]    <= 8'h00;
            xA8_Reg[7:0]    <= 8'h00;
            xA9_Reg[7:0]    <= 8'h00;
            xAA_Reg[7:0]    <= 8'h00;
            xAB_Reg[7:0]    <= 8'h00;
            xAC_Reg[7:0]    <= 8'h00;
            xAD_Reg[7:0]    <= 8'h00;
            xAE_Reg[7:0]    <= 8'h00;
            xAF_Reg[7:0]    <= 8'h00;
            
        end else begin
            if(irWe)begin
//              x00_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x00_Reg[7:0]);
//              x01_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x01_Reg[7:0]);
//              x02_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x02_Reg[7:0]);
//              x03_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x03_Reg[7:0]);
//              x04_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x04_Reg[7:0]);
                x05_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x05_Reg[7:0]);
                x06_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x06_Reg[7:0]);
                x07_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x07_Reg[7:0]);
                x08_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x08_Reg[7:0]);
                x09_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x09_Reg[7:0]);
                x0A_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x0A_Reg[7:0]);
                x0B_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x0B_Reg[7:0]);
                x0C_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x0C_Reg[7:0]);
                x0D_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x0D_Reg[7:0]);
                x0E_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x0E_Reg[7:0]);
                x0F_Reg[7:0]    <= (regCs[0] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x0F_Reg[7:0]);

                x10_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x10_Reg[7:0]);
                x11_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x11_Reg[7:0]);
                x12_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x12_Reg[7:0]);
                x13_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x13_Reg[7:0]);
                x14_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x14_Reg[7:0]);
                x15_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x15_Reg[7:0]);
                x16_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x16_Reg[7:0]);
                x17_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x17_Reg[7:0]);
                x18_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x18_Reg[7:0]);
                x19_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x19_Reg[7:0]);
                x1A_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x1A_Reg[7:0]);
                x1B_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x1B_Reg[7:0]);
                x1C_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x1C_Reg[7:0]);
                x1D_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x1D_Reg[7:0]);
                x1E_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x1E_Reg[7:0]);
                x1F_Reg[7:0]    <= (regCs[1] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x1F_Reg[7:0]);

                x20_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x20_Reg[7:0]);
                x21_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x21_Reg[7:0]);
                x22_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x22_Reg[7:0]);
                x23_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x23_Reg[7:0]);
                x24_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x24_Reg[7:0]);
                x25_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x25_Reg[7:0]);
                x26_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x26_Reg[7:0]);
                x27_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x27_Reg[7:0]);
                x28_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x28_Reg[7:0]);
                x29_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x29_Reg[7:0]);
                x2A_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x2A_Reg[7:0]);
                x2B_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x2B_Reg[7:0]);
                x2C_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x2C_Reg[7:0]);
                x2D_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x2D_Reg[7:0]);
                x2E_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x2E_Reg[7:0]);
                x2F_Reg[7:0]    <= (regCs[2] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x2F_Reg[7:0]);

                x30_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x30_Reg[7:0]);
                x31_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x31_Reg[7:0]);
                x32_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x32_Reg[7:0]);
                x33_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x33_Reg[7:0]);
                x34_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x34_Reg[7:0]);
                x35_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x35_Reg[7:0]);
                x36_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x36_Reg[7:0]);
                x37_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x37_Reg[7:0]);
                x38_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x38_Reg[7:0]);
                x39_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x39_Reg[7:0]);
                x3A_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x3A_Reg[7:0]);
                x3B_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x3B_Reg[7:0]);
                x3C_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x3C_Reg[7:0]);
                x3D_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x3D_Reg[7:0]);
                x3E_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x3E_Reg[7:0]);
                x3F_Reg[7:0]    <= (regCs[3] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x3F_Reg[7:0]);

                x40_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x40_Reg[7:0]);
                x41_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x41_Reg[7:0]);
                x42_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x42_Reg[7:0]);
                x43_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x43_Reg[7:0]);
                x44_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x44_Reg[7:0]);
                x45_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x45_Reg[7:0]);
                x46_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x46_Reg[7:0]);
                x47_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x47_Reg[7:0]);
                x48_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x48_Reg[7:0]);
                x49_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x49_Reg[7:0]);
                x4A_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x4A_Reg[7:0]);
                x4B_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x4B_Reg[7:0]);
                x4C_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x4C_Reg[7:0]);
                x4D_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x4D_Reg[7:0]);
                x4E_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x4E_Reg[7:0]);
                x4F_Reg[7:0]    <= (regCs[4] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x4F_Reg[7:0]);

                x50_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x50_Reg[7:0]);
                x51_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x51_Reg[7:0]);
                x52_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x52_Reg[7:0]);
                x53_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x53_Reg[7:0]);
                x54_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x54_Reg[7:0]);
                x55_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x55_Reg[7:0]);
                x56_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x56_Reg[7:0]);
                x57_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x57_Reg[7:0]);
                x58_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x58_Reg[7:0]);
                x59_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x59_Reg[7:0]);
                x5A_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x5A_Reg[7:0]);
                x5B_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x5B_Reg[7:0]);
                x5C_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x5C_Reg[7:0]);
                x5D_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x5D_Reg[7:0]);
                x5E_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x5E_Reg[7:0]);
                x5F_Reg[7:0]    <= (regCs[5] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x5F_Reg[7:0]);

                x60_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x60_Reg[7:0]);
                x61_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x61_Reg[7:0]);
                x62_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x62_Reg[7:0]);
                x63_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x63_Reg[7:0]);
                x64_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x64_Reg[7:0]);
                x65_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x65_Reg[7:0]);
                x66_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x66_Reg[7:0]);
                x67_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x67_Reg[7:0]);
                x68_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x68_Reg[7:0]);
                x69_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x69_Reg[7:0]);
                x6A_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x6A_Reg[7:0]);
                x6B_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x6B_Reg[7:0]);
                x6C_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x6C_Reg[7:0]);
                x6D_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x6D_Reg[7:0]);
                x6E_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x6E_Reg[7:0]);
                x6F_Reg[7:0]    <= (regCs[6] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x6F_Reg[7:0]);

                x70_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x70_Reg[7:0]);
                x71_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x71_Reg[7:0]);
                x72_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x72_Reg[7:0]);
                x73_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x73_Reg[7:0]);
                x74_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x74_Reg[7:0]);
                x75_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x75_Reg[7:0]);
                x76_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x76_Reg[7:0]);
                x77_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x77_Reg[7:0]);
                x78_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x78_Reg[7:0]);
                x79_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x79_Reg[7:0]);
                x7A_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x7A_Reg[7:0]);
                x7B_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x7B_Reg[7:0]);
                x7C_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x7C_Reg[7:0]);
                x7D_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x7D_Reg[7:0]);
                x7E_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x7E_Reg[7:0]);
                x7F_Reg[7:0]    <= (regCs[7] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x7F_Reg[7:0]);

                x80_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x80_Reg[7:0]);
                x81_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x81_Reg[7:0]);
                x82_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x82_Reg[7:0]);
                x83_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x83_Reg[7:0]);
                x84_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x84_Reg[7:0]);
                x85_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x85_Reg[7:0]);
                x86_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x86_Reg[7:0]);
                x87_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x87_Reg[7:0]);
                x88_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x88_Reg[7:0]);
                x89_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x89_Reg[7:0]);
                x8A_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x8A_Reg[7:0]);
                x8B_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x8B_Reg[7:0]);
                x8C_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x8C_Reg[7:0]);
                x8D_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x8D_Reg[7:0]);
                x8E_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x8E_Reg[7:0]);
                x8F_Reg[7:0]    <= (regCs[8] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x8F_Reg[7:0]);

                x90_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'h0) ? irWd[7:0] : x90_Reg[7:0]);
                x91_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'h1) ? irWd[7:0] : x91_Reg[7:0]);
                x92_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'h2) ? irWd[7:0] : x92_Reg[7:0]);
                x93_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'h3) ? irWd[7:0] : x93_Reg[7:0]);
                x94_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'h4) ? irWd[7:0] : x94_Reg[7:0]);
                x95_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'h5) ? irWd[7:0] : x95_Reg[7:0]);
                x96_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'h6) ? irWd[7:0] : x96_Reg[7:0]);
                x97_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'h7) ? irWd[7:0] : x97_Reg[7:0]);
                x98_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'h8) ? irWd[7:0] : x98_Reg[7:0]);
                x99_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'h9) ? irWd[7:0] : x99_Reg[7:0]);
                x9A_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'hA) ? irWd[7:0] : x9A_Reg[7:0]);
                x9B_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'hB) ? irWd[7:0] : x9B_Reg[7:0]);
                x9C_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'hC) ? irWd[7:0] : x9C_Reg[7:0]);
                x9D_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'hD) ? irWd[7:0] : x9D_Reg[7:0]);
                x9E_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'hE) ? irWd[7:0] : x9E_Reg[7:0]);
                x9F_Reg[7:0]    <= (regCs[9] & (irAddr[3:0]==4'hF) ? irWd[7:0] : x9F_Reg[7:0]);

                xA0_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'h0) ? irWdA[7:0] : xA0_Reg[7:0]);
                xA1_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'h1) ? irWdA[7:0] : xA1_Reg[7:0]);
                xA2_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'h2) ? irWd[7:0] : xA2_Reg[7:0]);
                xA3_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'h3) ? irWd[7:0] : xA3_Reg[7:0]);
                xA4_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'h4) ? irWdA[7:0] : xA4_Reg[7:0]);
                xA5_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'h5) ? irWdA[7:0] : xA5_Reg[7:0]);
                xA6_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'h6) ? irWdA[7:0] : xA6_Reg[7:0]);
                xA7_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'h7) ? irWdA[7:0] : xA7_Reg[7:0]);
                xA8_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'h8) ? irWdA[7:0] : xA8_Reg[7:0]);
                xA9_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'h9) ? irWd[7:0] : xA9_Reg[7:0]);
                xAA_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'hA) ? irWd[7:0] : xAA_Reg[7:0]);
                xAB_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'hB) ? irWd[7:0] : xAB_Reg[7:0]);
                xAC_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'hC) ? irWd[7:0] : xAC_Reg[7:0]);
                xAD_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'hD) ? irWd[7:0] : xAD_Reg[7:0]);
                xAE_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'hE) ? irWd[7:0] : xAE_Reg[7:0]);
                xAF_Reg[7:0]    <= (regCs[10] & (irAddr[3:0]==4'hF) ? irWd[7:0] : xAF_Reg[7:0]);

            end else begin
                x07_Reg[7:0]    <=  8'b0; // IC (Temperature) read trigger
            end
        end
    end

    assign  SlowCtrlSelect      [15:0]          =   {x05_Reg[7:0],x06_Reg[7:0]};
    assign  IcTmpReadTrigger    [7:0]           =   x07_Reg[7:0];
    assign  RegReadyEnb                         =   x08_Reg[0];
    assign  RegWrTrg                            =   x09_Reg[0];
    assign  RegDataNumber       [7:0]          =   x0A_Reg[7:0];//100000 = 186A0
    assign  TargetFlowDisableRate   [7:0]       =   x0D_Reg[7:0];//
/*
x08_Reg[7:0]    <= 8'h00; // RegReadyEnb
                x09_Reg[7:0]    <= 8'h00; // RegWrTrg
                x0A_Reg[7:0]    <= 8'h00; // RegDataNumber
                x0B_Reg[7:0]    <= 8'h00; 
                x0C_Reg[7:0]    <= 8'h00; 
                x0D_Reg[7:0]    <= 8'h00; // TargetFlowDisableRate 
                x0E_Reg[7:0]    <= 8'h00; 
                x0F_Reg[7:0]    <= 8'h00;
                */
    reg     [7:0]   rdData0     ; // x0?_Reg
    reg     [7:0]   rdData1     ; // x1?_Reg
    reg     [7:0]   rdData2     ; // x2?_Reg
    reg     [7:0]   rdData3     ; // x3?_Reg
    reg     [7:0]   rdData4     ; // x4?_Reg
    reg     [7:0]   rdData5     ; // x5?_Reg
    reg     [7:0]   rdData6     ; // x6?_Reg
    reg     [7:0]   rdData7     ; // x7?_Reg
    reg     [7:0]   rdData8     ; // x8?_Reg
    reg     [7:0]   rdData9     ; // x9?_Reg
    reg     [7:0]   rdDataA     ; // xA?_Reg
    reg     [10:0]   regRv      ;
    reg             regAck      ;

    always@ (posedge CLK) begin
        case(irAddr[3:0])
            4'h0:   rdData0[7:0]    <= w_fpgaRev[31:24];
            4'h1:   rdData0[7:0]    <= w_fpgaRev[23:16];
            4'h2:   rdData0[7:0]    <= w_fpgaRev[15: 8];
            4'h3:   rdData0[7:0]    <= w_fpgaRev[ 7: 0];
            4'h4:   rdData0[7:0]    <= w_fpgaVer[7:0];
            4'h5:   rdData0[7:0]    <= x05_Reg[7:0];
            4'h6:   rdData0[7:0]    <= x06_Reg[7:0];
            4'h7:   rdData0[7:0]    <= x07_Reg[7:0];
            4'h8:   rdData0[7:0]    <= x08_Reg[7:0];
            4'h9:   rdData0[7:0]    <= x09_Reg[7:0];
            4'hA:   rdData0[7:0]    <= x0A_Reg[7:0];
            4'hB:   rdData0[7:0]    <= x0B_Reg[7:0];
            4'hC:   rdData0[7:0]    <= x0C_Reg[7:0];
            4'hD:   rdData0[7:0]    <= x0D_Reg[7:0];
            4'hE:   rdData0[7:0]    <= x0E_Reg[7:0];
            4'hF:   rdData0[7:0]    <= x0F_Reg[7:0];
        endcase
        
        case(irAddr[3:0])
            4'h0:   rdData1[7:0]    <= x10_Reg[7:0];
            4'h1:   rdData1[7:0]    <= x11_Reg[7:0];
            4'h2:   rdData1[7:0]    <= x12_Reg[7:0];
            4'h3:   rdData1[7:0]    <= x13_Reg[7:0];
            4'h4:   rdData1[7:0]    <= x14_Reg[7:0];
            4'h5:   rdData1[7:0]    <= x15_Reg[7:0];
            4'h6:   rdData1[7:0]    <= x16_Reg[7:0];
            4'h7:   rdData1[7:0]    <= x17_Reg[7:0];
            4'h8:   rdData1[7:0]    <= x18_Reg[7:0];
            4'h9:   rdData1[7:0]    <= x19_Reg[7:0];
            4'hA:   rdData1[7:0]    <= x1A_Reg[7:0];
            4'hB:   rdData1[7:0]    <= x1B_Reg[7:0];
            4'hC:   rdData1[7:0]    <= x1C_Reg[7:0];
            4'hD:   rdData1[7:0]    <= x1D_Reg[7:0];
            4'hE:   rdData1[7:0]    <= x1E_Reg[7:0];
            4'hF:   rdData1[7:0]    <= x1F_Reg[7:0];
        endcase
        
        case(irAddr[3:0])
            4'h0:   rdData2[7:0]    <= x20_Reg[7:0];
            4'h1:   rdData2[7:0]    <= x21_Reg[7:0];
            4'h2:   rdData2[7:0]    <= x22_Reg[7:0];
            4'h3:   rdData2[7:0]    <= x23_Reg[7:0];
            4'h4:   rdData2[7:0]    <= x24_Reg[7:0];
            4'h5:   rdData2[7:0]    <= x25_Reg[7:0];
            4'h6:   rdData2[7:0]    <= x26_Reg[7:0];
            4'h7:   rdData2[7:0]    <= x27_Reg[7:0];
            4'h8:   rdData2[7:0]    <= x28_Reg[7:0];
            4'h9:   rdData2[7:0]    <= x29_Reg[7:0];
            4'hA:   rdData2[7:0]    <= x2A_Reg[7:0];
            4'hB:   rdData2[7:0]    <= x2B_Reg[7:0];
            4'hC:   rdData2[7:0]    <= x2C_Reg[7:0];
            4'hD:   rdData2[7:0]    <= x2D_Reg[7:0];
            4'hE:   rdData2[7:0]    <= x2E_Reg[7:0];
            4'hF:   rdData2[7:0]    <= x2F_Reg[7:0];
        endcase

        case(irAddr[3:0])
            4'h0:   rdData3[7:0]    <= x30_Reg[7:0];
            4'h1:   rdData3[7:0]    <= x31_Reg[7:0];
            4'h2:   rdData3[7:0]    <= x32_Reg[7:0];
            4'h3:   rdData3[7:0]    <= x33_Reg[7:0];
            4'h4:   rdData3[7:0]    <= x34_Reg[7:0];
            4'h5:   rdData3[7:0]    <= x35_Reg[7:0];
            4'h6:   rdData3[7:0]    <= x36_Reg[7:0];
            4'h7:   rdData3[7:0]    <= x37_Reg[7:0];
            4'h8:   rdData3[7:0]    <= x38_Reg[7:0];
            4'h9:   rdData3[7:0]    <= x39_Reg[7:0];
            4'hA:   rdData3[7:0]    <= x3A_Reg[7:0];
            4'hB:   rdData3[7:0]    <= x3B_Reg[7:0];
            4'hC:   rdData3[7:0]    <= x3C_Reg[7:0];
            4'hD:   rdData3[7:0]    <= x3D_Reg[7:0];
            4'hE:   rdData3[7:0]    <= x3E_Reg[7:0];
            4'hF:   rdData3[7:0]    <= x3F_Reg[7:0];
        endcase

        case(irAddr[3:0])
            4'h0:   rdData4[7:0]    <= x40_Reg[7:0];
            4'h1:   rdData4[7:0]    <= x41_Reg[7:0];
            4'h2:   rdData4[7:0]    <= x42_Reg[7:0];
            4'h3:   rdData4[7:0]    <= x43_Reg[7:0];
            4'h4:   rdData4[7:0]    <= x44_Reg[7:0];
            4'h5:   rdData4[7:0]    <= x45_Reg[7:0];
            4'h6:   rdData4[7:0]    <= x46_Reg[7:0];
            4'h7:   rdData4[7:0]    <= x47_Reg[7:0];
            4'h8:   rdData4[7:0]    <= x48_Reg[7:0];
            4'h9:   rdData4[7:0]    <= x49_Reg[7:0];
            4'hA:   rdData4[7:0]    <= x4A_Reg[7:0];
            4'hB:   rdData4[7:0]    <= x4B_Reg[7:0];
            4'hC:   rdData4[7:0]    <= x4C_Reg[7:0];
            4'hD:   rdData4[7:0]    <= x4D_Reg[7:0];
            4'hE:   rdData4[7:0]    <= x4E_Reg[7:0];
            4'hF:   rdData4[7:0]    <= x4F_Reg[7:0];
        endcase

        case(irAddr[3:0])
            4'h0:   rdData5[7:0]    <= x50_Reg[7:0];
            4'h1:   rdData5[7:0]    <= x51_Reg[7:0];
            4'h2:   rdData5[7:0]    <= x52_Reg[7:0];
            4'h3:   rdData5[7:0]    <= x53_Reg[7:0];
            4'h4:   rdData5[7:0]    <= x54_Reg[7:0];
            4'h5:   rdData5[7:0]    <= x55_Reg[7:0];
            4'h6:   rdData5[7:0]    <= x56_Reg[7:0];
            4'h7:   rdData5[7:0]    <= x57_Reg[7:0];
            4'h8:   rdData5[7:0]    <= x58_Reg[7:0];
            4'h9:   rdData5[7:0]    <= x59_Reg[7:0];
            4'hA:   rdData5[7:0]    <= x5A_Reg[7:0];
            4'hB:   rdData5[7:0]    <= x5B_Reg[7:0];
            4'hC:   rdData5[7:0]    <= x5C_Reg[7:0];
            4'hD:   rdData5[7:0]    <= x5D_Reg[7:0];
            4'hE:   rdData5[7:0]    <= x5E_Reg[7:0];
            4'hF:   rdData5[7:0]    <= x5F_Reg[7:0];
        endcase
        case(irAddr[3:0])
            4'h0:   rdData6[7:0]    <= x60_Reg[7:0];
            4'h1:   rdData6[7:0]    <= x61_Reg[7:0];
            4'h2:   rdData6[7:0]    <= x62_Reg[7:0];
            4'h3:   rdData6[7:0]    <= x63_Reg[7:0];
            4'h4:   rdData6[7:0]    <= x64_Reg[7:0];
            4'h5:   rdData6[7:0]    <= x65_Reg[7:0];
            4'h6:   rdData6[7:0]    <= x66_Reg[7:0];
            4'h7:   rdData6[7:0]    <= x67_Reg[7:0];
            4'h8:   rdData6[7:0]    <= x68_Reg[7:0];
            4'h9:   rdData6[7:0]    <= x69_Reg[7:0];
            4'hA:   rdData6[7:0]    <= x7A_Reg[7:0];
            4'hB:   rdData6[7:0]    <= x6B_Reg[7:0];
            4'hC:   rdData6[7:0]    <= x6C_Reg[7:0];
            4'hD:   rdData6[7:0]    <= x6D_Reg[7:0];
            4'hE:   rdData6[7:0]    <= x6E_Reg[7:0];
            4'hF:   rdData6[7:0]    <= x6F_Reg[7:0];
        endcase
        
        case(irAddr[3:0])
            4'h0:   rdData7[7:0]    <= x70_Reg[7:0];
            4'h1:   rdData7[7:0]    <= x71_Reg[7:0];
            4'h2:   rdData7[7:0]    <= x72_Reg[7:0];
            4'h3:   rdData7[7:0]    <= x73_Reg[7:0];
            4'h4:   rdData7[7:0]    <= x74_Reg[7:0];
            4'h5:   rdData7[7:0]    <= x75_Reg[7:0];
            4'h6:   rdData7[7:0]    <= x76_Reg[7:0];
            4'h7:   rdData7[7:0]    <= x77_Reg[7:0];
            4'h8:   rdData7[7:0]    <= x78_Reg[7:0];
            4'h9:   rdData7[7:0]    <= x79_Reg[7:0];
            4'hA:   rdData7[7:0]    <= x7A_Reg[7:0];
            4'hB:   rdData7[7:0]    <= x7B_Reg[7:0];
            4'hC:   rdData7[7:0]    <= x7C_Reg[7:0];
            4'hD:   rdData7[7:0]    <= x7D_Reg[7:0];
            4'hE:   rdData7[7:0]    <= x7E_Reg[7:0];
            4'hF:   rdData7[7:0]    <= x7F_Reg[7:0];
        endcase

        case(irAddr[3:0])
            4'h0:   rdData8[7:0]    <= x80_Reg[7:0];
            4'h1:   rdData8[7:0]    <= x81_Reg[7:0];
            4'h2:   rdData8[7:0]    <= x82_Reg[7:0];
            4'h3:   rdData8[7:0]    <= x83_Reg[7:0];
            4'h4:   rdData8[7:0]    <= x84_Reg[7:0];
            4'h5:   rdData8[7:0]    <= x85_Reg[7:0];
            4'h6:   rdData8[7:0]    <= x86_Reg[7:0];
            4'h7:   rdData8[7:0]    <= x87_Reg[7:0];
            4'h8:   rdData8[7:0]    <= x88_Reg[7:0];
            4'h9:   rdData8[7:0]    <= x89_Reg[7:0];
            4'hA:   rdData8[7:0]    <= x8A_Reg[7:0];
            4'hB:   rdData8[7:0]    <= x8B_Reg[7:0];
            4'hC:   rdData8[7:0]    <= x8C_Reg[7:0];
            4'hD:   rdData8[7:0]    <= x8D_Reg[7:0];
            4'hE:   rdData8[7:0]    <= x8E_Reg[7:0];
            4'hF:   rdData8[7:0]    <= x8F_Reg[7:0];
        endcase

        case(irAddr[3:0])
            4'h0:   rdData9[7:0]    <= x90_Reg[7:0];
            4'h1:   rdData9[7:0]    <= x91_Reg[7:0];
            4'h2:   rdData9[7:0]    <= x92_Reg[7:0];
            4'h3:   rdData9[7:0]    <= x93_Reg[7:0];
            4'h4:   rdData9[7:0]    <= x94_Reg[7:0];
            4'h5:   rdData9[7:0]    <= x95_Reg[7:0];
            4'h6:   rdData9[7:0]    <= x96_Reg[7:0];
            4'h7:   rdData9[7:0]    <= x97_Reg[7:0];
            4'h8:   rdData9[7:0]    <= x98_Reg[7:0];
            4'h9:   rdData9[7:0]    <= x99_Reg[7:0];
            4'hA:   rdData9[7:0]    <= x9A_Reg[7:0];
            4'hB:   rdData9[7:0]    <= x9B_Reg[7:0];
            4'hC:   rdData9[7:0]    <= x9C_Reg[7:0];
            4'hD:   rdData9[7:0]    <= x9D_Reg[7:0];
            4'hE:   rdData9[7:0]    <= x9E_Reg[7:0];
            4'hF:   rdData9[7:0]    <= x9F_Reg[7:0];
        endcase

        case(irAddr[3:0])
            4'h0:   rdDataA[7:0]    <= xA0_Reg[7:0];
            4'h1:   rdDataA[7:0]    <= xA1_Reg[7:0];
            4'h2:   rdDataA[7:0]    <= xA2_Reg[7:0];
            4'h3:   rdDataA[7:0]    <= xA3_Reg[7:0];
            4'h4:   rdDataA[7:0]    <= xA4_Reg[7:0];
            4'h5:   rdDataA[7:0]    <= xA5_Reg[7:0];
            4'h6:   rdDataA[7:0]    <= xA6_Reg[7:0];
            4'h7:   rdDataA[7:0]    <= xA7_Reg[7:0];
            4'h8:   rdDataA[7:0]    <= xA8_Reg[7:0];
            4'h9:   rdDataA[7:0]    <= xA9_Reg[7:0];
            4'hA:   rdDataA[7:0]    <= xAA_Reg[7:0];
            4'hB:   rdDataA[7:0]    <= xAB_Reg[7:0];
            4'hC:   rdDataA[7:0]    <= xAC_Reg[7:0];
            4'hD:   rdDataA[7:0]    <= xAD_Reg[7:0];
            4'hE:   rdDataA[7:0]    <= xAE_Reg[7:0];
            4'hF:   rdDataA[7:0]    <= xAF_Reg[7:0];
        endcase


        regRv[10:0] <= (irRe    ? regCs[10:0] : 11'd0);
        regAck      <= (|regCs[10:0]) & (irWe | irRe);
    end

    reg             orAck       ;
    reg     [7:0]   orRd        ;

    always @(posedge CLK) begin
        orAck       <= regAck;
        orRd[7:0]   <=  (regRv[0]   ? rdData0[7:0]  : 8'd0)|
                        (regRv[1]   ? rdData1[7:0]  : 8'd0)|
                        (regRv[2]   ? rdData2[7:0]  : 8'd0)|
                        (regRv[3]   ? rdData3[7:0]  : 8'd0)|
                        (regRv[4]   ? rdData4[7:0]  : 8'd0)|
                        (regRv[5]   ? rdData5[7:0]  : 8'd0)|
                        (regRv[6]   ? rdData6[7:0]  : 8'd0)|
                        (regRv[7]   ? rdData7[7:0]  : 8'd0)|
                        (regRv[8]   ? rdData8[7:0]  : 8'd0)|
                        (regRv[9]   ? rdData9[7:0]  : 8'd0)|
                        (regRv[10]  ? rdDataA[7:0]  : 8'd0);
    end

    assign  LOC_ACK     = orAck;
    assign  LOC_RD[7:0] = orRd[7:0];

endmodule



