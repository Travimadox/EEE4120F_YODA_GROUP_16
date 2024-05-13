`timescale 1ns / 1ps

module audio_min_max (
    input wire reset,  // reset when high
    input wire start,  // start pulse
    input wire clk,    // clock
    input reg signed [31:0] raw_audio [N-1:0], // raw audio data
    output reg d,      // done computing min & max
    output reg signed [31:0] out_max, // max audio amplitude
    output reg signed [31:0] out_min // min audio amplitude
);

localparam IDLE = 2'b00;
localparam COMPUTING = 2'b01;
localparam N = 100; // Number of samples 

reg [1:0] state;          // state
reg signed [31:0] max;    // current max
reg signed [31:0] min;    // current min
reg signed [31:0] y;      // sample placeholder

integer i = 0;

always @(posedge clk) begin
    if (reset) begin
        d <= 0;
        min <= 32'h7FFFFFFF; // maximum positive value for a 32-bit signed integer
        max <= 32'h80000000; // maximum negative value for a 32-bit signed integer
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= COMPUTING;
                    i <= 0; // Reset loop counter
                    min <= 32'h7FFFFFFF;; // Set initial min value to the first sample
                    max <= 32'h80000000; // Set initial max value to the first sample
                end
            end
           COMPUTING: begin
                y = raw_audio[i];
                if (y < min) begin
                    min <= y;
                    //$display("Min now is: %d", min);
                end 
                if (y > max) begin
                    max <= y;
                    //$display("Max now is: %d", max);
                end
                i = i + 1;

                if (i > N) begin
                    out_max <= max;
                    out_min <= min;
                    state <= IDLE;
                    d <= 1;
                end
            end

        endcase
    end
end

endmodule
