%
% Script for running 4 batches that generate either 100, 200, 400, or 800 data
% points from 1000 hypothetical participants, and then analyze the data with
% CPAR and with spectral analysis (Example 2). The data generated with this
% script will be saved under the data-fitted/ directory.
%
% This script relies on Optimization Toolbox.
%

clear;
addpath('lib');

% Set random seed. The seed 'rwda' will generate the data shown in Figure 4
% reported in the paper. You can use "rng('shuffle');" instead.
rngchar('rwda');

% Number of hypothetical participants and number of data points.
simCount = 1000;
nDataPoints = [100, 200, 400, 800];

% Rhythmic transformation parameters for the modified random walk model.
rhythmFs = 8.00 + .250 * randn_t95iw(simCount, 1);
rhythmPs = 0.00 + .785 * randn_t95iw(simCount, 1);
rhythmKs = rand(simCount, 1);

% Random walk model parameters for each hypothetical participant.
randWalkArgs = [
	.750 + .250 * randn_t95iw(simCount, 1), ...
	.667 + .333 * randn_t95iw(simCount, 1), ...
	.667 + .333 * randn_t95iw(simCount, 1) ...
	];

% Save rhythmic transformation and random walk model parameters for 4 batches
% under the data-fitted/ directory.
batchArgs = num2cell([randWalkArgs, rhythmFs, rhythmPs, rhythmKs], 2);
save(fullfile('data-fitted', 'Step3_BatchArgs.mat'));



% For each batch:
for dp = 1:length(nDataPoints)
	% Generate data from 1000 hypothetical participants.
	xData = batchSimRndWalk(nDataPoints(dp), batchArgs);

	% Analyze rhythms with CPAR and with spectral analysis, and save results
	% under the data-fitted/ directory.
	fitMatFile = sprintf('Step3_FitRhythms_%ddp-sim.mat', nDataPoints(dp));
	fftMatFile = sprintf('Step3_FFTRhythms_%ddp-sim.mat', nDataPoints(dp));
	batchFitRhythms(xData, fullfile('data-fitted', fitMatFile));
	batchFFTRhythms(xData, fullfile('data-fitted', fftMatFile));
end



% Generate data for 1000 hypothetical participants.
function xData = batchSimRndWalk(nDataPoints, batchArgs)
	timeoutMsec = 10 * 1000;  % 10 s

	simCount = numel(batchArgs);
	xData = cell(size(batchArgs));

	fprintf('sampling %d dp/sim |', nDataPoints);
	progText = { '\b:', '1', '\b2', '\b3', '\b4', '\b5', '\b6', '\b7', '\b8', '\b9' };
	% For each hypothetical participant:
	for s = 1:simCount
		fprintf(progText{mod(s, 10) + 1});
		% Run a modified random walk model simulation. See the help document for
		% each function for more details.
		simArgs = num2cell(batchArgs{s});
		simData = simRndWalk(nDataPoints, timeoutMsec, simArgs{:});
		xData{s} = simData / 1000;  % msec => s
	end
	fprintf('|\n');
end



% Analyze rhythms with CPAR, and save results.
function batchFitRhythms(xData, matFile)
	% Load variables defined in CommonVars_CDF.m.
	CommonVars_CDF;

	% Model frequencies and lower/upper bound frequncies.
	modelFreqs = (7:9)';
	freqBounds = [modelFreqs - .25, modelFreqs + .25];

	% Fitting options for fitRhythms() function.
	fitOptions = optimoptions('lsqcurvefit', ...
		'MaxIterations',       10000, ...
		'OptimalityTolerance', 1e-6, ...
		'Display',             'off');

	simCount = numel(xData);
	dataDims = num2cell(size(xData));
	cpData  = cell(dataDims{:});
	rcdfB   = cell(dataDims{:});
	cdfB    = cell(dataDims{:});
	varExpl = cell(dataDims{:});
	ampRCDF = cell(dataDims{:});
	ampEstd = cell(dataDims{:});

	fprintf('fitting batch |');
	progText = { '\b:', '1', '\b2', '\b3', '\b4', '\b5', '\b6', '\b7', '\b8', '\b9' };
	% For each hypothetical participant:
	for s = 1:simCount
		fprintf(progText{mod(s, 10) + 1});
		% Analyze rhythms. See Tutorial_FitRhythms_LognormCDF.m and the help
		% document for each function for more details.
		[xData{s}, cpData{s}] = cdfdata(xData{s});
		[rcdfB{s}, rcdfAdjRsq, cdfB{s}, cdfAdjRsq] = fitRhythms( ...
			freqBounds, rhythmB0, cdfFun, cdfB0, xData{s}, cpData{s}, ...
			cdfBlb, cdfBub, fitOptions);
		varExpl{s} = (rcdfAdjRsq - cdfAdjRsq) / (1 - cdfAdjRsq);
		ampRCDF{s} = rcdfB{s}(:, end);
		ampEstd{s} = ampRCDF{s} .* varExpl{s};
	end
	% Calculate average CPAR estimates within 7-9 Hz frequency range.
	avgAmpRCDF7_9Hz = cellfun(@mean, ampRCDF); %#ok<NASGU>
	avgAmpEstd7_9Hz = cellfun(@mean, ampEstd); %#ok<NASGU>
	fprintf('|\n');

	% Save CPAR results to a given path.
	save(matFile);
end



% Analyze rhythms with spectral analysis, and save results.
function batchFFTRhythms(xData, matFile)
	% Load variables defined in CommonVars_CDF.m.
	CommonVars_CDF;

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

	simCount = numel(xData);
	dataDims = num2cell(size(xData));
	cpData = cell(dataDims{:});
	fftAmp = cell(dataDims{:});
	pdfInfo(dataDims{:}) = struct( ...
		'tData',  [], ...
		'tEdges', [], ...
		'pRaw',   [], ...
		'pResid', [], ...
		'fftIdx', []);
	cdfB = cell(dataDims{:});

	fprintf('FFT-ing batch |');
	progText = { '\b:', '1', '\b2', '\b3', '\b4', '\b5', '\b6', '\b7', '\b8', '\b9' };
	% For each hypothetical participant:
	for s = 1:simCount
		fprintf(progText{mod(s, 10) + 1});
		% Conduct spectral analysis employed in Cha & Blake (2019).
		[xData{s}, cpData{s}] = cdfdata(xData{s});
		[fftAmp{s}, pdfInfo(s), cdfB{s}] = fftRhythms( ...
			pdfBinSize, pdfFun, fftWindow, icdfFun, cdfFun, cdfB0, ...
			xData{s}, cpData{s}, cdfBlb, cdfBub, fitOptions);
	end
	% Calculate average spectral power within 7-9 Hz frequency range.
	avgSpecPow7_9Hz = cellfun(@(a) mean(a(7:9)), fftAmp); %#ok<NASGU>
	fprintf('|\n');

	% Save spectral analysis results to a given path.
	save(matFile);
end
