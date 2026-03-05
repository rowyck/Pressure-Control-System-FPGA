`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2025 14:20:47
// Design Name: 
// Module Name: prelucrare
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

module tb_dig_top;

    logic clk_i;
    logic rst_n_i;
    
    logic data_i;
    logic ready_i;
    logic test_i;
    
    logic led_0_o;
    logic led_1_o;
    logic led_2_o;

    // instantiere DUT
    digital_top dut (
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .data_i(data_i),
        .ready_i(ready_i),
        .test_i(test_i),
        .led_0_o(led_0_o),
        .led_1_o(led_1_o),
        .led_2_o(led_2_o)
    );

    // clock 100MHz
    always #5 clk_i = ~clk_i;

    initial begin
        // initializare
        clk_i     = 0;
        rst_n_i   = 0;
        data_i    = 0;
        ready_i   = 0;
        test_i    = 0;

        // reset
        #20;
        rst_n_i = 1;

        // 4 apasari de buton
        repeat (4) begin
            data_i = 1; #10;
            data_i = 0; #10;
        end

        ready_i = 1; #10;
        ready_i = 0; #10;

        // asteptam sa devina led_1_o stable 
        #100;

        // intram in testmode
        test_i = 1; #10;
         test_i = 0; #10;


        // modificare de presiune, apasam de doua ori
        repeat (2) begin
            data_i = 1; #10;
            data_i = 0; #10;
        end

        // trimitere pentru test
        ready_i = 1; #10;
        ready_i = 0; #10;
        
       
        data_i = 1; #10;
        data_i = 0; #10;
        ready_i = 1; #10;
        ready_i = 0; #10;
        // asteptam sa intre in fault led_2_o
        #100;

        $stop();
    end

endmodule

