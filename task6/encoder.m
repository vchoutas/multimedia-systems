function [b, newstate] = encoder(x, state)
% ENCODER

m = state.m;
signalQuantBits = state.signalQuantBits;

weightQuantBits = state.weightQuantBits;

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
[rq, wq] = adpcm(x, D, L, m, minWeight, maxWeight, weightQuantBits);

% Calculate the probabilities for each symbol.
p = zeros(2 ^ signalQuantBits, 1);
for i =1 : 2 ^ signalQuantBits
    p(i) = length(find(rq == i))/length(rq);
end
% Create the Huffman Dictionary.
s = huffLUT(p);

% compute size of bitstream
counter = computeHuffmanSize(s, 2 ^ signalQuantBits);

% size of L
for i =1:length(L)
    binaryL = reshape(dec2bin(typecast(L(i), 'uint8'),8).',1,[]); 
    counter = counter + length(binaryL);
end

% size of Wmin anf Wmax
minWeight = reshape(dec2bin(typecast(min(w), 'uint8'),8).',1,[]); 
maxWeight = reshape(dec2bin(typecast(max(w), 'uint8'),8).',1,[]); 

counter = counter + length(minWeight) + length(maxWeight);

% size of bitstream
counter = counter + length(wq) * 2 ^ weightQuantBits;

%% Find huffman coding
b = huff(rq, s);

% total length
counter = counter + length(b);

%counters binary representation


windowWordSize = state.windowSizeWordLen;
binCounter = dec2bin(counter, windowWordSize);

fileId = state.fileID;

% Use a file as a temporary buffer for the code.
fprintf(fileId,'%c', binCounter);

printHuffman(s, fileId, 2 ^ signalQuantBits);

for i =1:length(L)
    binaryL = reshape(dec2bin(typecast(L(i), 'uint8'), 8).', 1, []);
    
    fprintf(fileId, '%c', binaryL);
end

fprintf(fileId, '%c', minWeight);
fprintf(fileId, '%c', maxWeight);

for i =1:length(wq)
    fprintf(fileId,'%c', dec2bin(wq(i), 2 ^ weightQuantBits));
end

newstate = state;

end