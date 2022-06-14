%
% Tutorial script exemplifying how to use fitRhythms() function. This script
% fits one set of response time data to a gamma rCDF.
%
% This script relies on Optimization Toolbox, fitRhythms.m file, and the files
% in the lib/ directory (these are the files and directories you need in a
% MATLAB path to use CPAR).
%

clear;
addpath('lib');

% CDF function for model fitting. This tutorial uses a gamma CDF as an
% underlying, non-rhythmic CDF. For this particular [cdfFun], [B] should be an
% array with 3 elements: the shape parameter a of a Gamma distribution, the
% scale parameter b of a Gamma distribution, and the delay parameter d.
cdfFun = @(B, x) gamcdf(x - B(3), B(1), B(2));

% Sets of initial guesses for the three parameters of the gamma CDF. Each row of
% [CDFB0] is a set of initial guesses. Note that these are arbitray initial
% guesses, and you will want to determine your own sets of initial guesses that
% work best for your data.
cdfB0  = combmat( ...
	[1; 1.25; 1.5; 2; 3], ...
	[.2; .3; .4; .6; 1], ...
	[.400; .600; .800]);

% Lower and upper bounds for the three parameters of the gamma CDF. 
cdfBlb = [.01, .01, 0];
cdfBub = [100, 100, 5];

% Sets of initial guesses for the last two parameters of a rhythmic
% transformation function, phase p and amplitude k.
rhythmB0 = combmat( ...
	[-.75; -.25; .25; .75] * pi, ...
	[.1; .3; .5; .7; .9]);



% Response time data for analysis.
rtData = [
	0.514 0.531 0.546 0.560 0.574 0.590 0.611 0.645 ...
	0.739 0.775 0.803 0.834 0.889 1.032 1.115 1.423 ...
	];

% Model frequencies (1 ~ 10 Hz in steps of 1 Hz)
modelFreqs = (1:10)';
% Lower (1st column) and upper (2nd column) bound frequencies.
freqBounds = [modelFreqs - .25, modelFreqs + .25];

% Fitting options for fitRhythms() function.
fitOptions = optimoptions('lsqcurvefit', ...
	'MaxIterations',       10000, ...
	'OptimalityTolerance', 1e-6, ...
	'Display',             'off');

% Trim reaction time data and generate cumulative probabilities.
[xData, cpData] = cdfdata(rtData);
% Conduct Computational Procedures for Analysis of Rhythms (CPAR).
[rcdfB, rcdfAdjRsq, cdfB, cdfAdjRsq] = fitRhythms( ...
	freqBounds,     ...  % lower and upper bound frequencies
	rhythmB0,       ...  % see CommonVars_CDF.m
	cdfFun, cdfB0,  ...  % see CommonVars_CDF.m
	xData, cpData,  ...  % response time data, cumulative probabilities
	cdfBlb, cdfBub, ...  % see CommonVars_CDF.m
	fitOptions      ...  % fitting options
	);
% Calculate Delta Variance explained, rCDF amplitude parameter, and estimated
% amplitude for each model frequency.
varExpl = (rcdfAdjRsq - cdfAdjRsq) / (1 - cdfAdjRsq);
ampRCDF = rcdfB(:, end);
ampEstd = ampRCDF .* varExpl;



% Data for graphs in the left panel.
xPlot = 0:.01:2;          % x values
rcdfB_4Hz = rcdfB(4, :);  % 4 Hz rCDF parameters 
yPlot_rCDF_4Hz = rhythmfwrap(cdfFun, rcdfB_4Hz, xPlot);  % y values for 4 Hz rCDF
yPlot_gammaCDF = cdfFun(cdfB, xPlot);                    % y values for gamma CDF

% Open new figure window.
figure('Color', 'w');

%
% Plot graphs in the left panel.
%
subplot(1, 3, 1);
scatter(xData, cpData);       % data points used for analysis
hold on;
plot(xPlot, yPlot_rCDF_4Hz);  % best-fit 4 Hz rCDF
plot(xPlot, yPlot_gammaCDF);  % best-fit gamma CDF
hold off;
box off;
% Set axis limits and labels.
xlim([min(xPlot), max(xPlot)]);
ylim([0 1]);
xlabel('Time (s)');
ylabel('Cumulative probability');
% Set legend.
legend({'Data point', '4 Hz rCDF', 'Gamma CDF'}, 'Location', 'southeast');
legend boxoff;

%
% Plot graph in the middle panel.
%
subplot(1, 3, 2);
plot(modelFreqs, ampEstd);  % Estimated amplitude values
box off;
% Set axis limits and labels.
xlim([0, max(modelFreqs) + 1]);
xlabel('Frequency (Hz)');
ylabel('Estimated amplitude');

%
% Plot graph in the right panel.
%
subplot(1, 3, 3);
plot(modelFreqs, ampRCDF);  % rCDF amplitude parameter values
box off;
% Set axis limits and labels.
xlim([0, max(modelFreqs) + 1]);
xlabel('Frequency (Hz)');
ylabel('rCDF amplitude parameter');
