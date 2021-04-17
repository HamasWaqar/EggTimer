`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University 
// Engineer: Hamas Waqar
// 
// Create Date: 03/28/2021 03:34:24 PM
// Module Name: debounce
// Project Name: Egg Timer
// Target Devices: NEXYS A7 100 T
// Tool Versions: 
// Description: Debounce circuit
// Dependencies: 
// 
// Revision:
// Revision 1.2
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce (
    input pulse_1Hz,
    input minutes_seconds_up,
    input reset,
    output minutes_seconds_debounce
    );  
    /*
    
        IDEA: Need to Get to bits in a datastream high consistantly... in other words, need to find when there is two continous
        1 ("11") in a datastream
        
        Therefore use a state machine
        where 
            current state S0: if the next bit is 0, the next state will be S0 as no one is found
            current state S0: if the next bit is 1, the next state will be S1 as a bit one is found
            current state S1: if the next bit is 1, then two sequenctial bits is found as such next state is S11 and debounde is 1
            current state S1: if next bit is 0, then two sequencial bit is not found as such next state is S0
            current state S11: if next bit is 0, then the sequency breaks so next state is S0
            current state S11: if next bit is 1, then again two sequenctial bits is found as such next state is S11 and debounde is 1
    **/
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