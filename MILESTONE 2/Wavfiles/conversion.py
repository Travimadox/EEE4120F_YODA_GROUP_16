import wave
import numpy as np

def wav_to_float(wav_file):
    """
    Convert WAV file to 32-bit float raw data.
    
    Args:
        wav_file (str): Path to the WAV file.
        
    Returns:
        np.ndarray: Audio data as a numpy array of 32-bit float values.
    """
    with wave.open(wav_file, 'r') as wav:
        # Get WAV file parameters
        num_channels = wav.getnchannels()
        sample_width = wav.getsampwidth()
        sample_rate = wav.getframerate()
        num_frames = wav.getnframes()
        
        # Read WAV file data
        wav_data = wav.readframes(num_frames)
        
        # Convert bytes to a numpy array
        np_data = np.frombuffer(wav_data, dtype=np.int16)
        
        # Convert numpy array to 32-bit float
        float_data = np_data.astype(np.float32) / (2 ** 15)
        
        # Reshape the array based on the number of channels
        if num_channels == 1:
            audio_data = float_data
        else:
            audio_data = float_data.reshape(-1, num_channels)
        
        return audio_data, sample_rate

# Example usage
wav_file = 'taunt.wav'
audio_data, sample_rate = wav_to_float(wav_file)
print(f"Audio data shape: {audio_data.shape}")
print(f"Sample rate: {sample_rate} Hz")
print("32-bit float values:")
print(audio_data)