`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2021 09:11:07 PM
// Design Name: 
// Module Name: music
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


module music(
    input clk,
    input [15:0] clk_divider,
    input reset,
    output reg audio
    );
  
    reg [15:0] counter; 
    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
        end else begin
             if(counter == 0) 
                counter <= clk_divider; 
             else 
                counter <= counter-1;
        end
    end
    
    always @(posedge clk) begin
        if (reset) begin
            audio <= 0;
       end else begin
             if(counter == 0)
                audio <= ~audio;
       end
    end

endmodule
