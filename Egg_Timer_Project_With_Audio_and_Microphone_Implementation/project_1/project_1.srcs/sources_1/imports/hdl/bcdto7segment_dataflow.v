`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Hamas Waqar
// 
// Create Date: 03/28/2021 03:34:24 PM
// Module Name: bcdto7segment_dataflow
// Project Name: Egg Timer
// Target Devices: NEXYS A7 100 T
// Tool Versions: 
// Description: configure the anode pins in the seven segment display for each digit from 0 - 9
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bcdto7segment_dataflow(
    input [3:0] v,
    output [6:0] seg
    );
    
     /*
       instances the anodes in the seven segment display for each number from  0 to 9
    */
        
     wire a,b,c,d;
     
     assign a = v[3];
     assign b = v[2];
     assign c = v[1];
     assign d = v[0];
     
      assign seg[0] = ~(a|c|(b&d)|(~a&~b&~d));
      assign seg[1] = ~(~b|(~c&~d)|(c&d));
      assign seg[2] = ~(~c|b|(c&d));
      assign seg[3] = ~(a|(c&~d)|(~d&~b)|(~b&c&d)|(b&~c&d));
      assign seg[4] = ~((~b&~d)|(c&~d));
      assign seg[5] = ~((~c&~d)|(b&~c)|(a&d)|(b&c&~d));
      assign seg[6] = ~(a|(b&~c)|(c&~d)|(~a&~b&c));
  
endmodule