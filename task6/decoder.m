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

sizeofL = 64;

for i = 1: length(L)
   binL = b(counter : counter + sizeofL - 1);
   L(i) = typecast(uint8(bin2dec(reshape(binL, 8, []).')), 'double');
   counter = counter + sizeofL;
end

%% Read Wmin Wmax from file
sizeofWminmax = 64;
binWmin = b(counter : counter + sizeofWminmax - 1);
minW = typecast(uint8(bin2dec(reshape(binWmin, 8, []).')), 'double');
counter = counter + sizeofWminmax;
binWmax = b(counter : counter+sizeofWminmax - 1);
maxW = typecast(uint8(bin2dec(reshape(binWmax, 8, []).')), 'double');
counter = counter + sizeofWminmax;


% Read Wq
wqsize = 2 ^ weightQuantBits;

for i = 1:m
    wq(i) = bin2dec(b(counter : counter + wqsize - 1));
    counter = counter + wqsize;
end

% Read the coded Huffman
b = b(counter:end);


% Find the inverse huffman
[rq, n] = ihuff(b, s);

% Compute the encoded x
x = iadpcm(rq, wq, L,minW, maxW, weightQuantBits);

newstate = state;

end

