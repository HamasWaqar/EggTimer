`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University 
// Engineer: Hamas Waqar
// 
// Create Date: 03/28/2021 03:34:24 PM
// Module Name: clock
// Project Name: Egg Timer
// Target Devices: NEXYS A7 100 T
// Tool Versions: 
// Description: Clock Divider - Output two syncronous clocks at 500 Hz, 5 MHz, 2.5 MHz, 100 KHz and 1 Hz from the BCD Display and the 
// Dependencies: 
// 
// Revision: 04/16/2021
// Revision 1.5
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module clock (
    input CLK100Mhz,
    input reset,
    output reg pulse_500Hz,
    output reg pulse_2dot5MHz,
    output reg pulse_100KHz,
    output reg pulse_5MHz,
    output reg pulse_1Hz
    );
    
    wire clk_5MHz, clk_17MHz;
    reg [25:0] divider_count_500Hz = 10000;
    reg [25:0] divider_count_1Hz = 5000000;
    reg divider_count_2dot5Hz = 1;
    reg [14:0] divider_count_100KHz = 25000;
    reg divider_count_5MHz = 1;
    
      /*
        The eggtimer will be running at two clock frequencies; at 1 Hz and 500 Hz. 
        The 1 Hz clock will be controlling the timer aspect of the egg timer, as it will be counting down the time every 1 second
        The 500 Hz clock will be controlling the four seven segment displays by alternating the seven segment displays making it seem
        that the four seven segment display is on to the human eye. 
    */
    
    //Generating a minimum clock frequency of 5 MHz that the Nexys A7 FPGA can produce using and vivado clk IP
       clk_wiz_0 dormammu
        (
         // Clock out ports
         .clk_out1(clk_5MHz),     // output clk_out1
         .clk_out2(clk_17MHz),
         // Status and control signals
         .locked(locked),       // output locked
        // Clock in ports
         .clk_in1(CLK100Mhz));      // input clk_in1

       
       /* 
          Using a clock divider to generate a 5 MHz clock
          
          Calculation: increment number = fin/(fout * 2) = 5 MHz / (5 MHz * 2) = 0.5 ~ 1
          Note the input clock from the FPGA is 5 MHz
        */
       always @(posedge clk_5MHz) begin
              if (reset)
               pulse_5MHz <= 0;
              else if (divider_count_5MHz == 0) begin
                  divider_count_5MHz <= 1;
                  pulse_5MHz = ~pulse_5MHz;
              end
              else divider_count_5MHz <= divider_count_5MHz - 1;    
      end
       
       /* 
         Using a clock divider to generate a 500 Hz clock
         
         Calculation: increment number = fin/(fout * 2) = 5 MHz / (500 Hz * 2) = 5000
         Note the input clock from the FPGA is 5 MHz
       */
       always @(posedge clk_5MHz) begin
               if (reset)
                pulse_500Hz <= 0;
               else if (divider_count_500Hz == 0) begin
                   divider_count_500Hz <= 5000;
                   pulse_500Hz = ~pulse_500Hz;
               end
               else divider_count_500Hz <= divider_count_500Hz - 1;    
       end
       
       /* 
         Using a clock divider to generate a 1 Hz clock
         
         Calculation: increment number = fin/(fout * 2) = 5 MHz / (1 Hz * 2) = 2500000
         Note the input clock from the FPGA is 5 MHz
       */
       always @(posedge clk_5MHz) begin
              if (reset)
                pulse_1Hz <= 0;
              else if (divider_count_1Hz == 0) begin
                  divider_count_1Hz <= 2500000;
                  pulse_1Hz = ~pulse_1Hz;
              end
              else divider_count_1Hz <= divider_count_1Hz - 1;   
      end
      
      /* 
       Using a clock divider to generate a 2.5 MHz clock
       
       Calculation: increment number = fin/(fout * 2) = 5 MHz / (2.5 MHz * 2) = 1
       Note the input clock from the FPGA is 5 MHz
     */
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
        
       /* 
          Using a clock divider to generate a 100 KHz clock
          
          Calculation: increment number = fin/(fout * 2) = 5 MHz / (100 KHz * 2) = 25
          Note the input clock from the FPGA is 5 MHz
        */  
       always @ (posedge clk_5MHz or posedge reset) begin
               if (reset) begin
                   pulse_100KHz <= 0;
                   divider_count_100KHz <= 25;
              end else begin
                   if (divider_count_100KHz == 0) begin
                       divider_count_100KHz <= 25;
                       pulse_100KHz <= ~pulse_100KHz;
                   end else 
                       divider_count_100KHz <= divider_count_100KHz - 1;
              end        
       end
      
endmodule