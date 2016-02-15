function xHat=iadpcm(rq, wq, L,wmin,wmax,n)
%IADPCM Applies the inverse Adaptive Differential Pulse Code Modulation so
%as to recover the original signal.
% rq The symbols for the prediction errors.
% wq The symbols for the quantized weights.
% L The quantization levels for the prediction errors.
% wmin The minimum weight value.
% wmax The maximum weight value.
% n The number of symbols used to quantize the weight vector.


addpath ../task3/
addpath ../task2/

% Calculate the quantization levels for the weight vector.
[~, Lw] = quantLevels(n, wmin, wmax);
% Initialise the weight vector.
w = zeros(length(wq), 1);

% Get the order of the filter.
m = length(w);

% Recover the values of the weights.
for i = 1:length(w)
    w(i) = iQuant(wq(i), Lw);
end

% Check if the resulting transfer function is unstable and invert the
% magnitude of the corresponding poles so as to stabilise it.
stableWeights = stabilise_weights(w);

% Initialise the signal estimation vector.
xHat = zeros(length(rq), 1);

% Initialise the prediction error vector.
dHat = zeros(size(xHat));

% Dequantize the prediction errors.
for i = 1:length(rq)
    dHat(i) = iQuant(rq(i), L);
end

xHat(1:m, 1) = dHat(1:m, 1);

% Calculate the signal values from the prediction errors and the optimal
% predictor.
for i = m + 1: length(xHat)
    xHat(i) = dHat(i) + stableWeights' * xHat(i - 1:-1:i - m); 
end

if size(xHat, 2) ~= 1
    xHat = xHat(:);
end

end
