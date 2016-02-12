function q = Quant(x, D)
%QUANT Performs quantization on the input value according to the given
%   steps.
% x The current sample
% D Quantization regions

k = length(D);
% If the value is larger than the largest level then assign the last
% symbol
if (x > max(D))
    q = k + 1;
% If it is smaller than the smallest level assign the first symbol.
elseif (x < min(D))
    q = 1;
% In any other case we have to find the correct level.
else
    % Compute the difference between each level and the sample.
    diffVector = D - x;
    % Find the index of the levels that are larger than the sample. 
    ind = find(diffVector > 0);
    % The first of them corresponds to the output symbol for the current
    % sample.
    q = ind(1);
end


end

