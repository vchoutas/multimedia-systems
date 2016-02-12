function [D, L] = quantLevels(n, xmin, xmax)
%QUANTLEVELS Calculates the quantization regions and levels for a uniform
%quantizer.
% n The desired number of bits for the symbols of the quantizer.
% xmin The minimum value for the input of the quantizer.
% xman The maximum value for the input of the quantizer.

% Calculate the number of levels.
k = 2 ^ n;
% Initialise the output vectors.
D = zeros(k - 1, 1);
L = zeros(k, 1);
% Calculate the step size.
delta = (xmax - xmin) / k;

% Calculate the quantization levels.
L(1) = xmin + delta / 2;
L(2:end, 1) = transpose(1:k-1) * delta + L(1);

% Calculate the quantization regions.
D(1) = xmin + delta;
D(2:end, 1) = transpose(1:k-2) * delta + D(1); 

end

