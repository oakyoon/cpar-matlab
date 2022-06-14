%
% Script for analyzing random walk model data using CPAR (Example 1, first
% part). The data generated with this script will be saved under the
% data-fitted/ directory.
%
% This script relies on Optimization Toolbox.
%

clear;
addpath('lib');

% Set random seed. The seed 'ampr' will generate the data shown in Figure 3
% reported in the paper. You can use "rng('shuffle');" instead.
rngchar('ampr');

% Load variables defined in CommonVars_CDF.m.
CommonVars_CDF;

% Number of hypothetical participants and number of data points.
simCount    = 30;
nDataPoints = 100;
% Response limit for the model.
timeoutMsec = 10 * 1000;  % 10 s

% Rhythmic transformation parameters for the modified random walk model.
rhythmF = 8;
rhythmP = 0;
rhythmK = [.8, .4];
rhythmFs = rhythmF + .250 * randn_t95iw(simCount, 1);
rhythmPs = rhythmP + .785 * randn_t95iw(simCount, 1);

% Random walk model parameters for each hypothetical participant.
randWalkArgs = [
	.750 + .250 * randn_t95iw(simCount, 1), ...
	.667 + .333 * randn_t95iw(simCount, 1), ...
	.667 + .333 * randn_t95iw(simCount, 1) ...
	];


% Model frequencies and lower/upper bound frequncies.
modelFreqs = (1:20)';
freqBounds = [modelFreqs - .25, modelFreqs + .25];

% Fitting options for fitRhythms() function.
fitOptions = optimoptions('lsqcurvefit', ...
	'MaxIterations',       10000, ...
	'OptimalityTolerance', 1e-6, ...
	'Display',             'off');



xData   = cell(2, simCount);
cpData  = cell(2, simCount);
rcdfB   = cell(2, simCount);
cdfB    = cell(2, simCount);
varExpl = cell(2, simCount);
ampRCDF = cell(2, simCount);
ampEstd = cell(2, simCount);

fprintf('fitting data |');
progText = { '.', '\b:' };
% For each hypothetical participant:
for s = 1:simCount
	% For each condition (strong/weak rhythms):
	for r = 1:2
		fprintf(progText{r});
		% Run a modified random walk model simulation. See the help
		% document for each function for more details.
		simData = simRndWalk(nDataPoints, timeoutMsec, ...
			randWalkArgs(s, 1), randWalkArgs(s, 2), randWalkArgs(s, 3), ...
			rhythmFs(s), rhythmPs(s), rhythmK(r));
		simData = simData / 1000;  % msec => s

		% Analyze rhythms. See Tutorial_FitRhythms_LognormCDF.m and the
		% help document for each function for more details.
		[xData{r, s}, cpData{r, s}] = cdfdata(simData);
		[rcdfB{r, s}, rcdfAdjRsq, cdfB{r, s}, cdfAdjRsq] = fitRhythms( ...
			freqBounds, rhythmB0, cdfFun, cdfB0, xData{r, s}, cpData{r, s}, ...
			cdfBlb, cdfBub, fitOptions);
		varExpl{r, s} = (rcdfAdjRsq - cdfAdjRsq) / (1 - cdfAdjRsq);
		ampRCDF{r, s} = rcdfB{r, s}(:, end);
		ampEstd{r, s} = ampRCDF{r, s} .* varExpl{r, s};
	end
end
fprintf('|\n');



% Save generated data under the data-fitted/ directory.
clear s r simData rcdfAdjRsq cdfAdjRsq;
save(fullfile('data-fitted', 'Step2A_AmpRndWalkData.mat'));
