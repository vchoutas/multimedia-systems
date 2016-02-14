function test_lpcoeffs_autocorr(x, m, testName)
%TEST_LPCOEFFS_AUTOCORR Summary of this function goes here
%   Detailed explanation goes here

[~, corrVec, R] = lpcoeffs(x, m, true);

[trueCorrVec, lags] = xcorr(x, m);
trueCorrVec = trueCorrVec(lags >= 0);

testSuccess = true;
fprintf('TEST %s with m = %d: ', testName, m);

if length(corrVec) ~= length(trueCorrVec)
    fprintf('FAILED. Correlation vector has incorrect length!\n');
    return
end

corrVecMse = 1/ length(corrVec) * sum((trueCorrVec - corrVec).^2);
if  corrVecMse >= 1e-4
    fprintf('\n\tFAILED. CorrelationVec MSE > 1e-4 !\n');
    testSuccess = false;
end

corrMatMse = 1 / length(R(:)) * sum(sum((R - ...
    toeplitz(trueCorrVec(1:end - 1) )).^2));

if  corrMatMse >= 1e-4
    fprintf('\n\tFAILED. Correlation Matrix MSE > 1e-4 !\n');
    testSuccess = false;
end

if testSuccess
    fprintf('PASSED \n');
end

end

