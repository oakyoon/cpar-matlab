%
% Script for generating fig-images/Figure2.png.
%

clear;
addpath('lib');

% Load variables defined in CommonVars_CDF.m and CommonVars_Figure.m.
CommonVars_CDF;
CommonVars_Figure;

% Lognormal CDF parameters.
cdfB  = [-1 .5 .100];
% Rhythmic transformation parameters.
rcdfB = {
	[8 0 1; 16 0 1];  % for panel A
	[8 0 1; 8 pi 1];  % for panel B
	[8 0 .5; 8 0 1];  % for panel C
	};

% Panel titles and legend items.
panelTitles = {
	'rCDF frequency';
	'rCDF phase';
	'rCDF amplitude';
	};
cdfLegend  = 'CDF';
rcdfLegend = {
	'rCDF ({\itF}=8)', 'rCDF ({\itF}=16)';
	'rCDF ({\itp}=0)', 'rCDF ({\itp}=π)';
	'rCDF ({\itk}=.5)', 'rCDF ({\itk}=1)';
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
% For each panel:
%
for p = 1:3
	% Set panel position.
	panelHandle = subplot(1, 3, p, subplotParams{:});
	set(panelHandle, 'Position', panelPos{p});

	% Plot one CDF and two rCDFs.
	xPlot = 0:.005:1.5;
	hold on;
	plot(xPlot, cdfFun(cdfB, xPlot), ...
		'Color', lineColors3(3, :), 'LineWidth', plotLineWidth);
	plot(xPlot, rhythmfwrap(cdfFun, [cdfB, rcdfB{p}(1, :)], xPlot), ...
		'Color', lineColors3(2, :), 'LineWidth', plotLineWidth);
	plot(xPlot, rhythmfwrap(cdfFun, [cdfB, rcdfB{p}(2, :)], xPlot), ...
		'Color', lineColors3(1, :), 'LineWidth', plotLineWidth);
	hold off;
	% Set axis limits, tick marks, and labels.
	xlim([min(xPlot), max(xPlot)]);
	ylim([0, 1]);
	setAxes(.5:.5:2, '%.1f\n', 0:.2:1, '%.1f\n');
	xlabel('Time (s)', labelParams{:});
	ylabel('Cumulative probability', labelParams{:});

	% Set panel title.
	titleHandle = title(panelTitles{p}, titleParams{:});
	titlePos = get(titleHandle, 'Position');
	titlePos(2) = panelTitleBottom;
	set(titleHandle, 'Position', titlePos);

	% Set legend.
	legendHandle = legend({
		cdfLegend, ...
		rcdfLegend{p, :} ...
		}, legendParams{:}, 'Location', 'southeast');
	legendPos = get(legendHandle, 'Position');
	legendPos(1) = sum(panelPos{p}([1 3])) - 2.95;
	legendPos(2) = panelPos{p}(2) + .35;
	set(legendHandle, 'Position', legendPos);

	% Set panel label.
	annotation('textbox', 'String', char('A' + p - 1), annotParams{:}, ...
		'Position', panelLabelPos{p});
end



% Save figure to an image file.
figureFile = fullfile('fig-images', 'Figure2.tif');
print(figureHandle, figureFile, '-dtiff', '-r300');
