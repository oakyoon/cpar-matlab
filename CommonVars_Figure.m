%
% Common variables used for figure formatting.
%

% Font name and font sizes.
if any(strcmp('Helvetica', listfonts))
	figureFont = 'Helvetica';
else
	figureFont = 'Arial';
end
axisFontSize   = 9;
labelFontSize  = 9;
legendFontSize = 9;
titleFontSize  = 10;
annotFontSize  = 12;

% Line widths, data point (scatterplot) shape and size.
plotLineWidth  = .75;
errorLineWidth = .50;
axisLineWidth  = .75;
dataPointShape = 'o';
dataPointSize  = 2;
dataPointLineT = .50;
arrowLineWidth = .50;  % used for Figure 3

% Plot element colors.
lineColors2 = [
	 0   0   0;
	.50 .50 .50;
	];
lineColors3 = [  % used for Figure 2
	 0   0   0;
	.45 .45 .45;
	.70 .70 .70;
	];
lineColors6 = [  % used for Figure 6
	 0   0   0;
	.15 .15 .15;
	.30 .30 .30;
	.45 .45 .45;
	.60 .60 .60;
	.75 .75 .75;
	];
dataPointColor = [.50 .50 .50];
histogramColor = [.60 .60 .60];
errorBarColor  = [.20 .20 .20];
shadeBarColor  = [.90 .90 .90];
shadeAreaColor = [.95 .95 .95];
arrowColor     = [.16 .16 .16];  % used for Figure 3

% Frequently used sets of input variables.
% E.g., subplot(1, 3, 1, subplotParams{:});
subplotParams = { 'FontName', figureFont, 'FontSize', axisFontSize, ...
	'LabelFontSizeMultiplier', labelFontSize / axisFontSize, ...
	'TitleFontSizeMultiplier', titleFontSize / axisFontSize, ...
	'TitleFontWeight', 'normal', 'Units', 'centimeters' };
dataPointParams = { dataPointSize ^ 2, dataPointColor, dataPointShape, ...
	'LineWidth', dataPointLineT };
histogramParams = { 'LineStyle', 'none', 'FaceColor', histogramColor, ...
	'BarWidth', .65 };
errorBarParams = { 'LineStyle', 'none', 'Color', errorBarColor, ...
	'LineWidth', errorLineWidth, 'CapSize', 2 };
labelParams = { 'FontName', figureFont, 'FontSize', labelFontSize, ...
	'Units', 'centimeters' };
legendParams = { 'FontName', figureFont, 'FontSize', legendFontSize, ...
	'Box', 'off', 'Units', 'centimeters' };
legendTitleParams = { 'FontName', figureFont, ...
	'FontSize', legendFontSize, 'FontWeight', 'normal' };
titleParams = { 'FontName', figureFont, 'FontSize', titleFontSize, ...
	'FontWeight', 'normal', 'Units', 'centimeters' };
annotParams = { 'FontName', figureFont, 'FontSize', annotFontSize, ...
	'LineStyle', 'none', 'Units', 'centimeters' };

% Helper function that opens a new figure window with a specifed size.
openFigure = @(imageSize) figure( ...
	'Color',             'w', ...
	'Units',             'centimeters', ...
	'Position',          [5 5 imageSize], ...
	'PaperPositionMode', 'manual', ...
	'PaperUnits',        'centimeters', ...
	'PaperSize',         imageSize, ...
	'PaperPosition',     [0 0 imageSize] ...
	);

% Helper function that sets axis ticks and labels.
setAxes = @(xTick, xFmt, yTick, yFmt) set(gca, ...
	'Layer', 'top', 'FontName', figureFont, 'FontSize', axisFontSize, ...
	'LineWidth', axisLineWidth, 'XColor', 'k', 'YColor', 'k', ...
	'XTick', xTick, 'Xticklabel', sprintf(xFmt, xTick), ...
	'YTick', yTick, 'Yticklabel', sprintf(yFmt, yTick)  ...
	);

% Helper function that hides a plot element from a legend. This function is used
% to prevent error bars from appearing as a legend item.
skipLegend = @(h) set(get(get(h, 'Annotation'), 'LegendInformation'), ...
	'IconDisplayStyle', 'off');
