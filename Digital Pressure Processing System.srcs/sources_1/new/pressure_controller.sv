`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2025 15:34:21
// Design Name: 
// Module Name: pressure_controller
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


module pressure_controller(
    input logic start_stb_i,
    input logic [3:0] pressure_i,
    input logic testmode_i,
    
    input logic clk_i,
    input logic rst_n_i,
    
    output logic captured_o,
    output logic stable_flag_o,
    output logic test_flag_o
    );
    logic [2:0] state_s, state_next_s;
    
    logic [3:0] pressure_s;
    logic circuit_stable_s;
    logic error_stb_s, correct_stb_s;
    logic [2:0] counter_s;
    
    ///mapare stari
    ///000 idle
    ///001 wait
    ///010 capture_pressure
    ///011 stable
    ///100 testmode
    ///101 pressure_lin
    ///110 fault
    
    
    always_ff @(posedge clk_i or negedge rst_n_i)
    begin
        if(~rst_n_i) begin
            state_s <= 3'b000;///idle
        end
        else begin
            state_s <= state_next_s;
        end
   end
   
   
   always_comb
   begin
        case(state_s)
            3'b000: begin ///idle
                if(rst_n_i) begin 
                state_next_s <= 3'b001;
                end
                else begin
                state_next_s <= 3'b000;
                end
           end
           3'b001: begin ///wait
                if(start_stb_i) begin
                state_next_s <= 3'b010;
                end
                else begin
                state_next_s <= 3'b001;
                end
           end
           3'b010:begin ///capture_pressure
                if(circuit_stable_s) begin
                state_next_s <= 3'b011;
                end
                else begin
                state_next_s <= 3'b010;
                end
           end
           3'b011:begin///stable
                if(testmode_i) begin
                state_next_s <= 3'b100;
                end
                else if(start_stb_i) begin
                state_next_s <= 3'b010;
                end
                else begin
                state_next_s <= 3'b011;
                end
           end
           3'b100:begin///testmode
                if(start_stb_i) begin
                state_next_s <= 3'b101;
                end
                else begin
                state_next_s <= 3'b100;
                end
           end
           3'b101:begin///pressrue_lin
                if(error_stb_s)begin
                state_next_s <= 3'b110;
                end
                else if (correct_stb_s)begin
                state_next_s <= 3'b011;
                end
                else begin
                state_next_s <= 3'b101;
                end
           end
           3'b110:begin
                state_next_s <= 3'b110;
                end
           default: begin
            state_next_s <= 3'b000;
            end
           endcase
     end
     
     ///functionalitatea fiecarei stari
     always_ff @(posedge clk_i, negedge rst_n_i)
     begin
        if(~rst_n_i)  
        begin
            captured_o <= 1'b0;
            stable_flag_o <= 1'b0;
            test_flag_o <= 1'b0;
            pressure_s <= 4'b0000;
            counter_s <= 3'b000;
        end
        else begin
            case(state_s)
            3'b000,3'b001:begin ///idle si wait
                captured_o <= 1'b0;
                stable_flag_o <= 1'b0;
                test_flag_o <= 1'b0;
                counter_s <= 3'b000;    
            end
            3'b010:begin ///capture_pressrue
                captured_o <= 1;
                pressure_s <= pressure_i; 

                if(counter_s < 3'd7) begin
                    counter_s <= counter_s + 1;
                    circuit_stable_s <= 0;
                    end
                 else begin
                    circuit_stable_s <= 1;
                 end                
            end
            3'b011:begin ///stable
                counter_s <= 0;
                circuit_stable_s <= 0;
                
                stable_flag_o <= 1;
                captured_o <= 1;
                end
            3'b100:begin ///testmode
                test_flag_o <= 1;
                captured_o <= 0;
                stable_flag_o <= 0;
            end
            3'b101: begin ///pressure lin
                if(pressure_i == pressure_s)
                    begin
                    correct_stb_s <= 1;
                    error_stb_s <= 0;
                    end
                 else begin
                    correct_stb_s <= 0;
                    error_stb_s <= 1;
                    end
              end
            3'b110: begin ///fault
                test_flag_o <= 1;
                end
            default: begin// safe fallback
                captured_o       <= 1'b0;
                stable_flag_o    <= 1'b0;
                test_flag_o      <= 1'b0;
                counter_s        <= 3'd0;
                circuit_stable_s <= 1'b0;
                end
              endcase
         end  
      end          
            
endmodule
