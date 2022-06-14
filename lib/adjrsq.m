function [adjrsq, rsq, SSE, SST] = adjrsq(fun, B, xdata, ydata)
% ADJRSQ calculates adjusted R-squared value from a given model and data
%
% [adjrsq, rsq, SSE, SST] = ADJRSQ(fun, B, xdata, ydata)
%
% Input Variables:
%   fun   - model function that predicts [ydata] from given [xdata] and fuction
%           parameters [B]; please refer to [cdfFun] in CommonVars_CDF.m
%   B     - vector containing function parameters for the model function [fun]
%   xdata - vector containing input data for the model fuction [fun]
%   ydata - vector containing output data for each data point in [xdata]
%
% Output Variables:
%   adjrsq - adjusted R-squared
%   rsq    - R-squared
%   SSE    - sum of squared errors
%   SST    - sum of squared total

	SST = sum((ydata - mean(ydata)) .^ 2);
	SSE = sum((ydata - fun(B, xdata)) .^ 2);
	rsq = 1 - (SSE / SST);
	n = length(xdata);
	k = length(B);
	adjrsq = 1 - ((1 - rsq) * (n - 1) / (n - k - 1));
end