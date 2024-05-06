import os
import pandas as pd
import numpy as np

def calculate_interval_min_max(input_dir, output_dir, interval_len):
    """
    Calculate the interval-based minimum and maximum of each CSV file in the input directory and save the results in the output directory.
    
    Args:
        input_dir (str): Path to the input directory.
        output_dir (str): Path to the output directory.
        interval_len (int): Length of the intervals.
    """
    # Create the output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Go through all files in the input directory
    for filename in os.listdir(input_dir):
        # Check if the file is a CSV file
        if filename.endswith('.csv'):
            # Read the CSV file
            df = pd.read_csv(os.path.join(input_dir, filename), header=None)

            #Scale the floats to 32 bit signed integers
            df = df * 2**31
            
            # Calculate the number of intervals
            num_intervals = len(df) // interval_len
            if len(df) % interval_len != 0:
                num_intervals += 1  # Add one more interval for the remaining data
            
            # Initialize an empty list to store the results
            results = []
            
            # Calculate the minimum and maximum for each interval
            for i in range(num_intervals):
                start = i * interval_len
                end = (i + 1) * interval_len
                interval_data = df.values[start:end]
                if len(interval_data) > 0:  # Check if the interval_data array is not empty
                    min_value = np.min(interval_data)
                    max_value = np.max(interval_data)
                    results.append([i, min_value, max_value])
                else:
                    results.append([i, np.nan, np.nan])  # Assign NaN values for empty intervals
            
            # Convert the results to a DataFrame
            df_results = pd.DataFrame(results, columns=['interval', 'min', 'max'])
            
            # Save the results to a CSV file in the output directory
            df_results.to_csv(os.path.join(output_dir, filename), index=False)

# Example usage
interval_len = 10  # Length of the intervals
calculate_interval_min_max('convertedwav', 'interval_min_max', interval_len)