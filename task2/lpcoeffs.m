function [w] = lpcoeffs(x, m)
%LPCOEFFS Calculates the coefficients of an optimal linear predictor for 
% the given signal.
% x The input signal.
% m The order of the filter/predictor.

% Calculate the autocorrelation of the input signal.
[correlationVec, lags] = xcorr(x, m, 'unbiased');


correlationVec = correlationVec(lags >= 0);

% Create the autocorrelation matrix.
R = toeplitz(correlationVec(1:m));

% Create the correlation vector.
v = correlationVec(2:m+1);
v = v(:);

% Solve the linear system so as to calculate the optimal weights.
w = R \ v;

end

