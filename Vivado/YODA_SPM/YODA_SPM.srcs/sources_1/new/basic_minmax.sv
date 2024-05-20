`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TEAM 14
// Engineer: TEAM 14
// 
// Create Date: 05/18/2024 01:11:53 PM
// Design Name: Basic Min-Max Filter
// Module Name: basic_minmax
// Project Name: SPM
// Target Devices: Nexys A7 
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


module basic_minmax #(parameter NO_OF_SAMPLES = 100, WIDTH = 32)
(
    input reg clk,
    input reg start,
    input reg reset,
    input reg signed [WIDTH-1:0] audio_in [NO_OF_SAMPLES-1:0],
    output reg done,
    output reg signed [WIDTH-1:0] min,
    output reg signed [WIDTH-1:0] max
 );
 
//State parameters
localparam IDLE = 2'b00;
localparam COMPUTING = 2'b01;
 
reg [1:0] state;                 // state variable 
reg signed [WIDTH-1:0] y;        // sample amplitude variable
 
integer i = 0;                   //  

always @(posedge clk) begin
    if (reset) begin
        $display("Reset");
        done <= 1'b0;
        min <= 32'h7FFFFFFF; // maximum positive value for a 32-bit signed integer
        max <= 32'h80000000; // maximum negative value for a 32-bit signed integer
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    $display("Start");
                    state <= COMPUTING;
                    i <= 0; // Reset loop counter
                    // min <= audio_in[i]; // Set initial min value to the first sample
                    // max <= audio_in[i]; // Set initial max value to the first sample
                end
                $display("State %d", state);
            end
           COMPUTING: begin
                y <= audio_in[i];
                //$display("Inst %d",y);
                if (y < min) begin
                    min <= y;
                    $display("Min now is: %d", min);
                end 
                if (y > max) begin
                    max <= y;
                    $display("Max now is: %d", max);
                end
                i = i + 1;
                // At the end of computatation indicate with done and go to the IDLE state
                if (i >= NO_OF_SAMPLES) begin
                    state <= IDLE;
                    done <= 1'b1;
                end
            end
        endcase
    end
end

endmodule