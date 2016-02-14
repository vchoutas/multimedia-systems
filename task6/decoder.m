function [x,newstate]=decoder(b,state)

% counter is a variable in order to find everything's position 
% in the bitstream

m = state.m;
nq = state.nq;
counter = 1;

%% Read huffman from file
s = {};
sizeofhumanlength = 4;
for i = 1 : 2^nq
    huffmanLength = bin2dec(b(counter : counter + sizeofhumanlength-1));
    counter = counter + sizeofhumanlength;
    s{i} = b(counter : counter + huffmanLength - 1);
    counter = counter + huffmanLength; 
end

%% Read L from file
L = zeros(nq,1);
sizeofL = 32;
for i = 1: 2^nq
   binL = b(counter : counter + sizeofL - 1);
   L(i) = typecast(uint8(bin2dec(reshape(binL, 8, []).')), 'single');
   counter = counter + sizeofL;
end
%% Read Wmin Wmax from file
sizeofWminmax = 32;
binWmin = b(counter : counter + sizeofWminmax - 1);
minW = typecast(uint8(bin2dec(reshape(binWmin, 8, []).')), 'single');
counter = counter + sizeofWminmax;
binWmax = b(counter : counter+sizeofWminmax - 1);
maxW = typecast(uint8(bin2dec(reshape(binWmax, 8, []).')), 'single');
counter = counter + sizeofWminmax;

% Read Wq
wqsize = 4;
for i = 1:m
    wq(i) = bin2dec(b(counter : counter + wqsize - 1));
    counter = counter + wqsize;
end

% Read the coded Huffman
b = b(counter:end);


%% Find the inverse huffman
[rq, n] = ihuff(b, s);

%% Compute the encoded x
x = iadpcm(rq, wq, L,minW, maxW, 1);
newstate = state;

