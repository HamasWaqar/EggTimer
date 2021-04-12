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
    output M_LRSEL,
    output reg AUD_PWM,
    output AUD_SD
    );  

    
    wire clk_5MHz;
    reg clk_2dot5MHz = 0;
    reg clk_100Hz = 0;
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
                 clk_100Hz <= 0;
                 counter2 <= 0;
            end else begin
                 if (counter2 >= 25000) begin
                     counter2 <= 0;
                     clk_100Hz <= ~clk_100Hz;
                 end else 
                     counter2 <= counter2 + 1;
            end        
     end
     
        
        
     
     reg [3:0] sampling_period;
     reg sampled_pwm_input;
     
     always @ (posedge clk_100Hz or posedge reset) begin
        if (reset) begin
            sampling_period <= 0;
            sampled_pwm_input <= 0;
        end else if ( sampling_period >= 10 ) begin
            sampling_period <= 0;
            sampled_pwm_input <= M_DATA;
        end else
            sampling_period <=  sampling_period + 1;
     end
     
     assign M_CLK = clk_2dot5MHz;
     assign M_LRSEL = 1'b1;
     

     reg [3:0] led_counter = 0;
     
     always @ (posedge clk_100Hz or posedge reset) begin
             if (reset) begin
                 led_counter <= 0;
                 LED <= 0;
             end else if ( led_counter >= 10 ) begin
                 LED <= LED << 1;
                 LED[0] <= sampled_pwm_input;
                 led_counter <= 0;
             end else
                 led_counter <=  led_counter + 1;
    end
    
    
    /*
        Sound
    */
    reg clk_1000Hz = 0;
    reg clk_660Hz = 0;
    
    reg counter_510Hz = 0;
    reg counter_770Hz = 0;
    reg counter_380Hz = 0;
    reg [13:0] count_sound_1000Hz = 0;
    reg [13:0] count_sound_660Hz = 0;
    reg [13:0] count_sound = 0;
    
    always @ (posedge clk_5MHz or posedge reset) begin
        if (reset && ~enable) begin
            clk_1000Hz <= 0;
            count_sound_1000Hz <= 0;
       end else begin
            if (count_sound_1000Hz >= 2500) begin
                clk_1000Hz <= ~clk_1000Hz;
            end else
                count_sound_1000Hz <= count_sound_1000Hz + 1;
       end         
     end
     
     always @ (posedge clk_5MHz or posedge reset) begin
         if (reset && ~enable) begin
             clk_660Hz <= 0;
             count_sound_660Hz <= 0;
        end else begin
             if (count_sound_660Hz >= 7576) begin
                 clk_660Hz <= ~clk_660Hz;
             end else
                 count_sound_660Hz <= count_sound_660Hz + 1;
        end         
      end
      
      always @ (posedge clk_1000Hz, posedge reset) begin 
        if (reset || ~enable) begin
            count_sound <= 0;
            AUD_PWM <= 0;
        end else begin
            AUD_PWM <= ~AUD_PWM;
        /*
            count_sound <= count_sound + 1;
            if (count_sound > 500) begin
                if (clk_660Hz)
                    AUD_PWM <= ~AUD_PWM;
            end else if (count_sound > 1000 && count_sound <1500) begin
                AUD_PWM <= 0;
            end else if (count_sound > 2000) begin
                count_sound <= 0;
            end
         */
        end
      end
    
    
    
    //assign AUD_PWM = 0;
    assign AUD_SD = 1'b1;
endmodule