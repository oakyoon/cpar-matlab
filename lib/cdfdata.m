function [xdata, cpdata] = cdfdata(xdata)
% CDFDATA trims duration data and generates cumulative probabilty values
%
% [xdata, cpdata] = CDFDATA(xdata)
%
% Input Variable:
%   xdata - vector containing duration data
%
% Output Variables:
%   xdata  - [xdata] sorted in ascending order, with NaN and Inf removed
%   cpdata - vector containing cumulative probability values for each data point
%            in [xdata]

	if ~isvector(xdata)
		error('The first input must be a vector.');
	end

	xdata  = xdata(isfinite(xdata));
	xdata  = sort(xdata);
	cpdata = (.5:length(xdata)) / length(xdata);
	cpdata = reshape(cpdata, size(xdata));
end