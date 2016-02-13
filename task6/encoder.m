function [b, newstate] = encoder(x, state)
% D = state.D;
m = state.m;
nq = state.nq;
% L = state.L;
fileId = state.fileId;
%% Number of quantization of W
n = 1;

%% Compute w
x = x';
w=lpcoeffs(x,m);
wmin = min(w);
wmax = max(w);


%% Use adpcm
x = x';
xmin = min(x);
xmax = max(x);
[D, L] = quantLevels(nq, xmin, xmax);
[rq, wq]=adpcm(x, D, L, m, wmin, wmax, n);

%% find huffman dictionary
p = zeros(2^nq,1);
for i =1 : 2^nq
    p(i) = length(find(rq == i))/length(rq);
end
s=huffLUT(p);

% isze of huffman dictionary
counter = computeHuffmansize(s, 4);
% if counter~=25
%     counter
% end
    

for i =1:length(L)
    binaryL = reshape(dec2bin(typecast(L(i), 'uint8'),8).',1,[]); 
    counter = counter + length(binaryL);
end


minW = reshape(dec2bin(typecast(min(w), 'uint8'),8).',1,[]); 
maxW = reshape(dec2bin(typecast(max(w), 'uint8'),8).',1,[]); 
counter = counter + 2*length(minW);
 
% wq
counter = counter + length(wq)*4;

b = huff(rq, s);

counter = counter + length(b);


binCounter = dec2bin(counter, 24);
fprintf(fileId,'%c',binCounter);
printHuffman(s, fileId, 4);
for i =1:length(L)
    binaryL = reshape(dec2bin(typecast(L(i), 'uint8'),8).',1,[]); 
    fprintf(fileId,'%c', binaryL); 
end
fprintf(fileId,'%c',minW); 
fprintf(fileId,'%c',maxW);
for i =1:length(wq)
    fprintf(fileId,'%c' ,dec2bin(wq(i), 4));
end

newstate = state;
