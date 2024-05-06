import pandas as pd
import os

def generate_testbench(input_dir, csv_filename, output_filename, num_samples):
    # Read the CSV file
    df = pd.read_csv(os.path.join(input_dir, csv_filename), header=None)
    
    # Convert the DataFrame to a list
    data = df.values.flatten().tolist()
    
    # Truncate the list to the desired number of samples
    data = data[:num_samples]
    
    #Scale the floats to 32 bit signed integers
    data = [int(x * 2**31) for x in data]
    
    # Start writing the testbench
    with open(output_filename, 'w') as f:
        f.write('module audio_min_max_tb;\n')
        f.write('localparam N = {}; // Number of samples\n'.format(num_samples))
        f.write('reg reset, start, clk;\n')
        f.write('reg signed [31:0] raw_audio [N-1:0];\n')
        f.write('wire d;\n')
        f.write('wire signed [31:0] out_max, out_min;\n')
        f.write('// Instantiate audio_min_max\n')
        f.write('audio_min_max aud_minmax (\n')
        f.write('    .reset(reset),\n')
        f.write('    .start(start),\n')
        f.write('    .clk(clk),\n')
        f.write('    .raw_audio(raw_audio),\n')
        f.write('    .d(d),\n')
        f.write('    .out_max(out_max),\n')
        f.write('    .out_min(out_min)\n')
        f.write(');\n')
        f.write('// Clock generation\n')
        f.write('always #5 clk = ~clk;\n')
        f.write('// Test case: Hardcoded array from CSV file\n')
        f.write('initial begin\n')
        f.write('    clk = 0;\n')
        f.write('    reset = 1;\n')
        f.write('    start = 0;\n')
        f.write('    // Load the hardcoded array\n')
        for i, value in enumerate(data):
            f.write('    raw_audio[{}] = {};\n'.format(i, value))
        f.write('    #10 reset = 0;\n')
        f.write('    #10 start = 1;\n')
        f.write('    #10 start = 0;\n')
        f.write('    // Wait for the computation to complete\n')
        f.write('    wait (d);\n')
        f.write('    // Print the results\n')
        f.write('    $display("Maximum: %d, Minimum: %d", out_max, out_min);\n')
        f.write('end\n')
        f.write('endmodule\n')

# Gnertate the testbench
generate_testbench('convertedwav', 'BabyElephantWalk60.csv', 'basic_min_max_csv_tb.v', 100)