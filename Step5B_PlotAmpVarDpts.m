%
% Script for plotting fig-images/Figure6.png.
%

clear;
addpath('lib');

% Load generated data.
load(fullfile('data-fitted', 'Step5_AmpVarDpts.mat'));

% Load variables defined in CommonVars_Figure.m.
CommonVars_Figure;

% Frequency of rCDF shown in panels C.
[~, rcdfIdx] = min(abs(modelFreqs - rhythmF));
rcdfFreq = modelFreqs(rcdfIdx);

% Panel titles.
panelTitles = {
	'Strong rhythms';
	'Weak rhythms';
	sprintf('%d Hz rhythms', rcdfFreq);
	};
% Legend items (panels A and B).
legendItemText = arrayfun( ...
	@(n) regexprep(sprintf('%03d', n), '^(0+)', ...
		'\\color{white}$0\\color{black}'), ...
	nDataPoints, 'UniformOutput', false);

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
% For panel A/B:
%
for r = 1:2
	% Set panel position.
	panelHandle = subplot(1, 3, r, subplotParams{:});
	set(panelHandle, 'Position', panelPos{r});

	hold on;
	rectangle('Position', ...
		[freqBounds(rcdfIdx, 1), -.5, diff(freqBounds(rcdfIdx, :)), 1.5], ...
		'EdgeColor', 'none', 'FaceColor', shadeBarColor);  % shaded bar
	% Plot estimated amplitude values for each simulation run.
	for d = 1:6
		tmpAmpEstd = permute(ampEstd(r, d, :), [2 3 1]);
		avgAmpEstd = mean(cell2mat(tmpAmpEstd), 2);
		plot(modelFreqs, avgAmpEstd, 'Color', lineColors6(d, :), ...
			'LineWidth', plotLineWidth);
	end
	hold off;
	% Set axis limits, tick marks, and labels.
	xlim([0, 20]);
	ylim([-.1, .6]);
	setAxes(4:4:20, '%d\n', 0:.2:.6, '%.1f\n');
	xlabel('Frequency (Hz)', labelParams{:});
	ylabel('Estimated amplitude', labelParams{:});

	% Set legend.
	legendHandle = legend(legendItemText, ...
		legendParams{:}, 'Location', 'northeast');
	title(legendHandle, '# data points', legendTitleParams{:});
	legendPos = get(legendHandle, 'Position');
	legendPos(1) = sum(panelPos{r}([1 3])) - 2;
	legendPos(2) = sum(panelPos{r}([2 4])) - 2.95;
	set(legendHandle, 'Position', legendPos);

	% Set panel title.
	titleHandle = title(panelTitles{r}, titleParams{:});
	titleAPos = get(titleHandle, 'Position');
	titleAPos(2) = panelTitleBottom;
	set(titleHandle, 'Position', titleAPos);

	% Set panel label.
	annotation('textbox', 'String', char('A' - 1 + r), annotParams{:}, ...
		'Position', panelLabelPos{r});
end

%
% Panel C: set panel position.
%
panelC = subplot(1, 3, 3, subplotParams{:});
set(panelC, 'Position', panelPos{3});

% Panel C: plot estimated amplitude values for strong/weak rhythms.
hold on;
for r = 1:2
	tmpAmpEstd = cellfun(@(d) d(rcdfIdx), ...
		permute(ampEstd(r, :, :), [2 3 1]));
	avgAmpEstd = mean(tmpAmpEstd, 2);
	semAmpEstd = std(tmpAmpEstd, [], 2) / sqrt(simCount);

	errorHandle = errorbar(nDataPoints', avgAmpEstd, semAmpEstd, ...
		errorBarParams{:});
	skipLegend(errorHandle);
	plot(nDataPoints', avgAmpEstd, 'Color', lineColors2(r, :), ...
		'LineWidth', plotLineWidth);
end
hold off;
% Panel C: set axis limits, tick marks, and labels.
set(gca, 'XDir','reverse')
xlim([0, 225]);
ylim([-.1, .6]);
setAxes(sort([0, nDataPoints(mod(nDataPoints, 50) == 0)]), '%d\n', 0:.2:.6, '%.1f\n');
xlabel('Number of data points', labelParams{:});
ylabel('Estimated amplitude', labelParams{:});

% Panel C: set legend.
legendC = legend({
	'Strong rhythms', ...
	'Weak rhythms' ...
	}, legendParams{:}, 'Location', 'north');
legendCPos = get(legendC, 'Position');
legendCPos(1) = sum(panelPos{3}([1 3]) .* [1 .5]) - 1.7;
legendCPos(2) = sum(panelPos{3}([2 4])) - .85;
set(legendC, 'Position', legendCPos);

% Panel C: set panel title.
titleC = title(panelTitles{3}, titleParams{:});
titleCPos = get(titleC, 'Position');
titleCPos(2) = panelTitleBottom;
set(titleC, 'Position', titleCPos);

% Panel C: set panel label.
annotation('textbox', 'String', 'C', annotParams{:}, ...
	'Position', panelLabelPos{3});



% Save figure to an image file.
figureFile = fullfile('fig-images', 'Figure6.tif');
print(figureHandle, figureFile, '-dtiff', '-r300');
