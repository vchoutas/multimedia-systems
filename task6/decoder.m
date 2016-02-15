function [x, newstate] = decoder(b, state)

% counter is a variable in order to find everything's position
% in the bitstream

m = state.m;
weightWordLen = state.weightWordLen;
signalQuantBits = state.signalQuantBits;
counter = 1;

%% Read huffman from file
huffmanWordLength = state.signalQuantBits;
numWords = 2 ^ huffmanWordLength;

s = cell(numWords, 1);
for i = 1 : numWords
    huffmanLength = bin2dec(b(counter : counter + huffmanWordLength - 1));
    counter = counter + huffmanWordLength;
    
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


for i = 1: length(L)
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
    else
        L(i) = L(i - 1) + Delta;
    end
end


%% Read Wmin Wmax from file

minWeightBin = b(counter:counter + weightWordSize - 1);
counter = counter + weightWordSize;

maxWeightBin = b(counter : counter+weightWordSize - 1);


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

counter = counter + weightWordSize;


% Read Wq
% Initialize the array containing
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

newstate = state;

end

