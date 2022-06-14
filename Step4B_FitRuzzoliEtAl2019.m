%
% Script for analyzing human response time data with CPAR (Example 3, first
% part). The data generated with this script will be saved under the
% data-fitted/ directory.
%
% This script relies on Optimization Toolbox.
%

clear;
addpath('lib');

% Load variables defined in CommonVars_CDF.m.
CommonVars_CDF;

% List data files downloaded from osf.io/bdgr4 (Ruzzoli et al., 2019)
dataRoot  = 'data-step4';
fileList  = dir(dataRoot);
dataNames = { fileList(arrayfun(@(d) d.isdir & strncmp(d.name, 'P0', 2), fileList)).name }';
dataFiles = cellfun(@(d) fullfile(dataRoot, d, strcat(d, '_data.mat')), dataNames, 'UniformOutput', false);
fileCount = length(dataFiles);

% Model frequencies and lower/upper bound frequncies.
modelFreqs = (1:20)';
freqBounds = [modelFreqs - .25, modelFreqs + .25];

% Fitting options for fitRhythms() function.
fitOptions = optimoptions('lsqcurvefit', ...
	'MaxIterations',       10000, ...
	'OptimalityTolerance', 1e-6, ...
	'Display',             'off');



xData   = cell(2, fileCount);
cpData  = cell(2, fileCount);
rcdfB   = cell(2, fileCount);
cdfB    = cell(2, fileCount);
varExpl = cell(2, fileCount);
ampRCDF = cell(2, fileCount);
ampEstd = cell(2, fileCount);

fprintf('fitting data |');
% For each participant:
for f = 1:fileCount
	load(dataFiles{f}, 'RESULTS_TABLE');
	% For hit/miss trials:
	for p = 1:2
		if p == 1
			fprintf('.');
			% Find RT data for "hit" trials for the given participant.
			sbjData = RESULTS_TABLE(RESULTS_TABLE.Trial_type == 1 & RESULTS_TABLE.Response == 1, :).Response_time;
		else
			fprintf('\b:');
			% Find RT data for "miss" trials for the given participant.
			sbjData = RESULTS_TABLE(RESULTS_TABLE.Trial_type == 1 & RESULTS_TABLE.Response == 0, :).Response_time;
		end

		% Analyze rhythms. See Tutorial_FitRhythms_LognormCDF.m and the help
		% document for each function for more details.
		[xData{p, f}, cpData{p, f}] = cdfdata(sbjData);
		[rcdfB{p, f}, rcdfAdjRsq, cdfB{p, f}, cdfAdjRsq] = fitRhythms( ...
			freqBounds, rhythmB0, cdfFun, cdfB0, xData{p, f}, cpData{p, f}, ...
			cdfBlb, cdfBub, fitOptions);
		varExpl{p, f} = (rcdfAdjRsq - cdfAdjRsq) / (1 - cdfAdjRsq);
		ampRCDF{p, f} = rcdfB{p, f}(:, end);
		ampEstd{p, f} = ampRCDF{p, f} .* varExpl{p, f};
	end
end
fprintf('|\n');



% Save generated data under the data-fitted/ directory.
clear RESULTS_TABLE f p sbjData rcdfAdjRsq cdfAdjRsq;
save(fullfile('data-fitted', 'Step4B_RuzzoliEtAl2019.mat'));
