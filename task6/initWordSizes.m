function [signalSizeWordLen, windowSizeWordLen, floatingPointSize] ...
    = initWordSizes()
%INITWORDSIZES Initializes parameters related to the encoder/decoder
%system.

% Represents the number of bits used to store the size of the original
% signal before it's compression.
signalSizeWordLen = 32;

% Represents the bits used for storing the number of bits in every window.
windowSizeWordLen = 24;

% Contains the data type that is used to store the quantization levels for
% the signal.
floatingPointSize = 'single';

end

