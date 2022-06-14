%
% Script for generating fig-images/Figure3.png.
%

clear;
addpath('lib');

% Load generated data (Example 1, first part).
load(fullfile('data-fitted', 'Step2A_AmpRndWalkData.mat'));

% Load variables defined in CommonVars_Figure.m.
CommonVars_Figure;

% Index of the hypothetical participant for panels A, B, D, E.
plotSimulIdx = 1;
% Frequency of rCDF shown in panel A.
plotFreq = rhythmF;

% Panel column titles.
columnTitles = {
	sprintf('Simul. #%d, Strong rhythms',  plotSimulIdx);
	sprintf('Simul. #%d, Strong rhythms',  plotSimulIdx);
	sprintf('Average of %d simulations', simCount);
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
	[ 7.0 1.0 4.2 4.0];
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
% Panel A: set panel position.
%
panelA = subplot(4, 3, [1 4], subplotParams{:});
set(panelA, 'Position', panelPos{1});

% Panel A: plot data points and rCDF.
xPlot = .25:.005:1.5;
[~, rcdfIdx] = min(abs(modelFreqs - plotFreq));
hold on;
scatter(xData{1, plotSimulIdx}, cpData{1, plotSimulIdx}, dataPointParams{:});
plot(xPlot, rhythmfwrap(cdfFun, rcdfB{1, plotSimulIdx}(rcdfIdx, :), xPlot), ...
	'Color', [0 0 0], 'LineWidth', plotLineWidth);
hold off;
% Panel A: set axis limits, tick marks, and labels.
xlim([min(xPlot), max(xPlot)]);
ylim([0, 1]);
setAxes(0:.5:2, '%.1f\n', 0:.2:1, '%.1f\n');
xlabel('Time (s)', labelParams{:});
ylabel('Cumulative probability', labelParams{:});

% Panel A: set legend.
legendA = legend({
	'Data point', ...
	sprintf('%d Hz rCDF', modelFreqs(rcdfIdx)) ...
	}, legendParams{:}, 'Location', 'southeast');
legendAPos = get(legendA, 'Position');
legendAPos(1) = sum(panelPos{1}([1 3])) - 2.85;
legendAPos(2) = panelPos{1}(2) + .35;
set(legendA, 'Position', legendAPos);

% Set column 1 (panels A and D) title.
titleAD = title(columnTitles{1}, titleParams{:});
titleADPos = get(titleAD, 'Position');
titleADPos(2) = columnTitleBottom;
set(titleAD, 'Position', titleADPos);

% Panel A: set panel label.
annotation('textbox', 'String', 'A', annotParams{:}, ...
	'Position', panelLabelPos{1});

%
% Panel B: set panel position.
%
panelB = subplot(4, 3, [2 5], subplotParams{:});
set(panelB, 'Position', panelPos{2});

% Panel B: plot estimated amplitude values.
hold on;
rectangle('Position', ...
	[freqBounds(rcdfIdx, 1), -.5, diff(freqBounds(rcdfIdx, :)), 1.5], ...
	'EdgeColor', 'none', 'FaceColor', shadeBarColor);  % shaded bar
plot(modelFreqs, ampEstd{1, plotSimulIdx}, 'Color', [0 0 0], ...
	'LineWidth', plotLineWidth);
hold off;
% Panel B: set axis limits, tick marks, and labels.
xlim([0, 20]);
ylim([-.1, .8]);
setAxes(4:4:20, '%d\n', 0:.2:.8, '%.1f\n');
xlabel('Frequency (Hz)', labelParams{:});
ylabel('Estimated amplitude', labelParams{:});

% Set column 2 (panels B and E) title.
titleBE = title(columnTitles{2}, titleParams{:});
titleBEPos = get(titleBE, 'Position');
titleBEPos(2) = columnTitleBottom;
set(titleBE, 'Position', titleBEPos);

% Panel B: set panel label.
annotation('textbox', 'String', 'B', annotParams{:}, ...
	'Position', panelLabelPos{2});

%
% Panel C: set panel position.
%
panelC = subplot(4, 3, [3 6], subplotParams{:});
set(panelC, 'Position', panelPos{3});

% Panel C: plot estimated amplitude values for strong/weak rhythms.
hold on;
for r = 1:2
	avgAmpEstd = mean(cell2mat(ampEstd(r, :)), 2);
	semAmpEstd = std(cell2mat(ampEstd(r, :)), [], 2) / sqrt(simCount);

	errorHandle = errorbar(modelFreqs, avgAmpEstd, semAmpEstd, ...
		errorBarParams{:});
	skipLegend(errorHandle);
	plot(modelFreqs, avgAmpEstd, 'Color', lineColors2(r, :), ...
		'LineWidth', plotLineWidth);
end
hold off;
% Panel C: set axis limits, tick marks, and labels.
xlim([0, 20]);
ylim([-.1, .8]);
setAxes(4:4:20, '%d\n', 0:.2:.8, '%.1f\n');
xlabel('Frequency (Hz)', labelParams{:});
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

% Set column 3 (panels C and F) title.
titleCF = title(columnTitles{3}, titleParams{:});
titleCFPos = get(titleCF, 'Position');
titleCFPos(2) = columnTitleBottom;
set(titleCF, 'Position', titleCFPos);

% Panel C: set panel label.
annotation('textbox', 'String', 'C', annotParams{:}, ...
	'Position', panelLabelPos{3});



% Load generated data (Example 1, second part).
load(fullfile('data-fitted', 'Step2B_AmpRndWalkData.mat'));
% Calcuate FFT frequency range.
fftFreqLb = 1 / fftWindow;
fftFreqUb = 1 / pdfBinSize / 2;
fftFreqs = fftFreqLb:fftFreqLb:fftFreqUb;
% Determine FFT window (shaded area in panel D).
plotPDFInfo = pdfInfo(1, plotSimulIdx);
wFFT = plotPDFInfo.tEdges(plotPDFInfo.fftIdx([1 end]) + [0 1]);

%
% Panel D: set upper panel position.
%
panelDu = subplot(4, 3, 7, subplotParams{:});
set(panelDu, 'Position', panelPos{4}(1, :));

% Panel D_upper: plot probability density histogram and PDF.
hold on;
rectangle('Position', [wFFT(1), 0, diff(wFFT), 4], ...
	'EdgeColor', 'none', 'FaceColor', shadeAreaColor);  % FFT window
bar(plotPDFInfo.tData, plotPDFInfo.pRaw, histogramParams{:});
plot(xPlot, pdfFun(cdfB{1, plotSimulIdx}, xPlot), ...
	'Color', [0 0 0], 'LineWidth', plotLineWidth);
hold off;
% Panel D_upper: set axis limits, tick marks, and labels.
xlim([min(xPlot), max(xPlot)]);
ylim([0, 3]);
setAxes(.5:.5:2, '%.1f\n', 0:1:3, '%d\n');
ylabelDu = ylabel('Probability', labelParams{:});

% Panel D: set lower panel position.
panelDl = subplot(4, 3, 10, subplotParams{:});
set(panelDl, 'Position', panelPos{4}(2, :));

% Panel D_lower: plot residual probability values.
hold on;
rectangle('Position', [wFFT(1), -1.5, diff(wFFT), 3], ...
	'EdgeColor', 'none', 'FaceColor', shadeAreaColor);  % FFT window
pPred = pdfFun(cdfB{1, plotSimulIdx}, plotPDFInfo.tData);
bar(plotPDFInfo.tData, plotPDFInfo.pRaw - pPred, histogramParams{:});
line([0 3], [0 0], 'Color', 'k', 'LineWidth', axisLineWidth);  % axis at 0 residual
hold off;
% Panel D_lower: set axis limits, tick marks, and labels.
xlim([min(xPlot), max(xPlot)]);
ylim([-1.25, 1.25]);
setAxes(.5:.5:2, '%.1f\n', -1:1:1, '%d\n');
xlabel('Time (s)', labelParams{:});
ylabelDl = ylabel('Residual', labelParams{:});

% Set the position of panel D_upper ylabel.
ylabelDuPos = get(ylabelDu, 'Position');
ylabelDlPos = get(ylabelDl, 'Position');
ylabelDuPos(1) = ylabelDlPos(1);
set(ylabelDu, 'Position', ylabelDuPos);

% Panel D: set panel label.
annotation('textbox', 'String', 'D', annotParams{:}, ...
	'Position', panelLabelPos{4});

%
% Panel E: set panel position.
%
panelE = subplot(4, 3, [8 11], subplotParams{:});
set(panelE, 'Position', panelPos{5});

% Panel E: plot spectral power distribution.
hold on;
rectangle('Position', ...
	[freqBounds(rcdfIdx, 1), -.5, diff(freqBounds(rcdfIdx, :)), 1.5], ...
	'EdgeColor', 'none', 'FaceColor', shadeBarColor);  % shaded bar
plot(fftFreqs, fftAmp{1, plotSimulIdx}, 'Color', [0 0 0], ...
	'LineWidth', plotLineWidth);
hold off;
% Panel E: set axis limits, tick marks, and labels.
xlim([0, 20]);
ylim([-.1, .8]);
setAxes(4:4:20, '%d\n', 0:.2:.8, '%.1f\n');
xlabel('Frequency (Hz)', labelParams{:});
ylabel('Spectral power', labelParams{:});

% Panel E: set panel label.
annotation('textbox', 'String', 'E', annotParams{:}, ...
	'Position', panelLabelPos{5});

%
% Panel F: set panel position.
%
panelF = subplot(4, 3, [9 12], subplotParams{:});
set(panelF, 'Position', panelPos{6});

% Panel F: plot spectral power distributions for strong/weak rhythms.
hold on;
for r = 1:2
	avgFFTAmp = mean(cell2mat(fftAmp(r, :)'), 1);
	semFFTAmp = std(cell2mat(fftAmp(r, :)'), [], 1) / sqrt(simCount);

	errorHandle = errorbar(fftFreqs, avgFFTAmp, semFFTAmp, ...
		errorBarParams{:});
	skipLegend(errorHandle);
	plot(fftFreqs, avgFFTAmp, 'Color', lineColors2(r, :), ...
		'LineWidth', plotLineWidth);
end
hold off;
% Panel F: set axis limits, tick marks, and labels.
xlim([0, 20]);
ylim([-.1, .8]);
setAxes(4:4:20, '%d\n', 0:.2:.8, '%.1f\n');
xlabel('Frequency (Hz)', labelParams{:});
ylabel('Spectral power', labelParams{:});

% Panel F: set legend.
legendF = legend({
	'Strong rhythms', ...
	'Weak rhythms' ...
	}, legendParams{:}, 'Location', 'north');
legendFPos = get(legendF, 'Position');
legendFPos(1) = sum(panelPos{6}([1 3]) .* [1 .5]) - 1.7;
legendFPos(2) = sum(panelPos{6}([2 4])) - .85;
set(legendF, 'Position', legendFPos);

% Panel F: set panel label.
annotation('textbox', 'String', 'F', annotParams{:}, ...
	'Position', panelLabelPos{6});



% Save figure to an image file.
figureFile = fullfile('fig-images', 'Figure3.tif');
print(figureHandle, figureFile, '-dtiff', '-r300');
