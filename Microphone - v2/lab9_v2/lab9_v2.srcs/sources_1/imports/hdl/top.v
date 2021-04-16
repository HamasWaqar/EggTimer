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


module top(
    input CLK100MHZ,
    output reg [15:0] LED,
    input reset,
    input enable,
    output M_CLK,
    input M_DATA,
    output M_LRSEL
    );  

    
    wire clk_5MHz;
    reg clk_2dot5MHz = 0;
    reg clk_100kHz = 0;
    reg counter = 0;
    reg [14:0] counter2 = 0;
    
    
      clk_wiz_0 demo_clk(
      // Clock out ports
      .clk_out1(clk_5MHz),     // output clk_out1
     // Clock in ports
      .clk_in1(CLK100MHZ));      // input clk_in1
      
     always @ (posedge clk_5MHz or posedge reset) begin
        if (reset) begin
            clk_2dot5MHz <= 0;
            counter <= 0;
       end else begin
            if (counter == 1) begin
                counter <= 0;
                clk_2dot5MHz <= ~clk_2dot5MHz;
            end else 
                counter <= counter + 1;
       end   
            
     end
     
     always @ (posedge clk_5MHz or posedge reset) begin
             if (reset) begin
                 clk_100kHz <= 0;
                 counter2 <= 0;
            end else begin
                 if (counter2 >= 25) begin
                     counter2 <= 0;
                     clk_100kHz <= ~clk_100kHz;
                 end else 
                     counter2 <= counter2 + 1;
            end        
     end
     
        
        
     
     reg [3:0] sampling_period;
     reg sampled_pwm_input;
     
     reg FD_in;
     
     // n = Fin/Fout = 100 KHz / 60Khz = 5/3
     always @ (posedge clk_100kHz or posedge reset) begin
        if (reset) begin
            sampling_period <= 0;
            sampled_pwm_input <= 0;
            //FD_in <= 0;
        end else begin
            sampling_period <= 0;
            sampled_pwm_input <= M_DATA;
            //FD_in <= 1;
        end
     end
     
     assign M_CLK = clk_2dot5MHz;
     assign M_LRSEL = 1'b1;
    
    // 
     wire [7:0] real_input ;
     wire [7:0] img_input ;
     wire [7:0] real_output ;
     wire [7:0] img_output ;
     wire FD_OUT;
     wire [3:0] BLK_EXP;
     assign real_input = { 7'd1 , sampled_pwm_input }; 
     assign img_input = 1; 
     
     /*
     dft_0 test (
       .CLK(clk_100kHz),                // input wire CLK
       .XN_RE(real_input),            // input wire [7 : 0] XN_RE
       .XN_IM(img_input),            // input wire [7 : 0] XN_IM
       .FD_IN(1),            // input wire FD_IN
       .FWD_INV(1),        // input wire FWD_INV
       .SIZE(2),              // input wire [5 : 0] SIZE
       .RFFD(RFFD),              // output wire RFFD
       .XK_RE(real_output),            // output wire [7 : 0] XK_RE
       .XK_IM(img_output),            // output wire [7 : 0] XK_IM
       .BLK_EXP(BLK_EXP),        // output wire [3 : 0] BLK_EXP
       .FD_OUT(FD_OUT),          // output wire FD_OUT
       .DATA_VALID(DATA_VALID)  // output wire DATA_VALID
     );
     
    */
    
  
  
     reg [21:0] led_counter = 0;
     
     always @ (posedge clk_100kHz or posedge reset) begin
             if (reset) begin
                 led_counter <= 0;
                 LED <= 0;
             end else if ( led_counter >= 10000 ) begin
                 LED <= LED << 1;
                 LED[0] <= sampled_pwm_input;
                 //LED[0] <= m_axis_data_tdata [0];
                 led_counter <= 0;
             end else
                 led_counter <=  led_counter + 1;
    end


endmodule