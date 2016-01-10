function [b] = huff(q, s)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

b = '';

for i = 1:length(q)
    b = [b, s{q(i)}];
end

end

