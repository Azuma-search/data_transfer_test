`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Azuma Ryuto
// 
// Create Date: 2023/09/22 13:25:39
// Design Name: 
// Module Name: TEST_FIFO
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


module TEST_FIFO(
    input   CLK,
    input   WrClk,
    input   RST,
    input   TCP_TX_FULL,      
    input   RegWrTrg,       //VIO_WR_TRG
    input   [7:0]  RegDataNumber,  //VIO_DATA_LENGTH,
    //input   [4:0]   RegDataLength, 
    input   RegReadyEnb,     //VIO_READY_ENB,
    input   [6:0]   TargetFlowDisableRate,
    input   Nim_in,
    output  reg Nim_out,
    output  reg [7:0] syncFifoDout,
    output  reg [7:0] SiTcpFifoWrData,
    output  reg [23:0] count_event_number,
    output  reg [23:0] counter_data,
    output  reg  [6:0] PAUSE_counter,
    output  TCP_TX_WR,
    output  [7:0]   TCP_TX_DATA,
    output   syncFifoFull,
    output   syncFifoAlmostFull,
    output   syncFifoEmpty,
    output   syncFifoAlmostEmpty,
    output   syncFifoValid,  
    output   SiTcpFifoValid,
    output   SiTcpFifoFull,
    output   SiTcpFifoAlmostFull,
    output   wr_rst_busy,
    output   rd_rst_busy,
    input   [31:0]  MY_IP_ADDR
    //output SiTcpFifoEmpty,
       /*
    output   [6:0]   TargetFlowDisableRate,
    input   Flow,
    output  Rdy,
    */
     /*
     .probe_in0(syncFifoValid),
     probe_in1(syncFifoDout[7:0]),
      .probe_in2(syncFifoFull),
      .probe_in3(syncFifoAlmostFull),
      .probe_in4(syncFifoEmpty),
      .probe_in5(syncFifoAlmostEmpty),
      .probe_in6(SiTcpFifoValid),
      .probe_in7(SiTcpFifoWrData[7:0]),
      .probe_in8(count_event_number[23:0]),
      .probe_in9(TCP_WR_TRG),
      .probe_in10(STATE),
      .probe_in11(counter_40ms[23:0]),
      .probe_in12(time_counter[23:0]),
      */
    //output   reg  [28:0] counter_40ms
      /*
      .wr_en(syncFifoWrEn),                // input wire wr_en
      .rd_en(syncFifoRdEn),                // input wire rd_en
      .dout(syncFifoDout),                  // output wire [7 : 0] dout
      .full(syncFifoFull),                  // output wire full
      .almost_full(syncFifoAlmostFull),    // output wire almost_full
      .wr_ack(syncFifoWrAck),              // output wire wr_ack
      .empty(syncFifoEmpty),                // output wire empty
      .almost_empty(syncFifoAlmostEmpty),  // output wire almost_empty
      .valid(syncFifoValid)                // output wire valid
      */
     
    );


//---------------------------------------------------------------------
// common clock FIFO
//---------------------------------------------------------------------
reg     syncFifoWrEn;
//reg [7:0]   syncFifoDin;

reg     syncFifoRdEn;
/*
wire    VIO_WR_TRG;
wire    [23:0]VIO_DATA_LENGTH;
wire    VIO_READY_ENB;
*/
//wire    syncFifoFull;
//wire    syncFifoAlmostFull;
//wire    syncFifoEmpty;
//wire    syncFifoAlmostEmpty;
//wire    syncFifoValid;
wire    syncFifoWrAck;
//wire    [7:0]   syncFifoDout;
//wire    VIO_RST;
/*
   wire SiTcpFifoEmpty;
   wire SiTcpFifoValid;
   
   wire    SiTcpFifoFull;
   wire    SiTcpFifoAlmostFull;   
   reg wr_rst_busy;
   reg rd_rst_busy;
   reg [7:0] SiTcpFifoWrData;
 */ 

/*
sync_fifo_w8_d2048 sync_fifo_w8_d2048 (

  .clk(CLK),                    // input wire clk
  .srst(VIO_RST),                  // input wire srst
  .din(syncFifoDin[7:0]),                    // input wire [7 : 0] din
  .wr_en(syncFifoWrEn),                // input wire wr_en
  .rd_en(syncFifoRdEn),                // input wire rd_en
  .dout(syncFifoDout),                  // output wire [7 : 0] dout
  .full(syncFifoFull),                  // output wire full
  .almost_full(syncFifoAlmostFull),    // output wire almost_full
  .wr_ack(syncFifoWrAck),              // output wire wr_ack
  .empty(syncFifoEmpty),                // output wire empty
  .almost_empty(syncFifoAlmostEmpty),  // output wire almost_empty
  .valid(syncFifoValid),                // output wire valid
   .sitcp_valid(SiTcpFifoValid),
   .sitcp_din(SiTcpFifoWrData[7:0]),
   .counter_event_number(count_event_number[23:0]),
   .counter_data(counter_data[23:0]),
   .sitcp_full(SiTcpFifoFull),
   .sitcp_alfull(SiTcpFifoAlmostFull),
   .sitcp_empty(SiTcpFifoEmpty),
   .wr_rst(wr_rst_busy),
   .rd_rst(rd_rst_busy),
   .pause_counter(PAUSE_counter[6:0])
*/
sync_fifo_w8_d2048 sync_fifo_w8_d2048 (
  .clk(CLK),                    // input wire clk
  .srst(RST),                  // input wire srst
  .din(syncFifoDin[7:0]),                    // input wire [7 : 0] din
  .wr_en(syncFifoWrEn),                // input wire wr_en
  .rd_en(syncFifoRdEn),                // input wire rd_en
  .dout(syncFifoDout[7:0]),                  // output wire [7 : 0] dout
  .prog_full(syncFifoFull),                  // output wire full
  .almost_full(syncFifoAlmostFull),    // output wire almost_full
  .wr_ack(syncFifoWrAck),              // output wire wr_ack
  .empty(syncFifoEmpty),                // output wire empty
  .almost_empty(syncFifoAlmostEmpty),  // output wire almost_empty
  .valid(syncFifoValid)                // output wire valid


);

//---------------------------------------------------------------------
// independent clock FIFO
//---------------------------------------------------------------------
/*
reg     asyncFifoWrEn;
reg [7:0]   asyncFifoDin;
reg     asyncFifoRdEn;
wire    asyncFifoFull;
wire    asyncFifoAlmostFull;
wire    asyncFifoEmpty;
wire    asyncFifoAlmostEmpty;
wire    asyncFifoValid;
wire    asyncFifoWrAck;
wire    [7:0]   asyncFifoDout;


async_fifo_w8_d2048 async_fifo_w8_d2048 (
  .rst(RST),                    // input wire rst
  .wr_clk(WrClk),              // input wire wr_clk
  .rd_clk(CLK),              // input wire rd_clk
  .din(asyncFifoDin[7:0]),                    // input wire [7 : 0] din
  .wr_en(asyncFifoWrEn),                // input wire wr_en
  .rd_en(asyncFifoRdEn),                // input wire rd_en
  .dout(asyncFifoDout[7:0]),                  // output wire [7 : 0] dout
  .full(asyncFifoFull),                  // output wire full
  .almost_full(asyncFifoAlmostFull),    // output wire almost_full
  .wr_ack(asyncFifoWrAck),              // output wire wr_ack
  .empty(asyncFifoEmpty),                // output wire empty
  .almost_empty(asyncFifoAlmostEmpty),  // output wire almost_empty
  .valid(asyncFifoValid)                // output wire valid
);
*/


   reg    SiTcpFifoRdEnb;
/*
   wire SiTcpFifoEmpty;
   wire SiTcpFifoValid;
   
   wire    SiTcpFifoFull;
   wire    SiTcpFifoAlmostFull;   
   reg wr_rst_busy;
   reg rd_rst_busy;  
   */
   // [7:0] SiTcpFifoWrData;
   

   //assign  SiTcpFifoRdEnb  =   ~SiTcpFifoEmpty;

   //reg SiTcpFifoWrAck;
    parameter PAUSE = 5'h0;
    parameter HEADER1 = 5'h1;
    parameter HEADER2 = 5'h2;
    parameter HEADER3 = 5'h3;
    parameter HEADER4 = 5'h4;
    parameter HEADER5 = 5'h5;
    parameter HEADER6 = 5'h6;
    parameter HEADER7 = 5'h7;
    parameter HEADER8 = 5'h8;
    parameter HEADER9 = 5'h9;
    parameter HEADER10 = 5'ha;
    parameter DATA1 = 5'hb;
    parameter DATA2 = 5'hc;
    parameter DATA3 = 5'hd;
    parameter DATA4 = 5'he;
    parameter DATA5 = 5'hf;
    parameter FOOTER1 = 5'h10;
    parameter FOOTER2 = 5'h11;
    parameter FOOTER3 = 5'h12;
    parameter FOOTER4 = 5'h13;
    parameter FOOTER5 = 5'h14;
    parameter FOOTER6 = 5'h15;
    parameter FOOTER7 = 5'h16;
    parameter FOOTER8 = 5'h17;
    parameter FOOTER9 = 5'h18;
    parameter FOOTER10 = 5'h19;
/*
    reg [23:0] count_event_number;
    reg [23:0] counter_data;
    reg [6:0] PAUSE_counter;
   */
    //HEADER
    //parameter FIXED_WORD_HEADER = 2'b10;
    wire [1:0]  FIXED_WORD_HEADER;
    assign FIXED_WORD_HEADER = 2'b10;
    //FIXED_WORD_HEADER[1];
    wire [7:0]  AddressOutsideFrbs;
    assign AddressOutsideFrbs = 8'b10101010;
    wire [1:0]  ModeSelection;
    assign ModeSelection = 2'b00;
    wire  IsEnableZeroSuppression;
    assign IsEnableZeroSuppression = 1'b0;
    wire [16:0]  Empty;
    assign Empty = 17'b0;
    wire  IsEnableTimeWindow;
    assign IsEnableTimeWindow = 1'b0;
    reg  [23:0]  EventNumber;
    //assign EventNumber = count_event_number;
    reg  IsLastReadfromLargeFifo;
    //assign IsLastReadfromLargeFifo = 1'b0;
    //reg  IsContinueEvent;
    //assign IsContinueEvent = 1'b0;
    wire [23:0]  SetDataLength;
    //assign DataLength = 24'd1000;    
    //assign SetDataLength = 24'b10011100010000;
    assign SetDataLength = 24'd10000;
    wire [7:0]  DataNumber;
    assign DataNumber = RegDataNumber;
    wire [23:0]  DataLength;
    assign DataLength = DataNumber * SetDataLength;
    //DATA
    wire [1:0]  FIXED_WORD_DATA;
    assign FIXED_WORD_DATA = 2'b00;
    wire [4:0]  ASIC_ID;
    assign ASIC_ID = 5'b00100;    
    wire [6:0]  Channel_ID;
    assign Channel_ID = 7'b0011100;
    wire [12:0]  Leading_Edge;
    assign Leading_Edge = 13'b1010101010101;
    wire [12:0]  Trailing_Edge;
    assign Trailing_Edge = 13'b0000011100000;  

    //FOOTER
    wire [1:0]  FIXED_WORD_FOOTER;
    assign FIXED_WORD_FOOTER = 2'b11;  

    reg [23:0]   datan_counter;        
    reg SiTcpFifoWrEnb;
    reg TCP_WR_TRG;
    reg [23:0]  counter_40ms;

    reg [5:0]   STATE;
    //reg [7:0]   counter;
    reg [23:0]  time_counter;
    reg [23:0]  current_time;
    reg [23:0]  rst_counter;
    reg Delay_Rst;
    //reg [6:0]   TargetFlowDisableRate;
    wire Rdy;
    
    FLOW_RATE_ADJUSTMENT FLOW_RATE_ADJUSTMENT(
    .Rst(RST),
    .Clk(CLK),
    .TargetFlowDisableRate(TargetFlowDisableRate),
    .Flow(TCP_TX_WR),
    .Rdy(Rdy)
    );
    
    /*
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
    */
/*always @(posedge CLK) begin

  if(RST) begin
      counter             <=  '0;
  end else begin
      counter [7:0]       <=  counter [7:0]   +   8'b1;
      
      if (TCP_WR_TRG) begin
          //syncFifoWrEn        <=  1'b1;
          //syncFifoDin[7:0]    <= SiTcpFifoWrData[7:0];
          //syncFifoDin[7:0]    <=  counter[7:0];
      end else begin
          //syncFifoWrEn        <=  1'b0;
      end
      
  end
  
end
*/

always@(posedge CLK)begin
    if(RST == 1'b1)begin
        rst_counter <= '0;
        Delay_Rst   <=  1'b0;
        //Nim_out     <=  1'b0;
    end else if(RST == 1'b0)begin
        //rst_counter <= rst_counter + {23'b0,~rst_counter[23]};
        rst_counter <= rst_counter + 24'b1;
        if(rst_counter == 24'd1000)begin
            Delay_Rst <=1'b1;
        end
    end
end
/*   
always@(posedge CLK) begin
    if(Delay_Rst == 1'b0  ||  VIO_WR_TRG == 1'b0) begin
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
*/
/*0703
always@(posedge CLK) begin
    if(Delay_Rst == 1'b0)begin // reset
        count_event_number[23:0]    <=  '0;
        counter_40ms[23:0]          <=  24'b1;
    //end else if(Delay_Rst == 1'b1|| RegWrTrg == 1'b1) begin
    end else if(Delay_Rst == 1'b1) begin
    
        if(counter_40ms[23:0]    ==      24'b010110111000110110000000)begin 
            counter_40ms    <=  24'b0;
            count_event_number  <=  count_event_number  +   24'b1; 
        end else begin
            counter_40ms[23:0] <= counter_40ms[23:0] + 24'b1;
        end
     end
 end
  */

 
 always@(posedge CLK) begin
    if(Delay_Rst == 1'b0 || (Nim_in == 1'b0 && RegWrTrg == 1'b0))begin // reset
        count_event_number[23:0]    <=  '0;
        counter_40ms[23:0]          <=  24'b1;
        Nim_out                     <=  '0;
    end else if(Nim_in == 1'b1 ||RegWrTrg == 1'b1) begin
        Nim_out                     <=  1'b1;
        if(counter_40ms[23:0]    ==      24'b010110111000110110000000)begin 
            counter_40ms    <=  24'b0;
            count_event_number  <=  count_event_number  +   24'b1; 
        end else begin
            counter_40ms[23:0] <= counter_40ms[23:0] + 24'b1;
        end
     end
 end
 
always@(posedge CLK)begin
    if(Delay_Rst == 1'b0 || (Nim_in == 1'b0 && RegWrTrg == 1'b0))begin // reset
    //if(Delay_Rst == 1'b0)begin // reset

      //if(VIO_WR_TRG == 1'b0)begin // reset 
        time_counter[23:0]  <=   24'b0;
    end else begin
        if(STATE == PAUSE   &&  (Nim_in == 1'b1 ||RegWrTrg == 1'b1)  &&  counter_40ms[23:0]  ==  24'b0)begin
       // if(STATE == PAUSE  &&  counter_40ms[23:0]  ==  24'b0)begin
            time_counter[23:0]  <=  24'b1;
        end else if(time_counter[23:0]!='0) begin
            //time_counter[23:0]  <=  time_counter[23:0]  + {23'b0,~time_counter[23]};
            time_counter[23:0]  <=  time_counter[23:0]  + {23'b0,~&time_counter[23:0]};
        end
    end
end
always@(posedge CLK) begin
 
   // if(RST || wr_rst_busy == 1'b1 || rd_rst_busy == 1'b1) begin
      //if(RST ==1'b1)begin
      if(RST == 1'b1)begin
        STATE                   <=  PAUSE;
        syncFifoWrEn            <=  1'b0;
        SiTcpFifoWrData[7:0]    <=  8'b0;
        counter_data            <=  24'b0;
        PAUSE_counter           <=  7'b0;
        current_time            <=  24'b0;
        IsLastReadfromLargeFifo <=  1'b0;
        datan_counter           <=  1'b0;
        EventNumber[23:0]           <=  24'b1;
    end else if(syncFifoAlmostFull == 1'b0) begin
        case (STATE)
            PAUSE : begin
                syncFifoWrEn  <=  1'b0;
                datan_counter <=  1'b0;
                if((Nim_in == 1'b1 ||RegWrTrg == 1'b1) && counter_40ms[23:0] == 24'b0 )begin
                    if(IsLastReadfromLargeFifo == 1'b1)begin
                        IsLastReadfromLargeFifo <= 1'b0;
                    end
                    STATE <= HEADER1;

           
                    
                end
                           
            end
            HEADER1 : begin
            TCP_WR_TRG  <= 1'b1;
                STATE <= HEADER2;
                syncFifoWrEn            <=  1'b1;
                datan_counter           <=  datan_counter   +   1'b1;
                SiTcpFifoWrData[7:0]    <=  {FIXED_WORD_HEADER, AddressOutsideFrbs[7:2]}; // dummy data
            end
            HEADER2 : begin
                STATE <= HEADER3;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {AddressOutsideFrbs[1:0], ModeSelection, IsEnableZeroSuppression, Empty[16:14]}; // dummy data
            end
            HEADER3 : begin
                STATE <= HEADER4;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {Empty[13:6]}; // dummy data
            end
            HEADER4 : begin
                STATE <= HEADER5;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {Empty[5:0], IsEnableTimeWindow, EventNumber[23]}; // dummy data
            end
            HEADER5 : begin
                STATE <= HEADER6;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {EventNumber[22:15]}; // dummy data
            end       
            HEADER6 : begin
                STATE <= HEADER7;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {EventNumber[14:7]}; // dummy data
            end
            HEADER7 : begin
                STATE <= HEADER8;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {EventNumber[6:0], IsLastReadfromLargeFifo}; // dummy data
            end                  
            HEADER8 : begin
                STATE <= HEADER9;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {SetDataLength[23:16]}; // dummy data
            end
            HEADER9 : begin
                STATE <= HEADER10;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {SetDataLength[15:8]}; // dummy data
            end
            HEADER10 : begin
                STATE <= DATA1;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {SetDataLength[7:0]}; // dummy data
                counter_data    <=  24'b0;
            end

            /*
            HEADER8 : begin
                STATE <= HEADER9;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {DataLength[23:16]}; // dummy data
            end
            HEADER9 : begin
                STATE <= HEADER10;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {DataLength[15:8]}; // dummy data
            end
            HEADER10 : begin
                STATE <= DATA1;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {DataLength[7:0]}; // dummy data
                counter_data    <=  24'b0;
            end
*/
            DATA1 : begin
                STATE <= DATA2;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {FIXED_WORD_DATA, ASIC_ID, Channel_ID[6]}; // dummy data
                counter_data    <=  counter_data    +   24'b1;
            end
            DATA2 : begin
                STATE <= DATA3;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {Channel_ID[5:0], Leading_Edge[12:11]}; // dummy data
            end
            DATA3 : begin
                STATE <= DATA4;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {Leading_Edge[10:3]}; // dummy data
            end
            DATA4 : begin
                STATE <= DATA5;
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {Leading_Edge[2:0], Trailing_Edge[12:8]}; // dummy data
            end
            DATA5 : begin
                syncFifoWrEn          <=  1'b1;
                SiTcpFifoWrData[7:0]    <=  {Trailing_Edge[7:0]}; // dummy data
                
                /*if( counter_data    ==  24'd1000) begin
                   STATE    <=  FOOTER1;
                end else if( counter_data    <  24'd1000) begin
                   STATE <= DATA1;
                end
                */
                if( STATE == DATA5 && counter_data  ==  SetDataLength) begin
                       STATE    <=  FOOTER1;
                end else if(STATE == DATA5 && counter_data    <  SetDataLength) begin
                       STATE <= DATA1;
                end
            end 
            
             FOOTER1 : begin
                 STATE <= FOOTER2;
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]  <=  {FIXED_WORD_FOOTER, AddressOutsideFrbs[7:2]}; // dummy data
                 //IsContinueEvent       <=  1'b1;
                 if(STATE == FOOTER1 && IsLastReadfromLargeFifo == 1'b1)begin
                    EventNumber         <=  count_event_number;
                 end
                 if(STATE == FOOTER1 && datan_counter == DataNumber)begin
                    current_time        <=  time_counter;
                 end
                            //IsContinueEvent       <=  1'b0;
             end
             FOOTER2 : begin
                 STATE <= FOOTER3;
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {AddressOutsideFrbs[1:0], ModeSelection, IsEnableZeroSuppression, current_time[23:21]}; // dummy data
             end
             FOOTER3 : begin
                 STATE <= FOOTER4;
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {current_time[20:13]}; // dummy data
             end
             FOOTER4 : begin
                 STATE <= FOOTER5;
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {current_time[12:7], IsEnableTimeWindow, EventNumber[23]}; // dummy data
             end
             FOOTER5 : begin
                 STATE <= FOOTER6;
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {EventNumber[22:15]}; // dummy data
             end       
             FOOTER6 : begin
                 STATE <= FOOTER7;
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {EventNumber[14:7]}; // dummy data
             end
             FOOTER7 : begin
                 STATE <= FOOTER8;
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {EventNumber[6:0], IsLastReadfromLargeFifo}; // dummy data
             end                  
             FOOTER8 : begin
                 STATE <= FOOTER9;
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {SetDataLength[23:16]}; // dummy data
             end
             FOOTER9 : begin
                 STATE <= FOOTER10;
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {SetDataLength[15:8]}; // dummy data
             end
             FOOTER10 : begin
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {SetDataLength[7:0]}; // dummy data
                 //count_event_number <= count_event_number + 24'b1;
                 if(FOOTER10 && datan_counter < DataNumber - 1)begin
                    STATE <= HEADER1;
                 end else if(FOOTER10 && datan_counter == DataNumber - 1)begin
                    STATE <= HEADER1;
                    IsLastReadfromLargeFifo <= 1'b1;
                 end else if(FOOTER10 && datan_counter == DataNumber)begin
                     STATE <= PAUSE;
                     counter_data   <=  24'b0;
                 end                 
             end

/*
             FOOTER8 : begin
                 STATE <= FOOTER9;
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {DataLength[23:16]}; // dummy data
             end
             FOOTER9 : begin
                 STATE <= FOOTER10;
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {DataLength[15:8]}; // dummy data
             end
             FOOTER10 : begin
                 syncFifoWrEn          <=  1'b1;
                 SiTcpFifoWrData[7:0]    <=  {DataLength[7:0]}; // dummy data
                 //count_event_number <= count_event_number + 24'b1;
                 if(FOOTER10 && datan_counter < DataNumber - 1)begin
                    STATE <= HEADER1;
                 end else if(FOOTER10 && datan_counter == DataNumber - 1)begin
                    STATE <= HEADER1;
                    IsLastReadfromLargeFifo <= 1'b1;
                 end else if(FOOTER10 && datan_counter == DataNumber)begin
                     STATE <= PAUSE;
                     counter_data   <=  24'b0;
                 end                 
             end
  */                                              
        endcase
        // ...... dummy data input to SITCP_FIFO
    end else begin
        syncFifoWrEn          <=  1'b0; 
    end
end
//---------------------------------------------------------------------
// Virtual IO (VIO)
//---------------------------------------------------------------------
wire    VIO_WR_EN;
wire    [7:0]   VIO_DOUT;
wire            VIO_VALID;
//wire    VIO_WR_TRG;
//wire    VIO_RD_TRG;
//wire    VIO_WRRD_TRG;
//wire    VIO_RST;
/*
wire    SiTcpFifoValid;
wire    SiTcpFifoFull;
wire    SiTcpFifoAlmostFull;
wire    SiTcpFifoEmpty;
wire    wr_rst_busy;
wire    rd_rst_busy;
*/
/*
VIO_TEST_FIFO VIO_TEST_FIFO (
  .clk(CLK), // input wire clk
  .probe_in0(syncFifoValid),
  .probe_in1(syncFifoDout[7:0]),
  .probe_in2(syncFifoFull),
  .probe_in3(syncFifoAlmostFull),
  .probe_in4(syncFifoEmpty),
  .probe_in5(syncFifoAlmostEmpty),
  .probe_in6(SiTcpFifoValid),
  .probe_in7(SiTcpFifoWrData[7:0]),
  .probe_in8(count_event_number[23:0]),
  .probe_in9(TCP_WR_TRG),
  .probe_in10(STATE),
  .probe_in11(counter_40ms[23:0]),
  .probe_in12(time_counter[23:0]),
  .probe_out0(VIO_WR_TRG),
  .probe_out1(VIO_DATA_LENGTH),
  .probe_out2(VIO_READY_ENB),
  .probe_out3(TargetFlowDisableRate[6:0])
  
  .probe_in9(counter_data[23:0]),
  .probe_in10(SiTcpFifoFull),
  .probe_in11(SiTcpFifoAlmostFull),
  .probe_in12(SiTcpFifoEmpty),
  .probe_in13(wr_rst_busy),
  .probe_in14(rd_rst_busy),
  .probe_in15(PAUSE_counter[6:0]),
  
 // .probe_out0(VIO_WR_TRG),

 // .probe_out2(VIO_WRRD_TRG),
  //.probe_out1(VIO_RST)
  
);
  */

assign  syncFifoRdEn    =   ~TCP_TX_FULL & ~syncFifoEmpty & (Rdy || ~RegReadyEnb);
assign  TCP_TX_WR   =   syncFifoValid;
assign  TCP_TX_DATA[7:0]   = syncFifoDout[7:0];

    wire [7:0]syncFifoDin;
    assign  syncFifoDin[7:0]    =   SiTcpFifoWrData[7:0];

/*
assign  syncFifoRdEn    =   ~TCP_TX_FULL & (VIO_RD_TRG | VIO_WRRD_TRG) & ~syncFifoEmpty;

    reg [7:0]   counter;
    always @(posedge CLK) begin
        if(VIO_RST) begin
            TCP_TX_WR           <=  1'b0;
            TCP_TX_DATA[7:0]    <=  '0;
            counter             <=  '0;
        end else begin
            counter [7:0]       <=  counter [7:0]   +   8'b1;
            if (VIO_WR_TRG | VIO_WRRD_TRG) begin
                syncFifoWrEn        <=  1'b1;
                syncFifoDin[7:0]    <= 
                //syncFifoDin[7:0]    <=  counter[7:0];
            end else begin
                syncFifoWrEn        <=  1'b0;
            end
        end
    end
*/


//---------------------------------------------------------------------
// Integrated Logic Analyzer (ILA)
//---------------------------------------------------------------------

ILA_TEST_FIFO ILA_TEST_FIFO (
	.clk(CLK), // input wire clk
	.probe0(RST),
	.probe1(TCP_TX_FULL),
	.probe2(syncFifoWrEn), 
	.probe3(syncFifoDin[7:0]), 
	.probe4(syncFifoRdEn), 
	.probe5(syncFifoDout[7:0]),
	.probe6(syncFifoValid),
	.probe7(syncFifoFull),
	.probe8(syncFifoAlmostFull),
	.probe9(syncFifoEmpty),
	.probe10(syncFifoAlmostEmpty),
	.probe11(syncFifoWrAck),
	.probe12(SiTcpFifoWrData[7:0]),
	.probe13(count_event_number[23:0]),
	.probe14(counter_data[23:0]),
    .probe15(PAUSE_counter[6:0]),
    .probe16(TCP_TX_WR),
    .probe17(TCP_TX_DATA[7:0]),
    .probe18(TCP_WR_TRG),
    .probe19(STATE[5:0]),
    .probe20(RegWrTrg),
    .probe21(counter_40ms[23:0]),
    .probe22(time_counter[23:0]),
    .probe23(RegDataNumber[7:0]),
    .probe24(RegReadyEnb),
    .probe25(current_time[23:0]),
    .probe26(rst_counter[23:0]),
    .probe27(Delay_Rst),
    .probe28(TargetFlowDisableRate),
    .probe29(MY_IP_ADDR[31:0]),
    .probe30(IsLastReadfromLargeFifo),
    .probe31(DataLength[23:0]),
    .probe32(datan_counter[23:0]),
    .probe33(Nim_in),
    .probe34(Nim_out)
    
    //.probe28(SiTcpFifoValid)
    //.probe12(SiTcpFifoValid),
);

endmodule
