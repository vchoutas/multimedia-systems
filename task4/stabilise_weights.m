function [stableWeights] = stabilise_weights(inputWeights)
%STABILISE_WEIGHTS Perfoms stabilisation on the quantized weights of the
%predictor filter if they haves unstable poles.
% inputWeights The quantized weights.
% stableWeights The output of the function that contains the new weights
% that correspond to a stable transfer function.

% Calculate the roots of the transfer function.
tfRoots = roots([1; -inputWeights(end:-1:1)]);

% Calculate the magnitude of each root.
mag = abs(tfRoots);

% Find all the unstable poles of the transfer function.
unstablePoles = tfRoots(mag > 1);
% If there are no unstable poles then return.
if isempty(unstablePoles)
    stableWeights = inputWeights;
    return
end
    
% Find all the stable poles of the transfer function.
stablePoles = tfRoots(mag <= 1);

% Calculate the stabilised poles by inverting their magnitude.
stabilisedPoles = exp(1i * angle(unstablePoles)) ./ abs(unstablePoles);

% Calculate the new denominator of the transfer function.
stableWeights = poly([stablePoles; stabilisedPoles]);
% Remove the 1st index, since it is always 1.
stableWeights = stableWeights(2:end);
% Convert the weight vector to a column-vector.
stableWeights = stableWeights(:);

end

