`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2025 14:50:15
// Design Name: 
// Module Name: counter_interface
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


module counter_interface(
    input logic clk_i,
    input logic rst_n_i,
    
    input logic data_i,
    input logic done_i,
    
    output logic [3:0] pressure_o,
    output logic end_stb_o
    );
    
    logic [3:0] pressure_counter;
    assign end_stb_o=done_i;
    
    always_ff @(posedge clk_i or negedge rst_n_i)
    begin
        if(~rst_n_i)///cazul de baza explicitat de negarea reset
            begin
            pressure_counter <= 4'b0000;
            pressure_o <= 4'b0000;
            end
            
        else begin
            if(done_i) begin ///daca e apasat butonul atunci se trimit datele din pressure_c in pressure_out
            pressure_o <= pressure_counter;
            pressure_counter <= 4'b0000; ///se reseteaza counterul
            end
            else if(data_i) begin
                 pressure_counter <= pressure_counter + 1'd1;
                 end
            end
    end
endmodule
