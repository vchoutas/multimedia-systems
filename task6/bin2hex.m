function [hexString] = bin2hex(binarySequence)
%BIN2HEX Converts a binary string to it's corresponding hexadecimal
%represantation.
% binarySequence The input binary sequence that must be converted.
% hexString The output equivalent hexadecimal string.

if mod(length(binarySequence), 4) ~= 0
    fprintf('ERROR: Invalid Binary Sequence provided!\n');
    return
end

hexString = repmat(char(0), 1, length(binarySequence) / 4);

for i = 1:length(hexString)
    currentHexChar = binarySequence(1 + (i - 1) * 4:1 + 4 * i - 1);
    if strcmp(currentHexChar, '0000')
        hexString(i) = '0';
    elseif strcmp(currentHexChar, '0001')
        hexString(i) = '1';
    elseif strcmp(currentHexChar, '0010')
        hexString(i) = '2';
    elseif strcmp(currentHexChar, '0011')
        hexString(i) = '3';
    elseif strcmp(currentHexChar, '0100')
        hexString(i) = '4';
    elseif strcmp(currentHexChar, '0101')
        hexString(i) = '5';
    elseif strcmp(currentHexChar, '0110')
        hexString(i) = '6';
    elseif strcmp(currentHexChar, '0111')
        hexString(i) = '7';
    elseif strcmp(currentHexChar, '1000')
        hexString(i) = '8';
    elseif strcmp(currentHexChar, '1001')
        hexString(i) = '9';
    elseif strcmp(currentHexChar, '1010')
        hexString(i) = 'A';
    elseif strcmp(currentHexChar, '1011')
        hexString(i) = 'B';
    elseif strcmp(currentHexChar, '1100')
        hexString(i) = 'C';
    elseif strcmp(currentHexChar, '1101')
        hexString(i) = 'D';
    elseif strcmp(currentHexChar, '1110')
        hexString(i) = 'E';
    else
        hexString(i) = 'F';
    end
end

end

