%
% Script for running and anlyzing sets of random walk model simulations with
% varying numbers of data points per condition. The data generated with this
% script will be saved under the data-fitted/ directory.
%
% This script relies on Optimization Toolbox.
%

clear;
addpath('lib');

% Set random seed. The seed 'ampv' will generate the data shown in Figure 6.
rngchar('ampv');

% Load variables defined in CommonVars_CDF.m.
CommonVars_CDF;

% Number of hypothetical participants.
simCount    = 30;
% Number of data points per condition for each simulation run.
nDataPoints = [200, 150, 100, 75, 50, 25];
dpCount     = length(nDataPoints);
% Response limit for the model.
timeoutMsec = 10 * 1000;

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


xData   = cell(2, dpCount, simCount);
cpData  = cell(2, dpCount, simCount);
rcdfB   = cell(2, dpCount, simCount);
cdfB    = cell(2, dpCount, simCount);
varExpl = cell(2, dpCount, simCount);
ampRCDF = cell(2, dpCount, simCount);
ampEstd = cell(2, dpCount, simCount);

fprintf('fitting data |');
progText = {
	  'a', '\bb', '\bc', '\bd', '\be', '\b.';
	'\bA', '\bB', '\bC', '\bD', '\bE', '\b:';
	};
% For each hypothetical participant:
for s = 1:simCount
	% For each condition (strong/weak rhythms):
	for r = 1:2
		% For each simulation run (different # data points per condition):
		for d = 1:dpCount
			fprintf(progText{r, d});
			% Run a modified random walk model simulation. See the help document
			% for each function for more details.
			simData = simRndWalk(nDataPoints(d), timeoutMsec, ...
				randWalkArgs(s, 1), randWalkArgs(s, 2), randWalkArgs(s, 3), ...
				rhythmFs(s), rhythmPs(s), rhythmK(r));
			simData = simData / 1000;

			% Analyze rhythms. See Tutorial_FitRhythms_LognormCDF.m and the help
			% document for each function for more details.
			[xData{r, d, s}, cpData{r, d, s}] = cdfdata(simData);
			[rcdfB{r, d, s}, rcdfAdjRsq, cdfB{r, d, s}, cdfAdjRsq] = fitRhythms( ...
				freqBounds, rhythmB0, cdfFun, cdfB0, xData{r, d, s}, cpData{r, d, s}, ...
				cdfBlb, cdfBub, fitOptions);
			varExpl{r, d, s} = (rcdfAdjRsq - cdfAdjRsq) / (1 - cdfAdjRsq);
			ampRCDF{r, d, s} = rcdfB{r, d, s}(:, end);
			ampEstd{r, d, s} = ampRCDF{r, d, s} .* varExpl{r, d, s};
		end
	end
end
fprintf('|\n');



% Save generated data under the data-fitted/ directory.
clear s r d simData rcdfAdjRsq cdfAdjRsq;
save(fullfile('data-fitted', 'Step5_AmpVarDpts.mat'));
