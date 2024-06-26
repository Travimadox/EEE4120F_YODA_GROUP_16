`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TEAM 14
// Engineer: TEAM 14
// 
// Create Date: 05/18/2024 01:11:53 PM
// Design Name: Interval Min-Max Filter
// Module Name: interval_minmax
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


module interval_minmax 
#
(
    parameter NO_OF_SAMPLES = 100, 
    WIDTH = 32, 
    INTERVAL_WIDTH = 16, 
    INTERVAL_LEN = 10, 
    NO_OF_INTERVALS = NO_OF_SAMPLES/INTERVAL_LEN
)
(
    input reg clk,
    input reg start,
    input reg reset,
    input reg signed [WIDTH-1:0] audio_in [NO_OF_SAMPLES-1:0],
    input reg [INTERVAL_WIDTH-1:0] interval_len = INTERVAL_LEN,
    output reg done,
    output reg signed [WIDTH-1:0] min [NO_OF_INTERVALS:0],
    output reg signed [WIDTH-1:0] max [NO_OF_INTERVALS:0],
    output reg signed [WIDTH-1:0] filtered_wave // For Vivado wave generation 
);

// state parameteres 
localparam IDLE = 2'b00;
localparam INTERVAL_START = 2'b01;
localparam INTERVAL_COMPUTING = 2'b10;
localparam INTERVAL_DONE = 2'b11;

reg [1:0] state = IDLE;    // state variable
reg signed [WIDTH-1:0] max_aux;  // current max variable
reg signed [WIDTH-1:0] min_aux;  // current min variable
reg signed [WIDTH-1:0] y;  // sample amplitude variable

reg [INTERVAL_WIDTH-1:0] interval_counter;
integer interval_index;
integer i = 0;


always @(posedge clk) begin
    if (reset) begin
        $display("Reset");
        done <= 0;
        state <= IDLE;
        interval_index <= 0;
    end else begin
        case (state)
            IDLE: begin
                //$display("IDLE, start:%1d",start);
                i <= 0;
                if (start) begin
                    state <= INTERVAL_START;
                    //$display("Start");
                end
            end
            INTERVAL_START: begin
                //$display("Interval start");
                min_aux <= 32'h7FFFFFFF; // maximum positive value for a 32-bit signed integer
                max_aux <= 32'h80000000;
                interval_counter <= 0;
                state <= INTERVAL_COMPUTING;
            end
            INTERVAL_COMPUTING: begin
                //$display("interval compute");
                y = audio_in[i];
                if (y < min_aux) begin
                    min_aux <= y;
                    //$display("min is: %d", min_aux);
                end
                if (y > max_aux) begin
                    max_aux <= y;
                end
                i <= i + 1;
                interval_counter <= interval_counter + 1;
                if (interval_counter == interval_len - 1) begin
                    state <= INTERVAL_DONE;
                end
            end
            INTERVAL_DONE: begin
                //$display("interval done");
                filtered_wave <= min_aux;
                @(negedge clk) begin
                    filtered_wave <= max_aux;
                end

                max[interval_index] <= max_aux;
                min[interval_index] <= min_aux;
                interval_index <= interval_index + 1;
                
                if (i > NO_OF_SAMPLES - 1) begin
                    state <= IDLE;
                    done <= 1;
                    $display("Done");
                end else begin
                    state <= INTERVAL_START;
                end
            end
        endcase
    end
end
endmodule
