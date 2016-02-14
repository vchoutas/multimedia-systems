function [b, newstate] = encoder(x, state)
% ENCODER

m = state.m;
signalQuantBits = state.signalQuantBits;

weightWordLen = state.weightWordLen;

% Compute the weights for the optimal linear predictor.
x = x(:);
w = lpcoeffs(x, m);

% Get the weights' range.
minWeight = min(w);
maxWeight = max(w);

x = x(:);
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
bitStreamSize = computeHuffmanSize(s, 2 ^ signalQuantBits);

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
for i =1:length(L)
    % First convert the current level value to a hexadecimal value and then
    % to its corresponding binary form.
    
    hexString = num2hex(L(i));
    
    quantLevelsBin{i} = hex2bin(hexString);
    
    bitStreamSize = bitStreamSize + length(quantLevelsBin{i});
end


minWeightBin = hex2bin(num2hex(minWeight));
maxWeightBin = hex2bin(num2hex(maxWeight));

bitStreamSize = bitStreamSize + length(minWeightBin) + ...
    length(maxWeightBin);

% size of bitstream
bitStreamSize = bitStreamSize + length(wq) * weightWordLen;

%% Find huffman coding
% b = huff(rq, s);
encodedSignal = huff(rq, s);

% total length
% bitStreamSize = bitStreamSize + length(b);
bitStreamSize = bitStreamSize + length(encodedSignal);

%counters binary representation

windowWordSize = state.windowSizeWordLen;
binCounter = dec2bin(bitStreamSize, windowWordSize);


% Use a file as a temporary buffer for the code.
b = [binCounter];

huffmanWordSize = 2 ^ signalQuantBits;

for i = 1:length(s)
    b = [b dec2bin(length(s{i}), huffmanWordSize) s{i}];
end

for i =1:length(L)    
    b = [b quantLevelsBin{i}];
end

b = [b minWeightBin maxWeightBin];

for i =1:length(wq)
    b = [b dec2bin(wq(i), weightWordLen)];
end

b = [b encodedSignal];
newstate = state;

end