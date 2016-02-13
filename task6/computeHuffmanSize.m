function counter = computeHuffmanSize(s, wordSize)
% s : huffman dictionary
% wordSize : how many bits are used to save each word in huffman
% dictionary
counter = 0;
for i =1:length(s)
   counter = counter + wordSize;   
   words_length = length(s{i});
   binary_length = dec2bin(words_length, wordSize); 
   counter = counter + words_length;
   
%    fprintf(fileId,'%c', binary_length);
%    fprintf(fileId,'%c',s{i});
end

end

