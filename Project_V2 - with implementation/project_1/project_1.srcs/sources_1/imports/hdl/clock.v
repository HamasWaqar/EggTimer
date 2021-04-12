`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University 
// Engineer: Hamas Waqar
// 
// Create Date: 03/28/2021 03:34:24 PM
// Design Name: Egg Timer
// Module Name: clock
// Project Name: 
// Target Devices: NEXYS A7 100 T
// Tool Versions: 
// Description: Clock Divider - Output two syncronous clocks at 500 Hz and 1 Hz fro the BCD Display and the 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module clock (
    input CLK100Mhz,
    input reset,
    output reg pulse_500Hz,
    output reg pulse_2dot5MHz,
    output reg pulse_100Hz,
    output reg pulse_17MHz,
    output reg pulse_1Hz
    );
    
    wire clk_5MHz, clk_17MHz;
    reg [25:0] divider_count_500Hz = 10000;
    reg [25:0] divider_count_1Hz = 5000000;
    reg divider_count_2dot5Hz = 1;
    reg [14:0] divider_count_100Hz = 25000;
    reg divider_count_17MHz = 1;
    
      
       clk_wiz_0 dormammu
        (
         // Clock out ports
         .clk_out1(clk_5MHz),     // output clk_out1
         .clk_out2(clk_17MHz),
         // Status and control signals
         .locked(locked),       // output locked
        // Clock in ports
         .clk_in1(CLK100Mhz));      // input clk_in1

       //assign pulse_17MHz = clk_17MHz;
       
       always @(posedge clk_17MHz) begin
              if (reset)
               pulse_17MHz <= 0;
              else if (divider_count_17MHz == 0) begin
                  divider_count_17MHz <= 1;
                  pulse_17MHz = ~pulse_17MHz;
              end
              else divider_count_17MHz <= divider_count_17MHz - 1;    
      end
       
       always @(posedge clk_5MHz) begin
               if (reset)
                pulse_500Hz <= 0;
               else if (divider_count_500Hz == 0) begin
                   divider_count_500Hz <= 5000;
                   pulse_500Hz = ~pulse_500Hz;
               end
               else divider_count_500Hz <= divider_count_500Hz - 1;    
       end
       
       
       always @(posedge clk_5MHz) begin
              if (reset)
                pulse_1Hz <= 0;
              else if (divider_count_1Hz == 0) begin
                  divider_count_1Hz <= 2500000;
                  pulse_1Hz = ~pulse_1Hz;
              end
              else divider_count_1Hz <= divider_count_1Hz - 1;   
      end
      
      
      always @ (posedge clk_5MHz or posedge reset) begin
              if (reset) begin
                  pulse_2dot5MHz <= 0;
                  divider_count_2dot5Hz <= 1;
             end else begin
                  if (divider_count_2dot5Hz == 0) begin
                      divider_count_2dot5Hz <= 1;
                      pulse_2dot5MHz <= ~pulse_2dot5MHz;
                  end else 
                      divider_count_2dot5Hz <= divider_count_2dot5Hz - 1;
             end   
                  
           end
           
           always @ (posedge clk_5MHz or posedge reset) begin
                   if (reset) begin
                       pulse_100Hz <= 0;
                       divider_count_100Hz <= 25000;
                  end else begin
                       if (divider_count_100Hz == 0) begin
                           divider_count_100Hz <= 25000;
                           pulse_100Hz <= ~pulse_100Hz;
                       end else 
                           divider_count_100Hz <= divider_count_100Hz - 1;
                  end        
           end
      
        
      //assign pulse_500Hz = (divider_count_500Hz == 0) ? 1 : 0;
      //assign pulse_1Hz = (divider_count_1Hz == 0) ? 1 : 0;

endmodule