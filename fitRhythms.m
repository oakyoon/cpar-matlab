function [rcdfB, rcdfAdjRsq, cdfB, cdfAdjRsq] = fitRhythms(freqBounds, rhythmB0, cdfFun, cdfB0, xData, cpData, cdfBlb, cdfBub, opts)
% fitRhythms conducts Computational Procedures for Analysis of Rhythms (CPAR)
%
% [rcdfB, rcdfAdjRsq, cdfB, cdfAdjRsq] = fitRhythms(freqBounds, rhythmB0,
%   cdfFun, cdfB0, xData, cpData, cdfBlb, cdfBub, opts)
%
% Input Variables:
%   freqBounds - two-column matrix containing lower and upper bounds for each
%                model frequency (in Hz)
%   rhythmB0   - sets of initial guesses for the two rhythmic transformation
%                parameters, p and k
%   cdfFun - CDF function; please refer to CommonVars_CDF.m
%   cdfB0  - matrix containing sets of initial guesses for CDF parameters; each
%            row is a set of initial guesses; please refer to CommonVars_CDF.m
%   xData  - duration data (in seconds), sorted in ascending order
%   cpData - cumulative probability values for each data point in [xData]
%   cdfBlb - lower bound for CDF parameters
%   cdfBub - upper bound for CDF parameters
%   opts   - this variable is passed to the lib/lsqbestfit() function, and then
%            to the lsqcurvefit() function
%
% Output Variables:
%   rcdfB      - matrix containing sets of best-fit rCDF parameters; each row
%                is a set of parameters for a model frequency specified in the
%                corresponding row of [freqBounds]
%   rcdfAdjRsq - vector containing adjusted R-squared values for best-fit rCDFs;
%                each row is an R-squared value calculated with the rCDF
%                parameters in the corresponding row of [rcdfB]
%   cdfB       - best-fit parameters for a non-rhythmic CDF
%   cdfAdjRsq  - adjusted R-squared value for of the best-fit, non-rhythmic CDF
%
%   Variance explained can be calculated from rcdfAdjRsq and cdfAdjRsq.
%   E.g., varExpl = (rcdfAdjRsq - cdfAdjRsq) / (1 - cdfAdjRsq);
%
% This function relies on Optimization Toolbox and the functions in the lib/
% directory. You may execute "addpath('lib');" to add the lib/ directory to
% MATLAB path.
%
% See also OPTIMOPTIONS.

	% Find the best-fit CDF parameters, and calculate adjusted R-squared. 
	cdfB = lsqbestfit(cdfFun, cdfB0, xData, cpData, cdfBlb, cdfBub, opts);
	cdfAdjRsq = adjrsq(cdfFun, cdfB, xData, cpData);

	% Build rCDF function, and allocate output variables (rcdfB, rcdfAdjRsq).
	rcdfFun = @(B, x) rhythmfwrap(cdfFun, B, x);
	rcdfCount = size(freqBounds, 1);
	rcdfB = zeros(rcdfCount, size(cdfB0, 2) + 3);
	rcdfAdjRsq = zeros(rcdfCount, 1);

	% For each model frequency:
	for i = 1:rcdfCount
		% Build sets of initial guesses, lower and upper bounds for rhythmic
		% transformation parameters.
		rcdfB0  = combmat(cdfB, mean(freqBounds(i, 1:2)), rhythmB0);
		rcdfBlb = [cdfBlb, freqBounds(i, 1), -pi, 0];
		rcdfBub = [cdfBub, freqBounds(i, 2),  pi, 1];

		% Find the best-fit rCDF parameters, and calculate adjusted R-squared. 
		rcdfB(i, :) = lsqbestfit(rcdfFun, rcdfB0, xData, cpData, rcdfBlb, rcdfBub, opts);
		rcdfAdjRsq(i) = adjrsq(rcdfFun, rcdfB(i, :), xData, cpData);
	end
end