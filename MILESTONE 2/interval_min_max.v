`timescale 1ns / 1ps

module audio_min_max_interval (
    input wire reset,
    input wire start,
    input wire clk,
    input reg [31:0] raw_audio [N-1:0],  // raw audio data
    input reg [15:0] interval_len,  // interval length
    output reg done,
    output reg signed [31:0] out_max [NUM_INTERVALS-1:0],  // max audio amplitude per interval
    output reg signed [31:0] out_min [NUM_INTERVALS-1:0]   // min audio amplitude per interval
);

localparam IDLE = 0;
localparam INTERVAL_START = 1;
localparam INTERVAL_COMPUTING = 2;
localparam INTERVAL_DONE = 3;
localparam N = 100;  // number of samples
localparam NUM_INTERVALS = N / 10;  // number of intervals (assuming interval_len = 10)

reg [1:0] state;
reg [31:0] max;
reg [31:0] min;
reg [31:0] y;  // sample placeholder
reg [15:0] interval_counter;
reg [6:0] interval_index;

integer i = 0;

always @(posedge clk) begin
    if (reset) begin
        done <= 0;
        state <= IDLE;
        interval_index <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= INTERVAL_START;
                end
            end
            INTERVAL_START: begin
                min <= raw_audio[0];
                max <= raw_audio[0];
                interval_counter <= 0;
                state <= INTERVAL_COMPUTING;
            end
            INTERVAL_COMPUTING: begin
                y = raw_audio[i];
                if (y < min) begin
                    min <= y;
                end else if (y > max) begin
                    max <= y;
                end
                i <= i + 1;
                interval_counter <= interval_counter + 1;
                if (interval_counter == interval_len - 1) begin
                    state <= INTERVAL_DONE;
                end
            end
            INTERVAL_DONE: begin
                out_max[interval_index] <= max;
                out_min[interval_index] <= min;
                interval_index <= interval_index + 1;
                if (i == N - 1) begin
                    state <= IDLE;
                    done <= 1;
                end else begin
                    state <= INTERVAL_START;
                end
            end
        endcase
    end
end

endmodule