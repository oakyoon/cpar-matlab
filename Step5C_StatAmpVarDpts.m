%
% Script for statistical tests for Figure 6.
%
% This script relies on bayesFactor Toolbox, which requires Statistics and
% Machine Learning Toolbox. The bayesFactor toolbox files, including a LICENSE
% file, are located under the lib/bayesFactor-2.2.0/ directory.
%
% bayesFactor Toolbox github repository: https://klabhub.github.io/bayesFactor/
%

clear;
addpath('lib', fullfile('lib', 'bayesFactor-2.2.0'));

% Load generated data.
load(fullfile('data-fitted', 'Step5_AmpVarDpts.mat'));



% Estimate data density (data points/sec for data points < 90% quantile).
dataDensity = zeros(size(xData));
for i = 1:numel(xData)
	q90 = quantile(xData{i}, .90);
	dataDensity(i) = sum(xData{i} < q90) / q90;
end



% Print data density and t-test results (CPAR).
avgDataDensity = mean(mean(dataDensity, 1), 3);
[~, rcdfIdx] = min(abs(modelFreqs - rhythmF));

fprintf('\n');
fprintf('Data Points  Data Density    BF\x2081\x2080\n');
fprintf('-----------  ------------  --------\n');
for j = 1:length(nDataPoints)
	ampEstdStrong = cellfun(@(v) v(rcdfIdx), squeeze(ampEstd(1, j, :)));
	ampEstdWeak   = cellfun(@(v) v(rcdfIdx), squeeze(ampEstd(2, j, :)));
	BF10 = bf.ttest(ampEstdStrong, ampEstdWeak);

	fprintf('   %4d        %4d dp/s   %8.2f\n', ...
		nDataPoints(j), round(avgDataDensity(j)), BF10);
end
fprintf('\n');
