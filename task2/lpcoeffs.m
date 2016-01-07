function [w] = lpcoeffs(x, m)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[correlationVec, lags] = xcorr(x, m, 'unbiased');
correlationVec = correlationVec(lags >= 0);
R = toeplitz(correlationVec(1:m));

w = R \ correlationVec(2:end);

end

