function [rq, wq]=adpcm(x, D, L, m, wmin, wmax, n)
%ADPCM Applies the Adaptive Differential Pulse Code Modulation algorithm on
% the input signal.
% x The input signal.
% D The  for the input signal.
% L The quantization levels for the input signal.
% m The order of the prediction filter.
% wmin The minimum weight value allowed.
% wmax The maximum weight value allowed.
% n The number of quantization levels for the filter coefficients.


addpath ../task3/
addpath ../task2/

% Initialize the vector that will contained the symbols for the quantized
% weight vector.
wq  = zeros(m, 1);

% Find the filter Coefficients
w = lpcoeffs(x, m);

% Calculate the qu
[Dw, Lw] = quantLevels(n, wmin, wmax);
for i = 1:length(w)
    wq(i) = Quant(w(i), Dw);
end

% Get the quantized weights.
wd = iQuant(wq, Lw);

% Initialise the output symbol vector.
rq = zeros(size(x));
xHat = zeros(length(x), 1);
for i = 1:m
    xHat(i) = x(i);
    rq(i) = Quant(x(i), D);
end

% Stabilise the transfer function for the quantized weights if necessary.
stableWeights = stabilise_weights(wd);

% Calculate the symbols for the prediction errors.
for i=m + 1:length(x)        
    % Start by calculating the prediction error.
    d = x(i) - stableWeights' * xHat(i:-1:i - m + 1);
    % Quantize the prediction error.
    rq(i) = Quant(d, D);    
    % Calculate an estimate for the signal for the current time step in
    % order to use it in the next step to compute the prediction error.
    xHat(i) = iQuant(rq(i), L) + stableWeights' * xHat(i:-1:i - m + 1);
end

end
  
