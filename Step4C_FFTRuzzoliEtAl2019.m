%
% Script for analyzing human response time data with spectral analysis (Example
% 3, second part). The data generated with this script will be saved under the
% data-fitted/ directory.
%
% This script relies on Optimization Toolbox.
%

clear;
addpath('lib');

% Load variables defined in CommonVars_CDF.m.
CommonVars_CDF;

% Load the same human respnose time data used in the first part.
load(fullfile('data-fitted', 'Step4B_RuzzoliEtAl2019.mat'), ...
	'fileCount', ...
	'xData', ...
	'cpData' ...
	);

% Fitting options for fftRhythms() function (used in step 1).
fitOptions = optimoptions('lsqcurvefit', ...
	'MaxIterations',       10000, ...
	'OptimalityTolerance', 1e-6, ...
	'Display',             'off');

% Input variables for fftRhythms() function.
pdfBinSize = .025;  % bin width of the probability density histogram in s
fftWindow  = 1;     % FFT window width in s
pdfFun  = @(B, x) lognpdf(x - B(3), B(1), B(2));  % lognormal PDF
icdfFun = @(B, p) logninv(p, B(1), B(2)) + B(3);  % inverse lognormal CDF



fftAmp = cell(2, fileCount);
pdfInfo(2, fileCount) = struct( ...
	'tData',  [], ...
	'tEdges', [], ...
	'pRaw',   [], ...
	'pResid', [], ...
	'fftIdx', []);
cdfB = cell(2, fileCount);

fprintf('FFT-ing data |');
progText = { '.', '\b:' };
% For each participant:
for f = 1:fileCount
	% For hit/miss trials:
	for r = 1:2
		fprintf(progText{r});
		% Conduct spectral analysis employed in Cha & Blake (2019).
		[fftAmp{r, f}, pdfInfo(r, f), cdfB{r, f}] = fftRhythms( ...
			pdfBinSize, pdfFun, fftWindow, icdfFun, cdfFun, cdfB0, ...
			xData{r, f}, cpData{r, f}, cdfBlb, cdfBub, fitOptions);
	end
end
fprintf('|\n');



% Save generated data under the data-fitted/ directory.
clear s r simData;
save(fullfile('data-fitted', 'Step4C_RuzzoliEtAl2019.mat'));
