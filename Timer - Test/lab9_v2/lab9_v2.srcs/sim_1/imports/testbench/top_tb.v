`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2021 03:53:01 PM
// Design Name: 
// Module Name: top_testbench
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


module top_tb(

    );
    
        reg clk;
        reg [3:0] load_sec_ones;
        reg [3:0] load_sec_tens;
        reg [3:0] load_min_ones;
        reg [3:0] load_min_tens;
        reg load;
        reg reset;
        reg enable;
        wire [3:0] second_ones;
        wire [3:0] second_tens;
        wire [3:0] minute_ones;
        wire [3:0] minute_tens;
        

        top dut(
            .clk(clk),
            .load_sec_ones (load_sec_ones),
            .load_sec_tens (load_sec_tens),
            .load_min_ones (load_min_ones),
            .load_min_tens (load_min_tens),
            .reset (reset),
            .load (load),
            .enable (enable),
            .second_ones (second_ones),
            .second_tens (second_tens),
            .minute_ones (minute_ones),
            .minute_tens (minute_tens)
        );
        
        initial begin
            clk = 0;
            reset = 0;
            enable = 0; 
            load = 0;
            load_sec_ones = 0;
            load_sec_tens = 3;
            load_min_ones = 1;
            load_min_tens = 0;
            #10;
            load = 1;
            #10;
            enable = 1;
            load = 0;
        
        end
        
        always begin
            #10; clk = ~clk;
        end
endmodule