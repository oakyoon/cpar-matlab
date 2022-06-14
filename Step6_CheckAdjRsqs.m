%
% Script for reporting statistics shown in Footnote 4.
%

clear;
addpath('lib');

% Load variables defined in CommonVars_CDF.m.
CommonVars_CDF;

exampleInfo = {
	'Example 1', 'Step2A_AmpRndWalkData.mat';
	'Example 3', 'Step4B_RuzzoliEtAl2019.mat';
	};

fprintf('\n');
fprintf('Goodness of Fit Measures\n');
fprintf('------------------------\n');
% For each Example:
for e = 1:size(exampleInfo, 1)
	% Load generated data.
	vars = load(fullfile('data-fitted', exampleInfo{e, 2}));

	% Calculate goodness of fit measures (adjusted R^2) for non-rhythmic CDF.
	cdfAdjRsq = zeros(size(vars.cdfB));
	for i = 1:numel(vars.cdfB)
		cdfAdjRsq(i) = adjrsq(cdfFun, vars.cdfB{i}, vars.xData{i}, vars.cpData{i});
	end

	% Print average and SD of goodness of fit measures.
	fprintf('%s: M=%.3f, SD=%.3f\n', exampleInfo{e, 1}, ...
		mean(cdfAdjRsq(:)), std(cdfAdjRsq(:)));
end
fprintf('\n');
