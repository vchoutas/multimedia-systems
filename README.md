# Project Description

The goal of the project was the creation of a simple audio encoder-decoder
system. It was the main assignment for the Multimedia Systems and Virtual Reality
course of the Electrical and Computer Engineering Department of the Aristotle University
of Thessaloniki.

## Encoder

The encoding procedure is implemented using the following steps:

1. Downsample the signal
2. Divide the signal into non overlapping frames
3. For each frame:
  1. Calculate the parameters of the optimal linear predictor.
  2. Quantize the signal and the parameters using a uniform quantizer.
  3. Apply the [A-DPCM](https://en.wikipedia.org/wiki/Adaptive_differential_pulse-code_modulation).
  4. Encode the current window using [Huffman Coding](https://en.wikipedia.org/wiki/Huffman_coding)
  5. Write the number of bits required, the Huffman code, the first two levels of the quantizer,
     the minimum and maximum value of the predictor and finally the encoded window to a file. These
     bits contain all the information needed to reconstruct the signal.

## Decoder

Iterate over the windows and decode them one at a time:

1. Extract the stored data from the bit stream
2. Reconstruct the quantizer
3. Decode the data using the huffman tree
4. Apply the inverse of the A-DPCM algorithm
5. Concatenate the reconstructed windows
6. Upsample the signal to it's original frequency

