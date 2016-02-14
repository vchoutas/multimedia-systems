function [x, newstate] = decoder(b, state)

% counter is a variable in order to find everything's position 
% in the bitstream

m = state.m;
weightQuantBits = state.weightQuantBits;
signalQuantBits = state.signalQuantBits;
counter = 1;

%% Read huffman from file
s = {};

huffmanWordLength = 2 ^ state.signalQuantBits;


for i = 1 : huffmanWordLength
    huffmanLength = bin2dec(b(counter : counter + huffmanWordLength - 1));
    counter = counter + huffmanWordLength;
    s{i} = b(counter : counter + huffmanLength - 1);
    counter = counter + huffmanLength; 
end

%% Read L from file
L = zeros(2 ^ signalQuantBits,1);

% Check the type of floating point precision used in order to find the
% number of bits used for each of the quantization levels.
if strcmp(state.floatingPointRep, 'single')
    quantLevelWordSize = 32;
    weightWordSize = 32;
else
    quantLevelWordSize = 64;
    weightWordSize = 64;
end

for i = 1: length(L)
   binL = b(counter : counter + quantLevelWordSize - 1);

   L(i) = typecast(uint8(bin2dec(reshape(binL, 8, []))), 'double');

   counter = counter + quantLevelWordSize;
end

%% Read Wmin Wmax from file

binWmin = b(counter : counter + weightWordSize - 1);
minW = typecast(uint8(bin2dec(reshape(binWmin, 8, []).')), 'double');
counter = counter + weightWordSize;
binWmax = b(counter : counter+weightWordSize - 1);
maxW = typecast(uint8(bin2dec(reshape(binWmax, 8, []).')), 'double');
counter = counter + weightWordSize;


% Read Wq
wqsize = 2 ^ weightQuantBits;

% Initialize the array containing 
wq = zeros(m, 1);
for i = 1:m
    wq(i) = bin2dec(b(counter : counter + wqsize - 1));
    counter = counter + wqsize;
end

% Read the coded Huffman
b = b(counter:end);


% Find the inverse huffman
[rq, n] = ihuff(b, s);

% Compute the encoded x
x = iadpcm(rq, wq, L, minW, maxW, weightQuantBits);

newstate = state;

end

