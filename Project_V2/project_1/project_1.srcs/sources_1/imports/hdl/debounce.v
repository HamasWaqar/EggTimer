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


module debounce (
    input pulse_1Hz,
    input minutes_seconds_up,
    input reset,
    output minutes_seconds_debounce
    );  

    parameter S0 = 0, S1 = 1, S11 = 2;
    reg [1:0] state;
    reg [1:0] nextstate;
    
    
    always @ (state or minutes_seconds_up) begin
      case (state)
            S0: begin
                if (minutes_seconds_up)
                    nextstate = S1;
                else
                    nextstate = S0;
            end
            S1: begin
                if (minutes_seconds_up)
                    nextstate = S11;
                else
                    nextstate = S0;
            end
            S11: begin
                if (minutes_seconds_up)
                    nextstate = S11;
                else
                    nextstate = S0;
            end
            default: nextstate = S0;
      endcase
    end

    always @ (posedge pulse_1Hz or posedge reset) begin
        if (reset)
            state = S0;
        else
            state = nextstate;
    end

    assign minutes_seconds_debounce = (state == S11) ? 1'b1: 1'b0;

endmodule