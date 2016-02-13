function [m, nq] = initPredictionFilter(desiredFilterOrder, ...
    filterQuantLevels)
%INITPREDICTIONFILTER Summary of this function goes here
%   Detailed explanation goes here

persistent filterOrder;
persistent predictorQuantLevels;

% Define the default values.
if nargin < 1 
    if isempty(filterOrder) && isempty(predictorQuantLevels)
        filterOrder = 1;
        predictorQuantLevels = 1;
    end
elseif nargin < 2
    filterOrder = desiredFilterOrder;
    predictorQuantLevels = 4;
else
    filterOrder = desiredFilterOrder;
    predictorQuantLevels = filterQuantLevels;
end
    

if isempty(filterOrder)
    fprintf('ERROR: The filter Order was not initiliazed!\n');
    return
end

if isempty(predictorQuantLevels)
    fprintf(['ERROR: The filter weights quantization bit number was' ...
        ' not initiliazed!\n']);
    return
end

m = filterOrder;
nq = predictorQuantLevels;

end

