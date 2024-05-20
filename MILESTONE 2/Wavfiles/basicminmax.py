import os
import pandas as pd
import time

def calculate_min_max(input_dir, output_dir, output_filename):
    """
    Calculate the global minimum and maximum of each CSV file in the input directory and save the results in the output directory.
    
    Args:
        input_dir (str): Path to the input directory.
        output_dir (str): Path to the output directory.
        output_filename (str): Name of the output file.
    """
    # Create the output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Initialize an empty list to store the results
    results = []
    
    # Go through all files in the input directory
    for filename in os.listdir(input_dir):
        # Check if the file is a CSV file
        if filename.endswith('.csv'):
            # Read the CSV file
            df = pd.read_csv(os.path.join(input_dir, filename), header=None)

            #Scale the floats to 32 bit signed integers
            df = df * 2**31
            
            # Calculate the global minimum and maximum
            

            start_time = time.time()
            min_value = df.values.min()
            max_value = df.values.max()
            end_time = time.time()

            elapsed_time = end_time - start_time
            print(f"Elapsed time: {elapsed_time} seconds")
            
            # Add the results to the list
            results.append([filename, min_value, max_value])
    
    # Convert the results to a DataFrame
    df_results = pd.DataFrame(results, columns=['filename', 'min', 'max'])
    
    # Save the results to a CSV file in the output directory
    df_results.to_csv(os.path.join(output_dir, output_filename), index=False)

# Example usage
calculate_min_max('convertedwav', 'basicminmax', 'basicminmax.csv')