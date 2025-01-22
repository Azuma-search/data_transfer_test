`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/20 12:13:32
// Design Name: 
// Module Name: SWITCHER
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

            
module FLOW_RATE_ADJUSTMENT(
    input   Rst,
    input   Clk,
    input   [6:0]   TargetFlowDisableRate,
    input   Flow,
    output  Rdy
    );
    wire [127:0] enableIndex;
    assign  enableIndex[0]         =   {1{~TargetFlowDisableRate[0]}};
    assign  enableIndex[2:1]       =   {2{~TargetFlowDisableRate[1]}};
    assign  enableIndex[6:3]       =   {4{~TargetFlowDisableRate[2]}};
    assign  enableIndex[15:7]      =   {8{~TargetFlowDisableRate[3]}};
    assign  enableIndex[31:16]     =   {16{~TargetFlowDisableRate[4]}};
    assign  enableIndex[63:32]     =   {32{~TargetFlowDisableRate[5]}};
    assign  enableIndex[127:64]    =   {64{~TargetFlowDisableRate[6]}};
    
    reg [127:0] targetEnableIndex;
    reg [8:0]   counter;
   always @(posedge Clk) begin
        if(Rst) begin
            counter             <=  '0;
            targetEnableIndex   <=  enableIndex;
        end else begin
            targetEnableIndex <=  {targetEnableIndex[0],targetEnableIndex[$bits(targetEnableIndex)-1:1]};
            if(Flow != targetEnableIndex[0] ) begin
                if( Flow ) begin
                    counter <=  counter + {{$bits(counter)-1{1'b0}},~counter[$bits(counter)-1]}; // increment
                end else begin
                    if( counter!='0 ) begin
                        counter <=  counter -   {{$bits(counter)-1{1'b0}},1'b1};
                    end
                end
            end
        end
    end
    assign  Rdy =   ~counter[8];
    
endmodule
