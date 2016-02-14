function state = initStateEncoder()
%% Number of previous elements in linear prediction
m = 1;
nq = 4;
%% Quantize find frequencies and HuffmanTree 
% Create quant levels
state.m = m;
state.nq = nq;
state.NofEl = 500;
end
