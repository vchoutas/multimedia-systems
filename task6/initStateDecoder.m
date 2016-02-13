function state = initStateDecoder()

% Initialize the parameters for the linear predictor.
[m, nq] = initPredictionFilter(1, 2);

% The number of bits used to quantize the signal.
state.signalQuantBits = 2;

% The order for the prediction filter.
state.m = m;
% The number of bits used to quantize the weights of the predictor.
state.weightQuantBits = nq;

% The size of 
state.windowSize = getParams();

% Upsampling factor.
state.L = 3;

% Downsampling Factor
state.M = 1;


end
