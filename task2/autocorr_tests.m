%% TEST SCRIPT
% Used to check if our autocorrelation vector and matrix calculations are
% correct.
clear all
close all

% Define different filter sizes.
M = [1 2 3 4 5 10 20 40];

for i = 1:length(M)
    
    m = M(i);
    N = 1000;
    
    % Create a constant sequence.
    x = ones(N, 1);
    
    test_lpcoeffs_autocorr(x, m, 'Constant Sequence');
    
    % Create an increasing integer sequence.
    x = [1:N];
    x = x(:);
    
    test_lpcoeffs_autocorr(x, m, 'Integer Increasing Sequence');
    
    N = 10;
    
    % Create an increasing decimal sequence.
    x = 0:0.1:N;
    x = x(:);
    
    test_lpcoeffs_autocorr(x, m, 'Decimal Increasing Sequence');
    
    % Create a random sequence drawn from a uniform distribution.
    N = 1000;
    x = rand(N, 1);
    
    test_lpcoeffs_autocorr(x, m, ...
        'Random Sequence with Uniform Distribution');
    
    % Create a random sequence drawn from a gaussian distribution.
    x = 10 + 2 * randn(N, 1);
    test_lpcoeffs_autocorr(x, m, ...
        'Random Sequence with Gaussian Distribution');
    
end