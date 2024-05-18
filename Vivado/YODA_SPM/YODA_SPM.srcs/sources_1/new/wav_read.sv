`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2024 01:11:53 PM
// Design Name: 
// Module Name: wav_read
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


module wav_read #(parameter string FILEPATH = "StarWars3")
(
    input reg clk,
    input reg start,
    input reg reset,
    output reg done,
    output reg [23:0] audio_out,
    output reg error
);

localparam IDLE = 1'b0;
localparam READING = 1'b1;

logic state;

logic data_valid;
logic aux;
int status;
int audio_in;
int no_of_samples;

logic           [31:0]  chunk_id;
logic           [31:0]  chunk_size;
logic           [31:0]  format;
logic           [31:0]  subchunk_1_id;
logic           [31:0]  subchunk_1_size;
logic           [15:0]  audio_format;
logic           [15:0]  num_channels;
logic           [31:0]  sample_rate;
logic           [31:0]  byte_rate;
logic           [15:0]  block_align;
logic           [15:0]  bits_per_sample;
logic           [31:0]  subchunk_2_id;
logic           [31:0]  subchunk_2_size;
logic signed    [23:0]  data_aux;


initial begin
    audio_in = $fopen(FILEPATH, "rb");
end 

always @(posedge clk) begin
    if(reset) begin
        done <= 1'b0;
        error <= 1'b0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if(start) begin
                    state <= READING;
                    
                end
            end
            READING: begin
                status = $fread(chunk_id, audio_in);
                if (status != 0) begin
                    $display ("Chunk ID: 0x%h. Expected: 0x52494646 ('RIFF')", chunk_id);
                end 

                status = $fread(chunk_size, audio_in);
                if (status != 0) begin
                    chunk_size = { << byte {chunk_size}}; // Converts to big endian
                    $display ("Chunk Size: %h bytes", chunk_size);
                end

                status = $fread(format, audio_in);
                if (status != 0) begin
                    $display ("Format: 0x%h. Expected: 0x57415645 ('WAVE')", format);
                end
                
                status = $fread(subchunk_1_id, audio_in);
                if (status != 0) begin
                    $display ("Subchunk 1 ID read: 0x%h. Expected: 0x666d7420 ('fmt ')", subchunk_1_id);
                end
                
                status = $fread(subchunk_1_size, audio_in);
                subchunk_1_size = { << byte {subchunk_1_size}}; // Converts to big endian
                if (status != 0) begin
                    $display ("Subchunk 1 Size: %d bytes. Expected: 16 (PCM)" , subchunk_1_size);
                end

                status = $fread(audio_format, audio_in);
                audio_format = { << byte {audio_format}}; // Converts to big endian
                if (status != 0) begin
                    $display ("Audio Format: %d. Expected: 1 (other values indicate data compression)", audio_format);
                end

                status = $fread(num_channels, audio_in);
                num_channels = { << byte {num_channels}}; // Converts to big endian
                if (status != 0) begin
                    $display ("Number of Channels: %d. Expected: 1 (mono)", num_channels);
                end

                status = $fread(sample_rate, audio_in);
                sample_rate = { << byte {sample_rate}}; // Converts to big endian
                if (status != 0) begin
                    $display ("Sample Rate: %d Hz", sample_rate);
                end

                status = $fread(byte_rate, audio_in);
                byte_rate = { << byte {byte_rate}}; // Converts to big endian
                if (status != 0) begin
                    $display ("Byte Rate: %d Bps", byte_rate);
                end

                status = $fread(block_align, audio_in);
                block_align = { << byte {block_align}}; // Converts to big endian
                if (status != 0) begin
                    $display ("Block Align: %d bytes", block_align);
                end

                status = $fread(bits_per_sample, audio_in);
                bits_per_sample = { << byte {bits_per_sample}}; // Converts to big endian
                if (status != 0) begin
                    $display ("Bits per Sample: %d", bits_per_sample);
                end

                status = $fread(subchunk_2_id, audio_in);
                if (status != 0) begin
                    $display ("Subchunk 2 ID: 0x%h. Expected: 0x64617461 ('data')", subchunk_2_id);
                end
        
                status = $fread(subchunk_2_size, audio_in);
                subchunk_2_size = { << byte {subchunk_2_size}}; // Converts to big endian
                if (status != 0) begin
                    $display ("Subchunk 2 Size: %d bytes", subchunk_2_size);
                end

                no_of_samples = (subchunk_2_size*8)/(num_channels*bits_per_sample);
                $display ("Calculated Number of Samples: %d", no_of_samples);
                $display ("Reading the audio data");
                for (int i = 0; i < no_of_samples; i++) begin
                    for (int j = 0; j < (bits_per_sample/8); j++) begin
                        status = $fread(aux, audio_in);
                        data_aux = {aux, data_aux[23:8]};
                    end
                
                    @(posedge clk);
                        data_valid <= 1'b1;
                        audio_out <= data_aux;
                        
                    @(posedge clk);
                        data_valid <= 1'b0;
                        
                end
                $display ("Audio data read");
                $fclose(audio_in);
            end
        endcase
    end 
end  
endmodule
