function state = initStateEncoder()
% Initialize the parameters for the linear predictor.

[m, nq] = initPredictionFilter(1, 16);

% The number of bits used to quantize the signal.
state.signalQuantBits = initSignalQuantizer();

% The order for the prediction filter.
state.m = m;
% The number of bits used to quantize the weights of the predictor.
state.weightWordLen = nq;

% The size of 
state.windowSize = getParams();

[signalSizeWordLen, windowSizeWordLen, floatingPointRep] = initWordSizes();
state.floatingPointRep = floatingPointRep;
state.signalSizeWordLen = signalSizeWordLen;
state.windowSizeWordLen = windowSizeWordLen;

% Upsampling factor.
state.L = 1;

% Downsampling Factor
state.M = 3;

end
