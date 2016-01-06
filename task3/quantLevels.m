function [D, L] = quantLevels(n, xmin, xmax)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

k = 2 ^ n;
D = zeros(k - 1, 1);
L = zeros(k, 1);
delta = (xmax - xmin) / k;

L(1) = xmin + delta / 2;
L(2:end, 1) = transpose(1:k-1) * delta + L(1);

D(1) = xmin + delta;
D(2:end, 1) = transpose(1:k-2) * delta + D(1); 

end

