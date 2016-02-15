function [x, newstate] = decoder(b, state)
%DECODER Takes as input the current state of the decoder and a bitstream
%and returns the decoded sequence as well the new state of the decoder.
%B Is the bitstream that will be decoded
%STATE The current state of the decoder. It is used to store useful
% information and data of the decoder
%X The decoded sequence.
%NEWSTATE The new state of the decoder.

% Get the order of the prediction filter.
m = state.m;
% Get the number of bits used to store each quantized weight.
weightWordLen = state.weightWordLen;
% Get the number of bits used for the signal quantization.
signalQuantBits = state.signalQuantBits;
% Initialize a counter that will be used to index our current position in
% the bitstream.
counter = 1;

%% Read the Huffman code from the bitstream
huffmanWordLength = state.signalQuantBits;
% Calculate the number of codewords.
numWords = 2 ^ huffmanWordLength;

% Extract every one of them from the bitstream.
s = cell(numWords, 1);
for i = 1 : numWords
    % First extract the size of the current word.
    huffmanLength = bin2dec(b(counter : counter + huffmanWordLength - 1));
    counter = counter + huffmanWordLength;
    % Extract the current word and update our position counter.
    s{i} = b(counter : counter + huffmanLength - 1);
    counter = counter + huffmanLength;
end


%% Read L from file
L = zeros(2 ^ signalQuantBits,1);

% Check the type of floating point precision used in order to find the
% number of bits used for each of the quantization levels.
floatRepresentation = state.floatingPointRep;

if strcmp(floatRepresentation, 'single')
    quantLevelWordSize = 32;
    weightWordSize = 32;
else
    quantLevelWordSize = 64;
    weightWordSize = 64;
end

% Extract and calculate the quantization levels from the bitstream.
for i = 1: length(L)
    % Since we used a uniform quantizer we only need to store two
    % quantization levels
    if i <= 2
        currentBinLevel = b(counter : counter + quantLevelWordSize - 1);
        
        if strcmp(floatRepresentation, 'double')
            L(i) = hex2num(bin2hex(currentBinLevel));
        else
            currentLevel = typecast(hex2num(bin2hex(currentBinLevel)), ...
                'single');
            L(i) = currentLevel(2);
        end
        counter = counter + quantLevelWordSize;
        if i == 2
            Delta = L(2) - L(1);
        end
    % And we can calculate the rest from the first two.
    else
        L(i) = L(i - 1) + Delta;
    end
end


%% Read the min and max weights.

minWeightBin = b(counter:counter + weightWordSize - 1);
counter = counter + weightWordSize;

maxWeightBin = b(counter : counter+weightWordSize - 1);

% Perform the correct cast in order to get the correct floating point
% representation.
if strcmp(floatRepresentation, 'double')
    maxWeight = hex2num(bin2hex(maxWeightBin));
    minWeight = hex2num(bin2hex(minWeightBin));    
else
    tmp = typecast(hex2num(bin2hex(minWeightBin)), ...
        'single');
    minWeight = tmp(2);
    tmp = typecast(hex2num(bin2hex(maxWeightBin)), ...
        'single');
    maxWeight = tmp(2);
end

% Update the counter.
counter = counter + weightWordSize;


% Read the filter weights.
% Initialize the array containing them.
wq = zeros(m, 1);
for i = 1:m
    wq(i) = bin2dec(b(counter : counter + weightWordLen - 1)) + 1;
    counter = counter + weightWordLen;
end

% Read the coded Huffman
b = b(counter:end);

% Find the inverse huffman
[rq, n] = ihuff(b, s);

% Compute the encoded x
x = iadpcm(rq, wq, L, minWeight, maxWeight, weightWordLen);

% Update the state and return.
newstate = state;

end

