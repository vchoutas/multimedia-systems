function [b, newstate] = encoder(x, state)
%ENCODER Takes as input the current state of the encoder and a part of the
% signal and returns an encoded bitstream, as well the new state of the 
% decoder.
%X Is the signal that will be encoded.
%STATE The current state of the encoder. It is used to store useful
% information and data of the encoder
%B The encoded sequence.
%NEWSTATE The new state of the encoder.

% Get the filter order.
m = state.m;
% Get the number of bits that will be used when quantizing the signal.
signalQuantBits = state.signalQuantBits;

% Get the number of bits used to store each quantized weight.
weightWordLen = state.weightWordLen;

% Compute the weights for the optimal linear predictor.
x = x(:);
w = lpcoeffs(x, m);

% Get the weights' range.
minWeight = min(w);
maxWeight = max(w);

if size(x, 2) ~= 1
    x = x(:);
end
% Get the range of the signal.
xMin = min(x);
xMax = max(x);

% Get the quantization regions and levels for the signal.
[D, L] = quantLevels(signalQuantBits, xMin, xMax);

% Apply the A-DPCM Algorithm to create the difference signal.
[rq, wq] = adpcm(x, D, L, m, minWeight, maxWeight, weightWordLen);

% Calculate the probabilities for each symbol.
p = zeros(2 ^ signalQuantBits, 1);
for i =1 : 2 ^ signalQuantBits
    p(i) = length(find(rq == i))/length(rq);
end
% Create the Huffman Dictionary.
s = huffLUT(p);

% compute size of bitstream
bitStreamSize = computeHuffmanSize(s, signalQuantBits);

minWeight = min(w);
maxWeight = max(w);

floatRepresentation = state.floatingPointRep;

% Convert the quantization levels, the minimum and the maximum value of the
% weights to a single precision represenation if necessary.
if strcmp(floatRepresentation, 'single')
    L = single(L);
    minWeight = single(minWeight);
    maxWeight = single(maxWeight);
end


% Initialize the cell array containing the binary form of the quantization
% levels.
quantLevelsBin = cell(length(L), 1);

% Convert the quantization levels to their equivalent binary
% representation. 
% We will only store the first two, since we can calculate the rest from
% them due to the usage of the uniform quantizer.
for i =1:2
    % First convert the current level value to a hexadecimal value and then
    % to its corresponding binary form.    
    hexString = num2hex(L(i));    
    quantLevelsBin{i} = hex2bin(hexString);    
    bitStreamSize = bitStreamSize + length(quantLevelsBin{i});
end

% Convert the weights to their equivalent binary form.
minWeightBin = hex2bin(num2hex(minWeight));
maxWeightBin = hex2bin(num2hex(maxWeight));

bitStreamSize = bitStreamSize + length(minWeightBin) + ...
    length(maxWeightBin);

% Update the length of the bitstream with the number of weights.
bitStreamSize = bitStreamSize + length(wq) * weightWordLen;

%% Find huffman coding
encodedSignal = huff(rq, s);

% total length
% bitStreamSize = bitStreamSize + length(b);
bitStreamSize = bitStreamSize + length(encodedSignal);

%counters binary representation

windowWordSize = state.windowSizeWordLen;
binCounter = dec2bin(bitStreamSize, windowWordSize);

%% Construct the bistream

% Use a file as a temporary buffer for the code.
b = [binCounter];

huffmanWordSize = signalQuantBits;

% Store the huffman code
for i = 1:length(s)
    b = [b dec2bin(length(s{i}), huffmanWordSize) s{i}];
end

% Store the quantization levels.
for i =1:2 
    b = [b quantLevelsBin{i}];
end

% Append the minimum and maximum weights to the bistream.
b = [b minWeightBin maxWeightBin];

% Store the filter weights.
for i =1:length(wq)
    b = [b dec2bin(wq(i) - 1, weightWordLen)];
end

% Finally append the encoded signal, update the state and return.
b = [b encodedSignal];
newstate = state;

end