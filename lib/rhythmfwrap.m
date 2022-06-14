function y = rhythmfwrap(fun, B, x)
% RHYTHMFWRAP generates rCDF from given non-rhythmic CDF funcion, non-rhythmic
%   CDF parameters, and rhythmic transformation parameters, and then calculates
%   cumulative probability values from the generated rCDF and given data
%
% y = RHYTHMFWRAP(fun, B, x)
%
% Input Variables:
%   cdfFun - non-rhythnmic CDF function; please refer to CommonVars_CDF.m
%   B - vector containing non-rhythmic CDF parameters and rhythmic
%       transformation parameters F, p, k (last three elements)
%   x - given data 
%
% Output Variable:
%   y - cumulative probability values
%
% Please refer to Tutorial_FitRhythms_LognormCDF.m.

	if length(B) < 3
		error('The second input must contain at least 3 elements.');
	end

	rx = rhythmconv(x, B((end - 2):end));
	y  = fun(B(1:(end - 3)), rx);
end