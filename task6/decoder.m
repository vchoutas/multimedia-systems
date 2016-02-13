function [x,newstate]=decoder(b,state)


m = state.m;
nq = state.nq;
% Read huffman from file
counter = 1;
s = {};
for i = 1 : nq^2
    huffmanLength = bin2dec(b(counter : counter + 3));
    s{i} = b(counter + 4 : counter + 4 + huffmanLength - 1);
    counter = counter + 4 + huffmanLength; 
end
% Read L from file
L = zeros(nq,1);
for i = 1: nq^2
   binL = b(counter:counter+63);
   L(i) = typecast(uint8(bin2dec(reshape(binL,8,[]).')),'double');
   counter = counter + 64;
end
% compute Wmin Wmax
binWmin = b(counter:counter+63);
minW = typecast(uint8(bin2dec(reshape(binWmin,8,[]).')),'double');
counter = counter + 64;
binWmax = b(counter:counter+63);
maxW = typecast(uint8(bin2dec(reshape(binWmax,8,[]).')),'double');
counter = counter + 64;
minW
maxW
% Read Wq
for i = 1:m
    wq(i) = bin2dec(b(counter : counter+3));
    counter = counter + 4;
end

% Read q
b = b(counter:end);

% pause
[rq, n] = ihuff(b, s);

x = iadpcm(rq, wq, L,minW, maxW, 1);
newstate = state;

