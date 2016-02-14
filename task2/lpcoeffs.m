function [w, varargout] = lpcoeffs(x, m, debug)
%LPCOEFFS Calculates the coefficients of an optimal linear predictor for 
% the given signal.
% x The input signal.
% m The order of the filter/predictor.
% debug A flag used for debugging purposes.

if nargin < 3
    debug = false;
    varargout = cell(0);
else
    if debug
        varargout = cell(3);
    else
        varargout = cell(0);
    end
end

% Calculate the autocorrelation of the input signal.
correlationVec = zeros(m + 1, 1);
for k = 0:m
    % Shift the input signal by k.
    xShifted = x(1 + k:end);    
    % Calculate the autocorrelation for the current shift.
    correlationVec(k + 1) = sum(x(1:end- k) .* ...
        xShifted);
end

% Create the autocorrelation matrix.
R = zeros(m, m);
for i = 1:m
    % Assign to the elements of the upper triangle and of the diagonal 
    % of the matrix the first m - i + 1 elements of the correlation vector.
    R(i, i:end) = correlationVec(1:m - i + 1);
    % Assign to the elements of the lower triangle of the matrix the
    % the first i elements of the correlation vector in inverse order.
    R(i, 1:i) = correlationVec(i:-1:1);
end

if debug
    varargout{1} = correlationVec;
    varargout{2} = R;
end

% Create the correlation vector.
v = correlationVec(2:m + 1);
v = v(:);

% Solve the linear system so as to calculate the optimal weights.
w = R \ v;

end

