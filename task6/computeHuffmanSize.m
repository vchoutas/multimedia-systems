function counter = computeHuffmanSize(s, wordSize)
%COMPUTEHUFFMANSIZE Calculates the size of a Huffman dictionary
% s : huffman dictionary
% wordSize : how many bits are used to save each word in huffman
% dictionary
counter = 0;
for i =1:length(s)
   counter = counter + wordSize;   
   words_length = length(s{i});
   counter = counter + words_length;
end

end

