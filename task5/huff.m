function [b] = huff(q, s)
%HUFF Encodes the given signal using the huffman code provided.
% Q An array containing the indexes of every symbol.
% S A cell array containing the huffman code for each symbol.
% B A character array containing the encoded sequence.
b = '';
for i = 1:length(q)
    b = [b, s{q(i)}];
end

end

