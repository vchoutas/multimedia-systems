function [binaryString] = hex2bin(hexString)
%HEX2BIN Converts a hexString to its corresponding binary represantion.

binaryString = repmat(char(0), 1, 4 * length(hexString));
for i = 1:length(hexString)
    currentDigit = hexString(i);
    if strcmpi(currentDigit, '0')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '0000';
    elseif strcmpi(currentDigit, '1')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '0001';
    elseif strcmpi(currentDigit, '2')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '0010';
    elseif strcmpi(currentDigit, '3')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '0011';
    elseif strcmpi(currentDigit, '4')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '0100';
    elseif strcmpi(currentDigit, '5')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '0101';
    elseif strcmpi(currentDigit, '6')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '0110';
    elseif strcmpi(currentDigit, '7')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '0111';
    elseif strcmpi(currentDigit, '8')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '1000';
    elseif strcmpi(currentDigit, '9')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '1001';
    elseif strcmpi(currentDigit, 'A')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '1010';
    elseif strcmpi(currentDigit, 'B')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '1011';
    elseif strcmpi(currentDigit, 'C')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '1100';
    elseif strcmpi(currentDigit, 'D')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '1101';
    elseif strcmpi(currentDigit, 'E')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '1110';
    elseif strcmpi(currentDigit, 'F')
        binaryString(1 + (i - 1) * 4:1 + 4 * i - 1) = '1111';
    else
        fprintf('Invalid char %c provided for binary conversion!\n', ...
            currentDigit);
    end 
end

end