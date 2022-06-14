%
% Script for analyzing random walk model data with spectral analysis (Example 1,
% second part). The data generated with this script will be saved under the
% data-fitted/ directory.
%
% This script relies on Optimization Toolbox.
%

clear;
addpath('lib');

% Set random seed. The seed 'ffta' will generate the data shown in Figure 3
% reported in the paper. You can use "rng('shuffle');" instead.
rngchar('ffta');

% Load variables defined in CommonVars_CDF.m.
CommonVars_CDF;


% Load random walk model parameters (hypothetical participants data).
load(fullfile('data-fitted', 'Step2A_AmpRndWalkData.mat'), ...
	'rhythmF', ...
	'rhythmP', ...
	'rhythmK', ...
	'simCount', ...
	'timeoutMsec', ...
	'randWalkArgs' ...
	);
% Number of data points for spectral analysis.
nDataPoints = 1000;

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



xData  = cell(2, simCount);
cpData = cell(2, simCount);
fftAmp = cell(2, simCount);
pdfInfo(2, simCount) = struct( ...
	'tData',  [], ...
	'tEdges', [], ...
	'pRaw',   [], ...
	'pResid', [], ...
	'fftIdx', []);
cdfB = cell(2, simCount);

fprintf('FFT-ing data |');
progText = { '.', '\b:' };
% For each hypothetical participant:
for s = 1:simCount
	% For each condition (strong/weak rhythms):
	for r = 1:2
		fprintf(progText{r});
		% Run a modified random walk model simulation. See the help document for
		% each function for more details.
		simData = simRndWalk(nDataPoints, timeoutMsec, ...
			randWalkArgs(s, 1), randWalkArgs(s, 2), randWalkArgs(s, 3), ...
			rhythmF, rhythmP, rhythmK(r));
		simData = simData / 1000;

		% Conduct spectral analysis employed in Cha & Blake (2019).
		[xData{r, s}, cpData{r, s}] = cdfdata(simData);
		[fftAmp{r, s}, pdfInfo(r, s), cdfB{r, s}] = fftRhythms( ...
			pdfBinSize, pdfFun, fftWindow, icdfFun, cdfFun, cdfB0, ...
			xData{r, s}, cpData{r, s}, cdfBlb, cdfBub, fitOptions);
	end
end
fprintf('|\n');



% Save generated data under the data-fitted/ directory.
clear s r simData;
save(fullfile('data-fitted', 'Step2B_AmpRndWalkData.mat'));
