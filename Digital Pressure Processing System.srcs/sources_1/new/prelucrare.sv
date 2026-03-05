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


module prelucrare(
    input logic data_i,
    input logic ready_i,
    input logic test_i,
    
    output logic data_re_o,
    output logic ready_re_o,
    output logic test_re_o,
    
    input logic clk_i,
    input logic rst_n_i
    );
    logic data_del1_s, data_sync_s;
    logic data_n_s;
    
    logic ready_del1_s, ready_sync_s;
    logic ready_n_s;
    
    logic test_del1_s, test_sync_s;
    logic test_n_s;
    
    //sync data
    always_ff @(posedge clk_i or negedge rst_n_i)
    begin
        if(~rst_n_i) 
            begin
            data_del1_s <= 1'b0;
            data_sync_s <= 1'b0;
            end
        else begin
            data_del1_s <= data_i; ///prima sincronizare
            data_sync_s <= data_del1_s; ///a doua sincronizare
            end
     end
     
     //sync ready
     always_ff @(posedge clk_i or negedge rst_n_i)
     begin
        if(~rst_n_i)
            begin
            ready_del1_s <= 1'b0;
            ready_sync_s <= 1'b0;
            end
        else begin
            ready_del1_s <= ready_i;
            ready_sync_s <= ready_del1_s;
            end
     end
     
     //sync test
     always_ff @(posedge clk_i or negedge rst_n_i)
     begin
        if(~rst_n_i)
            begin
            test_del1_s <= 1'b0;
            test_sync_s <= 1'b0;
            end
            else begin
            test_del1_s <= test_i;
            test_sync_s <= test_del1_s;
            end
     end
        
     //re for data
     always_ff @(posedge clk_i or negedge rst_n_i)
     begin
        if(~rst_n_i)
            begin
            data_n_s <= 1'b0;
            data_re_o <= 1'b0;
            end
            else begin
            data_n_s <= ~data_sync_s; //stocheaza inversul decalat cu un ceas
            data_re_o <= data_n_s&&data_sync_s;
            end
     end
     //re for ready
     always_ff @(posedge clk_i or negedge rst_n_i)
     begin
        if(~rst_n_i)
            begin
            ready_n_s <= 1'b0;
            ready_re_o <= 1'b0;
            end
            else begin
            ready_n_s <= ~ready_sync_s;
            ready_re_o <= ready_n_s && ready_sync_s;
            end
     end
     //re for test
     always_ff @(posedge clk_i or negedge rst_n_i)
     begin
        if(~rst_n_i)
            begin
            test_n_s <= 1'b0;
            test_re_o <= 1'b0;
            end
            else begin
            test_n_s <= ~test_sync_s;
            test_re_o <= test_n_s && test_sync_s;
            end
     end
     
        
endmodule
