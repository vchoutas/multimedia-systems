function printHuffman(s, fileId, sizeofwords)
% s : huffman dictionary
% sizeofword : how many bits are used to save each word in huffman
% dictionary
% counter = 0;
for i =1:length(s)
%    counter = counter + sizeofword;   
   words_length = length(s{i});
   binary_length = dec2bin(words_length, sizeofwords); 
%    counter = counter + binary_length;
   fprintf(fileId,'%c', binary_length);
   fprintf(fileId,'%c',s{i});
end
