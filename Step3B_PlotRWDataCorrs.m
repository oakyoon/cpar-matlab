%
% Script for plotting fig-images/Figure4.png.
%

clear;
addpath('lib');

% Load rhythmic transformation and random walk model parameters.
batchArgs = load(fullfile('data-fitted', 'Step3_BatchArgs.mat'));
% Load generated data and analysis results.
plotDpts = 800;
fitMatFile = sprintf('Step3_FitRhythms_%ddp-sim.mat', plotDpts);
fftMatFile = sprintf('Step3_FFTRhythms_%ddp-sim.mat', plotDpts);
fitResult = load(fullfile('data-fitted', fitMatFile));
fftResult = load(fullfile('data-fitted', fftMatFile));

% Load variables defined in CommonVars_Figure.m.
CommonVars_Figure;

% Panel titles.
panelTitles = {
	'Estimated amplitude (7-9 Hz)';
	'rCDF amplitude {\itk} (7-9 Hz)';
	'Spectral power (7-9 Hz)';
	};
% Panel axis labels.
panelAxisLabels = {
	'True amplitude', 'Estimated amplitude';
	'True amplitude', 'rCDF amplitude {\itk}';
	'True amplitude', 'Spectral power';
	};
% Panel data.
panelData = {
	batchArgs.rhythmKs, fitResult.avgAmpEstd7_9Hz;
	batchArgs.rhythmKs, fitResult.avgAmpRCDF7_9Hz;
	batchArgs.rhythmKs, fftResult.avgSpecPow7_9Hz;
	};

% Figure size in cm.
figureSize = [17.4, 5.8];
% Panel and label positions [left bottom width height] in cm.
panelPos = {
	[ 1.2 1.0 4.2 4.0];
	[ 7.0 1.0 4.2 4.0];
	[12.8 1.0 4.2 4.0];
	};
panelLabelPos = {
	[ 0   5.2 .7 .7];
	[ 5.8 5.2 .7 .7];
	[11.6 5.2 .7 .7];
	};
panelTitleBottom = 4.3;



% Open new figure window.
figureHandle = openFigure(figureSize);

%
% For panel A/B/C:
%
for c = 1:3
	% Set panel position.
	panelHandle = subplot(1, 3, c, subplotParams{:});
	set(panelHandle, 'Position', panelPos{c});

	% Plot data points.
	scatter(panelData{c, 1}, panelData{c, 2}, dataPointParams{:});
	% Plot regression line.
	xPlot = 0:.005:1;
	rmat = panelData{c, 1};
	rmat(:, 2) = 1;
	B = regress(panelData{c, 2}, rmat);
	hold on;
	plot(xPlot, xPlot * B(1) + B(2), 'Color', lineColors2(1, :), ...
		'LineWidth', plotLineWidth);
	hold off;
	% Set axis limits, tick marks, and labels.
	xlim([0, 1]);
	ylim([0, 1]);
	setAxes(0:.2:1, '%.1f\n', 0:.2:1, '%.1f\n');
	xlabel(panelAxisLabels{c, 1}, labelParams{:});
	ylabel(panelAxisLabels{c, 2}, labelParams{:});

	% Set legend on panel A.
	if c == 1
		legendHandle = legend({
			'Data point', ...
			'Regression line' ...
			}, legendParams{:}, 'Location', 'north');
		legendPos = get(legendHandle, 'Position');
		legendPos(1) = sum(panelPos{c}([1 3]) .* [1 .5]) - 1.7;
		legendPos(2) = sum(panelPos{c}([2 4])) - .85;
		set(legendHandle, 'Position', legendPos);
	end

	% Set panel title.
	titleHandle = title(panelTitles{c}, titleParams{:});
	titlePos = get(titleHandle, 'Position');
	titlePos(2) = panelTitleBottom;
	set(titleHandle, 'Position', titlePos);

	% Set panel label.
	annotation('textbox', 'String', char('A' - 1 + c), annotParams{:}, ...
		'Position', panelLabelPos{c});
end



% Save figure to an image file.
figureFile = fullfile('fig-images', 'Figure4.tif');
print(figureHandle, figureFile, '-dtiff', '-r300');
