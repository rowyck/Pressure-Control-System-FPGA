`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2025 19:00:52
// Design Name: 
// Module Name: digital_top
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


module digital_top(
    input logic clk_i,
    input logic rst_n_i,
    
    input logic data_i,
    input logic ready_i,
    input logic test_i,
    
    output logic led_0_o,
    output logic led_1_o,
    output logic led_2_o
    );
    logic data_re_s, ready_re_s, test_re_s;
    logic [3:0] pressure_stb_s;
    logic start_stb_s;
    
    prelucrare prel(
    .data_i(data_i),
    .ready_i(ready_i),
    .test_i(test_i),
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .data_re_o(data_re_s),
    .ready_re_o(ready_re_s),
    .test_re_o(test_re_s)
    );
    
    counter_interface ci(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .data_i(data_re_s),
    .done_i(ready_re_s),
    .pressure_o(pressure_stb_s),
    .end_stb_o(start_stb_s)
    );
    
    pressure_controller pc(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .start_stb_i(start_stb_s),
    .pressure_i(pressure_stb_s),
    .testmode_i(test_re_s),
    .captured_o(led_0_o),
    .stable_flag_o(led_1_o),
    .test_flag_o(led_2_o)
    );
endmodule
