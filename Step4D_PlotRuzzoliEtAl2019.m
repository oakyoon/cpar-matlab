%
% Script for plotting fig-images/Figure5.png.
%

clear;
addpath('lib');

% Load generated data (Example 3, first part).
load(fullfile('data-fitted', 'Step4B_RuzzoliEtAl2019.mat'));

% Load variables defined in CommonVars_Figure.m.
CommonVars_Figure;

% Index of the participant for panels A, B, D, E.
plotPIdx = 23;
% Frequency of rCDF shown in panels A, B.
plotFreq = 8;

% Panel column titles.
columnTitles = {
	sprintf('P%03d\\_S01, Hit trials',  plotPIdx);
	sprintf('P%03d\\_S01, Miss trials', plotPIdx);
	sprintf('Average of %d participants', fileCount);
	};

% Figure size in cm.
figureSize = [17.4, 11.2];
% Panel and label positions [left bottom width height] in cm.
panelPos = {
	[ 1.2 6.2 4.2 4.0];
	[ 7.0 6.2 4.2 4.0];
	[12.8 6.2 4.2 4.0];
	[ 1.2 3.0 4.2 1.8;   % panel Du
	  1.2 1.0 4.2 1.2];  % panel Dl
	[ 7.0 3.0 4.2 1.8;   % panel Eu
	  7.0 1.0 4.2 1.2];  % panel El
	[12.8 1.0 4.2 4.0];
	};
panelLabelPos = {
	[ 0   10.0 .7 .7];
	[ 5.8 10.0 .7 .7];
	[11.6 10.0 .7 .7];
	[ 0    4.8 .7 .7];
	[ 5.8  4.8 .7 .7];
	[11.6  4.8 .7 .7];
	};
columnTitleBottom = 4.45;



% Open new figure window.
figureHandle = openFigure(figureSize);

%
% For panel A/B:
%
panelAB = cell(1, 2);
for p = 1:2
	% Set panel position.
	panelAB{p} = subplot(4, 3, p + [0 3], subplotParams{:});
	set(panelAB{p}, 'Position', panelPos{p});

	% Plot data points and rCDF.
	xPlot = 0:.005:2;
	[~, rcdfPlot] = min(abs(modelFreqs - plotFreq));
	hold on;
	scatter(xData{p, plotPIdx}, cpData{p, plotPIdx}, dataPointParams{:});
	plot(xPlot, rhythmfwrap(cdfFun, rcdfB{p, plotPIdx}(rcdfPlot, :), xPlot), ...
		'Color', [0 0 0], 'LineWidth', plotLineWidth);
	hold off;
	% Set axis limits, tick marks, and labels. X-axis limits will be set later
	% so that the x-axis of panel A/B matches with the x-axis of panel D/E.
	ylim([0, 1]);
	setAxes(0:.5:2, '%.1f\n', 0:.2:1, '%.1f\n');
	xlabel('Time (s)', labelParams{:});
	ylabel('Cumulative probability', labelParams{:});

	% Set legend.
	legendHandle = legend({
		'Data point', ...
		sprintf('%d Hz rCDF', modelFreqs(rcdfPlot)) ...
		}, legendParams{:}, 'Location', 'southeast');
	legendPos = get(legendHandle, 'Position');
	legendPos(1) = sum(panelPos{p}([1 3])) - 2.85;
	legendPos(2) = panelPos{p}(2) + .35;
	set(legendHandle, 'Position', legendPos);

	% Set panel column title.
	titleHandle = title(columnTitles{p}, titleParams{:});
	titlePos = get(titleHandle, 'Position');
	titlePos(2) = columnTitleBottom;
	set(titleHandle, 'Position', titlePos);

	% Set panel label.
	labelText = 'AB';
	annotation('textbox', 'String', labelText(p), annotParams{:}, ...
		'Position', panelLabelPos{p});
end

%
% Panel C: set panel position.
%
panelC = subplot(4, 3, [3 6], subplotParams{:});
set(panelC, 'Position', panelPos{3});

% Panel C: plot estimated amplitude values for hit/miss trials.
hold on;
for r = 1:2
	avgAmpEstd = mean(cell2mat(ampEstd(r, :)), 2);
	semAmpEstd = std(cell2mat(ampEstd(r, :)), [], 2) / sqrt(fileCount);

	errorHandle = errorbar(modelFreqs, avgAmpEstd, semAmpEstd, ...
		errorBarParams{:});
	skipLegend(errorHandle);
	plot(modelFreqs, avgAmpEstd, 'Color', lineColors2(r, :), ...
		'LineWidth', plotLineWidth);
end
hold off;
% Panel C: set axis limits, tick marks, and labels.
xlim([0, 20]);
ylim([-.05, .3]);
setAxes(4:4:20, '%d\n', 0:.1:.3, '%.1f\n');
xlabel('Frequency (Hz)', labelParams{:});
ylabel('Estimated amplitude', labelParams{:});

% Panel C: set legend.
legendC = legend({
	'Hit trials', ...
	'Miss trials' ...
	}, legendParams{:}, 'Location', 'north');
legendCPos = get(legendC, 'Position');
legendCPos(1) = sum(panelPos{3}([1 3]) .* [1 .5]) - 1.35;
legendCPos(2) = sum(panelPos{3}([2 4])) - .85;
set(legendC, 'Position', legendCPos);

% Set column 3 (panels C and F) title.
titleC = title(columnTitles{3}, titleParams{:});
titleCPos = get(titleC, 'Position');
titleCPos(2) = columnTitleBottom;
set(titleC, 'Position', titleCPos);

% Panel C: set panel label.
annotation('textbox', 'String', 'C', annotParams{:}, ...
	'Position', panelLabelPos{3});



% Load generated data (Example 3, second part).
load(fullfile('data-fitted', 'Step4C_RuzzoliEtAl2019.mat'));
% Calcuate FFT frequency range.
fftFreqLb = 1 / fftWindow;
fftFreqUb = 1 / pdfBinSize / 2;
fftFreqs = fftFreqLb:fftFreqLb:fftFreqUb;

%
% For panel D/E:
%
for p = 1:2
	% Determine FFT window for panel D/E.
	plotPDFInfo = pdfInfo(p, plotPIdx);
	wFFT = plotPDFInfo.tEdges(plotPDFInfo.fftIdx([1 end]) + [0 1]);

	% Set panel Du/Eu position.
	panelU = subplot(4, 3, p + 6, subplotParams{:});
	set(panelU, 'Position', panelPos{3 + p}(1, :));

	% Plot probability density histogram and PDF.
	hold on;
	bar(plotPDFInfo.tData, plotPDFInfo.pRaw, histogramParams{:});
	plot(xPlot, pdfFun(cdfB{p, plotPIdx}, xPlot), ...
		'Color', [0 0 0], 'LineWidth', plotLineWidth);
	hold off;
	% Set axis limits, tick marks, and labels.
	xlim(wFFT);
	ylim([0, 3]);
	setAxes(0:.5:2, '%.1f\n', 0:1:3, '%d\n');
	ylabelU = ylabel('Probability', labelParams{:});

	% Set panel Dl/El position.
	panelL = subplot(4, 3, p + 9, subplotParams{:});
	set(panelL, 'Position', panelPos{3 + p}(2, :));

	% Plot residual probability values.
	hold on;
	pPred = pdfFun(cdfB{p, plotPIdx}, plotPDFInfo.tData);
	bar(plotPDFInfo.tData, plotPDFInfo.pRaw - pPred, histogramParams{:});
	line([0 3], [0 0], 'Color', 'k', 'LineWidth', axisLineWidth);  % axis at 0 residual
	hold off;
	% Set axis limits, tick marks, and labels.
	xlim(wFFT);
	ylim([-1, 1]);
	setAxes(0:.5:2, '%.1f\n', -1:1:1, '%d\n');
	xlabel('Time (s)', labelParams{:});
	ylabelL = ylabel('Residual', labelParams{:});

	% Set the position of panel Du ylabel.
	ylabelUPos = get(ylabelU, 'Position');
	ylabelLPos = get(ylabelL, 'Position');
	ylabelUPos(1) = ylabelLPos(1);
	set(ylabelU, 'Position', ylabelUPos);

	% Set panel label.
	labelText = 'DE';
	annotation('textbox', 'String', labelText(p), annotParams{:}, ...
		'Position', panelLabelPos{3 + p});

	% Set the x-axis of panel A/B.
	xlim(panelAB{p}, wFFT);
end

%
% Panel F: set panel position.
%
panelF = subplot(4, 3, [9 12], subplotParams{:});
set(panelF, 'Position', panelPos{6});

% Panel F: plot spectral power distributions for hit/miss trials.
hold on;
for r = 1:2
	avgFFTAmp = mean(cell2mat(fftAmp(r, :)'), 1);
	semFFTAmp = std(cell2mat(fftAmp(r, :)'), [], 1) / sqrt(fileCount);

	errorHandle = errorbar(fftFreqs, avgFFTAmp, semFFTAmp, ...
		errorBarParams{:});
	skipLegend(errorHandle);
	plot(fftFreqs, avgFFTAmp, 'Color', lineColors2(r, :), ...
		'LineWidth', plotLineWidth);
end
hold off;
% Panel F: set axis limits, tick marks, and labels.
xlim([0, 20]);
ylim([-.05, .3]);
setAxes(4:4:20, '%d\n', 0:.1:.3, '%.1f\n');
xlabel('Frequency (Hz)', labelParams{:});
ylabel('Spectral power', labelParams{:});

% Panel F: set legend.
legendF = legend({
	'Hit trials', ...
	'Miss trials' ...
	}, legendParams{:}, 'Location', 'north');
legendFPos = get(legendF, 'Position');
legendFPos(1) = sum(panelPos{6}([1 3]) .* [1 .5]) - 1.35;
legendFPos(2) = sum(panelPos{6}([2 4])) - .85;
set(legendF, 'Position', legendFPos);

% Panel F: set panel label.
annotation('textbox', 'String', 'F', annotParams{:}, ...
	'Position', panelLabelPos{6});



% Save generated data under the data-fitted/ directory.
figureFile = fullfile('fig-images', 'Figure5.tif');
print(figureHandle, figureFile, '-dtiff', '-r300');
