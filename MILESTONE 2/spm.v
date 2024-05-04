// set simulation time:
`timescale 1ns / 1ps

module audio_min_max (
    input wire reset,  // reset when high
    input wire start,  // start pulse
    input wire clk,    // clock
    input reg [31:0] raw_audio [N-1:0], // raw audio data
    output reg d, // done computing min & max
    output reg signed [31:0] out_max, // max audio amplitude
    output reg signed [31:0] out_min // min audio amplitude
);


  
localparam IDLE = 0;
localparam COMPUTING = 1;
  
localparam N = 100; //no of samples 

reg [1:0] state; // state
reg [31:0] max; // current max
reg [31:0] min; // current min
reg [31:0] y; // sample placeholder

integer i = 0;


always @(posedge clk) begin
    if(reset) begin
        $display("Reset");
        d <= 0;
        min <= 0;
        max <= 0;
        state <= IDLE;
    end else begin
        case(state)
            IDLE: begin
                if(start) begin
                    $display("Started...");
                    state <= COMPUTING;
                end
            end
            COMPUTING: begin
                y = raw_audio[i];
                $display("Computing... sample %2d, Hex: %h ",i,y);
                if(y<min) begin
                    min <= y;
                end else if(y > max) begin
                    max <= y;
                end
                i = i+1; 
                
              if (i>N-1) begin
                    out_max <= max;
                    out_min <= min;
                    state <= IDLE;
                    d <= 1;
                    $display("Done");
                end
            end
        endcase
    end
end
endmodule