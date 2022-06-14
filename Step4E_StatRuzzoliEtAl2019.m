%
% Script for statistical tests for Figure 5 (Example 3).
%
% This script relies on bayesFactor Toolbox, which requires Statistics and
% Machine Learning Toolbox. The bayesFactor toolbox files, including a LICENSE
% file, are located under the lib/bayesFactor-2.2.0/ directory.
%
% bayesFactor Toolbox github repository: https://klabhub.github.io/bayesFactor/
%

clear;
addpath('lib', fullfile('lib', 'bayesFactor-2.2.0'));

% Load generated data (Example 3, first part).
load(fullfile('data-fitted', 'Step4B_RuzzoliEtAl2019.mat'));



% Print number of participants.
fprintf('\n');
fprintf('# of Participants: %d\n\n', size(xData, 2));



% Print number of data points.
numDataPoints = cellfun(@length, xData);
avgDataPoints = mean(numDataPoints, 2);
minDataPoints = min(numDataPoints, [], 2);
maxDataPoints = max(numDataPoints, [], 2);

fprintf('# of Data Points\n');
fprintf('----------------\n');
fprintf('       Avg.    Min.  Max.\n');
fprintf('Hit:  %6.2f   %3d   %3d\n', ...
	avgDataPoints(1), minDataPoints(1), maxDataPoints(1));
fprintf('Miss: %6.2f   %3d   %3d\n\n', ...
	avgDataPoints(2), minDataPoints(2), maxDataPoints(2));



% Print data density.
dataDensity = zeros(size(xData));
for i = 1:numel(xData)
	q90 = quantile(xData{i}, .90);
	dataDensity(i) = sum(xData{i} < q90) / q90;
end

fprintf('Data Density\n');
fprintf('------------\n');
fprintf('Avg.: %.2f dp/s\n', mean(dataDensity(:)));
fprintf('Min.: %.2f dp/s\n', min(dataDensity(:)));
fprintf('Max.: %.2f dp/s\n\n', max(dataDensity(:)));



% Print t-test results (CPAR).
[~, lbFreqIdx] = min(abs(modelFreqs - 5));
[~, ubFreqIdx] = min(abs(modelFreqs - 15));
ampEstdExtAlpha = cellfun(@(rsq) mean(rsq(lbFreqIdx:ubFreqIdx)), ampEstd');
[BF10, pValue]  = bf.ttest(ampEstdExtAlpha(:, 1), ampEstdExtAlpha(:, 2));

fprintf('Paired-Samples T-Test (5-15 Hz)\n');
fprintf('-------------------------------\n');
if (BF10 < 10000) && (BF10 > 0.01)
	fprintf('Estimated Amplitude: BF\x2081\x2080=%.2f, p=%.3f\n', BF10, pValue);
else
	fprintf('Estimated Amplitude: BF\x2081\x2080=%.2e, p=%.3f\n', BF10, pValue);
end



% Load generated data (Example 3, second part).
load(fullfile('data-fitted', 'Step4C_RuzzoliEtAl2019.mat'));
% Calcuate FFT frequency range.
fftFreqLb = 1 / fftWindow;
fftFreqUb = 1 / pdfBinSize / 2;
fftFreqs = fftFreqLb:fftFreqLb:fftFreqUb;
[~, lbFreqIdx] = min(abs(fftFreqs - 5));
[~, ubFreqIdx] = min(abs(fftFreqs - 15));

% Print t-test results (spectral analysis).
fftAmpExtAlpha = cellfun(@(amp) mean(amp(lbFreqIdx:ubFreqIdx)), fftAmp');
[BF10, pValue]  = bf.ttest(fftAmpExtAlpha(:, 1), fftAmpExtAlpha(:, 2));
if (BF10 < 10000) && (BF10 > 0.01)
	fprintf('FFT Spectral Power:  BF\x2081\x2080=%.2f, p=%.3f\n\n', BF10, pValue);
else
	fprintf('FFT Spectral Power:  BF\x2081\x2080=%.2e, p=%.3f\n\n', BF10, pValue);
end
